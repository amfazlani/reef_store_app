require 'rails_helper'

RSpec.describe 'Items', type: :request do
  # initialize test data
  let!(:store) { create(:store) }
  let!(:items) { create_list(:item, 5, store: store) }
  let!(:item) { items.first }

  # valid payload
  let(:valid_create_params) {
    {
      "item": {
        "name": 'Item A',
        "price": 19.99
      }
    }
  }

  let(:valid_update_params) {
    {
      "item": {
        "name": 'Updated Item',
        "price": 19.99
      }
    }
  }

  # invalid payload
  let(:invalid_params) {
    {
      "item": {
        "name": '',
        "price": 19.99
      }
    }
  }

  describe '#index' do
    before do
      get store_items_path(store)
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
        get item_path(item)
      end

      it 'returns the store' do
        expect(parsed_response["data"]).not_to be_nil
        expect(parsed_response["data"]["id"]).to eq(item.id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let!(:item_id) { 100 }

      before { get item_path(item_id) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      before { post store_items_path(store), params: valid_create_params }

      it 'creates a store' do
        expect(parsed_response['data']['name']).to eq(valid_create_params[:item][:name])
        expect(parsed_response['data']['price']).to eq('19.99')
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post store_items_path(store), params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq([ "Name can't be blank" ])
      end
    end
  end

  # Test suite for PUT /branches/:id
  describe '#update' do
    context 'when the request is valid' do
      before { put item_path(item), params: valid_update_params }

      it 'updates the record' do
        expect(parsed_response["data"]["name"]).to eq(valid_update_params[:item][:name])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put item_path(item), params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq([ "Name can't be blank" ])
      end
    end
  end

  describe '#destroy' do
    before do
      delete item_path(item)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
