require 'sneakers'
Sneakers.configure  heartbeat: 10000,
  amqp: Rails.configuration.rabbitmq['amqp'],
  vhost: '/',
  exchange: 'sneakers',
  durable: true,
  ack: true,
  workers: 5,
  threads: 1,
  prefetch: 1,
  timeout_job_after: 1000000,
  start_worker_delay: 10,
  continuation_timeout: 300000,
  exchange_type: :direct
