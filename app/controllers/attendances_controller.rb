class AttendancesController < ApplicationController

  include AttendancesHelper

  before_action :set_user, only: %i(edit_one_month update_one_month update_month_apply edit_month_approval update_month_approval edit_overwork_request update_overwork_request
                                    edit_overwork_approval update_overwork_approval edit_worktime_approval update_worktime_approval attendance_log update_attendance_log) 
  before_action :logged_in_user, only: %i(update edit_one_month)
  before_action :set_one_month, only: %i(edit_one_month)
  before_action :superior_choice, only: %i(edit_overwork_request edit_one_month)
 
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

  #勤怠変更申請
  def update_one_month
    attendances_params.each do |id, item|   
      attendance = Attendance.find(id)
      unless params[:user][:attendances][id][:worktime_check_superior].blank?  
        if attendance.update_attributes(item)
          flash[:success] = "勤怠変更を申請しました。"
        else
          flash[:danger] = "申請に失敗しました。"  
        end 
      end
    end  
    redirect_to user_url
  end    
  
  #勤怠変更承認ページ
  def edit_worktime_approval
    @worktime_user = User.joins(:attendances).group("users.id").where(attendances: {worktime_check_superior: @user.name, worktime_approval: "申請中"})
    @worktime = Attendance.where(worktime_approval: "申請中", worktime_check_superior: @user.name).order(:worked_on)
    @first = Attendance.where(started_at: params[:date])
  end
  
  #勤怠変更承認
  def update_worktime_approval
    worktime_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if params[:user][:attendances][id][:worktime_change] == "true"
        attendance.update_attributes(item)
        flash[:success] = "勤怠変更申請処理が完了しました。"
      else    
        flash[:danger] = "変更する場合はチェックを入れてください。"
      end      
    end
    redirect_to user_url
  end

  #1ヶ月申請
  def update_month_apply
    @attendance = Attendance.where(user_id: month_params[:user_id], worked_on: params[:date])
     unless month_params[:month_check_superior].blank?
       @attendance.update_all(month_params)
       flash[:success] = "申請しました。"
     else
       flash[:danger] = "申請先を選択してください。" 
     end
     redirect_to user_url(date: params[:date])  
  end
  
  #1ヶ月申請一覧ページ
  def edit_month_approval
    @attendances = Attendance.where(month_status: "申請中", month_check_superior: @user.name).order(:user_id).order(:apply_month).group_by(&:user_id)
  end
  
  #1ヶ月承認
  def update_month_approval
    superior_approval_params.each do |id, item|
      attendance = Attendance.find(id)
      if params[:user][:attendances][id][:status_change] == "true"
         attendance.update_attributes(item)
        flash[:success] = "1か月申請処理が完了しました。"
      else    
        flash[:danger] = "変更する場合はチェックを入れてください。"
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
        if attendance.update_attributes(item)
          flash[:success] = "残業を申請しました。"
        else
          flash[:danger] = "残業申請に失敗しました。"  
        end 
    end
    redirect_to user_url
  end

  #残業申請承認ページ
  def edit_overwork_approval
    @overwork_user = User.joins(:attendances).group("users.id").where(attendances: {superior_confirmation: @user.name, overwork_status: "申請中"})
    @overwork = Attendance.where(overwork_status: "申請中").where.not(plans_endtime: nil).order(:worked_on)
  end

  #残業申請承認
  def update_overwork_approval
    overwork_approval_params.each do |id, item|
      attendance = Attendance.find(id)
        if params[:user][:attendances][id][:overwork_change] == "true"
          attendance.update_attributes(item)
        flash[:success] = "残業申請処理が完了しました。"
        else    
          flash[:danger] = "変更する場合はチェックを入れてください。"
        end      
    end
    redirect_to user_url
  end
 
  
  private
    #勤怠変更申請
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :tomorrow, :note, :worktime_check_superior, :worktime_approval])[:attendances]
    end
    
    #勤怠変更承認
    def worktime_approval_params 
      params.require(:user).permit(attendances: [:started_at, :finished_at, :worktime_approval, :worktime_change, :worktime_check_superior])[:attendances]
    end
    
    #1ヶ月申請
    def month_params
      params.require(:user).permit(:month_check_superior).merge(user_id: params[:id], month_status: '申請中', apply_month: params[:date].to_date).to_h
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

    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "編集権限がありません。"
        redirect_to(root_url)
      end
    end
   
    def get_changes
      @change_cols = self.changes
    end
end