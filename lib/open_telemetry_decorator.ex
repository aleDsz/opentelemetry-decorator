defmodule OpenTelemetryDecorator do
  @moduledoc """
  Implement decorators to your functions and send data to OpenTelemetry automatically
  """
  use Decorator.Define, with_span: 0

  @doc """
  Decorate function to run OpenTelemetry.Tracer.with_span/2
  """
  def with_span(block, context) do
    span_name = get_span_name(context)

    quote do
      result_handler = OpenTelemetryDecorator.get_module(:result)
      error_handler = OpenTelemetryDecorator.get_module(:error)
      exception_handler = OpenTelemetryDecorator.get_module(:exception)

      require OpenTelemetry.{Span, Tracer}

      OpenTelemetry.Tracer.with_span unquote(span_name) do
        try do
          case unquote(block) do
            {:ok, result} ->
              OpenTelemetry.Span.set_attributes(result_handler.handle_result(result))
              {:ok, result}

            {:error, _} = error ->
              OpenTelemetry.Span.set_attributes(error_handler.handle_error(error))
              error

            {:error, _, _, _} = error ->
              OpenTelemetry.Span.set_attributes(error_handler.handle_error(error))
              error

            other ->
              other
          end
        rescue
          exception ->
            stacktrace = __STACKTRACE__

            OpenTelemetry.Span.set_attributes(
              exception_handler.handle_exception(exception, stacktrace)
            )

            reraise exception, stacktrace
        end
      end
    end
  end

  @spec get_span_name(Decorator.Decorate.Context.t()) :: binary()
  defp get_span_name(context = %Decorator.Decorate.Context{}) do
    "#{context.module}.#{context.name}/#{context.arity}"
  end

  @doc """
  Get module from config to get attributes to use on OpenTelemetry

  You can input in your `config/*.exs`:

  ### Example
      config :opentelemetry_decorator, handler: MyApp.CustomHandler
  """
  @spec get_module(:error | :result | :exception) :: module()
  def get_module(:error) do
    get_module_from_config(OpenTelemetryDecorator.Error)
  end

  def get_module(:result) do
    get_module_from_config(OpenTelemetryDecorator.Result)
  end

  def get_module(:exception) do
    get_module_from_config(OpenTelemetryDecorator.Exception)
  end

  defp get_module_from_config(default) do
    Application.get_env(:opentelemetry_decorator, :handler, default)
  end
end
