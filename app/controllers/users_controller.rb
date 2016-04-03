class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update,
                                       :following, :followers]

  def show
   @user = User.find(params[:id])
   @microposts = @user.microposts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Complete Update!"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def following
    @user  = User.find(params[:id])
    @users = @user.following_users
    render 'show_follow'
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.follower_users
    render 'show_follower'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :location, :URL, :introduction)
  end
  
  def logged_in_user
    @user = User.find(params[:id])
    if current_user != @user
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end    
end