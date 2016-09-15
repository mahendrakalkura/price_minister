defmodule PriceministerCom.Aliases do
  @moduledoc false

  require HTTPoison
  require Kernel
  require PriceministerCom
  require SweetXml

  def query(channel) do
    method = :post
    url = PriceministerCom.get_url(channel["url"], "/stock_ws")
    body = ""
    headers = []
    params = %{
      "action" => "producttypes",
      "login" => channel["login"],
      "pwd" => channel["pwd"],
      "version" => "2011-11-29",
    }
    options = [
      {:params, params}
    ]
    result = parse_http(HTTPoison.request(method, url, body, headers, options))
    result
  end

  def parse_http({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    aliases = parse_body(body)
    result = {:ok, aliases}
    result
  end

  def parse_http({:ok, %HTTPoison.Response{status_code: status_code}}) do
    result = {:error, status_code}
    result
  end

  def parse_http({:error, %HTTPoison.Error{reason: reason}}) do
    result = {:error, reason}
    result
  end

  def parse_body(body) do
    aliases = SweetXml.xpath(body, SweetXml.sigil_x("//response/producttypetemplate/alias/text()", 'sl'))
    aliases = Enum.sort(aliases)
    aliases
  end
end
