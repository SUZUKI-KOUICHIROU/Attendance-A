class AttendancesController < ApplicationController

  include AttendancesHelper

  before_action :set_user, only: %i(edit_one_month update_one_month update_month_apply edit_month_approval update_month_approval edit_overwork_request update_overwork_request
                                    edit_overwork_approval update_overwork_approval edit_worktime_approval update_worktime_approval attendance_log update_attendance_log) 
  before_action :logged_in_user, only: %i(update edit_one_month)
  before_action :correct_user, only: %i(edit_one_month edit_worktime_approval edit_overwork_request edit_overwork_approval edit_month_approval)
  before_action :not_admin_user, only: %i(edit_one_month)
  before_action :correct_superior_user, only: %i(edit_worktime_approval update_worktime_approval edit_month_approval update_month_approval edit_overwork_approval update_overwork_request)
  before_action :set_one_month, only: %i(edit_one_month update_one_month update_month_apply edit_overwork_request update_overwork_request)
  before_action :superior_choice, only: %i(edit_overwork_request edit_one_month)
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0), before_started_at: Time.current.change(sec: 0))
        flash[:info] = "出勤しました"
      end
    elsif @attendance.finished_at.nil? 
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0), before_finished_at: Time.current.change(sec: 0))
        flash[:info] = "退勤しました"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user 
  end
  
  def edit_one_month
  end

  #勤怠変更申請
  def update_one_month
    @application_count = 0    
    ActiveRecord::Base.transaction do  
      attendances_params.each do |id, item|   
        attendance = Attendance.find(id)
        if item[:worktime_check_superior].present?
          @application_count += 1  
          if item[:worktime_approval] = "申請中" 
            item[:approval_day] = @first_day
            attendance.update_attributes!(item)
          end   
        end         
      end
    end
    if @application_count > 0
      flash[:success] = "勤怠変更を申請しました。"
      #redirect_to user_url(date: params[:date])       
    end
    redirect_to user_url(date: params[:date]) 
  rescue ActiveRecord::RecordInvalid        
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end 
        
  #勤怠変更承認ページ
  def edit_worktime_approval
    @worktime_user = User.joins(:attendances).group("users.id").where(attendances: {worktime_check_superior: @user.name, worktime_approval: "申請中"})
    @worktime = Attendance.where(worktime_approval: "申請中", worktime_check_superior: @user.name).order(:worked_on)
  end
  
 #勤怠変更承認
  def update_worktime_approval
    worktime_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if params[:user][:attendances][id][:worktime_change] == "1" && params[:user][:attendances][id][:worktime_approval] == "申請中" 
      elsif params[:user][:attendances][id][:worktime_change] == "1" && params[:user][:attendances][id][:worktime_approval] == "承認" 
        if attendance.first_approval == 0 
          attendance.update_attributes(item.merge(before_started_at: attendance.started_at, before_finished_at: attendance.finished_at, change_started_at: attendance.before_started_at, change_finished_at: attendance.before_finished_at, 
                                                  before_note: attendance.note, approval_tomorrow: attendance.tomorrow, 
                                                  worktime_before_superior: attendance.worktime_check_superior, worktime_before_approval: "承認", first_approval: 1))
          flash[:success] = "勤怠変更申請処理が完了しました。"
        elsif attendance.first_approval == 1 
          attendance.update_attributes(item.merge(before_started_at: attendance.started_at, before_finished_at: attendance.finished_at,
                                       before_note: attendance.note, approval_tomorrow: attendance.tomorrow, 
                                       worktime_before_superior: attendance.worktime_check_superior, worktime_before_approval: "承認"))
          flash[:success] = "勤怠変更申請処理が完了しました。"
        end
      elsif params[:user][:attendances][id][:worktime_change] == "1" && params[:user][:attendances][id][:worktime_approval] == "否認" 
        attendance.update_attributes(item.merge(worktime_before_superior: attendance.worktime_check_superior, worktime_before_approval: "否認"))
        flash[:success] = "勤怠変更申請処理が完了しました。"
      elsif params[:user][:attendances][id][:worktime_change] == "1" && params[:user][:attendances][id][:worktime_approval] == "なし"
        attendance.update_columns(started_at: attendance.before_started_at, finished_at: attendance.before_finished_at, tomorrow: attendance.approval_tomorrow, note: attendance.before_note,
                                  worktime_check_superior: attendance.worktime_before_superior, worktime_approval: attendance.worktime_before_approval)
        flash[:success] = "勤怠変更申請処理が完了しました。"
      else
        #flash[:danger] = "変更する場合はチェックを入れてください。"
      end
    end
    redirect_to user_url(date: params[:date])
    return 
  end
    
  #所属長承認申請一覧ページ
  def edit_month_approval
    @attendances = Attendance.where(month_status: "申請中", month_check_superior: @user.name).order(:user_id).order(:worked_on).group_by(&:user_id)
  end
  
  #所属長申請処理
  def update_month_approval
    superior_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if item[:status_change] == "1" && item[:month_status] == "申請中"
      elsif item[:status_change] == "1" && item[:month_status] == "承認" 
        attendance.update_attributes(item)
        flash[:success] = "所属長申請処理が完了しました。"    
      elsif item[:status_change] == "1" && item[:month_status] == "否認" 
        attendance.update_attributes(item)
        flash[:success] = "所属長申請処理が完了しました。"
      elsif item[:status_change] == "1" && item[:month_status] == "なし" 
        attendance.update_attributes(item)
        flash[:success] = "所属長申請処理が完了しました。"
      else
      end
    end
    redirect_to user_url(date: params[:date])
  end

  #残業申請ページ
  def edit_overwork_request
    @attendances = @user.attendances.where(worked_on: params[:date])
  end 
 
  #残業申請
  def update_overwork_request
    overwork_request_params.each do |id, item| 
      attendance = Attendance.find(id)
      if item[:superior_confirmation].present?
        item[:overwork_status] = "申請中"
        attendance.update_attributes(item)
        flash[:success] = "残業申請が完了しました。"
      else
        flash[:danger] = "残業申請に失敗しました。"
      end
    end
    redirect_back(fallback_location: user_url)
  end

  #残業申請承認ページ
  def edit_overwork_approval
    @overwork_user = User.joins(:attendances).group("users.id").where(attendances: {superior_confirmation: @user.name, overwork_status: "申請中"})
    @overwork = Attendance.where(overwork_status: "申請中", superior_confirmation: @user.name).where.not(plans_endtime: nil).order(:worked_on)
  end
  
  #残業申請承認
  def update_overwork_approval
    overwork_approval_params.each do |id, item|
      attendance = Attendance.find(id)
        if params[:user][:attendances][id][:overwork_change] == "1" && params[:user][:attendances][id][:overwork_status] == "申請中"    
        elsif params[:user][:attendances][id][:overwork_change] == "1" && params[:user][:attendances][id][:overwork_status] == "承認"
          attendance.update_attributes(item.merge(approval_overtime: attendance.plans_endtime, approval_contents: attendance.business_contents, approval_next: attendance.next_day, 
                                                  before_superior: attendance.superior_confirmation, before_status: "承認"))
          flash[:success] = "残業申請処理が完了しました。"
        elsif params[:user][:attendances][id][:overwork_change] == "1" && params[:user][:attendances][id][:overwork_status] == "否認"
          attendance.update_attributes(item.merge(approval_overtime: attendance.plans_endtime, approval_contents: attendance.business_contents, approval_next: attendance.next_day, 
                                                  before_superior: attendance.superior_confirmation, before_status: "否認"))
          flash[:success] = "残業申請処理が完了しました。"
        elsif params[:user][:attendances][id][:overwork_change] == "1" && params[:user][:attendances][id][:overwork_status] == "なし"
          attendance.update_attributes(item.merge(plans_endtime: attendance.approval_overtime, next_day: attendance.approval_next, business_contents: attendance.approval_contents, 
                                       superior_confirmation: attendance.before_superior, overwork_status: attendance.before_status))
          flash[:success] = "残業申請処理が完了しました。"
        else  
          #flash[:danger] = "変更する場合はチェックを入れてください。"
        end      
    end
    redirect_to user_url
  end

  
  private
    #勤怠変更申請
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :tomorrow, :note, :worktime_check_superior, :worktime_approval, :first_approval])[:attendances]
    end
    
    #勤怠変更承認
    def worktime_approval_params 
      params.require(:user).permit(attendances: [:started_at, :finished_at, :worktime_approval, :worktime_change, :worktime_check_superior, :first_approval, :tomorrow])[:attendances]
    end

    #1ヶ月承認
    def superior_approval_params
      params.require(:user).permit(attendances: [:month_status, :status_change])[:attendances]
    end

    #残業申請
    def overwork_request_params
      params.require(:user).permit(attendances: [:plans_endtime, :next_day, :business_contents, :superior_confirmation, :overwork_status])[:attendances]
    end
    
    #残業申請承認
    def overwork_approval_params
      params.require(:user).permit(attendances: [:overwork_status, :overwork_change])[:attendances]
    end
end
