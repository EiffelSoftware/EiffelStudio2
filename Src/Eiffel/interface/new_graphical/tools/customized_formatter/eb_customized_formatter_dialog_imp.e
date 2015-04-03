note
	description: "[
		Objects that represent an EV_DIALOG.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_DIALOG generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	generator: "EiffelBuild"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_CUSTOMIZED_FORMATTER_DIALOG_IMP

inherit
	EV_DIALOG
		redefine
			create_interface_objects, initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	frozen initialize
			-- Initialize `Current'.
		do
			Precursor {EV_DIALOG}

			
				-- Build widget structure.
			extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (main_area)
			main_area.extend (formatter_area)
			formatter_area.extend (formatter_grid_area)
			formatter_area.extend (formatter_grid_tool_bar_area)
			formatter_grid_tool_bar_area.extend (l_ev_cell_1)
			formatter_grid_tool_bar_area.extend (formatter_tool_bar)
			formatter_tool_bar.extend (add_button)
			formatter_tool_bar.extend (remove_button)
			main_area.extend (property_main_area)
			property_main_area.extend (l_ev_cell_2)
			property_main_area.extend (property_area)
			property_area.extend (l_ev_frame_1)
			l_ev_frame_1.extend (property_grid_area)
			property_grid_area.extend (empty_selection_label)
			property_area.extend (l_ev_frame_2)
			l_ev_frame_2.extend (help_area)
			l_ev_vertical_box_1.extend (button_area)
			button_area.extend (l_ev_cell_3)
			button_area.extend (ok_button)
			button_area.extend (l_ev_cell_4)
			button_area.extend (cancel_button)

			l_ev_vertical_box_1.set_padding (15)
			l_ev_vertical_box_1.set_border_width (8)
			l_ev_vertical_box_1.disable_item_expand (button_area)
			main_area.enable_item_expand (formatter_area)
			main_area.disable_item_expand (property_main_area)
			formatter_area.disable_item_expand (formatter_grid_tool_bar_area)
			formatter_grid_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			formatter_grid_area.set_border_width (1)
			formatter_grid_tool_bar_area.disable_item_expand (formatter_tool_bar)
			property_main_area.disable_item_expand (l_ev_cell_2)
			l_ev_cell_2.set_minimum_width (10)
			property_area.set_padding (5)
			property_area.disable_item_expand (l_ev_frame_2)
			l_ev_frame_1.set_style (1)
			l_ev_frame_2.set_style (1)
			help_area.set_border_width (2)
			button_area.set_minimum_height (25)
			button_area.disable_item_expand (ok_button)
			button_area.disable_item_expand (l_ev_cell_4)
			button_area.disable_item_expand (cancel_button)
			ok_button.set_minimum_width (100)
			l_ev_cell_4.set_minimum_width (10)
			cancel_button.set_minimum_width (100)
			set_title ("Display window")

			set_all_attributes_using_constants

				-- Call `user_initialization'.
			user_initialization
		end
		
	frozen create_interface_objects
			-- Create objects
		do
			
				-- Create all widgets.
			create l_ev_vertical_box_1
			create main_area
			create formatter_area
			create formatter_grid_area
			create formatter_grid_tool_bar_area
			create l_ev_cell_1
			create formatter_tool_bar
			create add_button
			create remove_button
			create property_main_area
			create l_ev_cell_2
			create property_area
			create l_ev_frame_1
			create property_grid_area
			create empty_selection_label
			create l_ev_frame_2
			create help_area
			create button_area
			create l_ev_cell_3
			create ok_button
			create l_ev_cell_4
			create cancel_button

			create string_constant_set_procedures.make (10)
			create string_constant_retrieval_functions.make (10)
			create integer_constant_set_procedures.make (10)
			create integer_constant_retrieval_functions.make (10)
			create pixmap_constant_set_procedures.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create integer_interval_constant_retrieval_functions.make (10)
			create integer_interval_constant_set_procedures.make (10)
			create font_constant_set_procedures.make (10)
			create font_constant_retrieval_functions.make (10)
			create pixmap_constant_retrieval_functions.make (10)
			create color_constant_set_procedures.make (10)
			create color_constant_retrieval_functions.make (10)
			user_create_interface_objects
		end


feature -- Access

	main_area: EV_HORIZONTAL_SPLIT_AREA
	formatter_area, formatter_grid_area, property_area: EV_VERTICAL_BOX
	formatter_grid_tool_bar_area,
	property_main_area, property_grid_area, help_area, button_area: EV_HORIZONTAL_BOX
	formatter_tool_bar: EV_TOOL_BAR
	add_button,
	remove_button: EV_TOOL_BAR_BUTTON
	empty_selection_label: EV_LABEL
	ok_button, cancel_button: EV_BUTTON

feature {NONE} -- Implementation

	l_ev_vertical_box_1: EV_VERTICAL_BOX
	l_ev_cell_1, l_ev_cell_2, l_ev_cell_3, l_ev_cell_4: EV_CELL
	l_ev_frame_1,
	l_ev_frame_2: EV_FRAME

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN
			-- Is `Current' in its default state?
		do
			Result := True
		end

	user_create_interface_objects
			-- Feature for custom user interface object creation, called at end of `create_interface_objects'.
		deferred
		end

	user_initialization
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end

feature {NONE} -- Constant setting

	frozen set_attributes_using_string_constants
			-- Set all attributes relying on string constants to the current
			-- value of the associated constant.
		local
			s: STRING_32
		do
			from
				string_constant_set_procedures.start
			until
				string_constant_set_procedures.off
			loop
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).item (Void)
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_integer_constants
			-- Set all attributes relying on integer constants to the current
			-- value of the associated constant.
		local
			i: INTEGER
			arg1, arg2: INTEGER
			int: INTEGER_INTERVAL
		do
			from
				integer_constant_set_procedures.start
			until
				integer_constant_set_procedures.off
			loop
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).item (Void)
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				arg1 := integer_interval_constant_retrieval_functions.item.item (Void)
				integer_interval_constant_retrieval_functions.forth
				arg2 := integer_interval_constant_retrieval_functions.item.item (Void)
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_pixmap_constants
			-- Set all attributes relying on pixmap constants to the current
			-- value of the associated constant.
		local
			p: EV_PIXMAP
		do
			from
				pixmap_constant_set_procedures.start
			until
				pixmap_constant_set_procedures.off
			loop
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).item (Void)
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end

	frozen set_attributes_using_font_constants
			-- Set all attributes relying on font constants to the current
			-- value of the associated constant.
		local
			f: EV_FONT
		do
			from
				font_constant_set_procedures.start
			until
				font_constant_set_procedures.off
			loop
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).item (Void)
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end	
		end

	frozen set_attributes_using_color_constants
			-- Set all attributes relying on color constants to the current
			-- value of the associated constant.
		local
			c: EV_COLOR
		do
			from
				color_constant_set_procedures.start
			until
				color_constant_set_procedures.off
			loop
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).item (Void)
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end

	frozen set_all_attributes_using_constants
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
	
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [READABLE_STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE, EV_COLOR]]

	frozen integer_from_integer (an_integer: INTEGER): INTEGER
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

end
