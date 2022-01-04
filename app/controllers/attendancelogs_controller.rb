class AttendancelogsController < ApplicationController

  before_action :set_user, only: %i(edit)
  
  def edit
    @attendance_day = Attendance.where(attendances: {worktime_approval: "承認", user_id: @user.id}).order(:worked_on)
    @select = Attendancelog.pluck(:month_form).last(1)
  end

  def create
    @attendance_log = Attendancelog.new(log_params)
    if @attendance_log.save
    end
    redirect_to edit_attendancelog_path(current_user)
  end

    private
    
    def log_params
      params.permit(:month_form)
    end
end