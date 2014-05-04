require_relative '../spec_helper'
require 'cliutils/ext/logger_extensions'

describe Logger do
  it 'allows custom levels to be attached' do
    l = Logger.new(STDOUT)
    l.formatter = proc do |severity, datetime, progname, msg|
      puts "#{ severity }: #{ msg }"
    end

    out = capture_stdout { l.prompt('test') }
    expect(out).to eq("PROMPT: test\n")

    out = capture_stdout { l.section('test') }
    expect(out).to eq("SECTION: test\n")

    out = capture_stdout { l.success('test') }
    expect(out).to eq("SUCCESS: test\n")
  end
end