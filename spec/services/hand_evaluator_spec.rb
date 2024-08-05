require 'rails_helper'

RSpec.describe HandEvaluator, type: :service do
  let(:straight_flush_hand) { 'H1 H2 H3 H4 H5' }
  let(:four_of_a_kind_hand) { 'H1 D1 S1 C1 H2' }
  let(:full_house_hand) { 'H1 D1 S1 H2 D2' }
  let(:flush_hand) { 'H1 H3 H5 H7 H9' }
  let(:straight_hand) { 'H1 D2 S3 C4 H5' }
  let(:three_of_a_kind_hand) { 'H1 D1 S1 H2 H3' }
  let(:two_pair_hand) { 'H1 D1 H2 D2 H3' }
  let(:one_pair_hand) { 'H1 D1 H2 H3 H4' }
  let(:high_card_hand) { 'H1 D3 S5 C7 H9' }

  describe '#evaluate' do
    it 'returns "Straight flush" for a straight flush hand' do
      evaluator = HandEvaluator.new(straight_flush_hand)
      expect(evaluator.evaluate).to eq('Straight flush')
    end

    it 'returns "Four of a kind" for a four of a kind hand' do
      evaluator = HandEvaluator.new(four_of_a_kind_hand)
      expect(evaluator.evaluate).to eq('Four of a kind')
    end

    it 'returns "Full house" for a full house hand' do
      evaluator = HandEvaluator.new(full_house_hand)
      expect(evaluator.evaluate).to eq('Full house')
    end

    it 'returns "Flush" for a flush hand' do
      evaluator = HandEvaluator.new(flush_hand)
      expect(evaluator.evaluate).to eq('Flush')
    end

    it 'returns "Straight" for a straight hand' do
      evaluator = HandEvaluator.new(straight_hand)
      expect(evaluator.evaluate).to eq('Straight')
    end

    it 'returns "Three of a kind" for a three of a kind hand' do
      evaluator = HandEvaluator.new(three_of_a_kind_hand)
      expect(evaluator.evaluate).to eq('Three of a kind')
    end

    it 'returns "Two pair" for a two pair hand' do
      evaluator = HandEvaluator.new(two_pair_hand)
      expect(evaluator.evaluate).to eq('Two pair')
    end

    it 'returns "One pair" for a one pair hand' do
      evaluator = HandEvaluator.new(one_pair_hand)
      expect(evaluator.evaluate).to eq('One pair')
    end

    it 'returns "High card" for a high card hand' do
      evaluator = HandEvaluator.new(high_card_hand)
      expect(evaluator.evaluate).to eq('High card')
    end
  end

  describe 'private methods' do
    subject { HandEvaluator.new(high_card_hand) }

    describe '#straight_flush?' do
      it 'returns true for a straight flush hand' do
        evaluator = HandEvaluator.new(straight_flush_hand)
        expect(evaluator.send(:straight_flush?)).to be true
      end

      it 'returns false for a non-straight flush hand' do
        expect(subject.send(:straight_flush?)).to be false
      end
    end

    describe '#four_of_a_kind?' do
      it 'returns true for a four of a kind hand' do
        evaluator = HandEvaluator.new(four_of_a_kind_hand)
        expect(evaluator.send(:four_of_a_kind?)).to be true
      end

      it 'returns false for a non-four of a kind hand' do
        expect(subject.send(:four_of_a_kind?)).to be false
      end
    end

    describe '#full_house?' do
      it 'returns true for a full house hand' do
        evaluator = HandEvaluator.new(full_house_hand)
        expect(evaluator.send(:full_house?)).to be true
      end

      it 'returns false for a non-full house hand' do
        expect(subject.send(:full_house?)).to be false
      end
    end

    describe '#flush?' do
      it 'returns true for a flush hand' do
        evaluator = HandEvaluator.new(flush_hand)
        expect(evaluator.send(:flush?)).to be true
      end

      it 'returns false for a non-flush hand' do
        expect(subject.send(:flush?)).to be false
      end
    end

    describe '#straight?' do
      it 'returns true for a straight hand' do
        evaluator = HandEvaluator.new(straight_hand)
        expect(evaluator.send(:straight?)).to be true
      end

      it 'returns false for a non-straight hand' do
        expect(subject.send(:straight?)).to be false
      end
    end

    describe '#three_of_a_kind?' do
      it 'returns true for a three of a kind hand' do
        evaluator = HandEvaluator.new(three_of_a_kind_hand)
        expect(evaluator.send(:three_of_a_kind?)).to be true
      end

      it 'returns false for a non-three of a kind hand' do
        expect(subject.send(:three_of_a_kind?)).to be false
      end
    end

    describe '#two_pair?' do
      it 'returns true for a two pair hand' do
        evaluator = HandEvaluator.new(two_pair_hand)
        expect(evaluator.send(:two_pair?)).to be true
      end

      it 'returns false for a non-two pair hand' do
        expect(subject.send(:two_pair?)).to be false
      end
    end

    describe '#one_pair?' do
      it 'returns true for a one pair hand' do
        evaluator = HandEvaluator.new(one_pair_hand)
        expect(evaluator.send(:one_pair?)).to be true
      end

      it 'returns false for a non-one pair hand' do
        expect(subject.send(:one_pair?)).to be false
      end
    end

    describe '#ranks_count' do
      it 'returns true when there are the specified number of ranks' do
        expect(subject.send(:ranks_count, 1)).to be true
      end

      it 'returns false when there are not the specified number of ranks' do
        expect(subject.send(:ranks_count, 4)).to be false
      end
    end

    describe '#suits_uniq_count' do
      it 'returns the number of unique suits' do
        expect(subject.send(:suits_uniq_count)).to eq(4)
      end
    end
  end
end
