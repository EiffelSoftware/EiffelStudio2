﻿note
	description: "Visitor for BYTE_NODE objects which count breakpoint slots in assertions."

class
	ASSERTION_BREAKABLE_SLOT_STRATEGY

inherit
	BYTE_NODE_ITERATOR
		redefine
			process_assign_b,
			process_assert_b,
			process_inv_assert_b,
			process_require_b,
			process_variant_b,
			process_elsif_b,
			process_elsif_expression_b,
			process_if_b,
			process_if_expression_b,
			process_inspect_b,
			process_instr_call_b,
			process_loop_b,
			process_loop_expr_b,
			process_retry_b,
			process_reverse_b,
			process_check_b,
			process_invariant_b,
			process_guard_b
		end

	SHARED_BYTE_CONTEXT

feature -- Status report

	update_breakpoint_slot (a_node: BYTE_NODE; ctx: BYTE_CONTEXT)
		require
			final_mode: ctx.final_mode
			assertion_not_kept: not ctx.system.keep_assertions
			exception_stack_managed: ctx.system.exception_stack_managed
		do
			counter := 0
			a_node.process (Current)
			context.set_breakpoint_slot (context.breakpoint_slots_number + counter)
		end

feature {NONE} -- Implementation: access

	counter: INTEGER

	increment_counter (a_node: BYTE_NODE)
		do
			counter := counter + 1
			debug ("dbg_assertion_in_trace")
				if attached {ASSERT_B} a_node as a_assert and then attached a_assert.tag as t then
					print (" - " + a_node.generator + " %"" + t + "%" [" + counter.out + "]%N")
				else
					print (" - " + a_node.generator + " [" + counter.out + "]%N")
				end
			end
		end

feature -- Node processing

	process_assert_b (a_node: ASSERT_B)
			-- Process `a_node`.
		do
				-- Assertion mark
			if context.assertion_type /= {ASSERT_TYPE}.in_invariant then
					-- No hooks when it is an invariant
				increment_counter (a_node)
			end
				-- Assertion byte code
			a_node.expr.process (Current)
		end

	process_inv_assert_b (a_node: INV_ASSERT_B)
			-- Process `a_node'.
		do
			process_assert_b (a_node)
		end

	process_require_b (a_node: REQUIRE_B)
		local
			l_prev_assertion_type: INTEGER
		do
			l_prev_assertion_type := context.assertion_type
			context.set_assertion_type ({ASSERT_TYPE}.In_precondition)
			process_assert_b (a_node)
			context.set_assertion_type (l_prev_assertion_type)
		end

	process_variant_b (a_node: VARIANT_B)
			-- Process `a_node'.
		local
			l_prev_assertion_type: INTEGER
		do
			l_prev_assertion_type := context.assertion_type
			context.set_assertion_type ({ASSERT_TYPE}.in_loop_variant)
			process_assert_b (a_node)
			context.set_assertion_type (l_prev_assertion_type)
		end

	process_check_b (a_node: CHECK_B)
			-- Process `a_node'.
		local
			l_prev_assertion_type: INTEGER
		do
			if attached a_node.check_list as l_check_list then
					-- Set assertion type
				l_prev_assertion_type := context.assertion_type
				context.set_assertion_type ({ASSERT_TYPE}.In_check)
				l_check_list.process (Current)
				context.set_assertion_type (l_prev_assertion_type)
			end
		end

	process_guard_b (a_node: GUARD_B)
			-- <Precursor>
		local
			l_prev_assertion_type: INTEGER
		do
				-- Generate hook for the condition test.
			if attached a_node.check_list as l_check_list then
					-- Generated byte code for assertions.
				l_prev_assertion_type := context.assertion_type
				context.set_assertion_type ({ASSERT_TYPE}.In_guard)
				l_check_list.process (Current)
				context.set_assertion_type (l_prev_assertion_type)
			end
			if attached a_node.compound as c then
					-- Generated byte code for compound.
				c.process (Current)
			end
		end

	process_invariant_b (a_node: INVARIANT_B)
			-- Process `a_node'.
		local
			l_prev_assertion_type: INTEGER
		do
			l_prev_assertion_type := context.assertion_type
			context.set_assertion_type ({ASSERT_TYPE}.in_invariant)
			Precursor (a_node)
			context.set_assertion_type (l_prev_assertion_type)
		end

	process_assign_b (a_node: ASSIGN_B)
			-- <Precursor>
		do
			increment_counter (a_node)
			Precursor (a_node)
		end

	process_elsif_b (a_node: ELSIF_B)
		do
			increment_counter (a_node)
			Precursor (a_node)
		end

	process_elsif_expression_b (a_node: ELSIF_EXPRESSION_B)
		do
				-- Generate hook for the condition test.
			increment_counter (a_node)

				-- Generate byte code for condition.
			a_node.condition.process (Current)

				-- Generate hook for Then_part.
			increment_counter (a_node)

				-- Generate alternative expression byte code.
			a_node.expression.process (Current)
		end

	process_if_b (a_node: IF_B)
		do
			if attached {HIDDEN_IF_B} a_node then
				Precursor (a_node)
			else
					-- Generate hook for the condition test
				increment_counter (a_node)

				Precursor (a_node)
			end
		end

	process_if_expression_b (a_node: IF_EXPRESSION_B)
			-- <Precursor>

		do
			a_node.condition.process (Current)

				-- Generate hook for Then_part.
			increment_counter (a_node)

				-- Generate expression for Then_part.
			a_node.then_expression.process (Current)

			if attached a_node.elsif_list as l_elsif_list then
					-- Generate byte code for alternatives.
				across
					l_elsif_list as c
				loop
					c.item.process (Current)
				end
			end

				-- Generate hook for Else_part.
			increment_counter (a_node)

				-- Generate expression for Else_part.
			a_node.else_expression.process (Current)
		end

	process_inspect_b (a_node: INSPECT_B)
			-- Process `a_node'.
		do
			increment_counter (a_node)

				-- Generate switch expression byte code
			a_node.switch.process (Current)
			if attached a_node.case_list as l_case_list then
					-- Generate code for the various inspect matches
				l_case_list.process (Current)
			end
			if attached a_node.else_part as l_else_part then
					-- We need to pop the value of the expression since we do not need it anymore.
				l_else_part.process (Current)
			end
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- Process `a_node'.
		do
			increment_counter (a_node)
			Precursor (a_node)
		end

	process_loop_b (a_node: LOOP_B)
			-- Process `a_node'.
		local
			invariant_breakpoint_slot: INTEGER
			body_breakpoint_slot: INTEGER
			l_context: like context
			l_old_hidden_code_level: INTEGER
			l_prev_assertion_type: INTEGER
		do
			l_context := context
			l_old_hidden_code_level := l_context.hidden_code_level
			l_context.set_hidden_code_level (0)
			if attached a_node.iteration_initialization as l_iteration_initialization then
					-- Generate byte code for iteration initialization.
				increment_counter (a_node)
				l_context.enter_hidden_code
				l_iteration_initialization.process (Current)
				l_context.exit_hidden_code
			end
			if attached a_node.from_part as l_from_part then
					-- Generate byte code for the from part
				l_from_part.process (Current)
			end

				-- Record context.
			invariant_breakpoint_slot := l_context.get_breakpoint_slot
			l_prev_assertion_type := l_context.assertion_type

				-- Invariant loop byte code
			if attached a_node.invariant_part as l_invariant_part then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_invariant)
				l_invariant_part.process (Current)
			end
				-- Variant loop byte code
			if attached a_node.variant_part as l_variant_part then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_variant)
				l_variant_part.process (Current)
			end
			l_context.set_assertion_type (l_prev_assertion_type)

			if attached a_node.stop as s then
					-- Generate breakpoint slot.
				increment_counter (a_node)
					-- Generate a test for loop exit condition.
				s.process (Current)
			end

			if attached a_node.compound as l_compound then
				l_compound.process (Current)
			end

				-- Save hook context & restore recorded context.
			body_breakpoint_slot := l_context.get_breakpoint_slot
			l_context.set_breakpoint_slot (invariant_breakpoint_slot)
			l_prev_assertion_type := l_context.assertion_type

				-- Invariant loop byte code
			if attached a_node.invariant_part as l_invariant_part then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_invariant)
				l_invariant_part.process (Current)
			end
				-- Variant loop byte code
			if attached a_node.variant_part as l_variant_part then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_variant)
				l_variant_part.process (Current)
			end
			l_context.set_assertion_type (l_prev_assertion_type)

				-- Restore hook context
			l_context.set_breakpoint_slot (body_breakpoint_slot)
			l_context.set_hidden_code_level (l_old_hidden_code_level)
		end

	process_loop_expr_b (a_node: LOOP_EXPR_B)
			-- <Precursor>
		local
			invariant_breakpoint_slot: INTEGER
			body_breakpoint_slot: INTEGER
			l_context: like context
			v: detachable VARIANT_B
			i: detachable BYTE_LIST [BYTE_NODE]
			l_old_hidden_code_level: INTEGER
			l_prev_assertion_type: INTEGER
		do
			l_context := context
			l_old_hidden_code_level := l_context.hidden_code_level
			l_context.set_hidden_code_level (0)

				-- Generate loop iteration part.
			l_context.enter_hidden_code
			a_node.iteration_code.process (Current)
			l_context.exit_hidden_code

			v := a_node.variant_code

				-- Record context.
			invariant_breakpoint_slot := l_context.get_breakpoint_slot
			l_prev_assertion_type := l_context.assertion_type

			i := a_node.invariant_code
			if i /= Void then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_invariant)
				i.process (Current)
			end
				-- Variant loop byte code
			if v /= Void then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_variant)
				v.process (Current)
			end
			l_context.set_assertion_type (l_prev_assertion_type)

			if attached a_node.exit_condition_code as e then
					-- Generate byte code for optional exit condition.
				increment_counter (a_node)
				e.process (Current)
			end

			increment_counter (a_node)
			a_node.expression_code.process (Current)
				-- Advance the loop cursor.
			a_node.advance_code.process (Current)

				-- Save hook context & restore recorded context.
			body_breakpoint_slot := l_context.get_breakpoint_slot
			l_context.set_breakpoint_slot (invariant_breakpoint_slot)
			l_prev_assertion_type := l_context.assertion_type

			if i /= Void then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_invariant)
				i.process (Current)
			end
				-- Variant loop byte code
			if v /= Void then
				l_context.set_assertion_type ({ASSERT_TYPE}.in_loop_variant)
				v.process (Current)
			end
			l_context.set_assertion_type (l_prev_assertion_type)

				-- Restore hook context
			l_context.set_breakpoint_slot (body_breakpoint_slot)
			l_context.set_hidden_code_level (l_old_hidden_code_level)
		end

	process_retry_b (a_node: RETRY_B)
			-- Process `a_node'.
		do
			increment_counter (a_node)
		end

	process_reverse_b (a_node: REVERSE_B)
			-- Process `a_node'.
		do
			increment_counter (a_node)
			Precursor (a_node)
		end


note
	date: "$Date$"
	revision: "$Revision$"
	copyright:	"Copyright (c) 1984-2018, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
