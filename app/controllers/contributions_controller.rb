class ContributionsController < ApplicationController
  include SessionsHelper
  before_action :auth_token, only: []
  skip_before_action :verify_authenticity_token
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  VIEWS = {
    submit: 'submit',
    ask: 'ask',
    newest: 'newest'
  }.freeze

  # GET /contributions
  # GET /contributions.json
  def index
    @contributions = Contribution.where.not(url: '').order(points: :desc)
  end

    def user_contributions
    begin
      @user = User.find(params[:user])
      @contributions = Contribution.where("user_id=?", params[:user]).order("created_at DESC")
    rescue ActiveRecord::RecordNotFound
      render :json => { "status" => "404", "error" => "User not found."}, status: :not_found
    end
  end

  # GET /contributions/newest
  # GET /contributions/newest
  def newest
    @view = VIEWS[:newest]
    @contributions = Contribution.all.order(created_at: :desc)
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @contributions }
    end
  end

  # GET /contributions/ask
  # GET /contributions/ask
  def ask
    @view = VIEWS[:ask]
    @contributions = Contribution.where(url: '')
    respond_to do |format|
      format.html { render :index }
      format.json { render json: @contributions }
    end
  end

  # GET /contributions/1
  # GET /contributions/1.json
  def show
      @comment = Comment.new(contribution_id: params[:id])
      @comments = Comment.where("contribution_id=" + (params[:id])).order("created_at DESC")
  end

  # GET /contributions/new
  def new
    redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @view = VIEWS[:submit]
    @contribution = Contribution.new
  end

  # GET /contributions/1/edit
  def edit
  end

  # POST /contributions
  # POST /contributions.json
  def create
    redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @contribution = Contribution.new(contribution_params)

    respond_to do |format|
      if @contribution.save
        format.html { redirect_to @contribution, notice: 'Contribution was successfully created.' }
        format.json { render :show, status: :created, location: @contribution }
      else
        format.html { render :new }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contributions/1
  # PATCH/PUT /contributions/1.json
  def update
    respond_to do |format|
      if @contribution.update(contribution_params)
        format.html { redirect_to @contribution, notice: 'Contribution was successfully updated.' }
        format.json { render :show, status: :ok, location: @contribution }
      else
        format.html { render :edit }
        format.json { render json: @contribution.errors, status: :unprocessable_entity }
      end
    end
  end

  def vote
    return redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @contribution = Contribution.find(params[:id])
    begin
         @contribution.liked_by current_user
       rescue Exception do |exception|
           raise exception
         end
       end

    redirect_to "/"
  end

  def unvote
    redirect_to '/auth/google_oauth2' unless user_is_logged_in?

    @contribution = Contribution.find(params[:id])
    begin
      @contribution.downvote_from current_user
      rescue Exception do |exception|
        raise exception
      end
    end

    redirect_to "/"
  end

  # DELETE /contributions/1
  # DELETE /contributions/1.json
  def destroy
    @contribution.destroy
    respond_to do |format|
      format.html { redirect_to contributions_url, notice: 'Contribution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contribution
    @contribution = Contribution.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contribution_params
    params[:contribution][:user_id] = current_user.id
    params.require(:contribution).permit(:title, :url, :text, :user_id)
  end

  def auth_token
    auth_user = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
    if !auth_user
      render json: {status: 'ERROR', message: 'Authentication error', data:[]}, status: :unauthorized
    end
  end
end
