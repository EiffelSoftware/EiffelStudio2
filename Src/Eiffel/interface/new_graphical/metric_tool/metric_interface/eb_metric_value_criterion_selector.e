note
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_VALUE_CRITERION_SELECTOR

inherit
	EB_METRIC_VALUE_CRITERION_SELECTOR_IMP

	QL_SHARED_NAMES
		undefine
			default_create,
			copy,
			is_equal
		end

	EVS_GRID_UTILITY
		undefine
			default_create,
			copy,
			is_equal
		end

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			default_create,
			copy,
			is_equal
		end

	EB_CONTEXT_MENU_HANDLER
		undefine
			default_create,
			copy,
			is_equal
		end

feature {NONE} -- Initialization

	user_create_interface_objects
			-- <Precursor>
		do
			-- FIXME: Currently code is not void-safe and initialization still takes place in `user_initialization'.
		end

	user_initialization
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_grid_support: like new_grid_support
		do
			metric_value_retriever_dialog_function := agent metric_value_retriever_dialog
			create grid
			l_grid_support := new_grid_support (grid)
			grid_area.extend (grid)
			grid.set_column_count_to (2)
			grid.column (1).set_title (metric_names.l_operator)
			grid.column (2).set_title (metric_names.l_base_value)
			grid.enable_single_row_selection
			grid.column (2).set_width (60)
			grid.enable_selection_on_single_button_click
			l_grid_support.enable_grid_item_pnd_support
			l_grid_support.set_context_menu_factory_function (agent context_menu_factory)

			grid.set_item_veto_pebble_function (agent is_pebble_droppable)
			grid.item_drop_actions.extend (agent on_pebble_drop)

			grid.key_press_actions.extend (agent on_key_pressed)

			add_btn.set_pixmap (pixmaps.icon_pixmaps.general_add_icon)
			add_btn.set_tooltip (metric_names.t_add_new_constant_value_retriever)
			add_btn.select_actions.extend (agent on_add_criterion)

			add_metrc_value_retriever_btn.set_pixmap (pixmaps.icon_pixmaps.general_add_icon)
			add_metrc_value_retriever_btn.set_tooltip (metric_names.t_add_new_metric_value_retriever)
			add_metrc_value_retriever_btn.select_actions.extend (agent on_add_metric_value_retriever)

			remove_btn.set_pixmap (pixmaps.icon_pixmaps.general_remove_icon)
			remove_btn.set_tooltip (metric_names.t_remove_value_retriever)
			remove_btn.select_actions.extend (agent on_remove_criterion)
			remove_btn.drop_actions.extend (agent on_remove_dropped_row)

			clear_btn.set_pixmap (pixmaps.icon_pixmaps.general_reset_icon)
			clear_btn.set_tooltip (metric_names.t_remove_all_value_retriever)
			clear_btn.select_actions.extend (agent on_clear_criteria)
			clear_btn.drop_actions.extend (agent on_remove_dropped_row)

			anded_option.set_text (metric_names.t_match_all_of_the_following)
			ored_option.set_text (metric_names.t_match_any_of_the_following)
		end

feature -- Access

	criterion: EB_METRIC_VALUE_TESTER
			-- Tester criterion from Current selector
		local
			l_grid: like grid
			l_grid_row: EV_GRID_ROW
			l_index: INTEGER
			l_count: INTEGER
			l_choice_item: EV_GRID_CHOICE_ITEM
			l_constant_value_item: EV_GRID_EDITABLE_ITEM
			l_metric_value_item: EB_METRIC_VALUE_CRITERION_GRID_ITEM
			l_criteria: LINKED_LIST [TUPLE [EB_METRIC_VALUE_RETRIEVER, INTEGER]]
			l_metric_value_retriever: EB_METRIC_METRIC_VALUE_RETRIEVER
			l_value: TUPLE [metric_name: STRING; external_delayed: BOOLEAN; tester: EB_METRIC_VALUE_TESTER]
			l_metric_name: STRING
		do
			create Result.make
			create l_criteria.make
			l_grid := grid
			from
				l_index := 1
				l_count := l_grid.row_count
			until
				l_index > l_count
			loop
				l_grid_row := l_grid.row (l_index)
				l_choice_item ?= l_grid_row.item (1)
				l_constant_value_item ?= l_grid_row.item (2)
				l_metric_value_item ?= l_grid_row.item (2)
				check l_choice_item /= Void end
				if l_constant_value_item /= Void then
					l_criteria.extend ([create {EB_METRIC_CONSTANT_VALUE_RETRIEVER}.make (l_constant_value_item.text.to_double), operator_interface_name_table.item (l_choice_item.text)])
				else
					l_value := l_metric_value_item.value
					if l_value = Void or else l_value.metric_name = Void then
						l_metric_name := ""
					else
						l_metric_name := l_value.metric_name
					end
					create l_metric_value_retriever.make (l_metric_name, l_metric_value_item.domain)
					l_metric_value_retriever.set_is_external_delayed_domain_used (l_value.external_delayed)
					l_criteria.extend ([l_metric_value_retriever, operator_interface_name_table.item (l_choice_item.text)])
				end
				l_index := l_index + 1
			end
			Result.set_criteria (l_criteria)
			if anded_option.is_selected then
				Result.enable_anded
			else
				Result.enable_ored
			end
		ensure
			result_attached: Result /= Void
		end

	metric_value_retriever_dialog_function: FUNCTION [ANY, TUPLE, EB_METRIC_VALUE_CRITERION_DIALOG]
			-- Function to retrieve a dialog to setup metric value retriever

feature -- Status report

	has_grid_been_binded: BOOLEAN
			-- Has `grid' been binded?

feature -- Basic operations

	set_criterion (a_cri: like criterion)
			-- Load `a_cri' into Current selector
		require
			a_cri_attached: a_cri /= Void
		local
			l_grid: like grid
		do
			l_grid := grid
			if l_grid.row_count > 0 then
				l_grid.remove_rows (1, l_grid.row_count)
			end
			a_cri.criteria.do_all (agent bind_row)
			auto_resize
			if a_cri.is_anded then
				anded_option.enable_select
			else
				ored_option.enable_select
			end
		end

feature -- Setting

	set_has_grid_been_binded (b: BOOLEAN)
			-- Set `has_grid_been_binded'.
		do
			has_grid_been_binded := b
		ensure
			has_grid_been_binded_set: has_grid_been_binded = b
		end

	set_metric_value_retriever_dialog_function (a_function: like metric_value_retriever_dialog_function)
			-- Set `metric_value_retriever_dialog_function' with `a_function'.
		require
			a_function_attached: a_function /= Void
		do
			metric_value_retriever_dialog_function := a_function
		ensure
			metric_value_retriever_dialog_function_set: metric_value_retriever_dialog_function = a_function
		end

feature{NONE} -- Actions

	on_add_criterion
			-- Action to be performed to add a new criterion item
		do
			bind_row ([create {EB_METRIC_CONSTANT_VALUE_RETRIEVER}.make (0.0), equal_to_type])
			auto_resize
		end

	on_add_metric_value_retriever
			-- Action to be performed to add new metric value retriever item
		do
			bind_row ([create {EB_METRIC_METRIC_VALUE_RETRIEVER}.make ("", create {EB_METRIC_DOMAIN}.make), equal_to_type])
		end

	on_remove_criterion
			-- Action to be performed to remove selected criterion
		local
			l_rows: LIST [EV_GRID_ROW]
		do
			from
				l_rows := grid.selected_rows
			until
				l_rows.is_empty
			loop
				grid.remove_row (l_rows.first.index)
				l_rows := grid.selected_rows
			end
		end

	on_clear_criteria
			-- Action to be performed to remove all criteria
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
		end

	on_value_text_change (a_value_item: EV_GRID_EDITABLE_ITEM)
			-- Action to be performed when text in `a_value_item' changes
		require
			a_value_item_attached: a_value_item /= Void
		do
			if not a_value_item.text.is_double then
				a_value_item.set_text ("0")
			end
		end

	on_remove_dropped_row (a_grid_row: EV_GRID_ROW)
			-- Action to be perfromed to remove `a_grid_row'.
		do
			if a_grid_row /= Void and then a_grid_row.parent = grid then
				grid.remove_row (a_grid_row.index)
			end
		end

	on_pebble_drop (a_item: EV_GRID_ITEM; a_pebble: ANY)
			-- Action to be performed when `a_pebble' is dropped into `a_item'.
		local
			l_metric_value_item: EB_METRIC_VALUE_CRITERION_GRID_ITEM
		do
			l_metric_value_item ?= a_item
			if l_metric_value_item /= Void then
				l_metric_value_item.drop_pebble (a_pebble)
				resize_grid (a_item)
			end
		end

	on_key_pressed (a_key: EV_KEY)
			-- Action to be performed when `a_key' is pressed
		require
			a_key_attached: a_key /= Void
		local
			l_selected_rows: LIST [EV_GRID_ROW]
			l_row_index: INTEGER
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_delete then
				if grid.has_selected_row then
					l_selected_rows := grid.selected_rows
					l_row_index := l_selected_rows.first.index
					on_remove_dropped_row (l_selected_rows.first)
					if l_row_index > grid.row_count then
						l_row_index := grid.row_count
					end
					if l_row_index > 0 then
						if grid.row (l_row_index).is_selectable then
							grid.row (l_row_index).enable_select
						end
					end
				end
			end
		end

feature {NONE} -- Implementation

	grid: ES_EDITOR_TOKEN_GRID
			-- Grid used to display criteria

	bind_row (a_cri: TUPLE [a_value_retriever: EB_METRIC_VALUE_RETRIEVER; a_operator_type: INTEGER])
			-- Bind `a_value' and `a_operator_type' in a new row in `grid'.
		require
			a_cri_attached: a_cri /= Void
		local
			l_grid: like grid
			l_grid_row: EV_GRID_ROW
			l_operator_item: like operator_grid_item
			l_constant_retriever: EB_METRIC_CONSTANT_VALUE_RETRIEVER
			l_metric_retriever: EB_METRIC_METRIC_VALUE_RETRIEVER
		do
			l_grid := grid
			l_grid.insert_new_row (l_grid.row_count + 1)
			l_grid_row := l_grid.row (l_grid.row_count)

			l_operator_item := operator_grid_item
			l_operator_item.set_text (operator_table.item (a_cri.a_operator_type).as_string_32)
			l_grid_row.set_item (1, l_operator_item)
			l_constant_retriever ?= a_cri.a_value_retriever
			l_metric_retriever ?= a_cri.a_value_retriever
			if l_constant_retriever /= Void then
				l_grid_row.set_item (2, constant_value_retriever_item (l_constant_retriever))
			else
				l_grid_row.set_item (2, metric_value_retriever_item (l_metric_retriever))
			end
		end

	constant_value_retriever_item (a_constant_value_retriever: EB_METRIC_CONSTANT_VALUE_RETRIEVER): EV_GRID_ITEM
			-- Grid item to setup `a_constant_value_retriever'.
		require
			a_constant_value_retriever_attached: a_constant_value_retriever /= Void
		local
			l_value_item: EV_GRID_EDITABLE_ITEM
		do
			create l_value_item.make_with_text (a_constant_value_retriever.value_internal.out)
			l_value_item.deactivate_actions.extend (agent on_value_text_change (l_value_item))
			l_value_item.pointer_button_press_actions.extend (agent activate_grid_item (?, ?, ?, ?, ?, ?, ?, ?, l_value_item))
			Result := l_value_item
		ensure
			result_attached: Result /= Void
		end

	metric_value_retriever_item (a_metric_value_retriever: EB_METRIC_METRIC_VALUE_RETRIEVER): EV_GRID_ITEM
			-- Grid item to setup `a_metric_value_retriever'.
		require
			a_metric_value_retriever_attached: a_metric_value_retriever /= Void
		local
			l_value_item: EB_METRIC_VALUE_CRITERION_GRID_ITEM
		do
			create l_value_item.make_with_setting (a_metric_value_retriever.input_domain, False)
			l_value_item.set_is_empty_tester_displayed (False)
			l_value_item.dialog_ok_actions.extend (agent resize_grid (l_value_item))
			l_value_item.set_tooltip (metric_names.f_pick_and_drop_metric_and_items)
			l_value_item.set_dialog_function (metric_value_retriever_dialog_function)
			l_value_item.set_value ([a_metric_value_retriever.metric_name, False, create {EB_METRIC_VALUE_TESTER}.make])
			Result := l_value_item
		ensure
			result_attached: Result /= Void
		end

	resize_grid (a_item: EV_GRID_ITEM)
			-- Resize grid where `a_item' locates.
		require
			a_item_attached: a_item /= Void
		do
			if a_item.is_parented then
				a_item.column.resize_to_content
			end
		end

	operator_grid_item: EV_GRID_CHOICE_ITEM
			-- Grid combo item for displaying operators "=", "/=", "<", "<=", ">", ">="
		local
			l_operator_names: like operator_interface_name_table
			l_name_list: LINKED_LIST [STRING_32]
		do
				-- Fill operator name list.
			create l_name_list.make
			l_operator_names := operator_interface_name_table
			from
				l_operator_names.start
			until
				l_operator_names.after
			loop
				l_name_list.extend (l_operator_names.key_for_iteration)
				l_operator_names.forth
			end

			create Result
			Result.set_item_strings (l_name_list)
			Result.pointer_double_press_actions.extend (agent activate_grid_item (?, ?, ?, ?, ?, ?, ?, ?, Result))
		ensure
			result_attached: Result /= Void
		end

	operator_interface_name_table: HASH_TABLE [INTEGER, STRING_32]
			-- Table for name of opterators "=", "/=", "<", "<=", ">", ">="
			-- Key is operator name, value is type index for that operator.
		once
			create Result.make (6)
			Result.put (equal_to_type, equal_to_operator.as_string_32)
		  	Result.put (not_equal_to_type, not_equal_to_operator.as_string_32)
		  	Result.put (less_than_type, less_than_operator.as_string_32)
		  	Result.put (less_than_equal_to_type, less_than_equal_to_operator.as_string_32)
		  	Result.put (greater_than_type, greater_than_operator.as_string_32)
		  	Result.put (greater_than_equal_to_type, greater_than_equal_to_operator.as_string_32)
		ensure
			result_attached: Result /= Void
		end

	auto_resize
			-- Auto resize `grid'.
		local
			l_size_tbl: HASH_TABLE [TUPLE [INTEGER, INTEGER], INTEGER]
		do
			if not has_grid_been_binded then
				create l_size_tbl.make (2)
				l_size_tbl.put ([60, 70], 1)
				l_size_tbl.put (Void, 2)
				auto_resize_columns (grid, l_size_tbl)
				set_has_grid_been_binded (True)
			end
		end

	is_pebble_droppable (a_item: EV_GRID_ITEM; a_pebble: ANY): BOOLEAN
			-- Is `a_pebble' droppable into `a_item'?
		require
			a_item_attached: a_item /= Void
		local
			l_metric_value_item: EB_METRIC_VALUE_CRITERION_GRID_ITEM
		do
			l_metric_value_item ?= a_item
			if l_metric_value_item /= Void then
				Result := l_metric_value_item.is_pebble_droppable (a_pebble)
			end
			Result := True
		end

	context_menu_handler (a_menu: EV_MENU; a_target_list: ARRAYED_LIST [EV_PND_TARGET_DATA]; a_source: EV_PICK_AND_DROPABLE; a_pebble: ANY)
			-- Context menu handler
		do
			-- Do nothing.
		end

invariant
	grid_attached: grid /= Void
	metric_value_retriever_dialog_function_attached: metric_value_retriever_dialog_function /= Void

note
	copyright:	"Copyright (c) 1984-2015, Eiffel Software"
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
