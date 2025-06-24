class ApplicationController < ActionController::Base
  # Handle CanCanCan authorization exceptions
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to main_app.root_url, alert: exception.message }
    end
  end
  
  protected
  
  def ensure_admin
    redirect_to root_path, alert: 'Access denied.' unless current_user&.admin?
  end
end
