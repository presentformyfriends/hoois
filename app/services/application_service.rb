class ApplicationService

    # Class method 'call' creates a new instance of the class with the args or block you pass to it and calls 'call' on the instance
    def self.call(*args, &block)
        new(*args, &block).call
    end

end
