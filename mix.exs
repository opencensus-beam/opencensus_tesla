defmodule OpencensusTesla.MixProject do
  use Mix.Project

  def project do
    [
      app: :opencensus_tesla,
      version: "0.2.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        docs: :docs,
        "inchci.add": :docs,
        "inch.report": :docs
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      test: "test --no-start"
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.2"},
      {:opencensus_elixir, "~> 0.3"},

      # Documentation
      {:ex_doc, ">= 0.0.0", only: [:docs]},
      {:inch_ex, "~> 1.0", only: [:docs]},

      # Testing
      {:excoveralls, "~> 0.10.3", only: [:test]},
      {:dialyxir, ">= 0.0.0", runtime: false, only: [:dev, :test]},
      {:junit_formatter, ">= 0.0.0", only: [:test]}
    ]
  end

  defp description() do
    "Tesla middleware for OpenCensus tracing"
  end

  defp package() do
    [
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/opencensus-beam/opencensus_tesla",
        "OpenCensus" => "https://opencensus.io",
        "OpenCensus Erlang" => "https://github.com/census-instrumentation/opencensus-erlang",
        "OpenCensus BEAM" => "https://github.com/opencensus-beam"
      }
    ]
  end
end
