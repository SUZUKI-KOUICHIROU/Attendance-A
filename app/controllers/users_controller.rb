class UsersController < ApplicationController
  before_action :set_user, only: %i(show edit update destroy edit_basic_info update_basic_infos)
  before_action :logged_in_user, only: %i(index show edit update destroy edit_basic_info update_basic_info)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(index destroy working_employee edit_basic_info update_basic_info)
  before_action :not_admin_user, only: %i(show)
  before_action :correct_superior_user, only: %i(show)
  before_action :set_one_month, only: %i(show)
  before_action :superior_choice, only: %i(show)


  def index
    @users = User.paginate(page: params[:page]).search(params[:search])
  end

  def import
    # fileはtmpに自動で一時保存される
    if User.import(params[:file])
      flash[:success] = 'インポートしました。'
    else
      flash[:danger] = "インポート失敗しました。"
    end
    redirect_to users_url
  end
  
  def show
    @approval = @user.attendances.find_by(worked_on: @first_day)
    @worked_sum = @attendances.where.not(started_at: nil).count  
    #申請お知らせ
    @approval_sum1 = Attendance.where(month_check_superior: "上長A", month_status: "申請中").count
    @approval_sum2 = Attendance.where(month_check_superior: "上長B", month_status: "申請中").count
    @approval_sum3 = Attendance.where(worktime_check_superior: "上長A", worktime_approval: "申請中").count
    @approval_sum4 = Attendance.where(worktime_check_superior: "上長B", worktime_approval: "申請中").count 
    @approval_sum5 = Attendance.where(superior_confirmation: "上長A", overwork_status: "申請中").count
    @approval_sum6 = Attendance.where(superior_confirmation: "上長B", overwork_status: "申請中").count
    #申請結果
    @result_sum1 = Attendance.where(user_id: @user.id, month_status: "3").count
    @result_sum2 = Attendance.where(user_id: @user.id, month_status: "4").count
    @result_sum7 = Attendance.where(user_id: @user.id, month_status: "申請中").count
    
    @result_sum3 = Attendance.where(user_id: @user.id, worktime_approval: "承認").count
    @result_sum4 = Attendance.where(user_id: @user.id, worktime_approval: "否認").count
    @result_sum8 = Attendance.where(user_id: @user.id, worktime_approval: "申請中").where.not(worktime_check_superior: nil).count
    
    @result_sum5 = Attendance.where(user_id: @user.id, overwork_status: "承認").count
    @result_sum6 = Attendance.where(user_id: @user.id, overwork_status: "否認").count
    @result_sum9 = Attendance.where(user_id: @user.id, overwork_status: "申請中").where.not(superior_confirmation: nil).count
  end

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
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
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


   private

    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end 
