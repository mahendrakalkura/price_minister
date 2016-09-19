defmodule PriceMinister.Aliases do
  @moduledoc false

  require HTTPoison
  require PriceMinister
  require SweetXml

  def query(channel) do
    arguments = get_arguments(channel)
    response = PriceMinister.http_poison(arguments)
    body = PriceMinister.parse_response(response)
    parse_body(body)
  end

  def parse_body({:ok, body}) do
    aliases = get_aliases(body)
    {:ok, aliases}
  end

  def parse_body({:error, reason}) do
    {:error, reason}
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
      {:recv_timeout, Application.get_env(:httpoison, :timeout, nil)},
      {:timeout, Application.get_env(:httpoison, :timeout, nil)},
    ]
    %{
      "method" => method,
      "url" => url,
      "body" => body,
      "headers" => headers,
      "options" => options,
    }
  end

  def get_aliases(body) do
    aliases = SweetXml.xpath(
      body,
      SweetXml.sigil_x("//response/producttypetemplate/alias/text()", 'sl')
    )
    Enum.sort(aliases)
  end
end
