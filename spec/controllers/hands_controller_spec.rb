require 'rails_helper'

RSpec.describe Api::V1::HandsController, type: :controller do
  describe 'POST #evaluate' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          cards: ["H1 H13 H12 H11 H10", "H9 C9 S9 H2 C2", "C13 D12 C11 H8 H7"]
        }
      end

      it 'returns a successful response' do
        post :evaluate, params: valid_params
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct result' do
        post :evaluate, params: valid_params
        json_response = JSON.parse(response.body)
        expect(json_response['result']).to be_an(Array)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { cards: [] } }

      it 'returns an error response' do
        post :evaluate, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Cards parameter is missing')
      end
    end
  end

  describe 'private methods' do
    controller(Api::V1::HandsController) do
      def validate_input(params)
        super(params)
      end

      def validate_hand(hand, index)
        super(hand, index)
      end

      def hand_strength(hand)
        super(hand)
      end
    end

    describe '#validate_input' do
      let(:valid_params) { { cards: ["H1 H13 H12 H11 H10"] } }
      let(:invalid_params) { { cards: [] } }

      it 'does not raise an error with valid parameters' do
        expect { subject.validate_input(valid_params) }.not_to raise_error
      end

      it 'raises an error with invalid parameters' do
        expect { subject.validate_input(invalid_params) }.to raise_error(ApiErrors::InvalidInputError)
      end
    end

    describe '#validate_hand' do
      let(:valid_hand) { "H1 H13 H12 H11 H10" }
      let(:invalid_hand) { "H1 H13 H12 H11" }

      it 'does not raise an error with a valid hand' do
        expect { subject.validate_hand(valid_hand, 0) }.not_to raise_error
      end

      it 'raises an error with an invalid hand' do
        expect { subject.validate_hand(invalid_hand, 0) }.to raise_error(ApiErrors::InvalidInputError)
      end
    end

    describe '#hand_strength' do
      it 'returns the correct index for a hand' do
        expect(subject.hand_strength('Straight flush')).to eq(8)
      end
    end
  end
end