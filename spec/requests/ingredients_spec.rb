require 'rails_helper'

RSpec.describe 'Ingredients', type: :request do
  # initialize test data
  let!(:item) { create(:item) }
  let!(:ingredients) { create_list(:ingredient, 5, item: item) }
  let!(:ingredient) { ingredients.first }

  let(:valid_params) do
    {
      ingredient: {
        name: 'Item A',
        quantity: 2
      }
    }
  end

  let(:updated_params) do
    {
      ingredient: {
        name: 'Updated Ingredient',
        quantity: 2
      }
    }
  end

  # invalid payload
  let(:invalid_params) do
    {
      ingredient: {
        name: '',
        quantity: 2
      }
    }
  end

  describe '#index' do
    before do
      get item_ingredients_path(item)
    end

    it 'returns stores' do
      expect(parsed_response["data"].size).to eq(5)
      expect_status(200)
    end
  end

  # Test suite for GET /branches/:id
  describe '#show' do
    context 'when the record exists' do
      before do
        get ingredient_path(ingredient)
      end

      it 'returns the store' do
        expect(parsed_response["data"]["id"]).to eq(ingredient.id)
        expect_status(200)
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      before { post item_ingredients_path(item), params: valid_params }

      it 'creates a store' do
        expect(parsed_response['data']['name']).to eq(valid_params[:ingredient][:name])
        expect(parsed_response['data']['quantity']).to eq(2)
        expect_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post item_ingredients_path(item), params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end
  end

  # Test suite for PUT /branches/:id
  describe '#update' do
    context 'when the request is valid' do
      before { put ingredient_path(ingredient), params: updated_params }

      it 'updates the record' do
        expect(parsed_response["data"]["name"]).to eq(updated_params[:ingredient][:name])
        expect_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put ingredient_path(ingredient), params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end
  end

  describe '#destroy' do
    before do
      delete ingredient_path(ingredient)
    end

    it 'returns status code 200' do
      expect_status(200)
    end
  end
end
