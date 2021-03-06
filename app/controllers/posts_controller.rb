class PostsController < ApplicationController
  before_action :must_logged_in, only: [:new, :create, :edit, :update]
  before_action :must_be_admin, only: [:destroy]

  def index
    if(params[:member_id].present?)
      @member = Member.find_by(id: params[:member_id])
      if @member.present?
        @posts = @member.posts.paginate(page: params[:page])
      end
    end
  end

  def show
    @post = Post.find_by(id: params[:id])
    if @post.present?
      @comments = @post.comments.paginate(page: params[:page])
      @post.update_attribute(:number_views, @post.number_views+1)
      if current_member.present?
        if current_member.id == @post.member.id
          notifications_post = Notification.where(post_id: @post.id, status: "haven't seen")
          unless notifications_post.empty?
            notifications_post.each do |notification|
              notification.update_attribute(:status, "seen")
            end
          end
        end
      end
    else
      redirect_to root_path
      flash[:danger] = "The post doesn't exist"
    end
  end

  def new
    @post = Post.new
    @topics = Topic.all
  end

  def create
    @post = Post.new(post_params)
    @post.member_id = current_member.id
    @post.status = "open"
    @post.number_views = 0
    if @post.save
      redirect_to post_path(@post.id)
      @post.update_attribute(:last_comment_at, @post.created_at)
      flash[:success] = "Success"
    else
      @topics = Topic.all
      render "new"
    end
  end

  def edit
    @post = Post.find_by(id: params[:id])
    if @post.present?
      unless current_member == @post.member
        redirect_to @post
        flash[:danger] = "Permission denied"
      end
    else
      redirect_to root_path
      flash[:danger] = "The post doesn't exist"
    end
  end

  def update
    @post = Post.find_by(id: params[:id])
    if @post.present?
      if current_member == @post.member
        if @post.update_attributes(post_params)
          redirect_to @post
          flash[:success] = "Edit successfully"
        else
          render "edit"
        end
      else
        redirect_to @post
        flash[:danger] = "Permission denied"
      end
    else
      redirect_to root_path
      flash[:danger] = "The post doesn't exist"
    end
  end

  def destroy
    @post = Post.find_by(id: params[:id])
    if @post.present?
      @post.update_attribute(:status, "closed")
      redirect_to @post
      flash[:success] = "Closed Topic"
    else
      redirect_to root_path
      flash[:danger] = "The post doesn't exist"
    end
  end

  private
    def post_params
      params.require(:post).permit(:topic_id, :title, :content)
    end

    def must_logged_in
      unless logged_in?
        redirect_to login_url
        flash[:danger] = "Please login to continue!"
      end
    end

    def must_be_admin
      if logged_in?
        unless current_member.role == "admin"
          redirect_to current_member
          flash[:danger] = "Permission denied"
        end
      else
        redirect_to login_url
        flash[:danger] = "Please login to continue!"
      end
    end
end
