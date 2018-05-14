module RabbitQueue
  class Configurator
    class << self
      attr_writer :reader_connection, :writer_connection
      CONSUMER_ENDPOINT = Rails.configuration.rabbitmq['consumer']
      PRODUCER_ENDPOINT = Rails.configuration.rabbitmq['producer']

      def reader_connection
        unless @reader_connection
          @reader_connection = bunny_connection(CONSUMER_ENDPOINT)
          @reader_connection.start
        end
        @reader_connection
      end

      def reader_channel
        @reader_channel ||= reader_connection.create_channel
      end

      def reader_queue(name)
        reader_channel.queue(name, durable: true, auto_delete: false)
      end

      def writer_connection
        unless @writer_connection
          @writer_connection = bunny_connection(PRODUCER_ENDPOINT)
          @writer_connection.start
        end
        @writer_connection
      end

      def writer_channel
        @writer_channel ||= writer_connection.create_channel
      end

      def writer_queue(name)
        writer_channel.queue(name, durable: true, auto_delete: false)
      end

      def bunny_connection(endpoint)
        Bunny.new(endpoint, continuation_timeout: 30_000)
      end
    end
  end
end
