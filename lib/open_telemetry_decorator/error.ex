defmodule OpenTelemetryDecorator.Error do
  @moduledoc false
  # Handle the result from error function

  @doc """
  Handle the error from tuple
  """
  @spec handle_error({:error, term()} | {:error, atom(), term(), map()}) :: list(tuple())
  def handle_error({:error, reason}) do
    return_error(reason)
  end

  def handle_error({:error, context, reason, _}) do
    return_error(reason) ++ [{"error.context", to_string(context)}]
  end

  @spec return_error(term()) :: list(tuple())
  defp return_error(reason) when is_binary(reason) do
    [
      {"error", true},
      {"error.reason", reason}
    ]
  end

  defp return_error(reason) when is_atom(reason) do
    reason =
      reason
      |> to_string()
      |> String.replace("_", " ")

    return_error(reason)
  end

  defp return_error(%{reason: reason}) when is_binary(reason) do
    return_error(reason)
  end

  defp return_error(%{reason: reason}) when is_atom(reason) do
    return_error(reason)
  end

  defp return_error(%{message: reason}) when is_binary(reason) do
    return_error(reason)
  end

  defp return_error(%{message: reason}) when is_atom(reason) do
    return_error(reason)
  end
end
