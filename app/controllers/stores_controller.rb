class StoresController < ApplicationController
  before_action :find_store, only: [:show, :update, :destroy]

  def index
    @stores = Store.all

    if params[:q].present?
      @stores = filter_stores
    end

    @stores = @stores.page(params[:page]).per(params[:limit] || 5)

    render json: {
      data: @stores,
      meta: {
        total: @stores.total_count,
        page: @stores.current_page,
        limit: @stores.limit_value,
        total_pages: @stores.total_pages
      }
    }
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      render json: { data: @store, message: 'Store created successfully', status: 200 }
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def update
    if @store.update(store_params)
      render json: { data: @store, message: 'Store updated successfully', status: 200 }
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def destroy
    if @store.destroy
      render json: { data: @store, message: 'Store deleted successfully', status: 200 }
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def show
    render json: { data: @store, status: 200 }
  end

  private

  def store_params
    params.require(:store).permit(:name, :address, :description)
  end


  def find_store
    @store = Store.find(params[:id])
  end

  def filter_stores
    @stores = @stores.where('name ILIKE ?', "%#{params[:q]}%")
  end
end
