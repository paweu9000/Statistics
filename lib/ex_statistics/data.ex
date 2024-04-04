defmodule ExStatistics.Data do
  alias ExStatistics.Data
  @typedoc """
  Represents statistics data such as
  \n`:single`\n
  `x | 1 | 2 | 3`\n
  `n | 21| 8 | 7`
  """
  @type type :: :single | :ranged
  @type x :: [number()] | [{number(), number()}]
  @type n :: [integer()]

  @type data :: %{
    type: type(),
    x: x(),
    n: n()
  }
  @enforce_keys [:type, :x, :n]
  defstruct [:type, :x, :n]


  @doc ~S"""
  Create new %Data struct. If x is list of numbers the return struct
  will be of type :single whereas if x is list of tuples the type will
  be :ranged

  ## Examples
    iex> Data.new([1, 2, 3], [15, 12, 54])
    %Data{type: :single, x: [1, 2, 3], n: [15, 12, 54]}

    iex> Data.new([{1, 2}, {3, 4}, {5, 6}], [15, 12, 54])
    %Data{type: :ranged, x: [{1, 2}, {3, 4}, {5, 6}], n: [15, 12, 54]}
  """
  @spec new(x(), n()) :: Data.type()
  def new(x, n) when is_list(x) do
    cond do
      length(x) != length(n) -> raise("Lengths of X and N do not match")
      Enum.all?(x, &is_tuple/1) -> %Data{type: :ranged, x: x, n: n}
      true -> %Data{type: :single, x: x, n: n}
    end
  end

  @doc ~S"""
  Get total x amount by multiplying each x by n and adding to accumulator

  ## Example
    iex> Data.get_total_x(Data.new([1, 2, 3], [1, 2, 3]))
    14
  """
  @spec get_total_x(Data.type()) :: number()
  def get_total_x(%Data{type: type, x: x, n: n}) do
    case type do
      :single -> Enum.zip(x, n)
                |> Enum.reduce(0, fn {fs, sd}, acc -> fs * sd + acc end)
      :ranged -> Enum.zip(x, n)
                |> Enum.reduce(0, fn {{fs, sd}, tr}, acc -> ((fs + sd)*tr)/2 + acc end)
    end
  end

  @doc ~S"""
  Get total n amount

  ## Example
    iex> Data.get_total_n(Data.new([1, 2, 3], [1, 2, 3]))
    6
  """
  @spec get_total_n(Data.type()) :: integer()
  def get_total_n(%{n: n}), do: Enum.sum(n)

  @doc ~S"""
  Calculate mean from provided Data struct

  ## Examples
    iex> Data.get_mean(Data.new([1, 2, 3], [1, 2, 3]))
    2.3333333333333335
  """
  @spec get_mean(Data.type()) :: number()
  def get_mean(data), do: get_total_x(data) / get_total_n(data)

end
