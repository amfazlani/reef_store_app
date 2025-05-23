require 'rails_helper'

RSpec.describe 'Items', type: :request do
  # initialize test data
  let!(:store) { create(:store) }
  let!(:items) { create_list(:item, 5, store: store) }
  let!(:item) { items.first }

  let(:valid_params) do
    {
      item: {
        name: 'Item A',
        price: 19.99
      }
    }
  end

  let(:updated_params) do
    {
      item: {
        name: 'Updated Item',
        price: 19.99
      }
    }
  end

  let(:invalid_params) do
    {
      item: {
        name: '',
        price: 19.99
      }
    }
  end

  describe '#index' do
    before do
      get store_items_path(store)
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
        get item_path(item)
      end

      it 'returns the item' do
        expect(parsed_response["data"]["id"]).to eq(item.id)
        expect_status(200)
      end
    end

    context 'when the record does not exist' do
      before { get item_path(99999) }

      it 'returns status code 404' do
        expect_status(404)
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      before { post store_items_path(store), params: valid_params }

      it 'creates a item' do
        expect(parsed_response['data']['name']).to eq(valid_params[:item][:name])
        expect(parsed_response['data']['price']).to eq('19.99')
        expect_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post store_items_path(store), params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end
  end

  # Test suite for PUT /branches/:id
  describe '#update' do
    context 'when the request is valid' do
      before { put item_path(item), params: updated_params }

      it 'updates the record' do
        expect(parsed_response["data"]["name"]).to eq(updated_params[:item][:name])
        expect_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put item_path(item), params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end
  end

  describe '#destroy' do
    before do
      delete item_path(item)
    end

    it 'returns status code 200' do
      expect_status(200)
    end
  end
end
