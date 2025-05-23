class ItemsController < ApplicationController
  before_action :find_store, only: [ :index, :create, :count ]
  before_action :find_item, only: [ :show, :update, :destroy ]
  after_action :clear_cache, only: [:create, :update, :destroy]

  def index
    cache_key = "stores/#{@store.id}/items"

    cached_items = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      @store.items
    end

    render json: { data: cached_items, status: 200 }
  end

  def create
    @item = Item.new(item_params.merge(store_id: @store.id))

    if @item.save
      render json: { data: @item, message: "item created successfully", status: 200 }
    else
      render json: { errors: @item.errors.full_messages }, status: 422
    end
  end

  def update
    if @item.update(item_params)
      render json: { data: @item, message: "item updated successfully", status: 200 }
    else
      render json: { errors: @item.errors.full_messages }, status: 422
    end
  end

  def destroy
    if @item.destroy
      render json: { data: @item, message: "item deleted successfully", status: 200 }
    else
      render json: { errors: @item.errors.full_messages }, status: 422
    end
  end

  def show
    render json: { data: @item, status: 200 }
  end

  def count
    count = @store.items.count

    render json: { data: count, status: 200 }
  end

  private

  def item_params
    params.require(:item).permit(:name, :price, :description)
  end

  def find_item
    @item = Item.find(params[:id])
  end

  def find_store
    @store = Store.find(params[:store_id])
  end

  def clear_cache
    Rails.cache.delete("stores/#{@store.id}/items") if @store
  end
end
