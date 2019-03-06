# OpenCensus Tesla Middleware

[![CircleCI](https://circleci.com/gh/opencensus-beam/opencensus_tesla.svg?style=svg)](https://circleci.com/gh/opencensus-beam/opencensus_tesla)
[![CodeCov](https://codecov.io/gh/opencensus-beam/opencensus_tesla/branch/master/graph/badge.svg)](https://codecov.io/gh/opencensus-beam/opencensus_tesla)
[![Inline docs](http://inch-ci.org/github/opencensus-beam/opencensus_tesla.svg)](http://inch-ci.org/github/opencensus-beam/opencensus_tesla)

OpencensusTesla is a Tesla middleware for generating spans for outgoing requests. This middleware will create a new child span from the current context and include this context in W3C TraceContext headers with the request.

## Installation

The package can be installed by adding `opencensus_tesla` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opencensus_tesla, "~> 0.2.0"}
  ]
end
```

### Example usage

```
defmodule MyClient do
  use Tesla

  plug OpencensusTesla.Middleware
end
```
