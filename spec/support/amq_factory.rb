require 'bunny'

module AMQFactory
  class << self
    attr_accessor :connection

    #
    # Public API
    #

    ##
    # Create a durable fanout exchange
    #
    # @param [String] name Name of the exchange
    #
    # @api public
    #
    def create_exchange(name)
      with_channel { |channel| channel.fanout name, durable: true }
    end

    ##
    # Remove exchange
    #
    # @param [String] name Name of the exchange
    #
    # @api public
    #
    def teardown_exchange(name)
      with_channel do |channel|
        xchg = channel.fanout name, durable: true
        xchg.delete
      end
    end

    ##
    # Create a durable queue that is bound to an exchange
    #
    # @param [String] name Name of the queue
    # @param [String] xchg_name Name of the exchange
    #
    # @api public
    #
    def create_queue(name, xchg_name)
      with_channel do |channel|
        xchg = channel.fanout xchg_name, durable: true
        queue = channel.queue name, durable: true

        queue.bind xchg
      end
    end

    ##
    # Remove a queue
    #
    # @param [String] name Name of the queue
    #
    # @api public
    #
    def teardown_queue(name)
      with_channel do |channel|
        queue = channel.queue name, durable: true
        queue.delete
      end
    end

    ##
    # Bind one exchange to another
    #
    # @param [String] source_name Name of the exchange to bind to
    # @param [String] receiver_name Name of the receiving exchange
    #
    # @api public
    #
    def bind_exchange(source_name, receiver_name)
      with_channel do |channel|
        receiver = channel.fanout receiver_name, durable: true
        receiver.bind source_name
      end
    end

    ##
    # Unbind one exchange from another
    #
    # @param [String] source_name Name of the source exchange
    # @param [String] receiver_name Name of the exchange to unbind
    #
    # @api public
    #
    def unbind_exchange(source_name, receiver_name)
      with_channel do |channel|
        receiver = channel.fanout receiver_name, durable: true
        receiver.unbind source_name
      end
    end

    ##
    # Publish a message to an exchange
    #
    # @param [Object] message Any payload that can receive +to_json+
    # @param [String] xchg_name Name of the exchange to publish to
    # @param [Hash] opts Any options to send to Bunny/RMQ with payload
    #
    # @api public
    #
    def publish(message, xchg_name, opts = {})
      with_channel do |channel|
        xchg = channel.fanout xchg_name, durable: true
        xchg.publish message.to_json, opts
      end
    end

    private

    ##
    # Create a Bunny::Session connection to RMQ
    #
    # @return [Bunny::Session] Connection
    # @api private
    #
    def connect
      @connection = Bunny.new # pass in configuration params
      @connection.start
    end

    ##
    # Wrapper for code requiring the use of a [Bunny::Channel] instance
    #
    # @return [BunnyMock::Session] Connection
    # @api private
    #
    def with_channel
      connect unless @connection&.open?
      @connection.with_channel { |c| yield c }
    end
  end
end
