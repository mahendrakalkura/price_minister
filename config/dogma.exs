require Dogma.Rule
require Dogma.RuleSet

use Mix.Config

config :dogma,
  override: [
    %Dogma.Rule.FunctionParentheses{
      enabled: false,
    },
  ],
  rule_set: Dogma.RuleSet.All
