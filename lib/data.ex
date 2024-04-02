defmodule Data do
  @typedoc """
  Represents statistics data such as
  `x | 1 | 2 | 3`
  `n | 21| 8 | 7`
  """
  defstruct [:type, :x, :n]
end
