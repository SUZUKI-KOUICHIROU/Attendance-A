class UsersController < ApplicationController
  
  require 'csv'

  before_action :set_user, only: %i(show edit update update_userinformation destroy edit_basic_info update_basic_infos update_month_apply confirmation_show)
  before_action :logged_in_user, only: %i(show edit update destroy edit_basic_info update_basic_info)
  before_action :correct_user, only: %i(show edit)
  before_action :admin_user, only: %i(index update_userinformation destroy working_employee edit_basic_info update_basic_info)
  before_action :not_admin_user, only: %i(show)
  before_action :correct_superior_user, only: %i(confirmation_show)
  before_action :set_one_month, only: %i(show confirmation_show)
  before_action :superior_choice, only: %i(show)
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'アカウント作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def show
    #CSV出力
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_attendances_csv(@attendances)
      end
    end 

    @approval = @user.attendances.find_by(worked_on: @first_day)
    @worked_sum = @attendances.where.not(started_at: nil).count  
    #申請お知らせ
    @approval_sum1 = Attendance.where(month_check_superior: "上長A", month_status: "申請中").count
    @approval_sum2 = Attendance.where(month_check_superior: "上長B", month_status: "申請中").count
    @approval_sum3 = Attendance.where(worktime_check_superior: "上長A", worktime_approval: "申請中").count
    @approval_sum4 = Attendance.where(worktime_check_superior: "上長B", worktime_approval: "申請中").count 
    @approval_sum5 = Attendance.where(superior_confirmation: "上長A", overwork_status: "申請中").count
    @approval_sum6 = Attendance.where(superior_confirmation: "上長B", overwork_status: "申請中").count
  end
  
  def confirmation_show
    @approval = @user.attendances.find_by(worked_on: @first_day)
    @worked_sum = @attendances.where.not(started_at: nil).count  
    #申請お知らせ
    @approval_sum1 = Attendance.where(month_check_superior: "上長A", month_status: "申請中").count
    @approval_sum2 = Attendance.where(month_check_superior: "上長B", month_status: "申請中").count
    @approval_sum3 = Attendance.where(worktime_check_superior: "上長A", worktime_approval: "申請中").count
    @approval_sum4 = Attendance.where(worktime_check_superior: "上長B", worktime_approval: "申請中").count 
    @approval_sum5 = Attendance.where(superior_confirmation: "上長A", overwork_status: "申請中").count
    @approval_sum6 = Attendance.where(superior_confirmation: "上長B", overwork_status: "申請中").count  
  end
  
  #1ヶ月申請
  def update_month_apply
    @attendance = @user.attendances.find_by(worked_on: params[:user][:apply_month])
    if params[:user][:month_check_superior].present?
      @attendance.month_status = "申請中"
      @attendance.update_attributes(month_params)
      flash[:success] = "1ヶ月申請が完了しました。"
    else
      flash[:danger] = "所属長を選択して下さい。"
    end
    redirect_to user_url(date: params[:date]) 
  end  
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end

  def update_userinformation
    if @user.update_attributes(userinformation_params)
      flash[:success] = "#{@user.name}のアカウント情報を更新しました。"
    elsif
      userinformation_params[:name].blank?
      flash[:danger] = "名前が入力されていません。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")  
    end
    redirect_to users_path
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  #CSVインポート
  def import
    # fileはtmpに自動で一時保存される
    if User.import(params[:file])
      flash[:success] = 'インポートしました。'
    else
      flash[:danger] = "インポート失敗しました。"
    end
    redirect_to users_url
  end
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  def working_employee
    @users = User.all.includes(:attendances)
  end
  
  # 勤怠csv出力
  def send_attendances_csv(csv_attendances)
    csv_data = CSV.generate(headers: true) do |csv|
      header = ["日付", "出社時間", "退社時間", "備考"]
      # 表のカラム名を定義
      csv << header
      # column_valuesに代入するカラム値を定義
      csv_attendances.each do |attendance|
        
        values = [attendance.worked_on,
          attendance.before_started_at.present? && attendance.worktime_check_superior.blank? || attendance.worktime_approval.try(:include?, "承認") ? attendance.before_started_at.floor_to(15.minutes).strftime("%H:%M") : nil,
          attendance.before_finished_at.present? && attendance.worktime_check_superior.blank? || attendance.worktime_approval.try(:include?, "承認") ? attendance.before_finished_at.floor_to(15.minutes).strftime("%H:%M") : nil,
          
          if attendance.worktime_approval.try(:include?, "承認") 
            attendance.note
          else
            nil
          end
        ]
        # 表の値を定義
        csv << values
      end
    end
    send_data(csv_data, filename: "【勤怠表】#{User.find(params[:id]).name}#{Time.zone.now.strftime("(%Y年%m月)")}.csv")
  end
   
   
   
   
   
   
   
   
   
   private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    #1ヶ月申請
    def month_params
      params.require(:user).permit(:month_check_superior)
    end  
    
    def userinformation_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number, :uid, :password, :password_confirmation, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end
