defmodule PriceMinister do
  @moduledoc false

  def http_poison(arguments) do
    HTTPoison.request(
      arguments["method"],
      arguments["url"],
      arguments["body"],
      arguments["headers"],
      arguments["options"]
    )
  end

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, status_code}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end

  def get_url(prefix, suffix) do
    parse = URI.parse(prefix)
    merge = URI.merge(parse, suffix)
    URI.to_string(merge)
  end
end
