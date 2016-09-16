%{
  configs: [
    %{
      checks: [
        {
          Credo.Check.Readability.MaxLineLength,
          priority: :low,
          max_length: 120,
        },
      ],
      files: %{
        included: [
          "config/",
          "lib/",
          "test/",
          "*.exs",
        ],
      },
      name: "default",
    },
  ],
}
