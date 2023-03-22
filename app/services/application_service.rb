class ApplicationService

    # Class method 'call' creates a new instance of the class with the passed args or code block and calls 'call' on the instance
    def self.call(*args, &block)
        new(*args, &block).call
    end

end
