defmodule Day13.Cart do
  alias __MODULE__

  defstruct [:id, :direction, :next_turn, :coordinates, :crashed]

  def move_forward(%Cart{} = cart) do
    %{cart | coordinates: move(cart.coordinates, cart.direction)}
  end

  def turn(%Cart{} = cart, track) do
    %{
      cart
      | direction: turn(cart.direction, track, cart.next_turn),
        next_turn: next_turn(cart.next_turn, track)
    }
  end

  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :down), do: {x, y + 1}

  defp turn(:right, "/", _), do: :up
  defp turn(:right, "\\", _), do: :down

  defp turn(:up, "/", _), do: :right
  defp turn(:up, "\\", _), do: :left

  defp turn(:down, "/", _), do: :left
  defp turn(:down, "\\", _), do: :right

  defp turn(:left, "/", _), do: :down
  defp turn(:left, "\\", _), do: :up

  defp turn(:up, "+", :straight), do: :up
  defp turn(:up, "+", next_turn), do: next_turn
  defp turn(:down, "+", :left), do: :right
  defp turn(:down, "+", :right), do: :left
  defp turn(:left, "+", :left), do: :down
  defp turn(:left, "+", :right), do: :up
  defp turn(:right, "+", :left), do: :up
  defp turn(:right, "+", :right), do: :down
  defp turn(facing, _, _), do: facing

  defp next_turn(:left, "+"), do: :straight
  defp next_turn(:straight, "+"), do: :right
  defp next_turn(:right, "+"), do: :left
  defp next_turn(turn, _), do: turn
end

defmodule Day13 do
  alias Day13.Cart

  def part1(input) do
    input
    |> parse_input
    |> run_until_crash(0)
  end

  def part2(input) do
    input
    |> parse_input
    |> run_removing_crashes(0)
  end

  def run_until_crash(state, tick) do
    {carts, grid} = tick(state)

    if crashed?(carts) do
      find_crash(carts)
    else
      run_until_crash({carts, grid}, tick + 1)
    end
  end

  defp find_crash(carts) do
    carts
    |> Enum.group_by(fn cart -> cart.coordinates end)
    |> Enum.find(fn {_, carts} -> length(carts) == 2 end)
  end

  def run_removing_crashes(state, tick) do
    {carts, grid} = tick(state)

    case uncrashed_carts(carts) do
      [cart] -> cart
      _ -> run_removing_crashes({carts, grid}, tick + 1)
    end
  end

  def tick({carts, grid}) do
    carts = Enum.sort_by(carts, fn cart -> cart.coordinates end)
    move(carts, {[], grid})
  end

  defp uncrashed_carts(carts) do
    Enum.filter(carts, fn cart -> !cart.crashed end)
  end

  defp move([], state), do: state

  defp move([%Cart{crashed: true} = cart | unmoved_carts], {moved_carts, grid}) do
    # This cart has been crashed into and cannot move.
    move(unmoved_carts, {[cart | moved_carts], grid})
  end

  defp move([%Cart{} = cart | unmoved_carts], {moved_carts, grid}) do
    cart = Cart.move_forward(cart)
    cart = Cart.turn(cart, Map.get(grid, cart.coordinates))

    # Have we crashed into any of the other carts?
    if crashed_into?(cart, moved_carts) || crashed_into?(cart, unmoved_carts) do
      cart = %{cart | crashed: true}
      moved_carts = mark_crashed_into(moved_carts, cart.coordinates)
      unmoved_carts = mark_crashed_into(unmoved_carts, cart.coordinates)

      move(unmoved_carts, {[cart | moved_carts], grid})
    else
      move(unmoved_carts, {[cart | moved_carts], grid})
    end
  end

  defp crashed_into?(new_cart, carts) do
    Enum.any?(carts, fn cart -> !cart.crashed && cart.coordinates == new_cart.coordinates end)
  end

  defp mark_crashed_into(carts, coordinates) do
    Enum.reduce(carts, [], fn cart, acc ->
      cart =
        if cart.coordinates == coordinates do
          %{cart | crashed: true}
        else
          cart
        end

      [cart | acc]
    end)
  end

  @spec crashed?([%Cart{}]) :: boolean()
  defp crashed?(carts) do
    Enum.any?(carts, fn cart -> cart.crashed end)
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce({[], %{}}, &parse_row/2)
  end

  defp parse_row({row, num}, {carts, grid}) do
    {carts, grid, _} =
      row
      |> String.graphemes()
      |> Enum.reduce({carts, grid, 0}, fn char, {carts, grid, col} ->
        {add_cart(carts, char, {col, num}), add_track(grid, char, {col, num}), col + 1}
      end)

    {carts, grid}
  end

  defp add_cart(carts, char, coord) do
    direction =
      case char do
        "^" -> :up
        "v" -> :down
        "<" -> :left
        ">" -> :right
        _ -> nil
      end

    if direction == nil do
      carts
    else
      [
        %Cart{
          id: length(carts) + 1,
          direction: direction,
          next_turn: :left,
          coordinates: coord,
          crashed: false
        }
        | carts
      ]
    end
  end

  defp add_track(grid, char, coord) do
    track =
      case char do
        " " -> nil
        "^" -> "|"
        "v" -> "|"
        "<" -> "-"
        ">" -> "-"
        c -> c
      end

    if track == nil do
      grid
    else
      Map.put(grid, coord, track)
    end
  end

  def bench do
    Benchee.run(
      %{
        "day 13, part 1" => fn -> Advent.data(13) |> Day13.part1() end,
        "day 13, part 2" => fn -> Advent.data(13) |> Day13.part2() end
      },
      Application.get_env(:advent, :benchee)
    )

    :ok
  end
end
