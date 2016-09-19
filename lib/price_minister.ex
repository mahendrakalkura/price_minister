defmodule PriceMinister do
  @moduledoc false

  require HTTPoison
  require URI

  def http_poison(arguments) do
    HTTPoison.request(
      arguments["method"],
      arguments["url"],
      arguments["body"],
      arguments["headers"],
      arguments["options"]
    )
  end

  def parse_response(
    {:ok, %HTTPoison.Response{status_code: 200, body: body}}
  ) do
    {:ok, body}
  end

  def parse_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, status_code}
  end

  def parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  def get_url(prefix, suffix) do
    parse = URI.parse(prefix)
    merge = URI.merge(parse, suffix)
    URI.to_string(merge)
  end
end
