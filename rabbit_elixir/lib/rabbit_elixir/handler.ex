defmodule RabbitElixir.Handler do
  use AMQP

  def handle(channel, tag, redelivered, payload) do
    try do
      number = String.to_integer(payload)
      if number <= 10 do
        Basic.ack channel, tag
        IO.puts "Consumed a #{number}."
      else
        Basic.reject channel, tag, requeue: false
        IO.puts "#{number} is too big and was rejected."
      end
    rescue
      exception ->
        # Requeue unless it's a redelivered message.
        # This means we will retry consuming a message once in case of exception
        # before we give up and have it moved to the error queue
        Basic.reject channel, tag, requeue: not redelivered
        IO.puts "Error converting #{payload} to integer"
    end
  end
end
