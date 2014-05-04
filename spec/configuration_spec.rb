require_relative 'spec_helper'
require 'cliutils/messaging'
require 'cliutils/configuration'
require 'cliutils/configurator'

describe CLIUtils::Configuration do
  include CLIUtils::Configuration

  it 'raises an exception if not loaded properly' do
    m = 'Attempted to access `configuration` before executing `load_configuration`'
    expect { configuration }.to raise_error(RuntimeError, m)
  end

  let(:config_path_new) { File.expand_path('support/configuration2.yaml') }
  it 'initializies configuration from scratch' do
    load_configuration(config_path_new)
    expect(configuration.class).to eq(CLIUtils::Configurator)
    expect(configuration.config_path).to eq(config_path_new)
    expect(configuration.data).to eq({})
  end

  let(:config_path_existing) { File.expand_path('support/configuration.yaml') }
  let(:existing_data) { { my_app: {
                            config_location: '/Users/bob/.my-app-config',
                            log_level: 'WARN',
                            version: '1.0.0' },
                          user_data: {
                            username: 'bob',
                            age: 45 } } }

  it 'works with existing configuration data' do
    load_configuration(config_path_existing)
    expect(configuration.class).to eq(CLIUtils::Configurator)
    expect(configuration.config_path).to eq(config_path_existing)
    expect(configuration.data).to eq(existing_data)
  end
end