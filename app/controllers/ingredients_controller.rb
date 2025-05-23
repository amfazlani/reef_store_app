class IngredientsController < ApplicationController
  before_action :find_item, only: [ :index, :create ]
  before_action :find_ingredient, only: [ :show, :update, :destroy ]
  after_action :clear_cache, only: [ :create, :update, :destroy ]

  def index
    cache_key = "items/#{@item.id}/ingredients"

    cached_ingredients = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      @item.ingredients
    end

    render json: { data: cached_ingredients, status: 200 }
  end

  def create
    @ingredient = Ingredient.new(ingredient_params.merge(item_id: @item.id))

    if @ingredient.save
      render json: { data: @ingredient, message: "Ingredient created successfully", status: 200 }
    else
      render json: { errors: @ingredient.errors.full_messages }, status: 422
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      render json: { data: @ingredient, message: "Ingredient updated successfully", status: 200 }
    else
      render json: { errors: @ingredient.errors.full_messages }, status: 422
    end
  end

  def destroy
    if @ingredient.destroy
      render json: { data: @ingredient, message: "Ingredient deleted successfully", status: 200 }
    else
      render json: { errors: @ingredient.errors.full_messages }, status: 422
    end
  end

  def show
    render json: { data: @ingredient, status: 200 }
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity)
  end

  def find_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def find_item
    @item = Item.find(params[:item_id])
  end

  def clear_cache
    Rails.cache.delete("items/#{@item.id}/ingredients") if @item
  end
end
