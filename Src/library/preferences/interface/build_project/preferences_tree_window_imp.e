indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PREFERENCES_TREE_WINDOW_IMP

inherit
	EV_TITLED_WINDOW
		redefine
			initialize, is_in_default_state
		end

-- This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_TITLED_WINDOW}
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create l_ev_horizontal_split_area_1
			create left_list
			create l_ev_vertical_box_2
			create right_list
			create preference_frame
			create l_ev_vertical_box_3
			create resource_container
			create resource_cell
			create set_button
			create set_default_button
			create description_text
			create l_ev_horizontal_separator_1
			create l_ev_horizontal_box_1
			create restore_button
			create l_ev_cell_1
			create ok_button
			create cancel_button
			
				-- Build_widget_structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_split_area_1)
			l_ev_horizontal_split_area_1.extend (left_list)
			l_ev_horizontal_split_area_1.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (right_list)
			l_ev_vertical_box_2.extend (preference_frame)
			preference_frame.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (resource_container)
			resource_container.extend (resource_cell)
			resource_container.extend (set_button)
			resource_container.extend (set_default_button)
			l_ev_vertical_box_3.extend (description_text)
			l_ev_vertical_box_1.extend (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (restore_button)
			l_ev_horizontal_box_1.extend (l_ev_cell_1)
			l_ev_horizontal_box_1.extend (ok_button)
			l_ev_horizontal_box_1.extend (cancel_button)
			
			l_ev_vertical_box_1.set_padding_width (5)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_separator_1)
			l_ev_vertical_box_1.disable_item_expand (l_ev_horizontal_box_1)
			left_list.set_minimum_width (200)
			l_ev_vertical_box_2.set_padding_width (5)
			l_ev_vertical_box_2.set_border_width (5)
			l_ev_vertical_box_2.disable_item_expand (preference_frame)
			right_list.set_minimum_height (270)
			preference_frame.set_text ("Details")
			l_ev_vertical_box_3.set_padding_width (5)
			l_ev_vertical_box_3.set_border_width (5)
			l_ev_vertical_box_3.disable_item_expand (resource_container)
			resource_container.set_padding_width (5)
			resource_container.set_border_width (5)
			resource_container.disable_item_expand (set_button)
			resource_container.disable_item_expand (set_default_button)
			set_button.disable_sensitive
			set_button.set_text ("Set")
			set_button.set_minimum_width (80)
			set_default_button.disable_sensitive
			set_default_button.set_text ("Restore default")
			set_default_button.set_minimum_width (90)
			description_text.set_minimum_height (50)
			description_text.disable_edit
			l_ev_horizontal_box_1.set_padding_width (5)
			l_ev_horizontal_box_1.set_border_width (5)
			l_ev_horizontal_box_1.disable_item_expand (restore_button)
			l_ev_horizontal_box_1.disable_item_expand (ok_button)
			l_ev_horizontal_box_1.disable_item_expand (cancel_button)
			restore_button.set_text ("Restore Defaults")
			restore_button.set_minimum_width (90)
			ok_button.set_text ("OK")
			ok_button.set_minimum_width (80)
			cancel_button.set_text ("Cancel")
			cancel_button.set_minimum_width (80)
			set_minimum_width (640)
			set_minimum_height (480)
			set_title ("Preferences")
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	left_list: EV_TREE
	right_list: EV_MULTI_COLUMN_LIST
	description_text: EV_TEXT
	resource_container: EV_HORIZONTAL_BOX
	set_button, set_default_button,
	restore_button, ok_button, cancel_button: EV_BUTTON
	preference_frame: EV_FRAME
	resource_cell: EV_CELL

feature {NONE} -- Implementation

	l_ev_horizontal_split_area_1: EV_HORIZONTAL_SPLIT_AREA
	l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR
	l_ev_vertical_box_1, l_ev_vertical_box_2,
	l_ev_vertical_box_3: EV_VERTICAL_BOX
	l_ev_horizontal_box_1: EV_HORIZONTAL_BOX
	l_ev_cell_1: EV_CELL

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
	
end -- class PREFERENCES_TREE_WINDOW_IMP
