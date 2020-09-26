defmodule OpenTelemetryDecorator.Result do
  @moduledoc """
  Handle the result from success function
  """

  @doc """
  Handle the result from map
  """
  @spec handle_result(map() | struct()) :: [{binary(), binary() | integer()}]
  def handle_result(%{__meta__: _, __struct__: struct, id: id}) do
    name = struct.__schema__(:source)
    return_attribute("#{name}_id", id)
  end

  def handle_result(%{__struct__: struct, id: id}) do
    name =
      Module.split(struct)
      |> List.last()
      |> Macro.camelize()

    return_attribute("#{name}_id", id)
  end

  def handle_result(%{id: id}) do
    return_attribute("id", id)
  end

  def handle_result(%{"id" => id}) do
    return_attribute("id", id)
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
