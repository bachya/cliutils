require 'test_helper'

require File.join(File.dirname(__FILE__), '..', 'lib/cliutils/ext/hash_extensions')

class TestHashExtensions < Test::Unit::TestCase
  def test_deep_merge
    h1 = { key: 'value', key2: %w(value1, value2) }
    h2 = { key: 'another_value', key3: { subkey1: 'value' } }
    exp_result = { key: 'another_value', key2: ['value1,', 'value2'], key3: { subkey1: 'value' } }
    actual_result = h1.deep_merge!(h2)

    assert_equal(exp_result, actual_result)
  end

  def test_deep_stringify_keys
    h = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'value' } } }
    exp_result = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value' } } }
    actual_result = h.deep_stringify_keys

    assert_not_equal(h, actual_result)
    assert_equal(exp_result, actual_result)
  end

  def test_deep_stringify_keys!
    h = {key: {subkey1: 'value1', subkey2: {subsubkey1: 'value'}}}
    exp_result = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value' } } }
    actual_result = h.deep_stringify_keys!

    assert_equal(h, actual_result)
    assert_equal(exp_result, actual_result)
  end

  def test_deep_symbolize_keys
    h = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value'} } }
    exp_result = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'value'} } }
    actual_result = h.deep_symbolize_keys

    assert_not_equal(h, actual_result)
    assert_equal(exp_result, actual_result)
  end

  def test_deep_symbolize_keys!
    h = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value'} } }
    exp_result = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'value'} } }
    actual_result = h.deep_symbolize_keys!

    assert_equal(h, actual_result)
    assert_equal(exp_result, actual_result)
  end

  def test_recursive_find_by_key
    h = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'subvalue1'} } }
    assert_equal(h.recursive_find_by_key(:subsubkey1), 'subvalue1')
  end
end
