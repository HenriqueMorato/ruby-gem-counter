module RabbitQueue
  class WorkerConsumer
    attr_reader :queue

    def initialize(queue_name)
      @queue = Configurator.queue(queue_name)
    end

    def ack(delivery_tag)
      Configurator.channel.acknowledge(delivery_tag, false)
    end
  end
end
