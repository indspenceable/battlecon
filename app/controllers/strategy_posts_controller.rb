class StrategyPostsController < ApplicationController
  def show
    @post = StrategyPost.find(params[:id])
  end
end
