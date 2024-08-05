class Api::V1::HandsController < ApplicationController
  rescue_from ApiErrors::InvalidInputError, with: :render_invalid_input_error
  def evaluate
    validate_input(params)

    hands = params[:cards].map do |cards|
      {
        card: cards,
        hand: HandEvaluator.new(cards).evaluate
      }
    end

    best_hand = hands.max_by { |hand| hand_strength(hand[:hand]) }
    hands.each { |hand| hand[:best] = (hand == best_hand) }

    render json: { result: hands }
  end

  private

  def validate_input(params)
    raise ApiErrors::InvalidInputError, 'Cards parameter is missing' unless params[:cards]
    raise ApiErrors::InvalidInputError, 'Cards must be an array' unless params[:cards].is_a?(Array)
    raise ApiErrors::InvalidInputError, 'At least one hand is required' if params[:cards].empty?
    raise ApiErrors::InvalidInputError, 'Maximum 10 hands allowed' if params[:cards].size > 10

    params[:cards].each_with_index do |hand, index|
      validate_hand(hand, index)
    end
  end

  def validate_hand(hand, index)
    raise ApiErrors::InvalidInputError, "Hand #{index + 1} must be a string" unless hand.is_a?(String)

    cards = hand.split
    raise ApiErrors::InvalidInputError, "Hand #{index + 1} must contain exactly 5 cards" unless cards.size == 5

    valid_ranks = %w[2 3 4 5 6 7 8 9 10 11 12 13 1]
    valid_suits = %w[S H D C]

    cards.each_with_index do |card, card_index|
      suit = card[0]
      rank = card[1..-1]
      unless valid_suits.include?(suit) && valid_ranks.include?(rank)
        raise ApiErrors::InvalidInputError, "Invalid card #{card_index + 1} in hand #{index + 1}"
      end
    end
  end

  def hand_strength(hand)
    [
      'High card', 'One pair', 'Two pair', 'Three of a kind',
      'Straight', 'Flush', 'Full house', 'Four of a kind', 'Straight flush'
    ].index(hand)
  end

  def render_invalid_input_error(error)
    render json: { error: error.message }, status: :unprocessable_entity
  end
end
