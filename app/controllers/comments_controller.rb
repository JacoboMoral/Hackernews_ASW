class CommentsController < ApplicationController
before_action :find_contribution

  def create
    @comment = @contribution.comments.create(params[:comment].permit(:content))
    @comment.user_id = 1 #TODO: de moment hardcodejat!
    @comment.save

    if @comment.save
      redirect_to contributions_path(@contribution)
    else
      render 'new'
    end

  end

  private
  def find_contribution
    @contribution = Contribution.find(params[:contribution_id])
  end
end
