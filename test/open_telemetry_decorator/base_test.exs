defmodule OpenTelemetryDecorator.BaseTest do
  use OpenTelemetryDecorator.Support.TestCase

  require OpenTelemetry.Tracer
  require OpenTelemetry.Span
  require Record

  for {name, spec} <- Record.extract_all(from_lib: "opentelemetry/include/ot_span.hrl") do
    Record.defrecord(name, spec)
  end

  for {name, spec} <- Record.extract_all(from_lib: "opentelemetry_api/include/opentelemetry.hrl") do
    Record.defrecord(name, spec)
  end

  setup_all do
    Application.put_env(
      :opentelemetry_decorator,
      :handler,
      OpenTelemetryDecorator.Support.Handler
    )

    :ok
  end

  describe "Using custom handler so" do
    test "test with with_span/0 retuns the value attribute" do
      Foo.struct()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.struct/0",
                        attributes: list
                      )}

      assert [{"id", "123"}, {"handler", "custom"}] == list
    end

    test "test with with_span/0 retuns the error attribute" do
      Foo.error_atom()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.error_atom/0",
                        attributes: list
                      )}

      assert [{"error", "internal_server_error"}, {"handler", "custom"}] == list
    end

    test "test with with_span/0 retuns the stacktrace attribute" do
      list =
        try do
          Foo.exception()
        rescue
          _ ->
            assert_receive {:span,
                            span(
                              name: "Elixir.Foo.exception/0",
                              attributes: list
                            )}

            list
        end

      assert [
               {"exception", "bla bla test"},
               {"stacktrace", message},
               {"handler", "custom"}
             ] = list

      assert message =~ "(opentelemetry_decorator) test/support/foo.ex"
    end
  end
end
