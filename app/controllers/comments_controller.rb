class CommentsController < ApplicationController

    def create

        auth_user = current_user
        begin
          tmp = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
          if (tmp)
            puts tmp.name
            auth_user = tmp
          end
        rescue
        end

        if auth_user
            @comment = Comment.new(comment_params)
            @comment.user = auth_user
            respond_to do |format|
                if @comment.save
                    format.html { redirect_to @comment.contribution, notice: 'Comment was successfully created.' }
                    format.json { render :show, status: :created, location: @comment }
                else
                    format.html { redirect_to @comment.contribution, notice: 'Please add a comment before submitting.' }
                    format.json { render json: @comment.errors, status: :unprocessable_entity }
                end
            end
        else
            redirect_to "/auth/google_oauth2"
        end
    end

    private
        def comment_params
            params.require(:comment).permit(:content, :user_id, :contribution_id)
        end
end
