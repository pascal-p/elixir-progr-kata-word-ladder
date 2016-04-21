defmodule WordLadder.Struct do
  # 
  
  defstruct queue: :queue.new(), visited: %{}, pred: %{}

  def get_visited(ds = %WordLadder.Struct{}) do
    ds.visited
  end

  def get_pred(ds = %WordLadder.Struct{}) do
    ds.pred
  end

  def get_q(ds = %WordLadder.Struct{}) do
    ds.queue
  end

  def dequeue(ds = %WordLadder.Struct{}) do
    {q_item, nq} = :queue.out(WordLadder.Struct.get_q(ds))
    # update current queue
    %WordLadder.Struct{ds | queue: nq}
    # return, the dequeue item
    elem(q_item, 1)
  end

  def empty_queue?(ds = %WordLadder.Struct{}) do
    :queue.is_empty(WordLadder.Struct.get_q(ds))
  end

  def enqueue(ds = %WordLadder.Struct{}, item) do
    nq = :queue.in(item, WordLadder.Struct.get_q(ds))
    %WordLadder.Struct{ds | queue: nq}
  end

  def add_to_visited(ds = %WordLadder.Struct{}, k, v) do
    %WordLadder.Struct{ds |
                       visited: Map.put(WordLadder.Struct.get_visited(ds), k, v)}
  end

  def add_to_pred(ds = %WordLadder.Struct{}, k, v) do
    %WordLadder.Struct{ds |
                       pred: Map.put(WordLadder.Struct.get_visited(ds), k, v)}
  end

end
