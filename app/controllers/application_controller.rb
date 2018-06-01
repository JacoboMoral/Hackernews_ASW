class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def user_is_logged_in?
    !!session[:user_id]
  end

  private

  def record_not_found
    render :file => "public/404.html", :status => 404
  end

  protected

  def authenticate
    if request.authorization and user = User.find_by_email(decode(request.authorization))
      @api_user = user
    else
      render_unauthorized
    end
  end

  def render_unauthorized
    render json: {:error => 'Unauthorized'}.to_json, :status => 401
  end

  def render_not_found
    render :json => {:error => "not-found"}.to_json, :status => 404
  end

end
