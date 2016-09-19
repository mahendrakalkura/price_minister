%{
  configs: [
    %{
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
