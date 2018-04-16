class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def main
      render html: "pagina principal"
  end
end
