class PostsController < ApplicationController

  def index
    @posts=Post.all
  end

  def new
    @post=Post.new
  end

  def create
    @topic=Topic.find(params[:topic_id])
    @post=@topic.posts.create(post_params)
    if @post.save
      redirect_to @topic
    else
      render 'new'
    end
  end

  private
  def post_params
    params.require(:post).permit(:name,:content)
  end

end
