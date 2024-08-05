module ApiErrors
  class InvalidInputError < StandardError
    attr_reader :message

    def initialize(message = 'Invalid input')
      super(message)
      @message = message
    end
  end
end
