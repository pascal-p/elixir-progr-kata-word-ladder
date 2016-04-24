defmodule WordLadder.Dict do

  @name __MODULE__

  def load(file \\ "./resources/wordlist.txt") do
    start_agent
    map = File.stream!(file, [:read, :utf8], :line)
    |> Enum.filter_map(&valid_word/1, &String.strip/1)
    |> Enum.reduce(%{}, &add_to/2)
    # TODO: rescue if exception (file not found or ...)
    Agent.update(@name, fn ds -> dict_update(ds, map) end)
    {:ok, map}
  end

  def start_agent_with(dict) do
    Agent.start_link(fn -> dict end, name: @name)
  end

  def has_key?(key), do: Map.has_key?(dict_get, key)

  defp start_agent do
    Agent.start_link(&dict_init/0, name: @name)
  end

  #
  # the data-struct hold by the agent, a map
  #
  defp dict_init, do: %{}

  defp dict_get, do: Agent.get(@name, &(&1))

  defp dict_update(_, map), do: map

  #
  # in this instance, valid words have length in [2, 5] (which [3, 6]
  # because of "\n") and do not contain any single quotes or accent
  #
  defp valid_word(word) do
    String.length(word) >= 3 &&
      String.length(word) <= 6 &&
      ! Regex.match?(~r/\'/, word) &&
      Regex.match?(~r/^[abcdefghijklmnopqrstuvwxyz]+$/i, word)
  end

  defp add_to(word, map) do
    Map.put(map, String.downcase(word), 1)
  end

end
