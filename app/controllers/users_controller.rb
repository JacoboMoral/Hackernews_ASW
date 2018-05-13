class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if current_user && current_user.id == @user.id
      redirect_to :controller => 'users', :action => 'edit'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if !current_user || (current_user && current_user.id != @user.id)
      redirect_to :controller => 'users', :action => 'show'

    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_authenticated
    auth_user = current_user
    begin
      tmp = User.where("oauth_token=?", request.headers["HTTP_API_KEY"])[0]
      if (tmp)
        auth_user = tmp
      end
    rescue ActiveRecord::RecordNotFound
      render :json => { "status" => "404", "error" => "User not found."}, status: :not_found
    end
    @user = auth_user

    respond_to do |format|
      if auth_user.update(user_params)
        format.html { redirect_to action: 'show', id: auth_user.id }
        format.json { render :show, status: :ok, location: auth_user }
      else
        format.html { render :edit }
        format.json { render json: auth_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :user_id, :about)
    end
end
