class RequestCreator
    attr_reader :request
    
    def initialize(params)
        @request = Request.new(params)
    end
    
    def save
        @request.save
    end
    
    def errors
        @request.errors
    end
end