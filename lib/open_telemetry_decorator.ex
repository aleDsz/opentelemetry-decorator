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
      alias OpenTelemetryDecorator.Error, as: E
      alias OpenTelemetryDecorator.Exception, as: Ex
      alias OpenTelemetryDecorator.Result, as: R

      require OpenTelemetry.{Span, Tracer}

      OpenTelemetry.Tracer.with_span unquote(span_name) do
        try do
          case unquote(block) do
            {:ok, result} ->
              OpenTelemetry.Span.set_attributes(R.handle_result(result))
              {:ok, result}

            {:error, _} = error ->
              OpenTelemetry.Span.set_attributes(E.handle_error(error))
              error

            {:error, _, _, _} = error ->
              OpenTelemetry.Span.set_attributes(E.handle_error(error))
              error

            other ->
              other
          end
        rescue
          exception ->
            OpenTelemetry.Span.set_attributes(Ex.handle_exception(exception))
            reraise exception, exception.__stacktrace__
        end
      end
    end
  end

  @spec get_span_name(Decorator.Decorate.Context.t()) :: binary()
  defp get_span_name(context = %Decorator.Decorate.Context{}) do
    "#{context.module}.#{context.name}/#{context.arity}"
  end
end
