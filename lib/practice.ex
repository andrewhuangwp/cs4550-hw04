defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def double(x) do
    2 * x
  end

  def calc(expr) do
    # This is more complex, delegate to lib/practice/calc.ex
    Practice.Calc.calc(expr)
  end

  def factor(x) do
    # Maybe delegate this too.
    factorization(x, 2, [])
  end

  def factorization(x, factor, factors) do
    cond do 
      x < factor * factor ->
        factors ++ [x]
      rem(x, factor) == 0 ->
        factorization(div(x, factor), factor, factors ++ [factor])
      true ->
        factorization(x, factor + 1, factors)
    end
  end

  # TODO: Add a palindrome? function.
  def palindrome?(x) do
    x == String.reverse(x)
  end
end
