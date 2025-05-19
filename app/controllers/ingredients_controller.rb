class IngredientsController < ApplicationController
  before_action :find_item, except: [:destroy]
  before_action :find_ingredient, only: [:show, :update, :destroy]

  def index
    @ingredients = @item.ingredients

    render json: { data: @ingredients, status: 200 }
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
      render json: { data: @ingredient }, status: 200
    else
      render json: { errors: @ingredient.errors }, status: 422
    end
  end

  def update
    if @ingredient.update(ingredient_params)
      render json: { data: @ingredient, status: 200 }
    else
      render json: { errors: @ingredient.errors }, status: 422
    end
  end

  def destroy
    if @ingredient.destroy
      render json: { data: @ingredient, status: 200 }
    else
      render json: { errors: @ingredient.errors }, status: 422
    end
  end

  def show
    render json: { data: @ingredient, status: 200 }
  end

  private

  def ingredient_params
    params.require(:ingredient).permit(:name, :quantity).merge(item_id: @item.id)
  end

  def find_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

  def find_item
    @item = Item.find(params[:item_id])
  end
end
