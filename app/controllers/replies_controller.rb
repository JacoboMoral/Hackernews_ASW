class RepliesController < ApplicationController

  def create
    auth_user = current_user
    begin
      tmp = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
      if (tmp)
        auth_user = tmp
      end
    rescue
      # intentionally left out
    end

    if auth_user
      @reply = Reply.new(reply_params)
      @reply.user = auth_user


       respond_to do |format|
        if @reply.save
           format.html { redirect_to @reply.comment.contribution, notice: 'Reply was successfully created.' }
           format.json { render :show, status: :created, location: @reply }
        else
          format.html { redirect_to '/comments/' + (@reply.comment.id).to_s, notice: 'Please add a comment before submitting.' }
          format.json { render json: @reply.errors, status: :unprocessable_entity }
        end
       end
    else
      redirect_to "/auth/google_oauth2"
    end
  end

  def vote
    return redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @reply = Reply.find(params[:id])
    begin
      @reply.liked_by current_user
      rescue Exception do |exception|
        raise exception
      end
    end

    redirect_to @reply.comment.contribution
  end


  def unvote
    return redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @reply = Reply.find(params[:id])
    begin
      @reply.downvote_from current_user
      rescue Exception do |exception|
        raise exception
      end
    end

    redirect_to @reply.comment.contribution
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reply_params
      params.require(:reply).permit(:content, :user_id, :comment_id)
    end

end
