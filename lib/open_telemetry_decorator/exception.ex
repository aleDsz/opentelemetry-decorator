defmodule OpenTelemetryDecorator.Exception do
  @moduledoc false
  # Handle the result from exception function

  @doc """
  Handle the exception from struct 
  """
  @spec handle_exception(struct(), list(tuple())) :: list(tuple())
  def handle_exception(exception, stacktrace) do
    message = Exception.message(exception)
    return_exception(message) ++ return_stacktrace(stacktrace)
  end

  @spec return_exception(binary()) :: list(tuple())
  defp return_exception(reason) when is_binary(reason) do
    [
      {"exception", true},
      {"exception.message", reason}
    ]
  end

  @spec return_stacktrace(list(tuple())) :: list(tuple())
  defp return_stacktrace(stacktrace) when is_list(stacktrace) do
    stacktrace =
      Exception.format_stacktrace(stacktrace)
      |> String.trim()

    [{"exception.stacktrace", stacktrace}]
  end
end
