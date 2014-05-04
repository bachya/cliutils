require_relative '../spec_helper'
require 'cliutils/ext/hash_extensions'

describe Hash do
  it 'allows for deep merging' do
    h1 = { key: 'value', key2: %w(value1, value2) }
    h2 = { key: 'another_value', key3: { subkey1: 'value' } }
    exp_result = { key: 'another_value', key2: ['value1,', 'value2'], key3: { subkey1: 'value' } }
    actual_result = h1.deep_merge!(h2)

    expect(actual_result).to eq(exp_result)
  end

  it 'allows for a new hash to be created with stringified keys' do
    h = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'value' } } }
    exp_result = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value' } } }
    actual_result = h.deep_stringify_keys

    expect(actual_result).to_not eq(h)
    expect(actual_result).to eq(exp_result)
  end

  it 'allows for inline key stringification' do
    h = {key: {subkey1: 'value1', subkey2: {subsubkey1: 'value'}}}
    exp_result = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => 'value' } } }
    actual_result = h.deep_stringify_keys!

    expect(actual_result).to eq(h)
    expect(actual_result).to eq(exp_result)
  end

  it 'allows for a new hash to be created with symbolized keys' do
    h = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => ['value1', 'value2']} } }
    exp_result = { key: { subkey1: 'value1', subkey2: { subsubkey1: ['value1', 'value2']} } }
    actual_result = h.deep_symbolize_keys

    expect(actual_result).to_not eq(h)
    expect(actual_result).to eq(exp_result)
  end

  it 'allows for inline key symbolization' do
    h = { 'key' => { 'subkey1' => 'value1', 'subkey2' => { 'subsubkey1' => ['value1', 'value2']} } }
    exp_result = { key: { subkey1: 'value1', subkey2: { subsubkey1: ['value1', 'value2']} } }
    actual_result = h.deep_symbolize_keys!

    expect(actual_result).to eq(h)
    expect(actual_result).to eq(exp_result)
  end

  it 'can find a nested value by key' do
    h = { key: { subkey1: 'value1', subkey2: { subsubkey1: 'subvalue1'} } }
    h.recursive_find_by_key(:subsubkey1).should == 'subvalue1'
  end
end