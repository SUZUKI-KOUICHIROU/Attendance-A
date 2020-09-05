class BasesController < ApplicationController
  before_action :set_base, only: %i(edit update destroy)
  before_action :admin_user

  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new
  end

  def create
    @base = Base.new(base_params)
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
    else
      flash[:danger] = "拠点情報の追加は失敗しました。<br>" + @base.errors.full_messages.join("<br>")
    end
      redirect_to bases_url
  end

  def edit
  end
  
  def update
    if @base.update_attributes(base_params)
      flash[:success] = "拠点の更新に成功しました。"
    else
      flash[:danger] = "拠点情報の更新は失敗しました。<br>" + @base.errors.full_messages.join("<br>")
    end
      redirect_to bases_url
  end
  
  def destroy
    @base.destroy
    flash[:success] = "#{@base.base_name}のデータを削除しました。"
    redirect_to bases_url
  end


  private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end  
end
