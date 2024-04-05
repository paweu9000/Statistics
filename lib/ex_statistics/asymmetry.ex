defmodule ExStatistics.Asymmetry do
  alias ExStatistics.Data

  @type assymetry :: :left | :right
  # Ws = X - D
  # Ws < 0 = left | Ws > 0 = right
  # As = (X - D) / S or As = ((Q3 - Q2) - (Q2 - Q1)) / 2Q

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

  defp dominant_helper([a, b, c|tail], largest) do
    case b == largest do
      true -> {a, c}
      _ -> dominant_helper([b, c|tail], largest)
    end
  end
end
