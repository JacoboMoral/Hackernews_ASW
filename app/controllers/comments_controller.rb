class CommentsController < ApplicationController
# include SessionsHelper
# before_action :auth_token, only: []
# skip_before_action :verify_authenticity_token
# before_action :auth_token, only: [:apiCreate, :apiCreateReply, :apiUpvote, :apiUnvote, :apiDelete]
# skip_before_action :verify_authenticity_token, only: [:apiCreate, :apiCreateReply, :apiUpvote, :apiUnvote, :apiDelete]

    def newReply
        @comment = Comment.find(params[:id])
        @replies = Reply.where("comment_id=?",@comment.id).order("created_at DESC")
    end

    def index
      @comments = Comment.all
    end

    def show
    end

    def contribution_comments
       begin
        @comments = Comment.where("contribution_id=?", params[:id]).order("created_at DESC")
      rescue ActiveRecord::RecordNotFound
        render :json => { "code" => "404", "message" => "Contribution not found."}, status: :not_found
      end
    end

    def user_comments
    begin
      @user = User.find(params[:user])
      @comments = Comment.where("user_id=?", params[:user]).order("created_at DESC")
    rescue ActiveRecord::RecordNotFound
      render :json => { "code" => "404", "message" => "User not found."}, status: :not_found
    end
  end


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

    def apiCreateComment
      key = request.headers["X-API-KEY"]
      @user = User.find(params[:idu])
        if @user.oauth_token == key
          @contribution = Contribution.find(params[:id])
          if @contribution == nil
            render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error
          else
            @comment = Comment.new(params.permit(:content))
            @comment.user_id = params[:idu]
            @comment.contribution_id = params[:id]
            if @comment.save
              render json: {status: 'SUCCESS', message: 'Comment saved', data: @comment}, status: :ok
            else
              render json: {status: 'ERROR', message: 'Internal server error', data:[]}, status: :internal_server_error

            end
          end
        else
          render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
        end
    end

    def threads
      @user = User.find(params[:id])
      @commentsandreplies = (Comment.where(user_id: @user.id) + Reply.where(user_id: @user.id)).sort_by(&:created_at).reverse
      respond_to do |format|
          format.html
          format.json { render json: @commentsandreplies }
        end
    end


    def vote
      return redirect_to '/auth/google_oauth2' unless user_is_logged_in?

      @comment = Comment.find(params[:id])
      begin
        @comment.liked_by current_user
        rescue Exception do |exception|
          raise exception
        end
      end

      redirect_to @comment.contribution
    end

    def apiUpVote
      key = request.headers["X-API-KEY"]
      @user = User.find(params[:idu])
      if @user.oauth_token == key
        @comment = Comment.find(params[:id])
        if @comment == nil
          render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
        end
        @comment.liked_by @user
        render json: {status: 'SUCCESS', message: 'Comment upvoted', data: []}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
      end
    end


    def unvote
      return redirect_to '/auth/google_oauth2' unless user_is_logged_in?

      @comment = Comment.find(params[:id])
      begin
        @comment.downvote_from current_user
        rescue Exception do |exception|
          raise exception
        end
      end

      redirect_to @comment.contribution
    end

    def apiDownVote
      key = request.headers["X-API-KEY"]
      @user = User.find(params[:idu])
      if @user.oauth_token == key
        @comment = Comment.find(params[:id])
        if @comment == nil
          render json: {status: 'ERROR', message: 'Comment does not exist', data: []}, status: :internal_server_error
        end
        @comment.unliked_by @user
        render json: {status: 'SUCCESS', message: 'Comment upvoted', data: []}, status: :ok
      else
        render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
      end
    end

    private
      def comment_params
          params.require(:comment).permit(:content, :user_id, :contribution_id)
      end

      def auth_token
        auth_user = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
        if !auth_user
          render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
        end
      end
end
