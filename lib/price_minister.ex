defmodule PriceMinister do
  @moduledoc false

  require HTTPoison
  require URI

  def http_poison(result) do
    result = HTTPoison.request(result["method"], result["url"], result["body"], result["headers"], result["options"])
    result
  end

  def parse_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    result = {:ok, body}
    result
  end

  def parse_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    result = {:error, status_code}
    result
  end

  def parse_response({:error, %HTTPoison.Error{reason: reason}}) do
    result = {:error, reason}
    result
  end

  def get_url(prefix, suffix) do
    url = prefix
    url = URI.parse(url)
    url = URI.merge(url, suffix)
    url = URI.to_string(url)
    url
  end
end
