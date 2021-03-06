class HomeController < ApplicationController
  before_action :set_user, except: :front
  respond_to :html, :js

  def index
    @post = Post.new
    @friends = @user.all_following.unshift(@user)
    @activities = PublicActivity::Activity.where(owner_id: @friends).order(created_at: :desc).paginate(page: params[:page], per_page: 10)

  end

  def about
    Rails.cache.fetch('users') {User.all}
    @users = Rails.cache.fetch('users')
  end


  def front

    @activities = PublicActivity::Activity.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def find_friends
    @friends = @user.all_following
    if params[:search]
      @users =  User.where.not(id: @friends.unshift(@user)).search(params[:search]).order("created_at DESC").paginate(page: params[:page])
    else
      @users =  User.where.not(id: @friends.unshift(@user)).paginate(page: params[:page])
    end
  end

  private
  def set_user
    @user = current_user
  end
end
