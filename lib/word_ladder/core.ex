defmodule WordLadder.Core do

  alias WordLadder.Dict
  alias WordLadder.DS

  @alpha String.split("abcdefghijklmnopqrstuvwxyz", "") |> List.delete("")

  def main(start_word, end_word, file \\  "./resources/wordlist.txt") do
    Dict.load(file)
    _main(start_word, end_word)
  end

  def main_alt(dict, start_word, end_word) do
    Dict.start_agent_with dict
    _main(start_word, end_word)
  end

  # == Private ==
  defp _main(start_word, end_word) do
    {res, pred} = bfs(start_word, end_word)
    if res == :ok do
      {:ok, get_path(end_word, pred)}
    else
      {:ko, nil}
    end
  end

  #
  # Generates a list of all valid candidates of word by changing only 1 letter
  # at a time.
  # A word is illegal if it is not defined in the in-memory map (ds)
  #
  defp gen_candidates(word) do
    list = String.graphemes(word)
    for ix <- 0..String.length(word) - 1 do
      @alpha |> Enum.map(fn l -> List.replace_at(list, ix, l) |> Enum.join end)
    end |>
      Enum.flat_map(&(&1)) |>
      Enum.reject(fn w -> w == word end) |>
      Enum.filter(fn w -> Dict.has_key?(w) end) |>
      Enum.sort |>
      Enum.uniq
  end

  defp bfs(start_word, end_word) do
    ds = %DS{ queue: :queue.new(),
              visited: %{start_word => true}, pred: %{start_word => nil} }
    DS.enqueue(ds, start_word) |>
      process(end_word) # return ds
  end

  #
  # if the word to process is the end_word, work is done
  # otherwise, generate all the candidates for word and process
  # them
  #
  defp process(ds, end_word) do
    { word, ds } = DS.dequeue(ds)
    cond do
      word == end_word -> {:ok, DS.get_pred(ds)}
      true ->
        ds = gen_candidates(word) |> process_w(word, ds) # side-effect on ds
        if DS.empty_queue?(ds) do
          {:ko, nil}
        else
          process(ds, end_word) # rec. call but TCO applied, with new (updated) ds
        end
    end
  end

  #
  # Processing all the candidates for word
  #
  defp process_w([], _, ds), do: ds

  defp process_w([cword | cdr], word, ds) do
    unless DS.already_visited?(ds, cword) do
      ds = DS.update(ds, cword, word) # side-effect on ds
      # \__ update pred of cword, enqueue cword (for later proc.) and mark cword has visited
    end
    process_w(cdr, word, ds) # rec. call but TCO applied
  end

  defp get_path(word, pred), do: _get_path(word, pred, [])

  defp _get_path(nil, _, lr), do: lr

  defp _get_path(word, pred, lr) do
    _get_path(pred[word], pred, [word | lr])
  end

end
