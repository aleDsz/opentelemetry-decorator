defmodule OpenTelemetryDecorator.MixProject do
  use Mix.Project

  def project,
    do: [
      app: :opentelemetry_decorator,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application, do: [extra_applications: [:logger]]

  defp deps,
    do: [
      {:opentelemetry_api, "~> 0.3.0"},
      {:decorator, "~> 1.2"}
    ]
end
