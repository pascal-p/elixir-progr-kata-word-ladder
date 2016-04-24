defmodule WordLadderTest do
  use ExUnit.Case
  doctest WordLadder.Core

  import Expect

  # 1) test expect sleep -> dream (WordLadderTest)
  #    test/word_ladder_test.exs:46
  #    ** (ExUnit.TimeoutError) test timed out after 300000ms. You can change the timeout:
  #
  #      1. per test by setting "@tag timeout: x"
  #      2. per case by setting "@moduletag timeout: x"
  #      3. globally via "ExUnit.start(timeout: x)" configuration
  #      4. or set it to infinity per run by calling "mix test --trace"
  #         (useful when using IEx.pry)
  #
  #    Timeouts are given as integers in milliseconds.


  setup_all do
    # load dict once
    {:ok, dict } = WordLadder.Dict.load("./resources/wordlist.txt")

    {:ok, dict: dict}
  end

  expect "cat -> dog - found a path", context  do
   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "cat", "dog")
   assert list == ["cat", "cot", "cog", "dog"]
   # ["cat", "cot", "dot", "dog"]
   # =>  expect cat -> dog - found a path (261468.7ms) /OK
  end

  expect "cat -> dyg - NOT found", context  do
    {:ko, list} = WordLadder.Core.main_alt(context[:dict], "cat", "dyg")
    assert list == nil
    # * expect cat -> dyg - NOT found (448196.9ms)
  end

  expect "man -> god", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "man", "god")
    assert list == ["man", "gan", "gad", "god"]
    #   * expect man -> god (164125.9ms)
  end

  # expect "head -> tail", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "head", "tail")
  #   assert list == ["head", "tead", "teal", "taal", "tail"]
  # end

  # expect "milk -> wine", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "milk", "wine")
  #   assert list == ["milk", "mink", "wink", "wine"]
  # end

  # expect "cold -> warm", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "cold", "warm")
  #   assert list == ["cold", "wold", "wald", "ward", "warm"]
  # end

  # expect "sleep -> dream", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "sleep", "dream")
  #   assert list == ["sleep", "bleep", "bleed", "breed", "dreed", "dread", "dream"]
  # end

  # expect "door -> lock", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "door", "lock")
  #   assert list == ["door", "loor", "look", "lock"]
  # end

  # expect "word -> gene", context do
  #   {:ok, list} = WordLadder.Core.main_alt(context[:dict], "word", "gene")
  #   assert list == ["word", "wore", "gore", "gere", "gene"]
  # end

end
