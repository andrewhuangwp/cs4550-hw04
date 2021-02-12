defmodule Practice.Calc do
  def operator?(text) do
    text == "+" or text == "-" or text == "*" or text == "/"
  end

  def tag_tokens(expr) do
    tag_tokens_helper(expr, [])
  end

  # Go through expression that has been split and assign operator or number.
  def tag_tokens_helper(expr, tokens) do
    cond do
      expr == [] ->
        tokens
      operator?(hd(expr)) ->
        tag_tokens_helper(tl(expr), tokens ++ [{:operator, hd(expr)}])
      true ->
        tag_tokens_helper(tl(expr), tokens ++ [{:num, hd(expr)}])
    end
  end

  def postfix(expr) do
    postfix_helper(expr, [], [])
  end

  # Assign value based on order of operation. Higher value = higher precedence to evaluate.
  def order_of_operation(operator) do
    case operator do
      "+" -> 0
      "-" -> 0
      "*" -> 1
      "/" -> 1
    end
  end

  # Determine which operator is higher order. True if first operator has higher precedence,
  # false if second operator has higher precendence.
  def higher_order?(operator1, operator2) do
    order_of_operation(operator1) > order_of_operation(operator2)
  end

  # Creates new list so that expression can be read from right to left based on order of 
  # operations.
  def postfix_helper(expr, numbers, operators) do
    cond do
      expr == [] ->
        numbers ++ operators
      elem(hd(expr), 0) == :operator ->
        # If operator is higher order than previous prepend to operators.
        if operators == [] || higher_order?(elem(hd(expr), 1), hd(operators)) do
          postfix_helper(tl(expr), numbers, [elem(hd(expr), 1) | operators])
        else
          postfix_helper(tl(expr), numbers ++ [hd(operators)], [elem(hd(expr), 1) | tl(operators)])
        end
      true ->
        postfix_helper(tl(expr), numbers ++ [elem(hd(expr), 1)], operators)
    end
  end


  def evaluate(expr) do
    evaluate_helper(expr, [])
  end

  # Iterates through expression by storing numbers until an operation is called. The last two 
  # numbers are then evaluated according to the operation
  def evaluate_helper(expr, prev) do
    cond do
      expr == [] ->
        hd(prev)
      operator?(hd(expr)) ->
        case hd(expr) do
          "+" ->
            evaluate_helper(tl(expr), [hd(tl(prev)) + hd(prev) | (tl(tl(prev)))])
          "-" ->
            evaluate_helper(tl(expr), [hd(tl(prev)) - hd(prev) | (tl(tl(prev)))])
          "*" ->
            evaluate_helper(tl(expr), [hd(tl(prev)) * hd(prev) | (tl(tl(prev)))])
          "/" ->
            evaluate_helper(tl(expr), [hd(tl(prev)) / hd(prev) | (tl(tl(prev)))])
        end
      true ->
        evaluate_helper(tl(expr), [parse_float(hd(expr)) | prev])
    end
  end

  def parse_float(text) do
    {float, _} = Float.parse(text)
    float
  end

  # Assumed all inputs were separated by space.
  # e.g. input 1+2 would evalute to 1.0 while input 1 + 2 evalues to 3.0
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> postfix
    |> evaluate

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end
end
