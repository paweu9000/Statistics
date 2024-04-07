defmodule ExStatistics.Asymmetry do
  alias ExStatistics.{Data, Coefficients}

  @type asymmetry :: :left | :right
  # Ws = X - D
  # Ws < 0 = left | Ws > 0 = right
  # As = (X - D) / S or As = ((Q3 - Q2) - (Q2 - Q1)) / 2Q

  @doc ~S"""
    Calculates skewness coefficient from provided data set
    :left, :right means the type of asymmetry
    ##Example
    iex> Asymmetry.skewness_coefficient(Data.new([{0, 3}, {3, 6}, {6, 9}, {9, 12}, {12, 15}, {15, 18}, {18, 21}], [10, 15, 16, 27, 58, 81, 11]))
    {:left, {:As, -0.6156161946238491}, {:Ws, -2.8061556673572063}}
  """
  @spec skewness_coefficient(Data.type()) :: tuple()
  def skewness_coefficient(data) do
    mean = Data.get_mean(data)
    domin =  dominant(data)
    skewness = mean - domin
    deviation = Coefficients.get_standard_deviation(data)
    case skewness < 0 do
      true -> {:left, {:As, (mean-domin)/deviation}, {:Ws, skewness}}
      _ -> {:right, {:As, (mean-domin)/deviation}, {:Ws, skewness}}
    end
  end

  @doc ~S"""
    Calculates asymmetry dominant from provided data set
    ##Example
    iex> Asymmetry.dominant(Data.new([{0, 3}, {3, 6}, {6, 9}, {9, 12}, {12, 15}, {15, 18}, {18, 21}], [10, 15, 16, 27, 58, 81, 11]))
    15.741935483870968
  """
  @spec dominant(Data.type()) :: number()
  def dominant(%Data{type: type, x: x, n: n}) do
    largest = Enum.max(n)
    {neighbour1, neighbour2} = dominant_helper(n, largest)
    lower_bound = Enum.zip(x, n)
                  |> Enum.reduce_while(0, fn {xi, ni}, acc ->
                        if ni == largest do
                          case type do
                            :single -> {:halt, xi}
                            :ranged -> {:halt, elem(xi, 0)}
                          end
                        else
                          {:cont, acc}
                        end
                    end)
    range = case type do
              :single -> 1
              :ranged -> {a, b} = List.first(x)
                          b-a
            end
    lower_bound + ((largest - neighbour1)/((largest - neighbour1) + (largest - neighbour2))) * range
  end

  @spec dominant_helper(list(), integer()) :: tuple()
  defp dominant_helper([a, b, c|tail], largest) do
    case b == largest do
      true -> {a, c}
      _ -> dominant_helper([b, c|tail], largest)
    end
  end
end
