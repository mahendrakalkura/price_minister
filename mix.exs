defmodule PriceministerCom.Mixfile do
  use Mix.Project

  def application do
    [
      applications: [
        :httpoison
      ]
    ]
  end

  def deps do
    [
      {:credo, "~> 0.4"},
      {:dogma, "~> 0.1"},
      {:httpoison, "~> 0.9.0"},
      {:sweet_xml, "~> 0.6.1"}
    ]
  end

  def project do
    [
      app: :priceminister_com,
      build_embedded: Mix.env == :prod,
      deps: deps(),
      elixir: "~> 1.3",
      start_permanent: Mix.env == :prod,
      version: "0.1.0"
    ]
  end
end
