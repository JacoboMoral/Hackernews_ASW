class CommentsController < ApplicationController

    def create
        @comment = Comment.new(comment_params)
        respond_to do |format|
            if @comment.save
                format.html { redirect_to @comment.contribution, notice: 'Comment was successfully created.' }
                format.json { render :show, status: :created, location: @comment }
            else
                format.html { render :new }
                format.json { render json: @comment.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def comment_params
            params.require(:comment).permit(:content, :user_id, :contribution_id)
        end
end
