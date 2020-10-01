defmodule OpenTelemetryDecorator.Base do
  @moduledoc """
  Behaviour module to handle results, errors and exceptions for OpenTelemetry Decorator
  """

  @type attribute :: {binary(), any()}
  @type attributes :: [attribute()]
  @type error :: {:error, any()} | {:error, atom(), any(), map()}

  @callback handle_result(any()) :: attributes()
  @callback handle_error(error()) :: attributes()
  @callback handle_exception(Exception.t(), Exception.stacktrace()) :: attributes()
end
