How to install?
===============

Step 1
------

Add `:price_minister` to `def application()` in your `mix.exs`.

```
def application() do
  [
    applications: [
      ...
      :price_minister,
      ...
    ]
  ]
end
```

Step 2
------

Add `:price_minister` to `def deps()` in your `mix.exs`.

```
def deps do
  [
    ...
    {
      :price_minister,
      git: "https://github.com/mahendrakalkura/price_minister.git",
    },
    ...
  ]
end
```

Step 3
------

Execute `mix deps.get`.

How to use?
===========

```
$ iex -S mix
iex(1)> channel = %{
...(1)>   "url" => "...",
...(1)>   "login" => "...",
...(1)>   "pwd" => "...",
...(1)> }
%{
  "login" => "...",
  "pwd" => "...",
  "url" => "...",
}
iex(2)> PriceMinister.Aliases.query(channel)
{:ok, [...]}
iex(3)> PriceMinister.Templates.query(channel, "...")
{:ok, %{...}}
```
