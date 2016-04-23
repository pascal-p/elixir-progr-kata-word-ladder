defmodule WordLadderTest do
  use ExUnit.Case
  doctest WordLadder.Core

  import Expect

  @moduletag timeout: 300000 # ms
  
  setup_all do
    # load dict once
    {:ok, dict } = WordLadder.Core.load_dic("./resources/wordlist.txt")

    {:ok, dict: dict}
  end

  expect "cat -> dog - found a path", context  do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "cat", "dog")
    assert list == ["cat", "cot", "dot", "dog"]
  end

  expect "cat -> dag - NOT found", context  do
    {:ko, list} = WordLadder.Core.main_alt(context[:dict], "cat", "dag")
    assert list == nil
  end

  expect "man -> god", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "man", "god")
    assert list == ["man", "gan", "gad", "god"]
  end

  expect "head -> tail", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "head", "tail")
    assert list == ["head", "tead", "teal", "taal", "tail"]
  end

  expect "milk -> wine", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "milk", "wine")
    assert list == ["milk", "mink", "wink", "wine"]
  end

  expect "cold -> warm", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "cold", "warm")
    assert list == ["cold", "wold", "wald", "ward", "warm"]
  end
  
  expect "sleep -> dream", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "sleep", "dream")
    assert list == ["sleep", "bleep", "bleed", "breed", "dreed", "dread", "dream"]
  end
  
  expect "door -> lock", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "door", "lock")
    assert list == ["door", "loor", "look", "lock"]
  end
  
  expect "word -> gene", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "word", "gene")
    assert list == ["word", "wore", "gore", "gere", "gene"]
  end
  
end
