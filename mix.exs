defmodule OpenTelemetryDecorator.MixProject do
  use Mix.Project

  def project,
    do: [
      app: :opentelemetry_decorator,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      description: "Library to provide decorators for OpenTelemetry",
      package: [
        links: %{
          github: "https://github.com/aleDsz/opentelemetry-decorator"
        },
        licenses: ["MIT"]
      ],
      docs: docs(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application, do: [extra_applications: [:logger]]

  defp deps,
    do: [
      {:opentelemetry_api, "~> 0.4"},
      {:opentelemetry, "~> 0.4"},
      {:decorator, "~> 1.2"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false}
    ]

  defp docs,
    do: [
      main: "OpenTelemetryDecorator",
      extras: ["README.md"]
    ]
end
