defmodule ExStatistics do
  alias ExStatistics.{Data, Quartiles}

  # Basic operations

  def new(x, n), do: Data.new(x, n)

  def mean(data), do: Data.get_mean(data)

  # Quartiles

  def quartile(data, flag) do
    case flag do
      :first -> Quartiles.get_first_quartile(data)
      :second -> Quartiles.get_second_quartile(data)
      :third -> Quartiles.get_third_quartile(data)
      _ -> raise("Bad flag")
    end
  end


end
