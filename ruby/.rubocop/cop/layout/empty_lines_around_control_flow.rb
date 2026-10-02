# frozen_string_literal: true

module RuboCop
  module Cop
    module Layout
      class EmptyLinesAroundControlFlow < Base
        extend AutoCorrector

        MSG = 'Add an empty line around this control-flow block.'
        CONTROL_FLOW_TYPES = %i[case for if unless until while].freeze

        def on_begin(node)
          check_statement_sequence(node)
        end

        def on_kwbegin(node)
          check_statement_sequence(node)
        end

        private

        def check_statement_sequence(sequence)
          statements = sequence.children
          statements.each_cons(2) do |previous, current|
            next unless control_flow_block?(previous) || control_flow_block?(current)
            next if blank_line_between?(previous, current)

            add_offense(current, message: MSG) do |corrector|
              expression = current.loc.expression
              line_start = expression.source_buffer.line_range(expression.line).resize(0)
              newline = expression.source_buffer.source.include?("\r\n") ? "\r\n" : "\n"

              corrector.insert_before(line_start, newline)
            end
          end
        end

        def control_flow_block?(node)
          CONTROL_FLOW_TYPES.include?(node.type) &&
            !(node.if_type? && (node.modifier_form? || node.ternary?)) &&
            standalone_statement?(node)
        end

        def standalone_statement?(node)
          expression = node.loc.expression
          buffer = expression.source_buffer
          line = buffer.line_range(expression.line)
          source = buffer.source

          source[line.begin_pos...expression.begin_pos].strip.empty? &&
            source[expression.end_pos...line.end_pos].strip.empty?
        end

        def blank_line_between?(previous, current)
          lines = processed_source.lines
          lines[(previous.loc.expression.last_line)...(current.loc.expression.first_line - 1)]
            .any? { |line| line.strip.empty? }
        end
      end
    end
  end
end
