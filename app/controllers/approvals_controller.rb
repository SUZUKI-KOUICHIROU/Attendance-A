class ApprovalsController < ApplicationController
  protect_from_forgery  
  
  before_action :set_user, only: %i(edit_month_approval update_month_approval)
  

  
  def create
    @user = User.find(params[:user_id])
    @approval = @user.approvals.create(approvals_params)
    #@superior_user = User.where(superior: true)
    
      if @approval.save
        flash[:success] = "申請しました。"
        redirect_to @user  
      else
        flash[:danger] = "申請失敗しました。"
        redirect_to @user  
      end
  end

  #1ヵ月承認ページ
  def index
    @user = User.find(params[:user_id])
    @users = User.where(params[:user_id])
    #@approvals = User.joins(:approvals).group("users.id").where.not(approvals: {superior_id: nil})
    @approval_user = Approval.find(params[:user_id])
    #@approvals = Approval.where(params[:superior_id].present?, id: params[:superior_id])
    #@approvals = User.joins(:approval).where(superior_id: 2) 
    #@approvals = Approval.where(params[:superior_id])
    @approvals = Approval.where(month_checker:1, superior_id: 3).map{ |a| [a.id, a.attributes.delete("id")] }
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day]
    @month_approval =  ["申請なし", "申請中", "承認", "否認"]
    
  end

  #1ヵ月承認

  def update_month_approval
    @user = User.find(params[:user_id])
    @approval_month = Attendance.find(params[:id])
      if params[:approval][:status_change] == "1" 
         @approval_month.update_attributes(superior_approval_params)
          flash[:success] = "申請処理しました。"
          redirect_to @user
      else
          flash[:danger] = "変更する場合はチェックを入れてください。"
          redirect_to @user
      end   
  end


    private
      def approvals_params
        params.permit(:superior_id)
      end

      def superior_approval_params
        params.require(:approval).permit(:month_checker)
      end
end
