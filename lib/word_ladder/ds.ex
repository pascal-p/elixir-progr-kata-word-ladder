defmodule WordLadder.DS do
  #
  defstruct queue: :queue.new(), visited: %{}, pred: %{}

  def get_visited(ds), do: ds.visited

  def already_visited?(ds, k), do: ds.visited[k]

  def get_pred(ds), do: ds.pred

  def get_q(ds), do: ds.queue

  def dequeue(ds) do
    {q_item, nq} = :queue.out(ds.queue)
    {elem(q_item, 1), %WordLadder.DS{ds | queue: nq}}  # return tuple
  end

  def enqueue(ds, item) do
    nq = :queue.in(item, ds.queue) #
    %WordLadder.DS{ds | queue: nq}
  end

  def empty_queue?(ds), do: :queue.is_empty(WordLadder.DS.get_q(ds))

  def add_to_visited(ds, k, v \\ true) do
    %WordLadder.DS{ds |
                   visited: Map.put(ds.visited, k, v)}
  end

  #
  # predecessor of k is v
  #
  def add_to_pred(ds, k, v) do
    %WordLadder.DS{ds |
                   pred: Map.put(ds.pred, k, v)}
  end

  #
  # for convenience
  #
  def update(ds, cword, pword) do
    %WordLadder.DS{ds |
                   pred: Map.put(ds.pred, cword, pword),
                   queue: :queue.in(cword, ds.queue),
                   visited: Map.put(ds.visited, cword, true)}
  end

end
