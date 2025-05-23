require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  let!(:stores) { create_list(:store, 5) }
  let!(:store) { stores.first }
  let!(:place_id) { 'ChIJM7UJM-uNVoYRg-RTlgFosng' }

  let(:valid_params) do
    {
      store: {
        name: 'Branch A',
        address: '11411 West Oak Blvd',
        description: 'Description of the store',
        place_id: place_id
      }
    }
  end

  let(:updated_params) do
    {
      store: {
        name: 'Updated Store',
        address: '11411 West Oak Blvd',
        description: 'Updated description'
      }
    }
  end

  let(:invalid_params) do
    {
      store: {
        name: '',
        address: '11411 West Oak Blvd',
        description: 'Description of the store',
        place_id: place_id
      }
    }
  end

  describe '#index' do
    before { get stores_path }

    it 'returns all stores' do
      expect(parsed_response['data'].size).to eq(5)
      expect_status(200)
    end
  end

  describe '#show' do
    context 'when the store exists' do
      before { get store_path(store) }

      it 'returns the store' do
        expect(parsed_response['data']['id']).to eq(store.id)
        expect_status(200)
      end
    end

    context 'when the store does not exist' do
      before { get store_path(99999) }

      it 'returns 404' do
        expect_status(404)
      end
    end
  end

  describe '#create' do
    context 'with valid parameters' do
      before { post stores_path, params: valid_params }

      it 'creates a store' do
        expect(parsed_response['data']['name']).to eq(valid_params[:store][:name])
        expect_status(200)
      end
    end

    context 'with invalid parameters' do
      before { post stores_path, params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end

    context 'place is already taken' do
      let!(:store) { create(:store, place_id: place_id) }

      before { post stores_path, params: valid_params }

      it 'returns validation error' do
        expect_error_message("Place has already been taken")
        expect_status(422)
      end
    end
  end

  describe '#update' do
    context 'with valid parameters' do
      before { put store_path(store), params: updated_params }

      it 'updates the store' do
        expect(parsed_response['data']['name']).to eq(updated_params[:store][:name])
        expect_status(200)
      end
    end

    context 'with invalid parameters' do
      before { put store_path(store), params: invalid_params }

      it 'returns validation error' do
        expect_error_message("Name can't be blank")
        expect_status(422)
      end
    end
  end

  describe '#destroy' do
    before { delete store_path(store) }

    it 'deletes the store' do
      expect_status(200)
    end
  end
end
