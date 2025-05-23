require 'rails_helper'

RSpec.describe 'Stores', type: :request do
  # initialize test data
  let!(:stores) { create_list(:store, 5) }
  let!(:store) { stores.first }
  let!(:place_id) { 'ChIJM7UJM-uNVoYRg-RTlgFosng' }

  # valid payload
  let(:valid_create_params) {
    {
      "store": {
        "name": 'Branch A',
        "address": '3601 S Treadaway Blvd, Abilene, TX 79602, USA',
        "description": "Description of the store",
        "place_id": place_id
      }
    }
  }

  let(:valid_update_params) {
    {
      "store": {
        "name": 'Updated Store',
        "address": '11411 West Oak Blvd',
        "description": "Description of the store"
      }
    }
  }

  # invalid payload
  let(:invalid_params) {
    {
      "store": {
        "name": '',
        "address": '11411 West Oak Blvd',
        "description": "Description of the store",
        "place_id": place_id
      }
    }
  }

  describe '#index' do
    before do
      get stores_path
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
      context 'with permissions' do
        before do
          get store_path(store)
        end

        it 'returns the store' do
          expect(parsed_response["data"]).not_to be_nil
          expect(parsed_response["data"]["id"]).to eq(store.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
      end
    end

    context 'when the record does not exist' do
      let!(:store_id) { 100 }

      before { get store_path(store_id) }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe '#create' do
    context 'when the request is valid' do
      before { post stores_path, params: valid_create_params }

      it 'creates a store' do
        expect(parsed_response['data']['name']).to eq(valid_create_params[:store][:name])
        expect(parsed_response['data']['address']).to eq(valid_create_params[:store][:address])
        expect(parsed_response['data']['description']).to eq(valid_create_params[:store][:description])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { post stores_path, params: invalid_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq([ "Name can't be blank" ])
      end
    end

    context 'place is already taken' do
      let!(:store) { create(:store, place_id: place_id )}

      before { post stores_path, params: valid_create_params }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(parsed_response['errors']).to eq([ "Place has already been taken" ])
      end
    end
  end

  # Test suite for PUT /branches/:id
  describe '#update' do
    context 'when the request is valid' do
      before { put store_path(store), params: valid_update_params }

      it 'updates the record' do
        expect(parsed_response["data"]["name"]).to eq(valid_update_params[:store][:name])
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the request is invalid' do
      before { put store_path(store), params: invalid_params }

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
      delete store_path(store)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end
