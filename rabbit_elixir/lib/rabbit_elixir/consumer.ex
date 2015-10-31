defmodule RabbitElixir.Consumer do
  use GenServer
  use AMQP

  alias RabbitElixir.Handler

  @exchange    "rabbit_exchange"
  @queue       "rabbit_queue"
  @queue_error "#{@queue}_error"

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    open_connection
    |> declare_queues
    |> declare_fanout_exchange
    |> bind_queue
    |> register_consumer
  end

  defp open_connection,                 do: open_channel(Connection.open)
  defp open_channel({:ok, connection}), do: Channel.open(connection) |> elem(1)

  defp open_channel({:error, error}) do
    IO.puts :stderr, "\n==>#{IO.ANSI.red} Consumer failed to start because of #{inspect(error)} error!\n"
    System.halt
  end

  defp declare_queues(channel) do
    Queue.declare(channel, @queue_error, durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    Queue.declare(
      channel,
      @queue,
      durable: true,
      arguments: [
        {"x-dead-letter-exchange",    :longstr, ""},
        {"x-dead-letter-routing-key", :longstr, @queue_error}
      ]
    )
    channel
  end

  defp declare_fanout_exchange(channel) do
    Exchange.fanout(channel, @exchange, durable: true)
    channel
  end

  defp bind_queue(channel) do
    Queue.bind(channel, @queue, @exchange)
    channel
  end

  defp register_consumer(channel) do
    Basic.consume(channel, @queue)
    {:ok, channel}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan), do: {:noreply, chan}

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan), do: {:stop, :normal, chan}

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan), do: {:noreply, chan}

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> Handler.handle(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end
end
