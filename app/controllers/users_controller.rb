class UsersController < ApplicationController
  # for creating the instance variable @user before edit, update and show method
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

	def index
		@users = User.all
	end

	def new
		@user = User.new
	end

	def index 
    @users = User.paginate(page: params[:page], per_page: 4)

  end

	def create
		@user = User.new(user_params)
		if @user.save
			# new user will directly be logged into his account 
			session[:user_id] = @user.id
			flash[:success] = "Welcome to blog #{@user.username}"
			#.. and redirected to his profile page
			redirect_to user_path(@user.id)
		else
			render 'new'
		end
	end

	def edit
		
	end

	def update
		if @user.update(user_params)
			flash[:success] = "Changes has been saved"
			redirect_to articles_path
		else
			render 'edit'
		end
	end

	def show
		@user_articles = @user.articles.paginate(page: params[:page], per_page: 4)

	end

	def destroy
		@user = User.find(params[:id])
		@user.destroy
		flash[:danger] = "User and all of it's articles has been deleted"
		redirect_to users_path
	end

	private
	def user_params
		params.require(:user).permit(:username, :email, :password)
		
	end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
  	if current_user != @user and !current_user.admin?
  		flash[:danger] = "You can edit only your profile"
  		redirect_to root_path
  	end
  	
  end

  def require_admin
  	if logged_in? and !current_user.admin?
  		flash[:danger] = "only admin user can perform this task"
  	end
  end
  
end