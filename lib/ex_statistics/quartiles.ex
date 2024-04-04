defmodule ExStatistics.Quartiles do
  require Integer
  alias ExStatistics.Data

  @type flag :: :first | :second | :third

  @doc ~S"""
  Calculate first quartile from provided Data set
  ## Examples
    iex> get_first_quartile(Data.new([0, 1, 4, 5, 6, 9, 13, 17, 22, 30, 47], [2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]))
    1.0
    iex> get_first_quartile(Data.new([{30, 35}, {35, 40}, {40, 45}, {45, 50}, {50, 55}, {55, 60}], [10, 15, 25, 45, 40, 15]))
    42.5
  """
  @spec get_first_quartile(Data.type()) :: number()
  def get_first_quartile(data) do
    data
    |> calculate_quartile_pos(:first)
    |> find_quartile(data, :first)
  end

  @doc ~S"""
  Calculate second quartile(median) from provided Data set
  ## Examples
    iex> get_second_quartile(Data.new([0, 1, 4, 5, 6, 9, 13, 17, 22, 30, 47], [2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]))
    6.0
    iex> get_second_quartile(Data.new([{30, 35}, {35, 40}, {40, 45}, {45, 50}, {50, 55}, {55, 60}], [10, 15, 25, 45, 40, 15]))
    47.833333333333336
  """
  @spec get_second_quartile(Data.type()) :: number()
  def get_second_quartile(data) do
    data
    |> calculate_quartile_pos(:second)
    |> find_quartile(data, :second)
  end

  @doc ~S"""
  Calculate third quartile from provided Data set
  ## Examples
    iex> get_third_quartile(Data.new([0, 1, 4, 5, 6, 9, 13, 17, 22, 30, 47], [2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]))
    19.5
    iex> get_third_quartile(Data.new([{30, 35}, {35, 40}, {40, 45}, {45, 50}, {50, 55}, {55, 60}], [10, 15, 25, 45, 40, 15]))
    52.1875
  """
  @spec get_third_quartile(Data.type()) :: number()
  def get_third_quartile(data) do
    data
    |> calculate_quartile_pos(:third)
    |> find_quartile(data, :third)
  end

  @doc ~S"""
  Calculate quartile position by providing data set
  and flag describing which quartile position
  You want to get (:first, :second, :third)
  ## Examples
    iex> calculate_quartile_pos(Data.new([0, 1, 4, 5, 6, 9, 13, 17, 22, 30, 47], [2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1]), :third)
    9.75
    iex> calculate_quartile_pos(Data.new([{30, 35}, {35, 40}, {40, 45}, {45, 50}, {50, 55}, {55, 60}], [10, 15, 25, 45, 40, 15]), :second)
    75.5
  """
  @spec calculate_quartile_pos(Data.type(), flag()) :: number()
  def calculate_quartile_pos(data, flag) do
    total_n = Data.get_total_n(data)
    case flag do
      :first -> total_n / 4
      :second -> if Integer.is_even(total_n) do
                  (total_n + 1) / 2
                else
                  total_n / 2
                end
      :third -> (3 * (total_n)) / 4
      _ -> raise("Bad quartile flag")
    end
  end

  @doc ~S"""
  Finds specific x values that need to be used to calculate quartile
  """
  @spec find_quartile(number(), Data.type(), flag()) :: number()
  def find_quartile(pos, %{type: type, x: x, n: n}, flag) do
    Enum.zip(x, n)
    |> Enum.reduce_while({0, {}, {}}, fn {a, b}, {acc, first, _second} ->
      cond do
        type == :single && (flag == :first || flag == :second) -> if acc + b >= pos,
                        do: {:halt, {acc, {a, b}, {a, b}}},
                        else: {:cont, {acc + b, {a, b}, {}}}
        type == :single && flag == :third -> if acc >= pos,
                        do: {:halt, {acc, first, {a, b}}},
                        else: {:cont, {acc + b, {a, b}, {}}}
        true -> if acc + b >= pos,
                    do: {:halt, {acc, first, {a, b}}},
                    else: {:cont, {acc + b, {a, b}, {}}}
      end
    end)
    |> calculate_quartile(pos)
  end

  @doc ~S"""
  Calculate :single or :ranged quartile depending on provided arguments
  """
  @spec calculate_quartile({number(), {integer(), integer()}, {integer(), integer()}}, number()) :: number()
  def calculate_quartile({_, {pX, _pN}, {nX, _nN}}, pos) when is_number(pX) do
    case floor(pos) == ceil(pos) do
      true -> nX
      _ -> (nX + pX) / 2
    end
  end

  @spec calculate_quartile({number(), {tuple(), integer()}, {tuple(), integer()}}, number()) :: number()
  def calculate_quartile({total, {t, _pN}, {{nX1, nX2}, nN}}, pos) when is_tuple(t) do
    nX1 + ((pos - total) / nN) * (nX2 - nX1)
  end

end
