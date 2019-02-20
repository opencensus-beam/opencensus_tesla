defmodule OpencensusTesla.Middleware do
  @behaviour Tesla.Middleware

  @moduledoc """
  Short description what it does

  Longer description, including e.g. additional dependencies.


  ### Example usage
  ```
  defmodule MyClient do
    use Tesla

    plug OpencensusTesla.Middleware, most: :common, options: "here"
  end
  ```

  ### Options
  - `:list` - all possible options
  - `:with` - their default values
  """

  import Opencensus.Trace

  def call(env, next, _options) do
    uri = %URI{path: path} = URI.parse(env.url)

    with_child_span(path, http_attributes(env, uri)) do
      span_ctx = :ocp.current_span_ctx()
      headers = [{:oc_span_ctx_header.field_name(), :oc_span_ctx_header.encode(span_ctx)}]
      env = Tesla.run(Tesla.put_headers(env, headers), next)
      :ocp.put_attribute("http.status_code", env.status)
      env
    end
  end

  def http_attributes(env, uri) do
    attributes = %{
      "http.host" => uri.host,
      "http.method" => env.method,
      "http.path" => uri.path,
      "http.url" => env.url
    }

    case Tesla.get_header(env, "User-Agent") do
      nil ->
        attributes

      user_agent ->
        Map.put(attributes, "http.user_agent", user_agent)
    end
  end
end
