defmodule User do
  defstruct [:id, :name]
end

defmodule Account do
  defstruct [:__meta__, :id, :number]

  def __schema__(:source), do: "accounts"
end

defmodule Foo do
  use OpenTelemetryDecorator

  @decorate with_span()
  def value() do
    {:ok, "asdasda"}
  end

  @decorate with_span()
  def struct() do
    {:ok, %User{id: 123}}
  end

  @decorate with_span()
  def schema() do
    {:ok, %Account{id: 123}}
  end

  @decorate with_span()
  def map() do
    {:ok, %{"id" => 123}}
  end

  @decorate with_span()
  def exception() do
    raise %RuntimeError{message: "bla bla test"}
  end

  @decorate with_span()
  def error_string() do
    {:error, "this is an error"}
  end

  @decorate with_span()
  def error_atom() do
    {:error, :internal_server_error}
  end

  @decorate with_span()
  def error_multi() do
    {:error, :user, :not_found, %{}}
  end
end
