indexing
	description: "[
		Objects that represent an EV_TITLED_WINDOW.
		The original version of this class was generated by EiffelBuild.
		This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
		You should not modify this code by hand, as it will be re-generated every time
		 modifications are made to the project.
		 	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_METRIC_ARCHIVE_PANEL_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			
				-- Create all widgets.
			create l_ev_horizontal_box_1
			create archive_definition_frame
			create l_ev_vertical_box_1
			create definition_toolbar_area
			create l_ev_horizontal_box_2
			create definition_toolbar
			create run_btn
			create stop_btn
			create l_ev_tool_bar_separator_1
			create new_archive_file_area
			create new_archive_file_lbl
			create new_archive_file_name_text
			create new_archive_browse_btn
			create clean_btn
			create l_ev_horizontal_box_3
			create l_ev_vertical_box_2
			create l_ev_horizontal_box_4
			create source_domain_lbl
			create domain_selection_area
			create l_ev_vertical_box_3
			create l_ev_horizontal_box_5
			create metric_lbl
			create metric_selection_area
			create archive_comparison_area
			create l_ev_vertical_box_4
			create comparison_toolbar_area
			create compare_toolbar
			create compare_btn
			create l_ev_tool_bar_separator_2
			create display_mode_toolbar
			create ratio_btn
			create difference
			create reference_archve_area
			create reference_archive_lbl
			create l_ev_horizontal_box_6
			create reference_metric_archive_text
			create browse_reference_archive_btn
			create l_ev_cell_1
			create current_archive_area
			create current_archive_lbl
			create l_ev_horizontal_box_7
			create current_metric_archive_text
			create browse_current_archive_btn
			
				-- Build_widget_structure.
			extend (l_ev_horizontal_box_1)
			l_ev_horizontal_box_1.extend (archive_definition_frame)
			archive_definition_frame.extend (l_ev_vertical_box_1)
			l_ev_vertical_box_1.extend (definition_toolbar_area)
			definition_toolbar_area.extend (l_ev_horizontal_box_2)
			l_ev_horizontal_box_2.extend (definition_toolbar)
			definition_toolbar.extend (run_btn)
			definition_toolbar.extend (stop_btn)
			definition_toolbar.extend (l_ev_tool_bar_separator_1)
			l_ev_horizontal_box_2.extend (new_archive_file_area)
			new_archive_file_area.extend (new_archive_file_lbl)
			new_archive_file_area.extend (new_archive_file_name_text)
			new_archive_file_area.extend (new_archive_browse_btn)
			new_archive_file_area.extend (clean_btn)
			l_ev_vertical_box_1.extend (l_ev_horizontal_box_3)
			l_ev_horizontal_box_3.extend (l_ev_vertical_box_2)
			l_ev_vertical_box_2.extend (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.extend (source_domain_lbl)
			l_ev_vertical_box_2.extend (domain_selection_area)
			l_ev_horizontal_box_3.extend (l_ev_vertical_box_3)
			l_ev_vertical_box_3.extend (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.extend (metric_lbl)
			l_ev_vertical_box_3.extend (metric_selection_area)
			l_ev_horizontal_box_1.extend (archive_comparison_area)
			archive_comparison_area.extend (l_ev_vertical_box_4)
			l_ev_vertical_box_4.extend (comparison_toolbar_area)
			comparison_toolbar_area.extend (compare_toolbar)
			compare_toolbar.extend (compare_btn)
			compare_toolbar.extend (l_ev_tool_bar_separator_2)
			comparison_toolbar_area.extend (display_mode_toolbar)
			display_mode_toolbar.extend (ratio_btn)
			display_mode_toolbar.extend (difference)
			l_ev_vertical_box_4.extend (reference_archve_area)
			reference_archve_area.extend (reference_archive_lbl)
			reference_archve_area.extend (l_ev_horizontal_box_6)
			l_ev_horizontal_box_6.extend (reference_metric_archive_text)
			l_ev_horizontal_box_6.extend (browse_reference_archive_btn)
			l_ev_vertical_box_4.extend (l_ev_cell_1)
			l_ev_vertical_box_4.extend (current_archive_area)
			current_archive_area.extend (current_archive_lbl)
			current_archive_area.extend (l_ev_horizontal_box_7)
			l_ev_horizontal_box_7.extend (current_metric_archive_text)
			l_ev_horizontal_box_7.extend (browse_current_archive_btn)
			
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
			
			l_ev_horizontal_box_1.set_padding_width (15)
			l_ev_horizontal_box_1.set_border_width (2)
			archive_definition_frame.set_text ("Archive Managament")
			l_ev_vertical_box_1.set_padding_width (6)
			l_ev_vertical_box_1.set_border_width (10)
			l_ev_vertical_box_1.disable_item_expand (definition_toolbar_area)
			l_ev_horizontal_box_2.set_padding_width (3)
			l_ev_horizontal_box_2.disable_item_expand (definition_toolbar)
			new_archive_file_area.set_padding_width (3)
			new_archive_file_area.disable_item_expand (new_archive_file_lbl)
			new_archive_file_area.disable_item_expand (new_archive_browse_btn)
			new_archive_file_area.disable_item_expand (clean_btn)
			new_archive_file_lbl.set_text ("Location:")
			new_archive_file_lbl.align_text_left
			new_archive_browse_btn.set_text ("...")
			clean_btn.set_text ("Clean")
			l_ev_horizontal_box_3.set_padding_width (5)
			l_ev_vertical_box_2.set_padding_width (3)
			l_ev_vertical_box_2.disable_item_expand (l_ev_horizontal_box_4)
			l_ev_horizontal_box_4.set_padding_width (3)
			l_ev_horizontal_box_4.disable_item_expand (source_domain_lbl)
			source_domain_lbl.set_text ("Select source domain:")
			source_domain_lbl.align_text_left
			l_ev_vertical_box_3.set_padding_width (3)
			l_ev_vertical_box_3.disable_item_expand (l_ev_horizontal_box_5)
			l_ev_horizontal_box_5.set_padding_width (3)
			l_ev_horizontal_box_5.disable_item_expand (metric_lbl)
			metric_lbl.set_text ("Select Metrics:")
			archive_comparison_area.set_text ("Archive Comparison")
			l_ev_vertical_box_4.set_padding_width (6)
			l_ev_vertical_box_4.set_border_width (10)
			l_ev_vertical_box_4.disable_item_expand (comparison_toolbar_area)
			l_ev_vertical_box_4.disable_item_expand (reference_archve_area)
			l_ev_vertical_box_4.disable_item_expand (l_ev_cell_1)
			l_ev_vertical_box_4.disable_item_expand (current_archive_area)
			reference_archve_area.set_padding_width (3)
			reference_archve_area.disable_item_expand (reference_archive_lbl)
			reference_archive_lbl.set_text ("Select reference archive:")
			reference_archive_lbl.align_text_left
			l_ev_horizontal_box_6.set_padding_width (3)
			l_ev_horizontal_box_6.disable_item_expand (browse_reference_archive_btn)
			browse_reference_archive_btn.set_text ("...")
			l_ev_cell_1.set_minimum_height (15)
			current_archive_area.set_padding_width (3)
			current_archive_lbl.set_text ("Select current archive:")
			current_archive_lbl.align_text_left
			l_ev_horizontal_box_7.set_padding_width (3)
			l_ev_horizontal_box_7.disable_item_expand (browse_current_archive_btn)
			browse_current_archive_btn.set_text ("...")
			
			set_all_attributes_using_constants
			
				--Connect events.
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end


feature -- Access

	new_archive_browse_btn, browse_reference_archive_btn, browse_current_archive_btn: EV_BUTTON
	definition_toolbar,
	compare_toolbar, display_mode_toolbar: EV_TOOL_BAR
	ratio_btn, difference: EV_TOOL_BAR_TOGGLE_BUTTON
	run_btn, stop_btn,
	compare_btn: EV_TOOL_BAR_BUTTON
	definition_toolbar_area, new_archive_file_area, comparison_toolbar_area: EV_HORIZONTAL_BOX
	domain_selection_area,
	metric_selection_area, reference_archve_area, current_archive_area: EV_VERTICAL_BOX
	clean_btn: EV_CHECK_BUTTON
	new_archive_file_lbl,
	source_domain_lbl, metric_lbl, reference_archive_lbl, current_archive_lbl: EV_LABEL
	new_archive_file_name_text,
	reference_metric_archive_text, current_metric_archive_text: EV_TEXT_FIELD
	archive_definition_frame,
	archive_comparison_area: EV_FRAME

feature {NONE} -- Implementation

	l_ev_tool_bar_separator_1, l_ev_tool_bar_separator_2: EV_TOOL_BAR_SEPARATOR
	l_ev_cell_1: EV_CELL
	l_ev_horizontal_box_1,
	l_ev_horizontal_box_2, l_ev_horizontal_box_3, l_ev_horizontal_box_4, l_ev_horizontal_box_5,
	l_ev_horizontal_box_6, l_ev_horizontal_box_7: EV_HORIZONTAL_BOX
	l_ev_vertical_box_1, l_ev_vertical_box_2,
	l_ev_vertical_box_3, l_ev_vertical_box_4: EV_VERTICAL_BOX

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
		
feature {NONE} -- Constant setting

	set_attributes_using_string_constants is
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
				string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).call (Void)
				s := string_constant_retrieval_functions.i_th (string_constant_set_procedures.index).last_result
				string_constant_set_procedures.item.call ([s])
				string_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_integer_constants is
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
				integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).call (Void)
				i := integer_constant_retrieval_functions.i_th (integer_constant_set_procedures.index).last_result
				integer_constant_set_procedures.item.call ([i])
				integer_constant_set_procedures.forth
			end
			from
				integer_interval_constant_retrieval_functions.start
				integer_interval_constant_set_procedures.start
			until
				integer_interval_constant_retrieval_functions.off
			loop
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg1 := integer_interval_constant_retrieval_functions.item.last_result
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_retrieval_functions.item.call (Void)
				arg2 := integer_interval_constant_retrieval_functions.item.last_result
				create int.make (arg1, arg2)
				integer_interval_constant_set_procedures.item.call ([int])
				integer_interval_constant_retrieval_functions.forth
				integer_interval_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_pixmap_constants is
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
				pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).call (Void)
				p := pixmap_constant_retrieval_functions.i_th (pixmap_constant_set_procedures.index).last_result
				pixmap_constant_set_procedures.item.call ([p])
				pixmap_constant_set_procedures.forth
			end
		end
		
	set_attributes_using_font_constants is
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
				font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).call (Void)
				f := font_constant_retrieval_functions.i_th (font_constant_set_procedures.index).last_result
				font_constant_set_procedures.item.call ([f])
				font_constant_set_procedures.forth
			end	
		end
		
	set_attributes_using_color_constants is
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
				color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).call (Void)
				c := color_constant_retrieval_functions.i_th (color_constant_set_procedures.index).last_result
				color_constant_set_procedures.item.call ([c])
				color_constant_set_procedures.forth
			end
		end
		
	set_all_attributes_using_constants is
			-- Set all attributes relying on constants to the current
			-- calue of the associated constant.
		do
			set_attributes_using_string_constants
			set_attributes_using_integer_constants
			set_attributes_using_pixmap_constants
			set_attributes_using_font_constants
			set_attributes_using_color_constants
		end
					
	string_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [STRING_GENERAL]]]
	string_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], STRING_32]]
	integer_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER]]]
	integer_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	pixmap_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_PIXMAP]]]
	pixmap_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_PIXMAP]]
	integer_interval_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], INTEGER]]
	integer_interval_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [INTEGER_INTERVAL]]]
	font_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_FONT]]]
	font_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_FONT]]
	color_constant_set_procedures: ARRAYED_LIST [PROCEDURE [ANY, TUPLE [EV_COLOR]]]
	color_constant_retrieval_functions: ARRAYED_LIST [FUNCTION [ANY, TUPLE [], EV_COLOR]]
	
	integer_from_integer (an_integer: INTEGER): INTEGER is
			-- Return `an_integer', used for creation of
			-- an agent that returns a fixed integer value.
		do
			Result := an_integer
		end

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


end -- class EB_METRIC_ARCHIVE_PANEL_IMP
