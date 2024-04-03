defmodule Quartiles do
  require Integer
  require Data

  def get_first_quartile(data) do
    data
    |> calculate_quartile_pos(:first)
    |> find_quartile(data, :first)
  end

  def get_second_quartile(data) do
    data
    |> calculate_quartile_pos(:second)
    |> find_quartile(data, :second)
  end

  def get_third_quartile(data) do
    data
    |> calculate_quartile_pos(:third)
    |> find_quartile(data, :third)
  end

  def calculate_quartile_pos(data, flag) do
    total_n = Data.get_total_n(data)
    case flag do
      :first -> total_n / 4
      :second -> if Integer.is_even(total_n) do
                  (total_n + 1) / 2
                else
                  total_n / 2
                end
      :third -> (3 * total_n) / 4
      _ -> raise("Bad quartile flag")
    end
  end

  def find_quartile(pos, %{type: type, x: x, n: n}, flag) do
    Enum.zip(x, n)
    |> Enum.reduce_while({0, {}, {}}, fn {a, b}, {acc, first, second} ->
      cond do
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

  def calculate_quartile({total, {pX, pN}, {nX, nN}}, pos) when is_number(pX) do
    case floor(pos) == ceil(pos) do
      true -> nX
      _ -> (nX + pX) / 2
    end
  end

  def calculate_quartile({total, {t, pN}, {{nX1, nX2}, nN}}, pos) when is_tuple(t) do
    nX1 + ((pos - total) / nN) * (nX2 - nX1)
  end

end
