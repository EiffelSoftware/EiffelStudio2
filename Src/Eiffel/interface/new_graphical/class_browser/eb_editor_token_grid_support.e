indexing
	description: "[
					Supports for editor token grid.
					Functonalites:
						1. Scroll behaviour synchronization with preferences.
						2. Editor token font and color synchronization with preferences.
						3. Grid odd/even row background color synchronization with preferences.
						4. Pick and drop
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_EDITOR_TOKEN_GRID_SUPPORT

inherit
	SHARED_EDITOR_DATA

	EB_SHARED_PREFERENCES

	EVS_GRID_UTILITY

	EV_SHARED_APPLICATION

create
	make_with_grid

feature{NONE} -- Initialization

	make_with_grid (a_grid: like grid) is
			-- Initialize `grid' with `a_grid'.
		require
			a_grid_attached: a_grid /= Void
		do
			internal_grid := a_grid
		ensure
			grid_set: grid = a_grid
		end

feature -- Access

	grid: ES_GRID is
			-- Grid to which supports apply
		do
			Result := internal_grid
		ensure
			result_attached: Result /= Void
		end

	old_item_pebble_function: FUNCTION [ANY, TUPLE [EV_GRID_ITEM], ANY]
			-- Old `item_pebble_function' in `grid' before last `enable_editor_token_pnd'

	color_or_font_change_actions: ACTION_SEQUENCE [TUPLE] is
			-- Actions to be performed when color or font in editor changes
		do
			if color_or_font_change_actions_internal = Void then
				create color_or_font_change_actions_internal
			end
			Result := color_or_font_change_actions_internal
		ensure
			result_attached: Result /= Void
		end

	editor_token_at_position (a_x, a_y: INTEGER): EDITOR_TOKEN is
			-- Editor token at position (`a_x', `a_y') which is related to the top-left coordinate of `grid'
			-- Void if no item is found.
		local
			l_editor_token_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_index: INTEGER
		do
			l_editor_token_item ?= grid_item_at_position (grid, a_x, a_y)
			if l_editor_token_item /= Void then
				l_index := l_editor_token_item.token_index_at_current_position
				if l_index > 0 then
					Result := l_editor_token_item.token_at_position (l_index)
				end
			end
		end

	last_picked_item: EV_GRID_ITEM
			-- Last picked item	
			-- Void if no item is picked.		

feature -- Setting

	enable_editor_token_pnd is
			-- Enable pick and drop on individual editor token.
		do
			if not grid.pick_ended_actions.has (on_pick_ended_action) then
				grid.pick_ended_actions.force_extend (on_pick_ended_action)
			end
			old_item_pebble_function := grid.item_pebble_function
			grid.set_item_pebble_function (on_pick_function)
		end

	disable_editor_token_pnd is
			-- Disable pick and drop on individual editor token.
		do
			grid.pick_ended_actions.prune_all (on_pick_ended_action)
			grid.set_item_pebble_function (old_item_pebble_function)
		end

	synchronize_scroll_behavior_with_editor is
			-- Sychronize scroll behavior with editor.
		local
			l_change_agent: like on_scroll_behavior_change_agent
		do
			l_change_agent := on_scroll_behavior_change_agent
			on_scroll_behavior_change
			editor_preferences.mouse_wheel_scroll_full_page_preference.change_actions.extend (l_change_agent)
			editor_preferences.mouse_wheel_scroll_size_preference.change_actions.extend (l_change_agent)
			editor_preferences.scrolling_common_line_count_preference.change_actions.extend (l_change_agent)
		end

	desynchronize_scroll_behavior_with_editor is
			-- Desychronize scroll behavior with editor.
			-- Note: Make sure that this feature gets called after use, otherwise memory leak may occur.
		local
			l_change_agent: like on_scroll_behavior_change_agent
		do
			l_change_agent := on_scroll_behavior_change_agent
			editor_preferences.mouse_wheel_scroll_full_page_preference.change_actions.prune_all (l_change_agent)
			editor_preferences.mouse_wheel_scroll_size_preference.change_actions.prune_all (l_change_agent)
			editor_preferences.scrolling_common_line_count_preference.change_actions.prune_all (l_change_agent)
		end

	synchronize_color_or_font_change_with_editor is
			-- Synchronize color or font with editor.
		local
			l_change_agent: like on_color_or_font_change_agent
			l_list: ARRAYED_LIST [ACTION_SEQUENCE [TUPLE]]
		do
			l_change_agent := on_color_or_font_change_agent
			create l_list.make (6)
			l_list.extend (editor_preferences.keyword_font_preference.change_actions)
			l_list.extend (editor_preferences.keyword_text_color_preference.change_actions)
			l_list.extend (editor_preferences.normal_text_color_preference.change_actions)
			l_list.extend (editor_preferences.editor_font_preference.change_actions)
			l_list.extend (preferences.class_browser_data.odd_row_background_color_preference.change_actions)
			l_list.extend (preferences.class_browser_data.even_row_background_color_preference.change_actions)
			from
				l_list.start
			until
				l_list.after
			loop
				if not l_list.item.has (l_change_agent) then
					l_list.item.extend (l_change_agent)
				end
				l_list.forth
			end
		end

	desynchronize_color_or_font_change_with_editor is
			-- Desychronize color or font change with editor.
			-- Note: Make sure that this feature gets called after use, otherwise memory leak may occur.
		local
			l_change_agent: like on_color_or_font_change_agent
		do
			l_change_agent := on_color_or_font_change_agent
			editor_preferences.keyword_font_preference.change_actions.prune_all (l_change_agent)
			editor_preferences.keyword_text_color_preference.change_actions.prune_all (l_change_agent)
			editor_preferences.normal_text_color_preference.change_actions.prune_all (l_change_agent)
			editor_preferences.editor_font_preference.change_actions.prune_all (l_change_agent)
			preferences.class_browser_data.odd_row_background_color_preference.change_actions.prune_all (l_change_agent)
			preferences.class_browser_data.even_row_background_color_preference.change_actions.prune_all (l_change_agent)
		end

	enable_ctrl_right_click_to_open_new_window is
			-- Enable that Ctrl+Right click will open a new development window to display stone conatined in current pointer hovered editor token.
		do
			if not grid.pointer_button_press_actions.has (on_pointer_right_click_agent) then
				grid.pointer_button_press_actions.extend (on_pointer_right_click_agent)
			end
		end

	disable_ctrl_right_click_to_open_new_window is
			-- Disable that Ctrl+Right click will open a new development window to display stone conatined in current pointer hovered editor token.
		do
			grid.pointer_button_press_actions.prune_all (on_pointer_right_click_agent)
		end


feature{NONE} -- Actions

	on_pick_ended_action: PROCEDURE [ANY, TUPLE [a_item: EV_ABSTRACT_PICK_AND_DROPABLE]] is
			-- Agent object of `on_pick_ended'
		do
			if on_pick_ended_action_internal = Void then
				on_pick_ended_action_internal := agent on_pick_ended
			end
			Result := on_pick_ended_action_internal
		ensure
			result_attached: Result /= Void
		end

	on_pick_function: FUNCTION [ANY, TUPLE [a_item: EV_GRID_ITEM], ANY] is
			-- Agent object of `on_pick'
		do
			if on_pick_function_internal = Void then
				on_pick_function_internal := agent on_pick
			end
			Result := on_pick_function_internal
		ensure
			result_attached: Result /= Void
		end

	on_color_or_font_change is
			-- Action to be performed when color or font in editor changes
		do
			if not color_or_font_change_actions.is_empty then
				color_or_font_change_actions.call ([])
			end
		end

	on_scroll_behavior_change is
			-- Action to be performed when scroll behavior changes
		do
			grid.scrolling_behavior.set_mouse_wheel_scroll_full_page (editor_preferences.mouse_wheel_scroll_full_page)
			grid.scrolling_behavior.set_mouse_wheel_scroll_size (editor_preferences.mouse_wheel_scroll_size)
			grid.scrolling_behavior.set_scrolling_common_line_count (editor_preferences.scrolling_common_line_count)
		end

	on_color_or_font_change_agent: PROCEDURE [ANY, TUPLE] is
			-- Agent of `on_color_or_font_change'
		do
			if on_color_or_font_change_agent_internal = Void then
				on_color_or_font_change_agent_internal := agent on_color_or_font_change
			end
			Result := on_color_or_font_change_agent_internal
		ensure
			Result_attached: Result /= Void
		end

	on_scroll_behavior_change_agent: PROCEDURE [ANY, TUPLE] is
			-- Agent of `on_scroll_behavior_change'
		do
			if on_scroll_behavior_change_agent_internal = Void then
				on_scroll_behavior_change_agent_internal := agent on_scroll_behavior_change
			end
			Result := on_scroll_behavior_change_agent_internal
		ensure
			result_attached: Result /= Void
		end

	on_pointer_right_click_agent: PROCEDURE [ANY, TUPLE [INTEGER_32, INTEGER_32, INTEGER_32, REAL_64, REAL_64, REAL_64, INTEGER_32, INTEGER_32]] is
			-- Agent of `on_pointer_right_click'
		do
			if on_pointer_right_click_agent_internal = Void then
				on_pointer_right_click_agent_internal := agent on_pointer_right_click
			end
			Result := on_pointer_right_click_agent_internal
		ensure
			result_attached: Result /= Void
		end

feature{NONE} -- Pick and drop

	on_pick_ended (a_item: EV_ABSTRACT_PICK_AND_DROPABLE) is
			-- Action performed when pick ends
		local
			l_item: EB_GRID_EDITOR_TOKEN_ITEM
		do
			l_item ?= last_picked_item
			if l_item /= Void then
				l_item.set_last_picked_token (0)
				if l_item.is_parented and then l_item.is_selectable then
					l_item.enable_select
				end
				if l_item.is_parented then
					l_item.redraw
				end
			end
			last_picked_item := Void
		ensure
			last_picked_item_not_attached: last_picked_item = Void
		end

	on_pick (a_item: EV_GRID_ITEM): ANY is
			-- Action performed when pick on `a_item'.
		local
			l_item: EB_GRID_EDITOR_TOKEN_ITEM
			l_stone: STONE
			l_index: INTEGER
		do
			if not ev_application.ctrl_pressed then
				last_picked_item := Void
				l_item ?= a_item
				if l_item /= Void then
					l_index := l_item.token_index_at_current_position
					if l_index > 0 then
						Result := l_item.editor_token_pebble (l_index)
						l_stone ?= Result
						if l_stone /= Void then
							grid.remove_selection
							grid.set_accept_cursor (l_stone.stone_cursor)
							grid.set_deny_cursor (l_stone.x_stone_cursor)
							l_item.set_last_picked_token (l_index)
							l_item.redraw
							last_picked_item := l_item
						end
					end
				end
			end
		end

	on_pointer_right_click (a_x, a_y, a_button: INTEGER; a_x_tilt, a_y_tilt, a_pressure: DOUBLE; a_screen_x, a_screen_y: INTEGER) is
			-- Action to be performed when pointer right click on `grid'
			-- Behavior is launch the stone contained in pointer hovered editor token in a new development window.
		local
			l_editor_token: EDITOR_TOKEN
			l_stone: STONE
		do
			if a_button = 3 and then ev_application.ctrl_pressed then
				l_editor_token := editor_token_at_position (a_x, a_y)
				if l_editor_token /= Void then
					l_stone ?= l_editor_token.pebble
					if l_stone /= Void and then l_stone.is_valid then
						(create {EB_CONTROL_PICK_HANDLER}).launch_stone (l_stone)
					end
				end
			end
		end

feature{NONE} -- Implementation

	internal_grid: like grid
			-- Implementation of `grid'

	on_pick_ended_action_internal: like on_pick_ended_action
			-- Implementation of `on_pick_ended_action'

	on_pick_function_internal: like on_pick_function
			-- Implementation of `on_pick_function'

	color_or_font_change_actions_internal: like color_or_font_change_actions
			-- Implementation of `color_or_font_change_actions'	

	on_color_or_font_change_agent_internal: like on_color_or_font_change_agent
			-- Implementation of `on_color_or_font_change_agent'

	on_scroll_behavior_change_agent_internal: like on_scroll_behavior_change_agent
			-- Implementation of `on_scroll_behavior_change_agent'

	on_pointer_right_click_agent_internal: like on_pointer_right_click_agent
			-- Implementation of `on_pointer_right_click_agent'

invariant
	grid_attached: grid /= Void

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

end
