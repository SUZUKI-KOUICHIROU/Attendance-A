class Attendance < ApplicationRecord

  belongs_to :user
  
  
  enum worktime_approval: { なし: 0, 申請中: 1, 承認: 2, 否認: 3 }, _prefix: true
  enum overwork_status: { なし: 0, 申請中: 1, 承認: 2, 否認: 3 }, _prefix: true

  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validates :business_contents, length: { maximum: 50 }
  
  #出勤・退勤時間が存在しない場合無効
  validate :attendance_is_invalid_without_a_started_at_finished_at
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at

  # 退勤時間が存在しない場合、出勤時間は無効
  validate :started_at_is_invalid_without_a_finished_at
  
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  
  def attendance_is_invalid_without_a_started_at_finished_at
    if worktime_check_superior.present?
      errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.blank?
    end
  end 
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present? 
  end

  def started_at_is_invalid_without_a_finished_at
    unless worked_on == Date.current  
      errors.add(:finished_at, "が必要です") if finished_at.blank? && started_at.present?
    end
  end 
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?  
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at && tomorrow == false 
    end
  end

  def finished_at_invalid
    worktime_approval.present?
  end
end