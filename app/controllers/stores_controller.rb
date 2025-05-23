class StoresController < ApplicationController
  before_action :find_store, only: [ :show, :update, :destroy ]

  def index
    cache_key = "stores/index/#{params[:page] || 1}-#{params[:limit] || 5}-#{params[:q]}"

    result = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      stores = Store.all.ordered

      if params[:q].present?
        stores = stores.where("name ILIKE ?", "%#{params[:q]}%")
      end

      paginated = stores.page(params[:page]).per(params[:limit] || 5)

      {
        data: paginated.as_json,
        meta: {
          total: paginated.total_count,
          page: paginated.current_page,
          limit: paginated.limit_value,
          total_pages: paginated.total_pages
        }
      }
    end

    render json: result
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      clear_cache

      render json: { data: @store, message: "Store created successfully", status: 200 }
    else
      render json: { errors: @store.errors.full_messages }, status: 422
    end
  end

  def update
    if @store.update(store_params)
      clear_cache

      render json: { data: @store, message: "Store updated successfully", status: 200 }
    else
      render json: { errors: @store.errors.full_messages }, status: 422
    end
  end

  def destroy
    if @store.destroy
      clear_cache

      render json: { data: @store, message: "Store deleted successfully", status: 200 }
    else
      render json: { errors: @store.errors.full_messages }, status: 422
    end
  end

  def show
    render json: { data: @store, status: 200 }
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :description, :place_id)
  end


  def find_store
    @store = Store.find(params[:id])
  end

  def filter_stores
    @stores = @stores.where("name ILIKE ?", "%#{params[:q]}%")
  end
end
