defmodule WordLadder.Core do

  require WordLadder.Struct

  @name __MODULE__

  def main(start_word, end_word, file \\  "./resources/wordlist.txt") do
    load_dic(file)
    ds = bfs(start_word, end_word)
    if Map.has_key?(WordLadder.Struct.get_pred(ds), end_word) do
      list = get_path(end_word, WordLadder.Struct.get_pred(ds))
      {:ok, list}
    else
      {:ko}
    end
  end

  #
  # internal map which holds the dictionnaray in memory
  #
  def load_dic(file \\ "./resources/wordlist.txt") do
    start_agent
    my_map = File.stream!(file, [:read, :utf8], :line)
    |> Enum.filter_map(&exclude_non_word/1, &String.strip/1)
    |> Enum.reduce(%{}, &add_to/2)
    Agent.update(@name,
      fn ds ->
        dict_update(ds, my_map)
      end)
  end

  @doc """
  Generates a map of all valid candidates of word by changing only 1 letter
  at a time.
  A word is illegal if it is not defined in the in-memory map (ds)
  """
  def gen_candidates(word) do
    list = String.graphemes(word)
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
      visited: %{ start_word => 1 }
    }
    ds = WordLadder.Struct.enqueue(ds, start_word)
    # visited = %{ start_word => 1 }
    # pred = %{}
    # q = :queue.new(start_word)

    #ds = process_q(ds, end_word)
    process_q(ds, end_word) # return ds
    #   
  end

  # == Private ==
  defp process_q(ds, end_word) do
    word = WordLadder.Struct.dequeue(ds)
    cond do
      word == end_word -> ds
      true ->
        ds = gen_candidates(word) |>
          Map.keys |>
          Enum.each(fn word -> process_w(word, ds) end)
        unless WordLadder.Struct.empty_queue?(ds) do
          process_q(ds, end_word)
        end
    end
  end

  defp process_w(word, ds) do
    unless Map.has_key?(WordLadder.Struct.get_visited(ds, word)) do
      ds = WordLadder.Struct.add_to_pred(ds, word, 1) |>
        WordLadder.Struct.enqueue(word) |>
        WordLadder.Struct.add_to_visitor(word, true)
    end
    ds
  end

  defp get_path(word, pred), do: _get_path(word, pred, [])

  def _get_path(nil, _, lr), do: lr

  def _get_path(word, pred, lr) do
    if Map.has_key?(pred, word) do
      _get_path(Map.get(pred, word), pred, [word | lr])
    end
  end


  # defp process_w_OLD(word, q, visited, pred) do
  #   unless Map.has_key?(visited, word) do
  #     Map.put(pred, word, 1) # add {word: 1} to pred map
  #     q = :queue(q, word)
  #     Map.put(visited, word, true)
  #   end
  #   {q, visited, pred}
  # end

  defp start_agent do
    Agent.start_link(&dict_init/0, name: @name)
  end

  #
  # the data-struct hold by the agent, a map
  #
  defp dict_init, do: %{}

  defp dict_get, do: Agent.get(@name, &(&1))

  defp dict_update(ds, word) do
    Map.put(ds, word, 1)
  end

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

end
