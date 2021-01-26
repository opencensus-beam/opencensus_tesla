defmodule OpencensusTesla.Middleware do
  @behaviour Tesla.Middleware

  @moduledoc """
  Tesla middleware for generating spans for outgoing requests.

  This middleware will create a new child span from the current
  context and include this context in W3C TraceContext headers
  with the request.

  ### Example usage
  ```
  defmodule MyClient do
    use Tesla

    plug OpencensusTesla.Middleware
  end
  ```

  ### Options

  Following Middleware options are accepted:
    - `span_name_override` - if provided, will be used as the
      span name. Otherwise request path is used by default.
  """

  import Opencensus.Trace

  def call(env, next, options) do
    uri = %URI{path: path} = URI.parse(env.url)
    span_name = Keyword.get(options, :span_name_override, path)

    with_child_span(span_name, http_attributes(env, uri)) do
      span_ctx = :ocp.current_span_ctx()
      headers = :oc_propagation_http_tracecontext.to_headers(span_ctx)

      case Tesla.run(Tesla.put_headers(env, headers), next) do
        {:ok, env} ->
          :ocp.put_attribute("http.status_code", env.status)
          {:ok, env}

        {:error, _} = e ->
          # TODO: update span's status to with appropriate error code and message
          e
      end
    end
  end

  def http_attributes(env, uri) do
    attributes = %{
      "http.host" => uri.host,
      "http.method" => env.method,
      "http.path" => uri.path,
      "http.url" => env.url
    }

    case Tesla.get_header(env, "user-agent") do
      nil ->
        attributes

      user_agent ->
        Map.put(attributes, "http.user_agent", user_agent)
    end
  end
end
