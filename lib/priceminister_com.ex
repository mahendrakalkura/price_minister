defmodule PriceministerCom do
  @moduledoc false

  require Map
  require URI

  def get_url(prefix, suffix) do
    url = prefix
    url = URI.parse(url)
    url = URI.merge(url, suffix)
    URI.to_string(url)
  end
end
