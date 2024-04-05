defmodule ExStatistics.Coefficients do
  alias ExStatistics.{Data, Quartiles}

  @doc ~S"""
    Calculates standard deviation of provided set od data
   ## Examples
      iex> data = Data.new([{0, 2}, {2, 4}, {4, 6}, {6, 8}, {8, 10}, {10, 12}, {12, 14}, {14, 16}], [121, 98, 87, 75, 62, 49, 30, 21])
      iex> Coefficients.get_standard_deviation(data)
      4.073658164568168
  """
  @spec get_standard_deviation(Data.type()) :: number()
  def get_standard_deviation(data) do
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

  @doc ~S"""
    Calculates empirical range of variability
    x = [{-1, 0}, {0, 1}, {1, 2}] - smallest -1, biggest 2, range = 3
    ##Example
    iex> Coefficients.get_empirical_range_of_variability(Data.new([{-1, 0}, {0, 1}, {1, 2}], [1, 2, 3]))
    3.0
  """
  @spec get_empirical_range_of_variability(Data.type()) :: number()
  def get_empirical_range_of_variability(%Data{type: type, x: x}) do
    case type do
      :single -> List.last(x) - List.first(x)
      :ranged -> {_, last} = List.last(x)
                  {first, _} = List.first(x)
                  last - first
    end
  end

  @doc ~S"""
    Calculates mean absolute deviation from provided data set
    ##Example
    iex> Coefficients.get_mean_absolute_deviation(Data.new([-2, -1, 0, 1, 2], [12, 13, 27, 23, 25]))
    0.36
  """
  @spec get_mean_absolute_deviation()
  def get_mean_absolute_deviation(data) do
    case data.type do
      :single ->
        Enum.zip(data.x, data.n)
        |> Enum.reduce(0, fn {xi, ni}, acc -> (xi*ni)+acc end)
        |> Kernel./(Data.get_total_n(data))
      :ranged ->
        Enum.zip(data.x, data.n)
        |> Enum.reduce(0, fn {{x_min, x_max}, ni}, acc -> ((x_min+x_max)/2 * ni)+acc end)
        |> Kernel./(Data.get_total_n(data))
    end
  end

  @doc ~S"""
    Calculates coefficient of variation from provided data set and provides it as percentage
  """
  @spec coefficient_of_variation(Data.type()) :: number()
  def coefficient_of_variation(data), do:
        (get_standard_deviation(data)/get_empirical_range_of_variability(data)) * 100

  @doc ~S"""
    Calculate typical range of variability from provided set of data
    ##Example
    iex> Coefficients.typical_range_of_variability(Data.new([-2, -1, 0, 1, 2], [12, 13, 27, 23, 25]))
    {-1.0, :X, 1.0}
  """
  @spec typical_range_of_variability(Data.type()) :: tuple()
  def typical_range_of_variability(data) do
    q = Quartiles.quartile_deviation(data)
    median = Quartiles.get_second_quartile(data)
    {median-q, :X, median+q}
  end
end
