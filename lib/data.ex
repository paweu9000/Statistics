defmodule Data do
  @typedoc """
  Represents statistics data such as
  \n`:singular`\n
  `x | 1 | 2 | 3`\n
  `n | 21| 8 | 7`
  """
  @type type :: :single | :ranged
  @type x :: [number()] | [{number(), number()}]
  @type n :: [integer()]

  @type data :: %Data{
    type: type(),
    x: x(),
    n: n()
  }
  @enforce_keys [:type, :x, :n]
  defstruct [:type, :x, :n]

  @spec new(x(), n()) :: Data.type()
  def new(x, n) when is_list(x) do
    cond do
      length(x) != length(n) -> raise("Lengths of X and N do not match")
      Enum.all?(x, &is_tuple/1) -> %Data{type: :ranged, x: x, n: n}
      true -> %Data{type: :single, x: x, n: n}
    end
  end

  @spec get_total_x(Data.type()) :: number()
  def get_total_x(%{type: type, x: x}) do
    case type do
      :single -> Enum.reduce(x, 0, fn a, acc -> a + acc end)
      :ranged -> Enum.reduce(x, 0, fn {fs, sd}, acc -> (fs + sd)/2 + acc end)
    end
  end

end
