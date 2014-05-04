require_relative '../spec_helper'
require 'cliutils/ext/string_extensions'

describe String do
  it 'outputs strings with preset custom colors' do
    expect('blue string'.blue).to eq("\e[34mblue string\e[0m")
    expect('cyan string'.cyan).to eq("\e[36mcyan string\e[0m")
    expect('green string'.green).to eq("\e[32mgreen string\e[0m")
    expect('purple string'.purple).to eq("\e[35mpurple string\e[0m")
    expect('red string'.red).to eq("\e[31mred string\e[0m")
    expect('white string'.white).to eq("\e[37mwhite string\e[0m")
    expect('yellow string'.yellow).to eq("\e[33myellow string\e[0m")
  end

  it 'outputs strings with configurable custom colors' do
    expect('crazy string'.colorize('34,42')).to eq("\e[34,42mcrazy string\e[0m")
  end

  it 'camel-cases strings' do
    expect('my_long_snake_name'.camelize).to eq('MyLongSnakeName')
  end

  it 'snake-cases strings' do
    expect('MyLongCamelName'.snakify).to eq('my_long_camel_name')
  end
end