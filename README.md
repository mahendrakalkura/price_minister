How to install?
===============

Step 1
------

Add `:priceminister_com` to `def application()` in your `mix.exs`.

```
def application() do
  [
    applications: [
      ...
      :priceminister_com,
      ...
    ]
  ]
end
```

Step 2
------

Add `:priceminister_com` to `def deps()` in your `mix.exs`.

```
def deps do
  [
    ...
    {:priceminister_com, git: "https://github.com/mahendrakalkura/priceminister.com.git"},
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
%{"login" => "...",
  "pwd" => "...",
  "url" => "..."}
iex(2)> PriceministerCom.Aliases.query(channel)
{:ok, [...]}
iex(3)> PriceministerCom.Templates.query(channel, "...")
{:ok, %{...}}
```
