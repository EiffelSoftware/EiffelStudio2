indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

class
	EVENTS_TAB

inherit
	EVENTS_TAB_IMP
	
	GRID_ACCESSOR
		undefine
			copy, default_create, is_equal
		end

feature {NONE} -- Initialization

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			grid.pointer_motion_actions.extend (agent motion_event)
			grid.pointer_double_press_actions.extend (agent double_press_event)
			grid.pointer_button_press_actions.extend (agent press_event)
			grid.pointer_button_release_actions.extend (agent release_event)
			grid.pointer_enter_actions.extend (agent pointer_enter_event)
			grid.pointer_leave_actions.extend (agent pointer_leave_event)
			grid.mouse_wheel_actions.extend (agent mouse_wheel_event)
			grid.key_press_actions.extend (agent key_press_event)
			grid.key_press_string_actions.extend (agent key_press_string_event)
			grid.key_release_actions.extend (agent key_release_event)
			grid.focus_in_actions.extend (agent focus_in_event)
			grid.focus_out_actions.extend (agent focus_out_event)
			grid.resize_actions.extend (agent resize_event)
			grid.row_expand_actions.extend (agent row_expanded)
			grid.row_collapse_actions.extend (agent row_collapsed)
		end
		
feature -- Events

	motion_event (an_x, a_y: INTEGER; an_item: EV_GRID_ITEM) is
			--
		local
			l_string: STRING
		do
			l_string := "Motion : " + an_x.out + ", " +a_y.out
			if an_item /= Void then
				l_string.append (". Item : " + an_item.column.index.out + ", " + an_item.row.index.out)
			else
				l_string.append (". No item")
			end
			add_event_item_to_list (l_string)
		end
		
	double_press_event (an_x, a_y, a_button: INTEGER; an_item: EV_GRID_ITEM) is
			--
		local
			l_string: STRING
		do
			l_string := "Double Press : " + an_x.out + ", " +a_y.out + " Button : " + a_button.out
			if an_item /= Void then
				l_string.append (". Item : " + an_item.column.index.out + ", " + an_item.row.index.out)
			else
				l_string.append (". No item")
			end
			add_event_item_to_list (l_string)
		end
		
	press_event (an_x, a_y, a_button: INTEGER; an_item: EV_GRID_ITEM) is
		local
			l_string: STRING
		do
			l_string := "Press : " + an_x.out + ", " +a_y.out + " Button : " + a_button.out
			if an_item /= Void then
				l_string.append (". Item : " + an_item.column.index.out + ", " + an_item.row.index.out)
			else
				l_string.append (". No item")
			end
			add_event_item_to_list (l_string)
		end
		
	release_event (an_x, a_y, a_button: INTEGER; an_item: EV_GRID_ITEM) is
		local
			l_string: STRING
		do
			l_string := "Release : " + an_x.out + ", " +a_y.out + " Button : " + a_button.out
			if an_item /= Void then
				l_string.append (". Item : " + an_item.column.index.out + ", " + an_item.row.index.out)
			else
				l_string.append (". No item")
			end
			add_event_item_to_list (l_string)
		end
	
	pointer_enter_event (on_grid: BOOLEAN; an_item: EV_GRID_ITEM) is
			--
		do
			to_implement ("EVENTS_TAB.pointer_enter_event")
		end
		
	pointer_leave_event (on_grid: BOOLEAN; an_item: EV_GRID_ITEM) is
			--
		do
			to_implement ("EVENTS_TAB.pointer_leave_event")
		end
		
	mouse_wheel_event (a_value: INTEGER) is
			--
		do
			to_implement ("EVENTS_TAB.mouse_wheel_event")
		end
		
	key_press_event (a_key: EV_KEY) is
			--
		do
			to_implement ("EVENTS_TAB.key_press_event")
		end
		
	key_press_string_event (a_key: STRING) is
			--
		do
			to_implement ("EVENTS_TAB.key_press_string_event")
		end
		
	key_release_event (a_key: EV_KEY) is
			--
		do
			to_implement ("EVENTS_TAB.key_release_event")
		end
		
	focus_in_event is
			--
		do
			to_implement ("EVENTS_TAB.focus_in_event")
		end
		
	focus_out_event is
			--
		do
			to_implement ("EVENTS_TAB.focus_out_event")	
		end
		
	resize_event (an_x, a_y, a_width, a_height: INTEGER) is
			--
		do
			to_implement ("EVENTS_TAB.resize_event")
		end
		
	row_collapsed (a_row: EV_GRID_ROW) is
			--
		do
			add_event_item_to_list ("Row " + a_row.index.out + " collapsed.")
		end
		
	row_expanded (a_row: EV_GRID_ROW) is
			--
		do
			add_event_item_to_list ("Row " + a_row.index.out + " expanded.")
		end

	add_event_item_to_list (a_string: STRING) is
			--
		local
			list_item: EV_LIST_ITEM
		do
			create list_item.make_with_text (a_string)
			if event_list.count > 50 then
				event_list.wipe_out
			end
			event_list.extend (list_item)
			if event_list.is_displayed then
				event_list.ensure_item_visible (list_item)
			end
		end

	motion_highlight_event (an_x, a_y: INTEGER; an_item: EV_GRID_ITEM) is
			--
		local
			label_item: EV_GRID_LABEL_ITEM
		do
			if an_item /= Void then
				label_item ?= an_item
--				if label_item /= Void then
--					label_item.set_font (small_font)
--				end
				an_item.enable_select
			end
		end
		
	motion_event_in_item (an_x, a_y: INTEGER; an_item: EV_GRID_ITEM) is
			--
		local
			l_string: STRING
			textable:  EV_TEXTABLE
		do
			textable ?= an_item
			if textable /= Void then
				l_string := "Motion : " + (an_x - an_item.virtual_x_position).out + ", " + (a_y - an_item.virtual_y_position).out
				textable.set_text (l_string)
			end
		end
		
		
	small_font: EV_FONT is
			--
		once
			create Result
			Result.set_height (6)
		end
		

feature {NONE} -- Implementation

	
	highlight_items_on_motion_selected is
			-- Called by `select_actions' of `highlight_items_on_motion'.
		do
			grid.pointer_motion_actions.wipe_out
			grid.pointer_motion_actions.extend (agent motion_event)
			if highlight_items_on_motion.is_selected then
				grid.pointer_motion_actions.extend (agent motion_highlight_event)
			end
		end
	
	show_events_in_items_selected is
			-- Called by `select_actions' of `show_events_in_items'.
		do
			grid.pointer_motion_actions.wipe_out
			grid.pointer_motion_actions.extend (agent motion_event)
			if show_events_in_items.is_selected then
				grid.pointer_motion_actions.extend (agent motion_event_in_item)
			end
		end
		
end -- class EVENTS_TAB

