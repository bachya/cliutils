require_relative 'spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs'
require 'cliutils/prefs/pref'

describe CLIUtils::Pref do
  let(:base_filepath) { File.join(File.dirname(__FILE__), '..', 'support') }
  let(:prefs_filepath) { File.join(base_filepath, 'prefstest.yaml') }

  let(:hash_data) {
    {
      prompts: [
        {
          prompt_text: 'What is your name?',
          default: 'Bob Cobb',
          config_key: :name,
          config_section: :personal_info
        },
        {
          prompt_text: 'What is your age?',
          default: '45',
          config_key: :age,
          config_section: :personal_info
        },
        {
          prompt_text: 'Batman or Superman?',
          default: 'Batman',
          config_key: :superhero,
          config_section: :personal_info
        }
      ]
    }
  }

  let(:array_data) {
    [
      {
        prompt_text: 'What is your name?',
        default: 'Bob Cobb',
        config_key: :name,
        config_section: :personal_info
      },
      {
        prompt_text: 'What is your age?',
        default: '45',
        config_key: :age,
        config_section: :personal_info,
        prereqs: {
          config_key: :name,
          config_value: 'Bob Cobb'
        }
      },
      {
        prompt_text: 'Batman or Superman?',
        default: 'Batman',
        config_key: :superhero,
        config_section: :personal_info
      }
    ]
  }

  it 'loads prefs from a YAML file' do
    prefs = CLIUtils::Prefs.new(prefs_filepath)
    expect(prefs.prompts.count).to eq(4)
    expect(prefs.prompts[2].prompt_text).to eq('Why do you prefer Superman?!')
    expect(prefs.prompts[2].config_key).to eq('superman_answer')
    expect(prefs.prompts[2].config_section).to eq('personal_info')
  end

  it 'raises an exception when attempting to load a nonexistant YAML file' do
    m = 'Invalid configuration file: bachya'
    expect { p = CLIUtils::Prefs.new('bachya') }.to raise_error(RuntimeError, m)
  end

  it 'loads prefs from a Hash' do
    prefs = CLIUtils::Prefs.new(hash_data)
    expect(prefs.prompts.count).to eq(3)
    expect(prefs.prompts[1].prompt_text).to eq('What is your age?')
    expect(prefs.prompts[1].config_key).to eq(:age)
    expect(prefs.prompts[1].config_section).to eq(:personal_info)
  end

  it 'loads prefs from an Array' do
    prefs = CLIUtils::Prefs.new(array_data)
    expect(prefs.prompts.count).to eq(3)
    expect(prefs.prompts[1].prompt_text).to eq('What is your age?')
    expect(prefs.prompts[1].config_key).to eq(:age)
    expect(prefs.prompts[1].config_section).to eq(:personal_info)
  end

  it 'raises an exception when given bad Prefs data' do
    m = 'Invalid configuration data'
    expect { p = CLIUtils::Prefs.new(:bachya) }.to raise_error(RuntimeError, m)
  end

  it 'delivers prompts for the user to answer' do
    Readline.stub(:readline).and_return('')
    prefs = CLIUtils::Prefs.new(prefs_filepath)
    prefs.ask

    expect(prefs.prompts[0].answer).to eq('Batman')
    expect(prefs.prompts[1].answer).to eq('Y')
    expect(prefs.prompts[2].answer).to eq(nil)
    expect(prefs.prompts[3].answer).to eq(nil)
  end

  it 'uses Configurator values as part of its prompts' do
    c = CLIUtils::Configurator.new('/tmp/file1.txt')
    c.add_section(:personal_info)
    c.personal_info['superhero'] = 'Superman'

    Readline.stub(:readline).and_return('')
    prefs = CLIUtils::Prefs.new(prefs_filepath, c)
    prefs.ask

    expect(prefs.prompts[0].answer).to eq('Batman')
    expect(prefs.prompts[1].answer).to eq('Y')
    expect(prefs.prompts[2].answer).to eq(nil)
    expect(prefs.prompts[3].answer).to eq(nil)
  end

  it 'pre-registers and de-registers Actions' do
    CLIUtils::Prefs.register_action(File.join(base_filepath, 'test_action.rb'))
    expect(CLIUtils::Prefs.registered_actions.count).to eq(1)

    CLIUtils::Prefs.deregister_action(:Test)
    expect(CLIUtils::Prefs.registered_actions.count).to eq(0)
  end

  it 'pre-registers and de-registers Behaviors' do
    CLIUtils::Prefs.register_behavior(File.join(base_filepath, 'test_behavior.rb'))
    expect(CLIUtils::Prefs.registered_behaviors.count).to eq(1)

    CLIUtils::Prefs.deregister_behavior(:Test)
    expect(CLIUtils::Prefs.registered_behaviors.count).to eq(0)
  end

  it 'pre-registers and de-registers Validators' do
    CLIUtils::Prefs.register_validator(File.join(base_filepath, 'test_validator.rb'))
    expect(CLIUtils::Prefs.registered_validators.count).to eq(1)

    CLIUtils::Prefs.deregister_validator(:Test)
    expect(CLIUtils::Prefs.registered_validators.count).to eq(0)
  end

  it 'raises an exception when registering a bad Action/Behavior/Validator' do
    m = 'Registration failed because of unknown filepath: bachya'
    expect { CLIUtils::Prefs.register_validator('bachya') }.to raise_error(RuntimeError, m)
  end
end
