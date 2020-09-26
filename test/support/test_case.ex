defmodule OpenTelemetryDecorator.Support.TestCase do
  @moduledoc """
  This module defines a setup for tests requiring
  `OpenTelemetry` validations.

  By using this module, an `OpenTelemetry` span is
  started before test and finished at the end.
  """
  use ExUnit.CaseTemplate

  setup do
    :application.stop(:opentelemetry)
    :application.set_env(:opentelemetry, :tracer, :ot_tracer_default)

    :application.set_env(:opentelemetry, :processors, [
      {:ot_batch_processor, %{scheduled_delay_ms: 1}}
    ])

    :application.start(:opentelemetry)
    :ot_batch_processor.set_exporter(:ot_exporter_pid, self())

    :opentelemetry.register_application_tracer(:opentelemetry_decorator)

    tracer = :opentelemetry.get_tracer()
    :ot_tracer.start_span(tracer, "test", %{})

    on_exit(fn ->
      :ot_tracer.end_span(tracer)
    end)

    :ok
  end
end
