# ExStatistics

Lightweight elixir library to calculate statistical operations, such as:
Mean, quartiles, deviations, coefficients, asymmetries, concentrations.

## Example
```elixir
data = ExStatistics.new([1000, 2000, 4000, 10000], [1250, 500, 240, 10])
%ExStatistics.Data{
  type: :single,
  x: [1000, 2000, 4000, 10000],
  n: [1250, 500, 240, 10]
}

ExStatistics.mean(data)
1655.0

data = ExStatistics.new([{0,3}, {3,6}, {6,9},{9,12},{12,15},{15,18},{18,21}], [10, 15, 16, 27, 58, 81, 11])
%ExStatistics.Data{
  type: :ranged,
  x: [{0, 3}, {3, 6}, {6, 9}, {9, 12}, {12, 15}, {15, 18}, {18, 21}],
  n: [10, 15, 16, 27, 58, 81, 11]
}

ExStatistics.quartile(data, :second)
14.14655172413793
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_statistics` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_statistics, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_statistics>.

