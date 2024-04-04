defmodule ExStatistics do
  alias ExStatistics.{Data, Quartiles, Coefficients}

  # Basic operations

  @spec new(Data.x(), Data.n()) :: Data.type()
  def new(x, n), do: Data.new(x, n)

  @spec mean(Data.type()) :: number()
  def mean(data), do: Data.get_mean(data)

  # Quartiles

  @spec quartile(Data.type(), Quartiles.flag()) :: number()
  def quartile(data, flag) do
    case flag do
      :first -> Quartiles.get_first_quartile(data)
      :second -> Quartiles.get_second_quartile(data)
      :third -> Quartiles.get_third_quartile(data)
      _ -> raise("Bad flag")
    end
  end

  @spec coefficient(Data.type()) :: number()
  def coefficient(data), do:  Coefficients.get_coefficient(data)

end
