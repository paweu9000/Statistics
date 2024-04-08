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
    iex> Concentration.cumulated_data(Data.new([1000, 2000, 4000, 10000], [1250, 500, 240, 10]))
    %ExStatistics.Concentration{
      ni: [62.5, 87.5, 99.5, 100.0],
      xi_ni: [37.764350453172206, 67.97583081570997, 96.97885196374622, 100.0]
    }
  """
  @spec cumulated_data(Data.type()) :: Concentration.cumulation()
  def cumulated_data(data) do
    if data.type == :single do
      total_n = Data.get_total_n(data)
      ni_freq = Enum.map(data.n, fn n -> (n/total_n)*100 end)
      total_x = Data.get_total_x(data)
      xini_freq = Enum.map(Enum.zip(data.x, data.n), fn {xi, ni} -> ((xi*ni)/total_x)*100 end)
      concentrate = fn a -> Enum.map_reduce(a, 0, fn x, acc -> {x+acc, x+acc} end) end
      {ni, _} = concentrate.(ni_freq)
      {xini, _} = concentrate.(xini_freq)
      %Concentration{ni: ni, xi_ni: xini}
    else
      nil
    end
  end

  @doc ~S"""
    Calculates lorentz (k)

    #Example
    iex> Concentration.lorentz(Data.new([1000, 2000, 4000, 10000], [1250, 500, 240, 10]))
    0.29182779456193364
  """
  @spec lorentz(Data.type()) :: number()
  def lorentz(data) do
    if data.type == :single do
      cumulation = cumulated_data(data)
      [xini_head|xini_tail] = cumulation.xi_ni
      [ni_head|ni_tail] = cumulation.ni
      total = ((ni_head * xini_head)/2) + lorentz_helper([xini_head|xini_tail], [ni_head|ni_tail])
      # 5000 is total field of triangle (100% * 100% / 2)
      (5000 - total) / 5000
    else
      nil
    end
  end

  @spec lorentz_helper(list(), list()) :: number()
  defp lorentz_helper([_|[]], [_|[]]), do: 0

  defp lorentz_helper([xini1, xini2|xinitail], [ni1, ni2|nitail]) do
    (xini1+xini2)/2
    |> Kernel.*(ni2-ni1)
    |> Kernel.+(lorentz_helper([xini2|xinitail], [ni2|nitail]))
  end
end
