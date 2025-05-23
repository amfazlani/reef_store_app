class ApplicationController < ActionController::API
 rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { errors: "Resource could not be found" }, status: :not_found
  end

  def clear_cache
    Rails.cache.clear # invalidate cache
  end
end
