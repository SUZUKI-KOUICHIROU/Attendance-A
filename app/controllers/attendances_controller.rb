class AttendancesController < ApplicationController

  include AttendancesHelper
  
  before_action :set_user, only: %i(edit_one_month update_one_month)
  before_action :logged_in_user, only: %i(update edit_one_month)
  before_action :set_one_month, only: %i(edit_one_month)
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil? 
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user 
  end
  
  def edit_one_month
  end

  def update_one_month
    ActiveRecord::Base.transaction do
      if attendances_invalid?
        attendances_params.each do |id, item|
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
        flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
        redirect_to attendances_edit_one_month_user_url(date: params[:date])
      end
    end
  rescue ActiveRecord::RecordInvalid
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  #勤怠変更申請ページ
  def edit_attendance_application
    @user = User.joins(:attendances).group("users.id").where.not(attendances: {changed_finished_at: nil})
    @attendance_date = Attendance.where(attendance_date: current_user.id)
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    @superiors = User && User.where(superior: true).where.not(id: current_user.id) #.map(&:name)
    @attendances = Attendance.where.not(attendances: {changed_finished_at: nil})
    #@attendances = Attendance.where(change_confirmation_status: :pending, change_confirmation_approver_id: current_user.id)
    @pending_users = @attendances.group_by(&:user_id)
  end  

  #勤怠変更承認
  def update_attendance_application
    confirmation_attendances_params.each do |id, item|
      if apply_confirmed_invalid?(item[:change_status], item[:change_check])
        attendance = Attendance.find(id)
        item[:approval_date] = Time.current
        attendance.update_attributes(item)
        if item[:change_confirmation_status]  == "否認"
          item[:change_approval] = 2
          item[:change_check] = "0"
          item[:approval_date] = nil
          attendance.update_attributes(item)
        end
        flash[:success] = "勤怠変更を更新しました。"
        redirect_to user_url(date: params[:date])
      else
        flash[:danger] ="勤怠変更の更新がキャンセルされました。"
        redirect_to user_url(date: params[:date])  
      end
    end
  end

  #勤怠ログ
  def attendance_log
  end 

  private
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:changed_started_at, :changed_finished_at])[:attendances]
    end
    
    # 勤怠変更申請承認
    def confirmation_attendances_params
      params.permit(:note, :change_confirmation_status)
    end

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
end