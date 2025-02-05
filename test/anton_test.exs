defmodule AntonTest do
  use ExUnit.Case
  doctest Anton

  test "greets the world" do
    assert Anton.hello() == :world
  end
end
