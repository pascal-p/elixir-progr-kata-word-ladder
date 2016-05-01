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
   # could be: ["cat", "cot", "dot", "dog"]
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

  expect "head -> tail", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "head", "tail")
    assert list == ["head", "heal", "heil", "hail", "tail"]
    # ["head", "tead", "teal", "taal", "tail"]
  end

  expect "milk -> wine", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "milk", "wine")
    assert list == ["milk", "mile", "mine", "wine"]
    # could be: ["milk", "mink", "wink", "wine"]
  end

  expect "cold -> warm", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "cold", "warm")
    assert list == ["cold", "cord", "card", "ward", "warm"]
    # could be: ["cold", "wold", "wald", "ward", "warm"]
  end

  expect "sleep -> dream", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "sleep", "dream")
    assert list == ["sleep", "bleep", "bleed", "breed", "bread", "bream", "dream"]
    # could be: ["sleep", "bleep", "bleed", "breed", "dreed", "dread", "dream"]
  end

  expect "door -> lock", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "door", "lock")
    assert list == ["door", "dook", "dock", "lock"]
    # could be: ["door", "loor", "look", "lock"]
  end

  expect "word -> gene", context do
    {:ok, list} = WordLadder.Core.main_alt(context[:dict], "word", "gene")
    assert list == ["word", "wore", "gore", "gere", "gene"]
  end

end

# >	mix test --trace
# Compiled lib/word_ladder/ds.ex
# Compiled lib/word_ladder/core.ex
#
# WordLadderTest
#   * expect cold -> warm (883154.7ms)
#   * expect sleep -> dream (327923.6ms)
#   * expect milk -> wine (108603.9ms)
#   * expect door -> lock (71773.7ms)
#   * expect head -> tail (322417.6ms)
#   * expect cat -> dog - found a path (230474.7ms)
#   * expect cat -> dyg - NOT found (389954.5ms)
#   * expect man -> god (146009.4ms)
#   * expect word -> gene (737136.3ms)
#
#
# Finished in 3219.9 seconds (0.09s on load, 3219.9s on tests)
# 9 tests, 0 failures
#
# Randomized with seed 878335
#
