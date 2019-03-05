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

defmodule OpencensusTeslaTest do
  use ExUnit.Case

  test "span is reported after request is complete" do
    Application.load(:opencensus)
    Application.put_env(:opencensus, :send_interval_ms, 1)
    Application.put_env(:opencensus, :reporters, [{:oc_reporter_pid, self()}])

    {:ok, _} = Application.ensure_all_started(:opencensus)
    {:ok, _} = Application.ensure_all_started(:opencensus_elixir)

    {:ok, env} = TestRequestClient.post("/", "")
    assert 200 = env.status

    assert_receive {:span, _}, 1_000
  end
end
