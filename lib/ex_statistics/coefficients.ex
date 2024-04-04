defmodule ExStatistics.Coefficients do
  alias ExStatistics.{Data}

  @doc ~S"""
    Calculates coefficient of variation of provided set od data
   ## Examples
      iex> data = Data.new([{0, 2}, {2, 4}, {4, 6}, {6, 8}, {8, 10}, {10, 12}, {12, 14}, {14, 16}], [121, 98, 87, 75, 62, 49, 30, 21])
      iex> Coefficients.get_coefficient(data)
      4.073658164568168
  """
  @spec get_coefficient(Data.type()) :: number()
  def get_coefficient(data) do
    mean = Data.get_mean(data)
    total_n = Data.get_total_n(data)
    case data.type do
      :single -> data.x
      :ranged -> Enum.map(data.x, fn {a, b} -> (a + b) / 2 end)
    end
    |> Enum.zip(data.n)
    |> Enum.map(fn {xi, ni} -> :math.pow((xi - mean), 2) * ni end)
    |> Enum.sum()
    |> Kernel./(total_n)
    |> :math.sqrt()
  end
end
