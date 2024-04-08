defmodule ExStatistics.Concentration do
  alias ExStatistics.Concentration
  alias ExStatistics.{Data}

  @type cumulation :: %{
    ni: list(number()),
    xi_ni: list(number())
  }
  @enforce_keys [:ni, :xi_ni]
  defstruct [:ni, :xi_ni]

  @doc ~S"""
    Calculates cumulation of ni and xi*ni in %

    #Example
    iex> Concentration.lorentz(Data.new([1000, 2000, 4000, 10000], [1250, 500, 240, 10]))
    %ExStatistics.Concentration{
      ni: [62.5, 87.5, 99.5, 100.0],
      xi_ni: [37.764350453172206, 67.97583081570997, 96.97885196374622, 100.0]
    }
  """
  @spec lorentz(Data.type()) :: Concentration.cumulation()
  def lorentz(data) do
    total_n = Data.get_total_n(data)
    ni_freq = Enum.map(data.n, fn n -> (n/total_n)*100 end)
    total_x = Data.get_total_x(data)
    xini_freq = Enum.map(Enum.zip(data.x, data.n), fn {xi, ni} -> ((xi*ni)/total_x)*100 end)
    concentrate = fn a -> Enum.map_reduce(a, 0, fn x, acc -> {x+acc, x+acc} end) end
    {ni, _} = concentrate.(ni_freq)
    {xini, _} = concentrate.(xini_freq)
    %Concentration{ni: ni, xi_ni: xini}
  end
end
