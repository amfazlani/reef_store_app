require 'rails_helper'

RSpec.describe 'Ingredients', type: :request do
  # initialize test data
  let!(:item) { create(:item) }
  let!(:ingredients) { create_list(:ingredient, 5, item: item) }
  let!(:ingredient) { ingredients.first }

  # valid payload
  let(:valid_create_params) {
    {
      "ingredient": {
        "name": 'Item A',
        "quantity": 2
      }
    }
  }

  let(:valid_update_params) {
    {
      "ingredient": {
        "name": 'Updated Ingredient',
        "quantity": 2
      }
    }
  }

  # invalid payload
  let(:invalid_params) {
    {
      "ingredient": {
        "name": '',
        "quantity": 2
      }
    }
  }

  describe '#index' do
    before do
      get item_ingredients_path(item)
    end

    it 'returns stores' do
      expect(parsed_response["data"]).not_to be_empty
      expect(parsed_response["data"].size).to eq(5)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /branches/:id
  describe '#show' do
    context 'when the record exists' do
      before do
        get ingredient_path(ingredient)
      end

      it 'returns the store' do
        expect(parsed_response["data"]).not_to be_nil
        expect(parsed_response["data"]["id"]).to eq(ingredient.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      before { post item_ingredients_path(item), params: valid_create_params }

      it 'creates a store' do
        expect(parsed_response['data']['name']).to eq(valid_create_params[:ingredient][:name])
        expect(parsed_response['data']['quantity']).to eq(2)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post item_ingredients_path(item), params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq(["Name can't be blank"])
      end
    end
  end

  # Test suite for PUT /branches/:id
  describe '#update' do
    context 'when the request is valid' do
      before { put ingredient_path(ingredient), params: valid_update_params }

      it 'updates the record' do
        expect(parsed_response["data"]["name"]).to eq(valid_update_params[:ingredient][:name])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put ingredient_path(ingredient), params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq(["Name can't be blank"])
      end
    end
  end

  describe '#destroy' do
    before do
      delete ingredient_path(ingredient)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
