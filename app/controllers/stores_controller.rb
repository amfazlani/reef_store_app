class StoresController < ApplicationController
  before_action :find_store, only: [:show, :update, :destroy]

  def index
    @stores = Store.all.order(:name)

    render json: { data: @stores, status: 200 }
  end

  def create
    @store = Store.new(store_params)

    if @store.save
      render json: { data: @store }, status: 200
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def update
    if @store.update(store_params)
      render json: { data: @store, status: 200 }
    else
      render json: { errors: @store.errors }, status: 422
    end
  end

  def destroy
    if @store.destroy
      render json: { data: @store, status: 200 }
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
end
