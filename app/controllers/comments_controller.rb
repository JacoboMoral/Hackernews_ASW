class CommentsController < ApplicationController

    def new
        @comment = Comment.new
    end
    def create
        @comment = Comment.new(comment_params)
        if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
    def show
        @comment = Comment.find(params[:id])
    end

    private
        def comment_params
            params.require(:comment).permit(:content, :user_id, :contribution_id)
        end
end
