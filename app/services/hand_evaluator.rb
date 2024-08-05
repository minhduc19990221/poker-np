class HandEvaluator
    RANKS = %w(1 2 3 4 5 6 7 8 9 10 11 12 13)
    SUITS = %w(S H D C)

    def initialize(cards)
        @cards = cards.split.map { |card| { suit: card[0], rank: card[1..-1] } }
        @ranks = @cards.map { |card| card[:rank] }
        @suits = @cards.map { |card| card[:suit] }
    end

    def evaluate
        return "Straight flush" if straight_flush?
        return "Four of a kind" if four_of_a_kind?
        return "Full house" if full_house?
        return "Flush" if flush?
        return "Straight" if straight?
        return "Three of a kind" if three_of_a_kind?
        return "Two pair" if two_pair?
        return "One pair" if one_pair?
        "High card"
    end

    private

    def straight_flush?
        flush? && straight?
    end

    def four_of_a_kind?
        ranks_count(4)
    end

    def full_house?
        three_of_a_kind? && one_pair?
    end

    def flush?
        suits_uniq_count == 1
    end

    def straight?
        sorted_ranks = @ranks.map { |rank| RANKS.index(rank) }.sort
        sorted_ranks.each_cons(2).all? { |a, b| b == a + 1 } ||
            sorted_ranks == [0, 1, 2, 3, 12] # Ace-low straight
    end

    def three_of_a_kind?
        ranks_count(3)
    end

    def two_pair?
        @ranks.uniq.count { |rank| @ranks.count(rank) == 2 } == 2
    end

    def one_pair?
        ranks_count(2)
    end

    def ranks_count(count)
        @ranks.uniq.any? { |rank| @ranks.count(rank) == count }
    end

    def suits_uniq_count
        @suits.uniq.size
    end
end