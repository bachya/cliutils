require_relative '../spec_helper'
require 'cliutils/messaging'
require 'cliutils/prefs/pref_validators/pref_validator'
require 'cliutils/prefs/pref_validators/filepath_exists_validator'

describe CLIUtils::FilepathExistsValidator do
  it 'confirms that its input is an existing filepath' do
    v = CLIUtils::FilepathExistsValidator.new
    v.validate('/tmp')
    expect(v.is_valid).to be_true
    expect(v.message).to eq('Path does not exist locally: /tmp')
  end

  it 'confirms that its input is not an existing filepath' do
    v = CLIUtils::FilepathExistsValidator.new
    v.validate('!@&^')
    expect(v.is_valid).to_not be_true
    expect(v.message).to eq('Path does not exist locally: !@&^')
  end
end