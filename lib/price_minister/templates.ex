defmodule PriceMinister.Templates do
  @moduledoc false

  require HTTPoison
  require Kernel
  require PriceMinister
  require SweetXml

  def query(channel, alias) do
    arguments = get_arguments(channel, alias)
    response = PriceMinister.http_poison(arguments)
    body = PriceMinister.parse_response(response)
    parse_body(body)
  end

  def parse_body({:ok, body}) do
    template = get_template(body)
    {:ok, template}
  end

  def parse_body({:error, reason}) do
    {:error, reason}
  end

  def get_arguments(channel, alias) do
    method = :get
    url = PriceMinister.get_url(channel["url"], "stock_ws")
    body = ""
    headers = []
    params = %{
      "action" => "producttypetemplate",
      "alias" => alias,
      "login" => channel["login"],
      "pwd" => channel["pwd"],
      "scope" => "VALUES",
      "version" => "2015-02-02",
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

  def get_template(body) when Kernel.is_bitstring(body) do
    response = SweetXml.xpath(body, SweetXml.sigil_x("//response", 'e'))
    name = ""
    name_fr = SweetXml.xpath(
      response,
      SweetXml.sigil_x("./prdtypelabel/text()", 's')
    )
    sections = get_sections(response)
    %{
      "name" => name,
      "name_fr" => name_fr,
      "sections" => sections,
    }
  end

  def get_sections(response) do
    advert = get_section(response, "advert")
    media = get_section(response, "media")
    product = get_section(response, "product")
    %{
      "advert" => advert,
      "media" => media,
      "product" => product,
    }
  end

  def get_section(response, section) do
    section = SweetXml.xpath(
      response,
      SweetXml.sigil_x("./attributes/#{section}", 'e')
    )
    get_attributes(section)
  end

  def get_attributes(section) do
    attributes = SweetXml.xpath(section, SweetXml.sigil_x("./attribute", 'el'))
    Enum.reduce(
      attributes,
      %{},
      fn(attribute, attributes) ->
        attribute = get_attribute(attribute)
        Map.merge(attributes, attribute)
      end
    )
  end

  def get_attribute(attribute) do
    key = get_key(attribute)
    value = get_key(attribute)
    %{
      key => value
    }
  end

  def get_key(attribute) do
    SweetXml.xpath(attribute, SweetXml.sigil_x("./key/text()", 's'))
  end

  def get_value(attribute) do
    name = ""

    name_fr = SweetXml.xpath(
      attribute,
      SweetXml.sigil_x("./label/text()", 's')
    )

    is_mandatory = SweetXml.xpath(
      attribute,
      SweetXml.sigil_x("./mandatory/text()", 's')
    )
    is_mandatory = get_is_mandatory(is_mandatory)

    options = SweetXml.xpath(
      attribute,
      SweetXml.sigil_x("./valueslist/value/text()", 'sl')
    )
    options = get_options(options)

    type = SweetXml.xpath(
      attribute,
      SweetXml.sigil_x("./valuetype/text()", 's')
    )
    type = get_type(options, type)

    %{
      "name" => name,
      "name_fr" => name_fr,
      "is_mandatory" => is_mandatory,
      "options" => options,
      "type" => type,
    }
  end

  def get_is_mandatory("1") do
    true
  end

  def get_is_mandatory(_is_mandatory) do
    false
  end

  def get_options(options) do
    options = Enum.map(options, fn(option) -> String.trim(option) end)
    options = Enum.filter(options, fn(option) -> String.length(option) > 0 end)
    Enum.reduce(
      options,
      %{},
      fn(option, options) -> Map.put(options, option, "") end
    )
  end

  def get_type(options, "Boolean") when Kernel.map_size(options) == 0 do
    ~s(input[type="checkbox"])
  end

  def get_type(options, "Date") when Kernel.map_size(options) == 0 do
    ~s(input[type="date"])
  end

  def get_type(options, "Number") when Kernel.map_size(options) == 0 do
    ~s(input[type="number"])
  end

  def get_type(options, "Text") when Kernel.map_size(options) == 0 do
    ~s(input[type="text"])
  end

  def get_type(options, _type) when Kernel.map_size(options) == 0 do
    ~s(input[type="text"])
  end

  def get_type(options, _type) when Kernel.map_size(options) != 0 do
    "select"
  end
end
