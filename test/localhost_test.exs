defmodule LocalhostTest do
  use ExUnit.Case
  doctest Localhost

  test "greets the world" do
    assert Localhost.hello() == :world
  end
end
