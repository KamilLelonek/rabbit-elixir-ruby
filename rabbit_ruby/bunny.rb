#!/usr/bin/env ruby

require 'bunny'

conn = Bunny.new
conn.start

ch = conn.create_channel
q  = ch.queue 'rabbit_queue', durable: true, arguments: {'x-dead-letter-exchange' => '', 'x-dead-letter-routing-key' => 'rabbit_queue_error'}
x  = ch.default_exchange

x.publish("1", routing_key: q.name)

conn.close
