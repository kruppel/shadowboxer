# frozen_string_literal: true

require 'rubocop'
require 'rubocop/rspec/support'
require_relative '../../.rubocop/cop/layout/empty_lines_around_control_flow'

RSpec.describe RuboCop::Cop::Layout::EmptyLinesAroundControlFlow, :config do
  it 'accepts a blank line before and after a standalone if' do
    expect_no_offenses(<<~RUBY)
      prepare

      if condition
        work
      end

      finish
    RUBY
  end

  it 'flags missing blank lines before and after standalone control flow' do
    expect_offense(<<~RUBY)
      prepare
      if condition
      ^^^^^^^^^^^^ Add an empty line around this control-flow block.
        work
      end
      finish
      ^^^^^^ Add an empty line around this control-flow block.
    RUBY
  end

  it 'checks each supported block form' do
    [
      "if condition\n  work\nend",
      "unless condition\n  work\nend",
      "case condition\nwhen :value\n  work\nend",
      "while condition\n  work\nend",
      "until condition\n  work\nend"
    ].each do |control_flow|
      source = "prepare\n#{control_flow}\nfinish\n"
      expect(inspect_source(source).size).to eq(2)
    end

    source = <<~RUBY
      prepare
      for item in items
        work(item)
      end
      finish
    RUBY
    expect(inspect_source(source).size).to eq(2)
  end

  it 'checks one-line block forms but ignores semicolon-separated statements' do
    expect(inspect_source("prepare\nif condition then work end\nfinish\n").size).to eq(2)
    expect_no_offenses('prepare; if condition then work end; finish')
  end

  it 'does not separate consecutive modifier guard clauses' do
    expect_no_offenses(<<~RUBY)
      return true if a.nil?
      return true if b.nil?
    RUBY
  end

  it 'allows control flow at the beginning or end of a body' do
    expect_no_offenses(<<~RUBY)
      if condition
        work
      end
    RUBY

    expect_no_offenses(<<~RUBY)
      if condition
        work
      end

      finish
    RUBY

    expect_no_offenses(<<~RUBY)
      prepare

      if condition
        work
      end
    RUBY
  end

  it 'checks nested statement sequences without crossing block boundaries' do
    source = <<~RUBY
      items.each do |item|
        prepare
        if item.valid?
          work(item)
        end
        finish
      end
    RUBY
    expect(inspect_source(source).size).to eq(2)
  end

  it 'accepts existing blank lines and does not add duplicate offenses' do
    expect_no_offenses(<<~RUBY)
      prepare


      if condition
        work
      end


      finish
    RUBY
  end
end
