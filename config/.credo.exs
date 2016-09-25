%{
  configs: [
    %{
      checks: [{Credo.Check.Design.AliasUsage, false}],
      files: %{included: ["config/", "lib/", "test/", "*.exs"]},
      name: "default",
    },
  ],
}
