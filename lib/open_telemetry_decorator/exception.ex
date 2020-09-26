defmodule OpenTelemetryDecorator.Exception do
  @moduledoc """
  Handle the result from exception function
  """

  @doc """
  Handle the exception from struct 
  """
  @spec handle_exception(struct()) :: list(tuple())
  def handle_exception(exception) do
    message = Exception.message(exception)
    return_exception(message)
  end

  @spec return_exception(binary()) :: list(tuple())
  defp return_exception(reason) when is_binary(reason) do
    [
      {"exception", true},
      {"exception.message", reason}
    ]
  end
end
