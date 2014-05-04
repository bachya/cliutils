require_relative 'spec_helper'
require 'cliutils/messaging'
require 'cliutils/configurator'
require 'cliutils/ext/hash_extensions'
require 'cliutils/prefs'
require 'yaml'

describe CLIUtils::Configuration do
  include CLIUtils::Configuration

  let(:config_path) { File.expand_path('support/configuration.yaml') }
  let(:prefs_path) { File.expand_path('support/prefstest.yaml') }
  let(:config) { CLIUtils::Configurator.new(config_path)}
  let(:existing_data) { { my_app: {
                            config_location: '/Users/bob/.my-app-config',
                            log_level: 'WARN',
                            version: '1.0.0' },
                          user_data: {
                            username: 'bob',
                            age: 45 } } }

  it 'adds a section to the config data' do
    config.add_section(:test)
    expect(config.data).to eq(existing_data.merge!(test: {}))
  end

  it 'raises an exception when trying to add an already-existing section' do
    config.add_section(:test)
    m = 'Section already exists: test'
    expect { config.add_section(:test) }.to raise_error(RuntimeError, m)
  end

  it 'backs up the configuration file' do
    backup_path = config.backup
    expect(backup_path).to eq("#{ config_path }-#{ Time.now.to_i }")
    FileUtils.rm(backup_path)
  end

  it 'deletes a section from the config data' do
    config.add_section(:test)
    config.add_section(:test2)
    config.delete_section(:test)
    expect(config.data).to eq(existing_data.merge!(test2: {}))
  end

  it 'raises an exception when trying to delete a nonexistent section' do
    m = 'Cannot delete nonexistent section: test'
    expect { config.delete_section(:test) }.to raise_error(RuntimeError, m)
  end

  it 'allows data retrieval via a hash or magic methods' do
    config.add_section(:test)
    config.data[:test].merge!(name: 'Bob')
    expect(config.data[:test][:name]).to eq('Bob')
    expect(config.test[:name]).to eq('Bob')
  end

  it 'resets the entire data collection' do
    config.add_section(:test)
    config.data[:test].merge!(name: 'Bob')
    config.reset
    expect(config.data).to eq({})
  end

  it 'saves its data to a file' do
    config.add_section(:section1)
    config.section1.merge!(a: 'test', b: 'test')
    config.save

    saved_data = YAML.load_file(config.config_path).deep_symbolize_keys
    expect(saved_data).to eq(config.data)

    config.delete_section(:section1)
    config.save
  end

  it 'compares versions' do
    config.add_section(:app_data)
    config.app_data.merge!(VERSION: '1.0.0')
    config.current_version = config.app_data[:VERSION]
    config.last_version = '1.0.8'
    config.compare_version do |c, l|
      expect(c).to be < l
    end
  end

  it 'successfully ingests Prefs into its data' do
    config.ingest_prefs(CLIUtils::Prefs.new(prefs_path))
    h = {
      personal_info: {
        superhero: nil,
        batman_answer: nil,
        superman_answer: nil,
        no_clue: nil
      }
    }
    expect(existing_data.merge!(h)).to eq(config.data)
  end

  it 'raises an exception when attempting to ingest invalid Prefs' do
    m = 'Invaid Prefs class'
    expect { config.ingest_prefs(123) }.to raise_error(RuntimeError, m)
  end
end
