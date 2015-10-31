defmodule RabbitElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app:             :rabbit_elixir,
      version:         "0.0.1",
      elixir:          "~> 1.0",
      build_embedded:  Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps:            deps,
    ]
  end

  def application do
    [
      mod:          { RabbitElixir, [] },
      applications: apps,
    ]
  end

  defp apps do
    [
      :logger,
      :amqp,
    ]
  end

  defp deps do
    [
      { :amqp, "0.1.2" },
    ]
  end
end
