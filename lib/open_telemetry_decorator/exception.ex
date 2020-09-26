defmodule OpenTelemetryDecorator.Exception do
  @moduledoc """
  Handle the result from exception function
  """

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
      Enum.map(stacktrace, fn
        {fun, arity, location} ->
          arity = get_arity(arity)
          "#{fun}/#{arity} at #{location[:file]} on line #{location[:line]}"

        {module, function, arity, location} ->
          arity = get_arity(arity)
          "#{module}.#{function}/#{arity} at #{location[:file]} on line #{location[:line]}"
      end)
      |> Enum.join("\n")

    [{"exception.stacktrace", stacktrace}]
  end

  @spec get_arity(non_neg_integer() | list()) :: non_neg_integer()
  defp get_arity(arity) when is_integer(arity), do: arity

  defp get_arity(arity) when is_list(arity) do
    IO.inspect(arity)
    0
  end
end
