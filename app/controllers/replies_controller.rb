class RepliesController < ApplicationController


  # GET /replies.json
  def index
    @replies = Reply.all
  end

  #Get /replies/1.json
  def show
    @reply = Reply.find(params[:id])
  end

  def comment_replies
    begin
      @replies = Reply.where("comment_id=?", params[:id]).order("created_at DESC")
    rescue ActiveRecord::RecordNotFound
      render :json => { "code" => "404", "message" => "Comment not found."}, status: :not_found
    end
  end

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

  def apiCreateReply
    key = request.headers["X-API-KEY"]
    @user = User.find(params[:idu])
      if @user.oauth_token == key
        @comment = Comment.find(params[:id])
        if @comment == nil
          render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error
        else
          @reply = Reply.new(params.permit(:content))
          @reply.user_id = params[:idu]
          @reply.comment_id = params[:id]
          if @reply.save
            render json: {status: 'SUCCESS', message: 'Comment saved', data: @reply}, status: :ok
          else
            render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error

          end
        end
      else
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
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

  def apiUpVote
    key = request.headers["X-API-KEY"]
    @user = User.find(params[:idu])
    if @user.oauth_token == key
      @reply = Reply.find(params[:id])
      if @reply == nil
        render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
      end
      @reply.liked_by @user
      render json: {status: 'SUCCESS', message: 'Comment upvoted', data: []}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
    end
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

  def apiDownVote
    key = request.headers["X-API-KEY"]
    @user = User.find(params[:idu])
    if @user.oauth_token == key
      @reply = Reply.find(params[:id])
      if @reply == nil
        render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
      end
      @reply.unliked_by @user
      render json: {status: 'SUCCESS', message: 'Comment upvoted', data: []}, status: :ok
    else
      render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def reply_params
      params.require(:reply).permit(:content, :user_id, :comment_id)
    end

end
