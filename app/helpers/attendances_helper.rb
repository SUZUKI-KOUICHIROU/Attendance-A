module AttendancesHelper

  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出社' if attendance.started_at.nil?
      return '退社' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    return false
  end 

  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
    
  def overwork_times(plans_endtime, designated_endtime, next_day)
    unless next_day == true
      format("%.2f", (plans_endtime.to_f - designated_endtime.to_f)) 
    else
      format("%.2f", (plans_endtime.to_f - designated_endtime.to_f) + 24) 
    end
  end 

  def attendances_invalid?
    attendances = true
    attendances_params.each do |id, item|
      if item[:started_at].blank? && item[:finished_at].blank?
        next
      elsif item[:started_at].blank? || item[:finished_at].blank?
        attendances = false
        break
      elsif item[:started_at] > item[:finished_at]
        attendances = false
        break
      end
    end
    return attendances
  end
end
