defmodule PriceMinister.Aliases do
  @moduledoc false

  require HTTPoison
  require PriceMinister
  require SweetXml

  def query(channel) do
    result = get_arguments(channel)
    result = PriceMinister.http_poison(result)
    result = PriceMinister.parse_response(result)
    result = parse_body(result)
    result
  end

  def parse_body({:ok, body}) do
    aliases = get_aliases(body)
    result = {:ok, aliases}
    result
  end

  def parse_body({:error, reason}) do
    result = {:error, reason}
    result
  end

  def get_arguments(channel) do
    method = :get
    url = PriceMinister.get_url(channel["url"], "stock_ws")
    body = ""
    headers = []
    params = %{
      "action" => "producttypes",
      "login" => channel["login"],
      "pwd" => channel["pwd"],
      "version" => "2011-11-29",
    }
    options = [
      {:params, params},
    ]
    result = %{
      "method" => method,
      "url" => url,
      "body" => body,
      "headers" => headers,
      "options" => options,
    }
    result
  end

  def get_aliases(body) do
    aliases = SweetXml.xpath(body, SweetXml.sigil_x("//response/producttypetemplate/alias/text()", 'sl'))
    aliases = Enum.sort(aliases)
    aliases
  end
end
