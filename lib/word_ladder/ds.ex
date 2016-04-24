defmodule WordLadder.DS do
  #
  defstruct queue: :queue.new(), visited: %{}, pred: %{}

  def get_visited(ds = %WordLadder.DS{}), do: ds.visited

  def already_visited?(ds = %WordLadder.DS{}, k), do: ds.visited[k]

  def get_pred(ds = %WordLadder.DS{}), do: ds.pred

  def get_q(ds = %WordLadder.DS{}), do: ds.queue

  def dequeue(ds = %WordLadder.DS{}) do
    {q_item, nq} = :queue.out(WordLadder.DS.get_q(ds))
    {elem(q_item, 1), %WordLadder.DS{ds | queue: nq}}  # return tuple
  end

  def enqueue(ds = %WordLadder.DS{}, item) do
    nq = :queue.in(item, WordLadder.DS.get_q(ds)) #
    %WordLadder.DS{ds | queue: nq}
  end

  def empty_queue?(ds = %WordLadder.DS{}), do: :queue.is_empty(WordLadder.DS.get_q(ds))

  def add_to_visited(ds = %WordLadder.DS{}, k, v \\ true) do
    %WordLadder.DS{ds |
                       visited: Map.put(WordLadder.DS.get_visited(ds), k, v)}
  end

  #
  # predecessor of k is v
  #
  def add_to_pred(ds = %WordLadder.DS{}, k, v) do
    %WordLadder.DS{ds |
                   pred: Map.put(WordLadder.DS.get_pred(ds), k, v)}
  end

  #
  # for convenience
  #
  def update(ds = %WordLadder.DS{}, cword, pword) do
    %WordLadder.DS{ds |
                   pred: Map.put(WordLadder.DS.get_pred(ds), cword, pword),
                   queue: :queue.in(cword, WordLadder.DS.get_q(ds)),
                   visited: Map.put(WordLadder.DS.get_visited(ds), cword, true)}
  end
end
