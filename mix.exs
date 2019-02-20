defmodule OpencensusTesla.MixProject do
  use Mix.Project

  def project do
    [
      app: :opencensus_tesla,
      version: "0.1.0",
      elixir: "~> 1.8-dev",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.2"},
      {:opencensus_elixir, github: "opencensus-beam/opencensus_elixir"}
    ]
  end
end
