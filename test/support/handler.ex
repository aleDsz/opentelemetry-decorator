defmodule OpenTelemetryDecorator.Support.Handler do
  @moduledoc false
  @behaviour OpenTelemetryDecorator.Base

  @impl true
  def handle_error({:error, atom}) when is_atom(atom) do
    [{"error", to_string(atom)}, {"handler", "custom"}]
  end

  @impl true
  def handle_result(%{id: id}) do
    [{"id", to_string(id)}, {"handler", "custom"}]
  end

  @impl true
  def handle_exception(exception, stacktrace) do
    message = Exception.message(exception)
    stacktrace = Exception.format_stacktrace(stacktrace)

    [{"exception", message}, {"stacktrace", stacktrace}, {"handler", "custom"}]
  end
end
