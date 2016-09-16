require Dogma.Rule
require Dogma.RuleSet

use Mix.Config

config :dogma,
  override: [
    %Dogma.Rule.FunctionParentheses{
      enabled: false,
    },
    %Dogma.Rule.LineLength{
      max_length: 120,
    },
  ],
  rule_set: Dogma.RuleSet.All
