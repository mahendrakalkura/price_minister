defmodule PriceMinister.Aliases do
  @moduledoc false

  def query(channel) do
    arguments = get_arguments(channel)
    response = PriceMinister.http_poison(arguments)
    body = PriceMinister.parse_response(response)
    parse_body(body)
  end

  def get_arguments(channel) do
    url = PriceMinister.get_url(channel["url"], "stock_ws")
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
      "method" => :get,
      "url" => url,
      "body" => "",
      "headers" => [],
      "options" => options,
    }
  end

  def parse_body(body) do
    case body do
      {:ok, contents} ->
        aliases = get_aliases(contents)
        {:ok, aliases}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_aliases(body) do
    aliases = SweetXml.xpath(
      body,
      SweetXml.sigil_x("//response/producttypetemplate/alias/text()", 'sl')
    )
    aliases = Enum.uniq(aliases)
    Enum.sort(aliases)
  end
end
