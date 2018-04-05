module RabbitQueue
  class Producer
    attr_reader :data, :queue

    def self.enqueue(data, queue)
      new(data, queue).enqueue
    end

    def initialize(data, queue)
      @data = data
      @queue = queue
    end

    def enqueue
      exchange.publish(data, routing_key: queue)
    end

    def exchange
      @channel ||= Configurator.channel
      Configurator.queue(queue)
      @channel.default_exchange
    end
  end
end
