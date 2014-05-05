require_relative 'spec_helper'
require 'cliutils/ext/hash_extensions'
require 'cliutils/prefs/pref'
require 'cliutils/prefs/pref_actions/pref_action'
require 'cliutils/prefs/pref_behaviors/pref_behavior'
require 'cliutils/prefs/pref_validators/pref_validator'
require File.join(File.dirname(__FILE__), '..', 'support/test_action.rb')
require File.join(File.dirname(__FILE__), '..', 'support/test_behavior.rb')
require File.join(File.dirname(__FILE__), '..', 'support/test_validator.rb')
require 'yaml'

describe CLIUtils::Pref do
  let(:base_path) { File.join(File.dirname(__FILE__), '..', 'support') }
  let(:pref_data) {
    {
      behaviors: [{ name: "#{ File.join(base_path, 'test_behavior.rb') }" }],
      config_key: 'test_prompt',
      config_section: 'app_data',
      default: 'bachya',
      options: ['bachya'],
      pre: {
        message: 'Test pre message',
        action: {
          name: "#{ File.join(base_path, 'test_action.rb') }",
          parameters: {
            param1: 'value1'
          }
        }
      },
      post: {
        message: 'Test post message',
        action: {
          name: "#{ File.join(base_path, 'test_action.rb') }"
        }
      },
      prereqs: [
        { config_section: 'section' },
        { config_value: 'value' }
      ],
      prompt_text: 'Test',
      validators: ["#{ File.join(base_path, 'test_validator.rb') }"],
    }
  }

  let(:pref_data2) {
    {
      behaviors: [{ name: 'test' }],
      config_key: 'test_prompt',
      config_section: 'app_data',
      default: 'bachya',
      options: ['bachya'],
      pre: {
        message: 'Test pre message',
        action: {
          name: 'test',
          parameters: {
            param1: 'value1'
          }
        }
      },
      post: {
        message: 'Test post message',
        action: {
          name: 'test'
        }
      },
      prereqs: [
        { config_section: 'section' },
        { config_value: 'value' }
      ],
      prompt_text: 'Test',
      validators: ['test'],
    }
  }

  let(:pref_data3) {
    {
      behaviors: [{ name: 'capitalize' }],
      config_key: 'test_prompt',
      config_section: 'app_data',
      prompt_text: 'Test',
      validators: ['non_nil'],
    }
  }

  let(:pref_data4) {
    {
      config_key: 'test_prompt',
      config_section: 'app_data',
      prompt_text: 'Test',
      validators: ['non_nilz'],
    }
  }

  it 'instantiates via a hash' do
    pref = CLIUtils::Pref.new(pref_data)
    expect(pref.answer).to eq(nil)
    expect(pref.behavior_objects[0].class).to eq(CLIUtils::TestBehavior)
    expect(pref.behaviors).to eq([{ name: "#{ File.join(base_path, 'test_behavior.rb') }" }])
    expect(pref.config_key).to eq(pref_data[:config_key])
    expect(pref.config_section).to eq(pref_data[:config_section])
    expect(pref.default).to eq(pref_data[:default])
    expect(pref.last_error_message).to eq(nil)
    expect(pref.options).to eq(['bachya'])
    expect(pref.post).to eq({message: 'Test post message', action: { name: File.join(base_path, 'test_action.rb') } })
    expect(pref.pre).to eq({message: 'Test pre message', action: { name: File.join(base_path, 'test_action.rb'), parameters: { param1: 'value1'} } })
    expect(pref.prereqs).to eq([{ config_section: 'section' }, { config_value: 'value' }])
    expect(pref.validator_objects[0].class).to eq(CLIUtils::TestValidator)
    expect(pref.validators).to eq([File.join(base_path, 'test_validator.rb')])
  end

  it 'runs pre-registered assets' do
    Readline.stub(:readline).and_return('', 'bachya', '')
    CLIUtils::Prefs.register_action(File.join(base_path, 'test_action.rb'))
    CLIUtils::Prefs.register_behavior(File.join(base_path, 'test_behavior.rb'))
    CLIUtils::Prefs.register_validator(File.join(base_path, 'test_validator.rb'))

    p = CLIUtils::Pref.new(pref_data2)
    out = capture_stdout { p.deliver }
    expect(out).to eq("\e[34m# Test pre message\e[0m\nhere\n\e[34m# Test post message\e[0m\nhere\n")
  end

  it 'runs built-in assets' do
    Readline.stub(:readline).and_return('', 'bachya')
    p = CLIUtils::Pref.new(pref_data3)
    out = capture_stdout { p.deliver }
    expect(out).to eq("\e[31m# Nil text not allowed\e[0m\n")
  end

  it 'returns an error when a validator fails' do
    Readline.stub(:readline).and_return('', 'bachyazzz', 'bachya', '')
    p = CLIUtils::Pref.new(pref_data)
    out = capture_stdout { p.deliver }

    m = "\e[34m# Test pre message\e[0m\nhere\n\e[31m# Invalid option chosen " \
    "(\"bachyazzz\"); valid options are: [\"bachya\"]\e[0m\n\e[34m# Test post " \
    "message\e[0m\nhere\n"
    expect(out).to eq(m)
  end

  it 'raises an exception when given an unknown asset' do
    m = "\e[33m# Skipping undefined Pref Validator: non_nilz\e[0m\n"
    out = capture_stdout { p = CLIUtils::Pref.new(pref_data4) }
    expect(out).to eq("\e[33m# Skipping undefined Pref Validator: non_nilz\e[0m\n")
  end

  it 'compares equality to other Pref instances' do
    p1 = CLIUtils::Pref.new(pref_data)
    p2 = CLIUtils::Pref.new(pref_data)
    expect(p1).to eq(p2)
  end
end
