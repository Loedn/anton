defmodule Anton.Handler do
  def handle(request) do
    request
    |> parse
    |> route
    |> format_response
  end

  def parse(request) do
    # TODO: parse request string into map
    conv = %{ method: "GET", path: "/wildthings", resp_body: ""}
  end

  def route(conv) do
    # TODO: create map that has response body
    conv = %{ method: "GET", path: "wildthings", resp_body: "Bears, Lions, Tigers"}
  end

  def format_response(conv) do
  # TODO: use vals in map to create http response string
  """
  HTTP/1.1 200 OK
  Content-Type: text/html
  Content-Length: 20

  Bears, Lions, Tigers
  """
  end
end
request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept:*/*

"""

response = Anton.handler(request)
IO.puts response
