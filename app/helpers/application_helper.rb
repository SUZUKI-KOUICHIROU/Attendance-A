module ApplicationHelper

  def full_title(page_name = "")
    base_title = "AttendanceApp"
    if page_name.empty?
      base_title
    else
      page_name + " | " + base_title
    end
  end

  def overwork_times(plans_endtime, designated_endtime, next_day)
    unless next_day == true
      format("%.2f", (plans_endtime.to_f - designated_endtime.to_f)) 
    else
      format("%.2f", (plans_endtime.to_f + designated_endtime.to_f)) 
    end
  end 
end