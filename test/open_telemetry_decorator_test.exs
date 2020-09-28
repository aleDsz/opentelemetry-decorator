defmodule OpenTelemetryDecoratorTest do
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

  describe "with OpenTelemetry configured do" do
    test "test with with_span/0 retuns the value attribute" do
      Foo.value()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.value/0",
                        attributes: list
                      )}

      assert [{"value", "asdasda"}] == list
    end

    test "test with with_span/0 retuns the user_id attribute" do
      Foo.struct()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.struct/0",
                        attributes: list
                      )}

      assert [{"user_id", 123}] == list
    end

    test "test with with_span/0 retuns the id attribute" do
      Foo.map()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.map/0",
                        attributes: list
                      )}

      assert [{"id", 123}] == list
    end

    test "test with with_span/0 retuns the schema source attribute" do
      Foo.schema()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.schema/0",
                        attributes: list
                      )}

      assert [
               {"account_id", 123},
               {"schema_name", "accounts"}
             ] == list
    end

    test "test with with_span/0 retuns the exception attribute" do
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
               {"exception", true},
               {"exception.message", "bla bla test"},
               {"exception.stacktrace", message}
             ] = list

      assert message =~ "(opentelemetry_decorator) test/support/foo.ex"
    end

    test "test with with_span/0 retuns the stacktrace attribute" do
      list =
        try do
          Foo.stacktrace()
        rescue
          _ ->
            assert_receive {:span,
                            span(
                              name: "Elixir.Foo.stacktrace/0",
                              attributes: list
                            )}

            list
        end

      assert [
               {"exception", true},
               {"exception.message", "no case clause matching: {:ok, \"asdasda\"}"},
               {"exception.stacktrace", message}
             ] = list

      assert message =~ "(opentelemetry_decorator) test/support/foo.ex"
    end

    test "test with with_span/0 retuns the error string attribute" do
      Foo.error_string()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.error_string/0",
                        attributes: list
                      )}

      assert [
               {"error", true},
               {"error.reason", "this is an error"}
             ] == list
    end

    test "test with with_span/0 retuns the error atom attribute" do
      Foo.error_atom()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.error_atom/0",
                        attributes: list
                      )}

      assert [
               {"error", true},
               {"error.reason", "internal server error"}
             ] == list
    end

    test "test with with_span/0 retuns the error multi attribute" do
      Foo.error_multi()

      assert_receive {:span,
                      span(
                        name: "Elixir.Foo.error_multi/0",
                        attributes: list
                      )}

      assert [
               {"error", true},
               {"error.reason", "not found"},
               {"error.context", "user"}
             ] == list
    end
  end
end
