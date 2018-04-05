module RabbitQueue
  class Configurator
    class << self
      attr_writer :connection

      def connection
        unless @connection
          @connection = Bunny.new(Rails.configuration.rabbitmq['amqp'],
                                  continuation_timeout: 30_000)
          @connection.start
        end
        @connection
      end

      def channel
        @channel ||= connection.create_channel
      end

      def queue(name)
        channel.queue(name, durable: true, auto_delete: false)
      end
    end
  end
end
