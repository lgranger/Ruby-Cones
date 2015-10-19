#!/usr/bin/env ruby
# -*- ruby -*-

require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutAsserts < Neo::Koan

  # We'll get this trip started by checking that the engine is good to go, via asserts.
  def test_assert_truth
    #--
    assert true                 # This should be true
    if false
    #++
    assert false                # This should be true
    #--
    end
    #++
  end

  # Gettin' where you're going is easier
  # with good road signs.
  def test_assert_with_message
    #--
    assert true, "This should be true -- Please fix this"
    if false
    #++
    assert false, "This should be true -- Please fix this"
    #--
    end
    #++
  end

  # To see if the car is working, we need to compare
  # how we think the car should work, with how it really does work:
  def test_assert_equality
    expected_value = __(2)
    actual_value = 1 + 1

    assert expected_value == actual_value
  end

  # Some ways of asserting equality are better than others.
  def test_a_better_way_of_asserting_equality
    expected_value = __(2)
    actual_value = 1 + 1

    assert_equal expected_value, actual_value
  end

  # Sometimes we will ask you to fill in the values
  def test_fill_in_values
    assert_equal __(2), 1 + 1
  end
end
