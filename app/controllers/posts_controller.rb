class PostsController < ApplicationController

  before_action :check_logon, except: %w[show]
  before_action :set_forum, only: %w[create new]
  before_action :set_post, only: %w[show edit update destroy]
  before_action :check_access, only: %w[edit update delete]

  def create
    @post = @forum.posts.new(post_params)  # we create a new post for the current forum
    @post.user = @current_user

    if @post.save
       redirect_to @post, notice: "Your post was created."
    else
        render :new
    end
  end

  def new
    @post = @forum.posts.new  
  end

  def edit
  end

  def show
  end

  def update
   # @post = Post.new(post_params)
   #@post.save
   # redirect_to @post, notice: "Your post was updated."
  
    if @post.update(post_params)
      redirect_to @post, notice: "Your post was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @forum = @post.forum # we need to save this, so we can redirect to the forum after the destroy
    @post.destroy
    redirect_to @forum, notice: "Your post was deleted."
  end

  private

  def check_logon 
    if !@current_user
      redirect_to forums_path, notice: "You can't add, modify, or delete posts before logon."
    end
  end

  def set_forum
    @forum = Forum.find(params[:forum_id])  # If you check the routes for posts, you see that this is the 
  end                                         # forum parameter

  def set_post
    @post = Post.find(params[:id])
  end

  def check_access
    if @post.user_id != session[:current_user]
      redirect_to forums_path, notice: "That's not your post, so you can't change it."
    end
  end

  def post_params   # security check, also known as "strong parameters"
  #  params[:post][:user_id] = session[:current_user]["id"] 
       # here we have to add a parameter so that the post is associated with the current user
   # params.require(:post).permit(:title,:content,:user_id)

   # updated code here
   if @current_user.present?
    params[:post][:user_id] = @current_user.id
  else
    Rails.logger.error "Current user not found in session."
    # Handle this case appropriately
  end

  params.require(:post).permit(:title, :content, :user_id, :forum_id)
end

end