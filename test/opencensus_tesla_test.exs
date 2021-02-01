defmodule TestRequestClient do
  use Tesla

  plug(OpencensusTesla.Middleware)

  adapter(fn env ->
    {status, headers, body} =
      case env.url do
        _ ->
          {200, [], ""}
      end

    {:ok, %{env | status: status, headers: headers, body: body}}
  end)
end

defmodule TestRequestClientCustomized do
  use Tesla

  plug(OpencensusTesla.Middleware, span_name_override: fn path -> path <> "test" end)

  adapter(fn env ->
    {status, headers, body} =
      case env.url do
        _ ->
          {200, [], ""}
      end

    {:ok, %{env | status: status, headers: headers, body: body}}
  end)
end

defmodule OpencensusTeslaTest do
  use ExUnit.Case

  setup do
    Application.load(:opencensus)
    Application.put_env(:opencensus, :send_interval_ms, 1)
    Application.put_env(:opencensus, :reporters, [{:oc_reporter_pid, self()}])

    {:ok, _} = Application.ensure_all_started(:opencensus)
    {:ok, _} = Application.ensure_all_started(:opencensus_elixir)

    on_exit(fn -> Application.stop(:opencensus) end)
    :ok
  end

  test "span is reported after request is complete" do
    {:ok, env} = TestRequestClient.post("/", "")
    assert 200 = env.status

    assert_receive {:span, {:span, "/", _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}}, 1_000
  end

  test "can override span name" do
    {:ok, env} = TestRequestClientCustomized.post("/", "")
    assert 200 = env.status

    assert_receive {:span, {:span, "/test", _, _, _, _, _, _, _, _, _, _, _, _, _, _, _}}, 1_000
  end
end
