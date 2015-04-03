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
	EB_METRIC_IMPORT_DIALOG_IMP

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
			extend (main_container)
			main_container.extend (file_area)
			file_area.extend (import_file_lbl)
			file_area.extend (file_name_combo)
			file_area.extend (browse_metric_file_btn)
			file_area.extend (load_btn)
			main_container.extend (l_ev_cell_1)
			main_container.extend (main_area)
			main_area.extend (metric_list_lbl)
			main_area.extend (metric_list_area)
			main_area.extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (control_toolbar)
			control_toolbar.extend (select_integral_metrics_btn)
			control_toolbar.extend (deselect_integral_metrics_btn)
			control_toolbar.extend (select_all_metrics_btn)
			control_toolbar.extend (deselect_all_metrics_btn)
			control_toolbar.extend (reset_btn)
			l_ev_horizontal_box_1.extend (l_ev_cell_2)
			main_container.extend (l_ev_cell_3)
			main_container.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (l_ev_cell_4)
			l_ev_horizontal_box_2.extend (backup_btn)
			l_ev_horizontal_box_2.extend (import_btn)
			main_container.extend (l_ev_horizontal_separator_1)
			main_container.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_cell_5)
			l_ev_horizontal_box_3.extend (close_btn)

			main_container.set_border_width (5)
			main_container.disable_item_expand (file_area)
			main_container.disable_item_expand (l_ev_cell_1)
			main_container.disable_item_expand (l_ev_cell_3)
			main_container.disable_item_expand (l_ev_horizontal_box_2)
			main_container.disable_item_expand (l_ev_horizontal_separator_1)
			main_container.disable_item_expand (l_ev_horizontal_box_3)
			file_area.set_padding (3)
			file_area.disable_item_expand (import_file_lbl)
			file_area.disable_item_expand (browse_metric_file_btn)
			file_area.disable_item_expand (load_btn)
			import_file_lbl.set_text ("Metrics definition file:")
			import_file_lbl.align_text_left
			browse_metric_file_btn.set_text ("...")
			load_btn.set_minimum_width (60)
			l_ev_cell_1.set_minimum_height (10)
			main_area.set_padding (3)
			main_area.disable_item_expand (metric_list_lbl)
			main_area.disable_item_expand (l_ev_horizontal_box_1)
			metric_list_lbl.set_text ("Metrics List:")
			metric_list_lbl.align_text_left
			metric_list_area.set_background_color (create {EV_COLOR}.make_with_8_bit_rgb (0, 0, 0))
			metric_list_area.set_border_width (1)
			l_ev_horizontal_box_1.disable_item_expand (control_toolbar)
			l_ev_cell_3.set_minimum_height (10)
			l_ev_horizontal_box_2.set_padding (10)
			l_ev_horizontal_box_2.disable_item_expand (backup_btn)
			l_ev_horizontal_box_2.disable_item_expand (import_btn)
			backup_btn.set_text ("Backup User-defined Metrics")
			backup_btn.set_minimum_width (160)
			import_btn.set_text ("Import Selected Metrics")
			import_btn.set_minimum_width (160)
			l_ev_horizontal_separator_1.set_minimum_height (10)
			l_ev_horizontal_box_3.set_padding (10)
			l_ev_horizontal_box_3.disable_item_expand (close_btn)
			close_btn.set_minimum_width (70)
			set_title ("Import Metrics")

			set_all_attributes_using_constants

				-- Call `user_initialization'.
			user_initialization
		end
		
	frozen create_interface_objects
			-- Create objects
		do
			
				-- Create all widgets.
			create main_container
			create file_area
			create import_file_lbl
			create file_name_combo
			create browse_metric_file_btn
			create load_btn
			create l_ev_cell_1
			create main_area
			create metric_list_lbl
			create metric_list_area
			create l_ev_horizontal_box_1
			create control_toolbar
			create select_integral_metrics_btn
			create deselect_integral_metrics_btn
			create select_all_metrics_btn
			create deselect_all_metrics_btn
			create reset_btn
			create l_ev_cell_2
			create l_ev_cell_3
			create l_ev_horizontal_box_2
			create l_ev_cell_4
			create backup_btn
			create import_btn
			create l_ev_horizontal_separator_1
			create l_ev_horizontal_box_3
			create l_ev_cell_5
			create close_btn

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

	main_container, main_area, metric_list_area: EV_VERTICAL_BOX
	file_area: EV_HORIZONTAL_BOX
	import_file_lbl, metric_list_lbl: EV_LABEL
	file_name_combo: EV_COMBO_BOX
	browse_metric_file_btn,
	load_btn, backup_btn, import_btn, close_btn: EV_BUTTON
	control_toolbar: EV_TOOL_BAR
	select_integral_metrics_btn,
	deselect_integral_metrics_btn, select_all_metrics_btn, deselect_all_metrics_btn,
	reset_btn: EV_TOOL_BAR_BUTTON

feature {NONE} -- Implementation

	l_ev_cell_1, l_ev_cell_2, l_ev_cell_3, l_ev_cell_4, l_ev_cell_5: EV_CELL
	l_ev_horizontal_box_1,
	l_ev_horizontal_box_2, l_ev_horizontal_box_3: EV_HORIZONTAL_BOX
	l_ev_horizontal_separator_1: EV_HORIZONTAL_SEPARATOR

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
