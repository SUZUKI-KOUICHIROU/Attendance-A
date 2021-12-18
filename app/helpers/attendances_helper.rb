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
    
  def before_working_times(before_started_at, before_finished_at)
    format("%.2f", (((before_finished_at - before_started_at) / 60) / 60.0))
  end
  
  def overwork_times(plans_endtime, designated_work_end_time, next_day)
    unless next_day == true
      format("%.2f", (plans_endtime.to_f - designated_work_end_time.to_f)) 
    else
      format("%.2f", (plans_endtime.to_f - designated_work_end_time.to_f) + 24) 
    end
  end 

  def worktime_tomorrow(finished_at, started_at, tomorrow)
    unless tomorrow == true
      format("%.2f", (finished_at.to_f - started_at.to_f)) 
    else
      format("%.2f", (finished_at.to_f - started_at.to_f) + 24) 
    end
  end

  def worktime_change_tomorrow(change_finished_at, change_started_at, tomorrow)
    unless tomorrow == true
      format("%.2f", (change_finished_at.to_f - change_started_at.to_f)) 
    else
      format("%.2f", (change_finished_at.to_f - change_started_at.to_f) + 24) 
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
