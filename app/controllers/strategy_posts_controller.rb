class StrategyPostsController < ApplicationController
  def show
    @post = StrategyPost.find(params[:id])
  end
  
  def create
    @post = StrategyPost.new(params[:strategy_post])
    redirect_to:back, :flash => @post.save ? {:notice => "Successfully created post."} : {:error => "Unable to create post."}
  end
end
