# OpenTelemetry Decorator

This library provide an easily interface to trace your application with [OpenTelemetry](https://github.com/open-telemetry/opentelemetry-erlang-api) for Elixir, using decorations above your functions.

## Usage

```elixir
defmodule Foo do
	use OpenTelemetryDecorator

	@decorate with_span()
	def bar do
		{:ok, %{id: 123}}
	end
end
```

## Configuration

If you and a custom handler for function results, you can add to your `config/*.exs`:

```elixir
config :opentelemetry_decorator, handler: MyApp.Handler
```

## Installation

The package can be installed by adding `opentelemetry_decorator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentelemetry_decorator, "~> 0.1.0"}
  ]
end
```

## Documentation

Documentation can be found at [https://hexdocs.pm/opentelemetry_decorator](https://hexdocs.pm/opentelemetry_decorator).
