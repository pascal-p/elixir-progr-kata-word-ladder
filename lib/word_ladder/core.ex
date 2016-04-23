defmodule WordLadder.Core do

  require WordLadder.Struct

  @name __MODULE__

  def main(start_word, end_word, file \\  "./resources/wordlist.txt") do
    start_agent
    {ok, map} = load_dic(file)
    # 
    Agent.update(@name,
      fn ds -> dict_update(ds, map) end)
    #
    _main(start_word, end_word)
  end

  def main_alt(dict, start_word, end_word) do
    start_agent_with dict
    _main(start_word, end_word)
  end
  
  #
  # internal map which holds the dictionnaray in memory
  #
  def load_dic(file \\ "./resources/wordlist.txt") do
    map = File.stream!(file, [:read, :utf8], :line)
    |> Enum.filter_map(&exclude_non_word/1, &String.strip/1)
    |> Enum.reduce(%{}, &add_to/2)
    {:ok, map}
    # TODO: rescue if exception (file not found or ...)
  end

  @doc """
  Generates a list of all valid candidates of word by changing only 1 letter
  at a time.
  A word is illegal if it is not defined in the in-memory map (ds)
  """
  def gen_candidates(word) do
    list  = String.graphemes(word)
    alpha = String.split("abcdefghijklmnopqrstuvwxyz", "") |> List.delete("")
    for ix <- 0..String.length(word) - 1 do
      alpha |> Enum.map(fn l -> List.replace_at(list, ix, l) |> Enum.join end)
    end |>
      Enum.flat_map(&(&1)) |>
      Enum.reject(fn w -> w == word end) |>
      Enum.reject(fn w -> !Map.has_key?(dict_get, w) end) |>
      Enum.sort |>
      Enum.uniq
  end
  
  def bfs(start_word, end_word) do
    ds = %WordLadder.Struct{
      queue: :queue.new(),
      visited: %{ start_word => true }
    }
    ds = WordLadder.Struct.enqueue(ds, start_word)
    process_q(ds, end_word) # return ds
    #
  end

  # == Private ==
  defp process_q(ds, end_word) do
    { word, ds } = WordLadder.Struct.dequeue(ds)
    #
    cond do
      word == end_word -> ds
      true ->
        ds = gen_candidates(word) |>
          process_w(word, ds)
        unless WordLadder.Struct.empty_queue?(ds) do
          process_q(ds, end_word)
        else
          ds
        end
    end
  end

  defp process_w([], _, ds), do: ds

  defp process_w([cword | cdr], word, ds) do
    if Map.has_key?(WordLadder.Struct.get_visited(ds), cword) do
      process_w(cdr, word, ds)
    else
      process_w(cdr, word, WordLadder.Struct.add_to_pred(ds, cword, word) |>
        WordLadder.Struct.enqueue(cword) |>
        WordLadder.Struct.add_to_visited(cword, true))
    end
  end

  defp get_path(word, pred), do: _get_path(word, pred, [])

  defp _get_path(nil, _, lr), do: lr

  defp _get_path(word, pred, lr) do
    _get_path(Map.get(pred, word), pred, [word | lr])
  end

  defp start_agent do
    Agent.start_link(&dict_init/0, name: @name)
  end

  defp start_agent_with(dict) do
    Agent.start_link(fn -> dict end, name: @name)
  end

  #
  # the data-struct hold by the agent, a map
  #
  defp dict_init, do: %{}

  defp dict_get, do: Agent.get(@name, &(&1))

  defp dict_update(_, map), do: map end

  #
  # word with length < 2 or > 5, will be ignored
  # word containing at least one quote are excluded
  #
  defp exclude_non_word(word) do
    String.length(word) < 2 || String.length(word) > 5 || !Regex.match?(~r/[\^']/i, word)
  end

  defp add_to(word, map) do
    Map.put(map, word, 1)
  end

  defp _main(start_word, end_word) do
    ds = bfs(start_word, end_word)
    if Map.has_key?(WordLadder.Struct.get_pred(ds), end_word) do
      {:ok, get_path(end_word, WordLadder.Struct.get_pred(ds))}
    else
      {:ko, nil}
    end
  end
  
end
