indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MAIN_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			initialize, is_in_default_state
		end
			
	CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_TITLED_WINDOW}
			initialize_constants
			
				-- Create all widgets.
			create l_ev_menu_bar_1
			create file_menu
			create file_exit_menu_item
			create view_menu
			create view_tools_menu_item
			create profile_menu
			create profiling_on_menu_item
			create l_ev_vertical_box_1
			create l_ev_horizontal_box_1
			create grid_cell
			create tools_notebook
			create l_ev_vertical_box_2
			create l_ev_vertical_box_3
			create l_ev_vertical_box_4
			create l_ev_vertical_box_5
			create l_ev_vertical_box_6
			create l_ev_vertical_box_7
			create l_ev_vertical_box_8
			create status_bar_frame
			
				-- Build_widget_structure.
			set_menu_bar (l_ev_menu_bar_1)
			l_ev_menu_bar_1.extend (file_menu)
			file_menu.extend (file_exit_menu_item)
			l_ev_menu_bar_1.extend (view_menu)
			view_menu.extend (view_tools_menu_item)
			l_ev_menu_bar_1.extend (profile_menu)
			profile_menu.extend (profiling_on_menu_item)
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (grid_cell)
			l_ev_horizontal_box_1.extend (tools_notebook)
			tools_notebook.extend (l_ev_vertical_box_2)
			tools_notebook.extend (l_ev_vertical_box_3)
			tools_notebook.extend (l_ev_vertical_box_4)
			tools_notebook.extend (l_ev_vertical_box_5)
			tools_notebook.extend (l_ev_vertical_box_6)
			tools_notebook.extend (l_ev_vertical_box_7)
			tools_notebook.extend (l_ev_vertical_box_8)
			l_ev_vertical_box_1.extend (status_bar_frame)
			
			file_menu.set_text ("File")
			file_exit_menu_item.set_text ("Exit")
			view_menu.set_text ("View")
			view_tools_menu_item.enable_select
			view_tools_menu_item.set_text ("Tools Displayed")
			profile_menu.set_text ("Profile")
			profiling_on_menu_item.set_text ("Profiling on")
			l_ev_vertical_box_1.set_padding_width (box_padding)
			l_ev_vertical_box_1.disable_item_expand (status_bar_frame)
			l_ev_horizontal_box_1.disable_item_expand (tools_notebook)
			grid_cell.set_minimum_width (500)
			grid_cell.set_minimum_height (400)
			tools_notebook.set_minimum_width (400)
			tools_notebook.set_item_text (l_ev_vertical_box_2, "Grid")
			tools_notebook.set_item_text (l_ev_vertical_box_3, "Column")
			tools_notebook.set_item_text (l_ev_vertical_box_4, "Row")
			tools_notebook.set_item_text (l_ev_vertical_box_5, "Item")
			tools_notebook.set_item_text (l_ev_vertical_box_6, "Selection")
			tools_notebook.set_item_text (l_ev_vertical_box_7, "Position")
			tools_notebook.set_item_text (l_ev_vertical_box_8, "Events")
			status_bar_frame.set_style (1)
			set_title ("Grid Tester")
			
				--Connect events.
			file_exit_menu_item.select_actions.extend (agent file_exit_menu_item_selected)
			view_tools_menu_item.select_actions.extend (agent view_tools_menu_item_selected)
			profiling_on_menu_item.select_actions.extend (agent profiling_on_menu_item_selected)
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	file_exit_menu_item: EV_MENU_ITEM
	view_tools_menu_item, profiling_on_menu_item: EV_CHECK_MENU_ITEM
	file_menu, view_menu,
	profile_menu: EV_MENU
	tools_notebook: EV_NOTEBOOK
	status_bar_frame: EV_FRAME
	grid_cell: EV_CELL

feature {NONE} -- Implementation

	l_ev_vertical_box_3: COLUMN_TAB
	l_ev_vertical_box_8: EVENTS_TAB
	l_ev_vertical_box_7: POSITION_TAB
	l_ev_vertical_box_6: SELECTION_TAB
	l_ev_menu_bar_1: EV_MENU_BAR
	l_ev_vertical_box_5: ITEM_TAB
	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_vertical_box_4: ROW_TAB
	l_ev_vertical_box_2: GRID_TAB

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	file_exit_menu_item_selected is
			-- Called by `select_actions' of `file_exit_menu_item'.
		deferred
		end
	
	view_tools_menu_item_selected is
			-- Called by `select_actions' of `view_tools_menu_item'.
		deferred
		end
	
	profiling_on_menu_item_selected is
			-- Called by `select_actions' of `profiling_on_menu_item'.
		deferred
		end
	

end -- class MAIN_WINDOW_IMP
