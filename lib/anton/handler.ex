defmodule Anton.Handler do
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    |> log
    |> route
    |> track
    |> format_response
  end

  def track(%{status: 404, path: path} = conv) do
    IO.puts "Warning #{path}"
    conv
  end

  def track(conv) do
    conv
  end

  def rewrite_path(%{path: "/wildlife"} = conv) do
    %{conv | path: "wildthings"}
  end

  def rewrite_path(conv) do
    conv
  end

  def log(conv) do
    IO.inspect conv
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

      %{ method: method,
        path: path,
        resp_body: "",
        status: nil
      }
  end

  # def route(conv) do
  #   route(conv, conv.method, conv.path)
  # end

  def route(%{ method: "GET", path: "/wildthings"} = conv) do
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%{ method: "GET", path: "/bears"} = conv) do
    %{ conv | status: 200, resp_body: "Winnie, paddington, smokey"}
  end

  def route(%{ method: "GET", path: "/bears" <> id} = conv) do
    %{ conv | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{ method: "GET", path: "/about"} = conv) do
    file =
      Path.expand("../../pages", __DIR__)
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  defp handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content}
  end

  defp handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found"}
  end

  defp handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}"}
  end

  # catchall function needs to be last
  def route(%{ path: path} = conv) do
    %{ conv | status: 404, resp_body: "No #{path} here"}
  end

  def format_response(conv) do
  """
  HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
  Content-Type: text/html
  Content-Length: #{String.length(conv.resp_body)}

  #{conv.resp_body}
  """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
      }[code]
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept:*/*

"""

response = Anton.Handler.handle(request)
IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept:*/*

"""

response = Anton.Handler.handle(request)
IO.puts response


request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept:*/*

"""

response = Anton.Handler.handle(request)
IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept:*/*

"""

response = Anton.Handler.handle(request)
IO.puts response
