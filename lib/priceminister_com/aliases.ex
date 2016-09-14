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
    response = parse_http(HTTPoison.request(method, url, body, headers, options))
    response
  end

  def get_aliases(response) when Kernel.is_list(response) do
  end

  def parse_http({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    aliases = parse_xml(body)
    {:ok, aliases}
  end

  def parse_http({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, status_code}
  end

  def parse_http({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  def parse_xml(body) do
    aliases = SweetXml.xpath(body, SweetXml.sigil_x("//response/producttypetemplate/alias/text()", 'sl'))
    aliases = Enum.sort(aliases)
    aliases
  end
end
