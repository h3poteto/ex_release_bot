defmodule ReleaseBotTest do
  use ExUnit.Case
  doctest ReleaseBot

  test "greets the world" do
    assert ReleaseBot.hello() == :world
  end
end
