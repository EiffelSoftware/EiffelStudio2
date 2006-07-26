indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_DOMAIN_SELECTOR

inherit
	EB_METRIC_DOMAIN_SELECTOR_IMP

	EB_CONSTANTS
		undefine
			is_equal,
			copy,
			default_create
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		undefine
			default_create,
			is_equal,
			copy
		end

	EVS_GRID_TWO_WAY_SORTING_ORDER
		undefine
			default_create,
			is_equal,
			copy
		end

	CONF_REFACTORING
		undefine
			default_create,
			is_equal,
			copy
		end

	EB_SHARED_ID_SOLUTION
		undefine
			default_create,
			is_equal,
			copy
		end

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			default_create,
			is_equal,
			copy
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	make (is_delayed_scope_enabled: BOOLEAN) is
			-- Initialize.
			-- If `is_delayed_scope_enabled' is False, disable delayed scope selection.
		do
			default_create
			if not is_delayed_scope_enabled then
				disable_delayed_domain
			end
		end

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_sort_info: EVS_GRID_THREE_WAY_SORTING_INFO [EB_METRIC_DOMAIN_ITEM_ROW]
			l_border: EV_VERTICAL_BOX
			l_colors: EV_STOCK_COLORS
		do
			create l_colors
			create domain_change_actions

				-- Setup scope type
			add_delayed_scope_btn.set_tooltip (metric_names.f_delayed_scope)
			add_delayed_scope_btn.set_pixmap (pixmaps.icon_pixmaps.metric_domain_delayed_icon)
			add_delayed_scope_btn.select_actions.extend (agent on_delayed_scope_added)

				-- Build tool bar buttons for scope grid.
			add_item_btn.remove_text
			add_item_btn.set_pixmap (pixmaps.icon_pixmaps.general_add_icon)
			add_item_btn.set_tooltip (metric_names.f_add_scope)

			remove_item_btn.remove_text
			remove_item_btn.set_pixmap (pixmaps.icon_pixmaps.general_remove_icon)
			remove_item_btn.set_tooltip (metric_names.f_remove_scope)

			remove_all_btn.remove_text
			remove_all_btn.set_pixmap (pixmaps.icon_pixmaps.general_reset_icon)
			remove_all_btn.set_tooltip (metric_names.f_remove_all_scopes)

				-- Setup scope selection grid.
			create l_border
			l_border.set_border_width (1)
			l_border.set_background_color (l_colors.black)
			create grid
			grid.set_column_count_to (1)
			grid.set_minimum_width (200)
			grid.enable_multiple_row_selection

			create scope_grid.make (grid)
			scope_grid.disable_search
			l_border.extend (scope_grid.component_widget)
			domain_grid_area.extend (l_border)

				-- Build sorting facilities
			create l_sort_info.make (agent scope_order_tester, ascending_order)
			scope_grid.set_sort_action (agent sort_agent)
			l_sort_info.enable_auto_indicator
			scope_grid.set_sort_info (1, l_sort_info)
			scope_grid.enable_auto_sort_order_change

				-- Setup agents
			grid.drop_actions.extend (agent on_drop (?))
			grid.set_pebble_function (agent pebble_function)
			add_item_btn.select_actions.extend (agent on_add_scope_from_dialog)
			remove_item_btn.select_actions.extend (agent on_remove_selected_scopes)
			remove_all_btn.select_actions.extend (agent on_remove_all_scopes)
			grid.set_item_pebble_function (agent grid_item_pebble)
			remove_item_btn.drop_actions.extend (agent on_item_dropped_on_remove_button)
			remove_all_btn.drop_actions.extend (agent on_item_dropped_on_remove_button)
			add_item_btn.drop_actions.extend (agent on_drop)
			grid.key_press_actions.extend (agent on_key_pressed)
		end

feature -- Access

	relative_window: EV_WINDOW
			-- A window which can be used when show `scope_selection_dialog'.

	domain: EB_METRIC_DOMAIN is
			-- Selected domain
		local
			l_row_index: INTEGER
			l_scope_row: EB_METRIC_DOMAIN_ITEM_ROW
			l_grid: like grid
			l_row_count: INTEGER
		do
			create Result.make
			l_grid := grid
			l_row_count := l_grid.row_count
			if l_row_count > 0 then
				from
					l_row_index := 1
				until
					l_row_index > l_row_count
				loop
					l_scope_row ?= l_grid.row (l_row_index).data
					if l_scope_row /= Void then
						Result.extend (l_scope_row.domain_item)
					end
					l_row_index := l_row_index + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	domain_change_actions: ACTION_SEQUENCE [TUPLE [EB_METRIC_DOMAIN]]
			-- Actions to be performed when domain changes

feature -- Setting

	set_relative_window (a_window: like relative_window) is
			-- Set `relative_window' with `a_window'.
		do
			relative_window := a_window
		ensure
			relative_window_set: relative_window = a_window
		end

	disable_delayed_domain is
			-- Disable delayed domain selection.
		do
			domain_type_toolbar.hide
			separator_toolbar.hide
		end

	enable_delayed_domain is
			-- Enable delayed domain selection.
		do
			domain_type_toolbar.show
			separator_toolbar.show
		end

	set_domain (a_domain: EB_METRIC_DOMAIN) is
			-- Set `a_domain' into current domain selector.
		require
			a_domain_attached: a_domain /= Void
		local
			done: BOOLEAN
			l_id_domain_item: EB_METRIC_DOMAIN_ITEM
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			if a_domain /= Void then
				from
					a_domain.start
				until
					a_domain.after or done
				loop
					insert_domain_item (a_domain.item)
					a_domain.forth
				end
			end
			if not done then
				on_domain_change
			end
		end

	display_domain (a_domain: like domain) is
			-- Display content of `a_domain' in current selector.
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			if a_domain /= Void then
				a_domain.do_all (agent insert_domain_item)
			end
		end

	refresh is
			-- Refresh selected domain.
			-- Used in synchronization.
		do
			set_domain (domain)
		end

feature -- Status report

	domain_has (a_item: EB_METRIC_DOMAIN_ITEM): BOOLEAN is
			-- Does `domain' have `a_item'?
		require
			a_item_attached: a_item /= Void
		local
			l_domain: like domain
		do
			l_domain := domain
			l_domain.compare_objects
			result := l_domain.has (a_item)
		end

feature{NONE} -- Actions

	on_remove_selected_scopes is
			-- Actions to be performed to remove selected scopes
		local
			l_select_rows: LIST [EV_GRID_ROW]
		do
			l_select_rows := grid.selected_rows
			if not l_select_rows.is_empty then
				from
					l_select_rows.start
				until
					l_select_rows.after
				loop
					grid.remove_row (l_select_rows.item.index)
					l_select_rows.forth
				end
				on_domain_change
			end
		end

	on_remove_all_scopes is
			-- Actions to be performed to remove all scopes
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
				on_domain_change
			end
		end

	on_add_scope_from_dialog is
			-- Action to be performed when user wants to add scope from a scope dialog
		do
			if not scope_selection_dialog.is_displayed then
				scope_selection_dialog.show (relative_window)
			end
		end

	on_drop (a_any: ANY) is
			-- Invoke when dropping a pebble to add an item to the scope.
		local
			l_classi_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_feature_stone: FEATURE_STONE
			l_target_stone: TARGET_STONE
			l_stone: STONE
		do
			l_stone ?= a_any
			if l_stone /= Void and then not domain_has (domain_item_from_stone (l_stone))  then
				l_classi_stone ?= a_any
				l_cluster_stone ?= a_any
				l_feature_stone ?= a_any
				l_target_stone ?= a_any
				if l_classi_stone /= Void or l_cluster_stone /= Void or l_feature_stone /= Void or l_target_stone /= Void then
					insert_domain_item (domain_item_from_stone (l_stone))
					on_domain_change
				end
			end
		end

	on_delayed_scope_added is
			-- Action to be performed when a delayed scope is added
		local
			l_delayed_item: EB_METRIC_DELAYED_DOMAIN_ITEM
		do
			create l_delayed_item.make ("")
			if not domain_has (l_delayed_item) then
				insert_domain_item (l_delayed_item)
				on_domain_change
			end
		end

	grid_item_pebble (a_item: EV_GRID_ITEM): ANY is
			-- Pebble in `a_item'
		local
			l_row: EB_METRIC_DOMAIN_ITEM_ROW
			l_stone: STONE
		do
			if a_item /= Void then
				l_row ?= a_item.data
				if l_row /= Void and then l_row.is_valid then
					l_stone := l_row.stone
					grid.set_accept_cursor (l_stone.stone_cursor)
					grid.set_deny_cursor (l_stone.x_stone_cursor)
					last_picked_row_index := a_item.row.index
					Result := l_stone
				else
					last_picked_row_index := 0
				end
			end
		end

	on_item_dropped_on_remove_button (a_pebble: ANY) is
			-- Action to be performed when an item is dropped on remove item button
		do
			if last_picked_row_index > 0 and then last_picked_row_index <= grid.row_count then
				grid.remove_row (last_picked_row_index)
				last_picked_row_index := 0
				on_domain_change
			end
		end

	on_domain_change is
			-- Action to be performed when domain changes
		do
			if not domain_change_actions.is_empty then
				domain_change_actions.call ([domain])
			end
		end

	on_key_pressed (a_key: EV_KEY) is
			-- Action to be performed when a key is pressed in `grid'.
		do
			if a_key.code = {EV_KEY_CONSTANTS}.key_delete then
				on_remove_selected_scopes
			end
		end

feature{NONE} -- Implementation/Data

	last_picked_row_index: INTEGER
			-- Row index of last picked item

	domain_item_from_stone (a_stone: STONE): EB_METRIC_DOMAIN_ITEM is
			-- Domain item from `a_stone'
		require
			a_stone_attached: a_stone /= Void
		local
			l_classi_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_feature_stone: FEATURE_STONE
			l_target_stone: TARGET_STONE
			l_folder: EB_FOLDER
			done: BOOLEAN
		do
			l_feature_stone ?= a_stone
			if l_feature_stone/= Void then
				create {EB_METRIC_FEATURE_DOMAIN_ITEM} Result.make (id_of_feature (l_feature_stone.e_feature))
				done := True
			end
			if not done then
				l_classi_stone ?= a_stone
				if l_classi_stone /= Void then
					create {EB_METRIC_CLASS_DOMAIN_ITEM} Result.make (id_of_class (l_classi_stone.class_i.config_class))
					done := True
				end
			end
			if not done then
				l_cluster_stone ?= a_stone
				if l_cluster_stone /= Void then
					if not l_cluster_stone.path.is_empty then
							-- For a folder
						create l_folder.make_with_name (l_cluster_stone.cluster_i, l_cluster_stone.path, l_cluster_stone.folder_name)
						create {EB_METRIC_FOLDER_DOMAIN_ITEM} Result.make (id_of_folder (l_folder))
					else
							-- For a group
						create {EB_METRIC_GROUP_DOMAIN_ITEM} Result.make (id_of_group (l_cluster_stone.group))
					end
				end
			end
			if not done then
				l_target_stone ?= a_stone
				if l_target_stone /= Void then
					create {EB_METRIC_TARGET_DOMAIN_ITEM} Result.make (id_of_target (l_target_stone.target))
				end
			end
		ensure
			result_attached: Result /= Void
		end

	scope_grid: EVS_SEARCHABLE_COMPONENT [EB_METRIC_DOMAIN_ITEM_ROW]
			-- Scope grid

	grid: ES_GRID
			-- Grid in `scope_grid'

	rows: DS_LIST [EB_METRIC_DOMAIN_ITEM_ROW] is
			-- List of rows in `grid'
		local
			l_grid: like grid
			l_row_index: INTEGER
			l_row_count: INTEGER
			l_scope_row: EB_METRIC_DOMAIN_ITEM_ROW
		do
			create {DS_ARRAYED_LIST [EB_METRIC_DOMAIN_ITEM_ROW]}Result.make (grid.row_count)
			l_grid := grid
			l_row_count := l_grid.row_count
			if l_row_count > 0 then
				from
					l_row_index := 1
				until
					l_row_index > l_row_count
				loop
					l_scope_row ?= l_grid.row (l_row_index).data
					check l_scope_row /= Void end
					Result.force_last (l_scope_row)
					l_row_index := l_row_index + 1
				end
			end
		ensure
			result_attached: Result /= Void
		end

	scope_selection_dialog: EB_SELECT_SCOPE_DIALOG is
			-- Dialog to select scopes
		do
			if scope_selection_dialog_internal = Void or else scope_selection_dialog_internal.is_destroyed then
				create scope_selection_dialog_internal.make (agent on_drop (?))
			end
			Result := scope_selection_dialog_internal
		ensure
			result_attached: Result /= Void
		end

	scope_selection_dialog_internal: like scope_selection_dialog
			-- Implementation of `scope_selection_dialog'

feature{NONE} -- Implementation

	insert_domain_item (a_domain_item: EB_METRIC_DOMAIN_ITEM) is
			-- Insert `a_domain_item' into `grid'.
		require
			a_domain_item_attached: a_domain_item /= Void
		local
			l_row: EB_METRIC_DOMAIN_ITEM_ROW
		do
			create l_row.make (a_domain_item)
			l_row.bind_grid (grid)
			grid.header.i_th (1).remove_pixmap
			grid.row (grid.row_count).ensure_visible
		end

feature{NONE} -- Implementation/Sorting

	sort_agent (a_column_list: LIST [INTEGER]; a_comparator: AGENT_LIST_COMPARATOR [EB_METRIC_DOMAIN_ITEM_ROW]) is
			-- Action to be performed when sort `a_column_list' using `a_comparator'.
		require
			a_column_list_attached: a_column_list /= Void
			not_a_column_list_is_empty:
		local
			l_sorter: DS_QUICK_SORTER [EB_METRIC_DOMAIN_ITEM_ROW]
			l_rows: like rows
		do
			create l_sorter.make (a_comparator)
			l_rows := rows
			l_sorter.sort (l_rows)
			bind_grid (l_rows)
		end

	bind_grid (a_rows: like rows) is
			-- Bind `a_rows' in `grid'.
		require
			a_rows_attached: a_rows /= Void
		local
			l_scope_row: EB_METRIC_DOMAIN_ITEM_ROW
		do
			if grid.row_count > 0 then
				grid.remove_rows (1, grid.row_count)
			end
			from
				a_rows.start
			until
				a_rows.after
			loop
				create l_scope_row.make (a_rows.item_for_iteration.domain_item)
				l_scope_row.bind_grid (grid)
				a_rows.forth
			end
		end

	scope_order_tester (a_scope_a, a_scope_b: EB_METRIC_DOMAIN_ITEM_ROW; a_order: INTEGER): BOOLEAN is
			-- Tester to test is `a_scope_a' is less than `a_scope_b' using sorting order `a_order'
		require
			a_scope_a_attached: a_scope_a /= Void
			a_scope_b_attached: a_scope_b /= Void
		local
			l_name_a: STRING
			l_name_b: STRING
		do
			l_name_a := a_scope_a.name.as_lower
			l_name_b := a_scope_b.name.as_lower
			if a_order = ascending_order then
				Result := l_name_a < l_name_b
			elseif a_order = descending_order then
				Result := l_name_a > l_name_b
			elseif a_order = topology_order then
				if a_scope_a.index /= a_scope_b.index then
					Result := a_scope_a.index < a_scope_b.index
				else
					Result := l_name_a < l_name_b
				end
			end
		end

invariant
	domain_change_actions_attached: domain_change_actions /= Void

indexing
        copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
                        distributed in the hope that it will be useful,	but
                        WITHOUT ANY WARRANTY; without even the implied warranty
                        of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
                        See the	GNU General Public License for more details.
                        
                        You should have received a copy of the GNU General Public
                        License along with Eiffel Software's Eiffel Development
                        Environment; if not, write to the Free Software Foundation,
                        Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
                ]"
        source: "[
                         Eiffel Software
                         356 Storke Road, Goleta, CA 93117 USA
                         Telephone 805-685-1006, Fax 805-685-6869
                         Website http://www.eiffel.com
                         Customer support http://support.eiffel.com
                ]"


end -- class EB_METRIC_DOMAIN_SELECTOR

