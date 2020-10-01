defmodule OpenTelemetryDecorator.Result do
  @moduledoc false
  # Handle the result from success function

  @doc """
  Handle the result from map
  """
  @spec handle_result(map() | struct() | any()) :: [{binary(), binary() | integer()}]
  def handle_result(%{__meta__: _} = schema) do
    name = schema.__struct__.__schema__(:source)

    attributes =
      schema
      |> Map.delete(:__meta__)
      |> handle_result()

    attributes ++ [{"schema_name", name}]
  end

  def handle_result(%{__struct__: struct, id: id}) do
    name =
      Module.split(struct)
      |> List.last()
      |> Macro.camelize()
      |> String.downcase()

    return_attribute("#{name}_id", id)
  end

  def handle_result(%{id: id}) do
    return_attribute("id", id)
  end

  def handle_result(%{"id" => id}) do
    return_attribute("id", id)
  end

  def handle_result(value) do
    return_attribute("value", value)
  end

  @doc """
  Return the result attribute with key and value
  """
  @spec handle_result(binary(), any()) :: [{binary(), any()}]
  def handle_result(variable_name, value) when is_map(value) do
    [{_, value}] = handle_result(value)
    return_attribute(variable_name, value)
  end

  def handle_result(variable_name, value) do
    return_attribute(variable_name, value)
  end

  @spec return_attribute(binary(), any()) :: [{binary(), any()}]
  defp return_attribute(name, value) do
    [{name, value}]
  end
end
