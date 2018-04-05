module Sneakers
  module Testing
    class << self
      def all
        messages_by_queue.values.flatten
      end

      delegate :[], to: :messages_by_queue

      def push(queue, message)
        messages_by_queue[queue] << message
      end

      def messages_by_queue
        @messages_by_queue ||= Hash.new { |hash, key| hash[key] = [] }
      end

      def clear_for(queue, _klass)
        messages_by_queue[queue].clear
      end

      def clear_all
        messages_by_queue.clear
      end
    end
  end
end

module WorkerAdditions
  def publish(payload, opts)
    Sneakers::Testing.push(opts[:to_queue], payload)
  end
end

module QueuePublisher
  module_function

  def publish(payload, routing)
    Sneakers::Testing.push(routing[:to_queue], payload)
  end
end
