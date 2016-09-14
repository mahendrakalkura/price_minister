alias Dogma.Rule

use Mix.Config

config :dogma,
  override: [
    %Rule.FunctionParentheses{
      enabled: false
    },
    %Rule.LineLength{
      max_length: 120
    }
  ],
  rule_set: Dogma.RuleSet.All
