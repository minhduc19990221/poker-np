class Api::V1::HandsController < ApplicationController
  rescue_from ApiErrors::InvalidInputError, with: :render_invalid_input_error
  def evaluate
    validate_input(params)
    
    result = []
    errors = []

    params[:cards].each do |cards|
      begin
        validate_hand(cards)
        result << {
          card: cards,
          hand: HandEvaluator.new(cards).evaluate,
          best: false  # We'll update this later
        }
      rescue ApiErrors::InvalidInputError => e
        errors << {
          card: cards,
          msg: e.message
        }
      end
    end

    best_hand = result.max_by { |hand| hand_strength(hand[:hand]) }
    result.each { |hand| hand[:best] = (hand == best_hand) } if best_hand

    render json: { result: result, error: errors }
  end

  private

  def validate_input(params)
    raise ApiErrors::InvalidInputError, 'Cards parameter is missing' unless params[:cards]
    raise ApiErrors::InvalidInputError, 'Cards must be an array' unless params[:cards].is_a?(Array)
    raise ApiErrors::InvalidInputError, 'At least one hand is required' if params[:cards].empty?
    raise ApiErrors::InvalidInputError, 'Maximum 10 hands allowed' if params[:cards].size > 10
  end

  def validate_hand(hand)
        raise ApiErrors::InvalidInputError, "Hand must be a string" unless hand.is_a?(String)
        
        cards = hand.split
        raise ApiErrors::InvalidInputError, "Hand must contain exactly 5 cards" unless cards.size == 5

        valid_ranks = %w(2 3 4 5 6 7 8 9 10 11 12 13 1)
        valid_suits = %w(S H D C)

        cards.each_with_index do |card, index|
          suit, rank = card[0], card[1..-1]
          unless valid_suits.include?(suit)
            raise ApiErrors::InvalidInputError, "Invalid suit in card #{index + 1}. (#{card})"
          end
          unless valid_ranks.include?(rank)
            raise ApiErrors::InvalidInputError, "Invalid rank in card #{index + 1}. (#{card})"
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
