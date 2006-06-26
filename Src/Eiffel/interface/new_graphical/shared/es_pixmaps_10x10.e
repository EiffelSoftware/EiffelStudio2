indexing
	description: "An Eiffel pixmap matrix accessor, generated by Eiffel Matrix Generator."
	legal      : "See notice at end of class."
	status     : "See notice at end of class."
	date       : "$Date$"
	revision   : "$Revision$"

class
	ES_PIXMAPS_10X10

create
	make

feature {NONE} -- Initialization

	make (a_name: STRING) is
			-- Initialize matrix
		require
			a_name_attached: a_name /= Void
			not_a_name_is_empty: not a_name.is_empty
		local
			l_file: FILE_NAME
			l_warn: EV_WARNING_DIALOG
			retried: BOOLEAN
		do
			if not retried then
				create l_file.make_from_string ((create {EIFFEL_ENV}).bitmaps_path)
				l_file.set_subdirectory ("png")
				l_file.set_file_name (a_name)
			end

			if not retried and then (create {RAW_FILE}.make (l_file)).exists then
				create raw_buffer
				raw_buffer.set_with_named_file (l_file)
			else
				create l_warn.make_with_text ("Cannot read pixmap file:%N" + l_file + ".%NPlease make sure the installation is not corrupted.")
				l_warn.show

					-- Fail safe, use blank pixmap
				create raw_buffer.make_with_size ((width * pixel_width) + 1,(height * pixel_height) + 1)
			end
		rescue
			retried := True
			retry
		end

feature -- Access

	toolbar_close_icon: EV_PIXMAP is
			-- Access to 'close' pixmap.
		once
			Result := pixmap_from_coords (1, 1)
		end

	toolbar_close_buffer: EV_PIXEL_BUFFER is
			-- Access to 'close' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 1)
		end

	toolbar_minimize_icon: EV_PIXMAP is
			-- Access to 'minimize' pixmap.
		once
			Result := pixmap_from_coords (2, 1)
		end

	toolbar_minimize_buffer: EV_PIXEL_BUFFER is
			-- Access to 'minimize' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 1)
		end

	toolbar_maximize_icon: EV_PIXMAP is
			-- Access to 'maximize' pixmap.
		once
			Result := pixmap_from_coords (3, 1)
		end

	toolbar_maximize_buffer: EV_PIXEL_BUFFER is
			-- Access to 'maximize' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 1)
		end

	toolbar_restore_icon: EV_PIXMAP is
			-- Access to 'restore' pixmap.
		once
			Result := pixmap_from_coords (4, 1)
		end

	toolbar_restore_buffer: EV_PIXEL_BUFFER is
			-- Access to 'restore' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 1)
		end

	toolbar_pinned_icon: EV_PIXMAP is
			-- Access to 'pinned' pixmap.
		once
			Result := pixmap_from_coords (5, 1)
		end

	toolbar_pinned_buffer: EV_PIXEL_BUFFER is
			-- Access to 'pinned' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (5, 1)
		end

	toolbar_unpinned_icon: EV_PIXMAP is
			-- Access to 'unpinned' pixmap.
		once
			Result := pixmap_from_coords (6, 1)
		end

	toolbar_unpinned_buffer: EV_PIXEL_BUFFER is
			-- Access to 'unpinned' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (6, 1)
		end

	toolbar_expand_icon: EV_PIXMAP is
			-- Access to 'expand' pixmap.
		once
			Result := pixmap_from_coords (7, 1)
		end

	toolbar_expand_buffer: EV_PIXEL_BUFFER is
			-- Access to 'expand' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (7, 1)
		end

	toolbar_dropdown_icon: EV_PIXMAP is
			-- Access to 'dropdown' pixmap.
		once
			Result := pixmap_from_coords (8, 1)
		end

	toolbar_dropdown_buffer: EV_PIXEL_BUFFER is
			-- Access to 'dropdown' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (8, 1)
		end

	sort_accending_icon: EV_PIXMAP is
			-- Access to 'accending' pixmap.
		once
			Result := pixmap_from_coords (9, 1)
		end

	sort_accending_buffer: EV_PIXEL_BUFFER is
			-- Access to 'accending' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (9, 1)
		end

	sort_descending_icon: EV_PIXMAP is
			-- Access to 'descending' pixmap.
		once
			Result := pixmap_from_coords (10, 1)
		end

	sort_descending_buffer: EV_PIXEL_BUFFER is
			-- Access to 'descending' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (10, 1)
		end

	sort_group_icon: EV_PIXMAP is
			-- Access to 'group' pixmap.
		once
			Result := pixmap_from_coords (11, 1)
		end

	sort_group_buffer: EV_PIXEL_BUFFER is
			-- Access to 'group' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (11, 1)
		end

	general_blank_icon: EV_PIXMAP is
			-- Access to 'blank' pixmap.
		once
			Result := pixmap_from_coords (1, 2)
		end

	general_blank_buffer: EV_PIXEL_BUFFER is
			-- Access to 'blank' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 2)
		end

	general_save_icon: EV_PIXMAP is
			-- Access to 'save' pixmap.
		once
			Result := pixmap_from_coords (2, 2)
		end

	general_save_buffer: EV_PIXEL_BUFFER is
			-- Access to 'save' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 2)
		end

	general_add_icon: EV_PIXMAP is
			-- Access to 'add' pixmap.
		once
			Result := pixmap_from_coords (3, 2)
		end

	general_add_buffer: EV_PIXEL_BUFFER is
			-- Access to 'add' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 2)
		end

	general_edit_icon: EV_PIXMAP is
			-- Access to 'edit' pixmap.
		once
			Result := pixmap_from_coords (4, 2)
		end

	general_edit_buffer: EV_PIXEL_BUFFER is
			-- Access to 'edit' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 2)
		end

	general_delete_icon: EV_PIXMAP is
			-- Access to 'delete' pixmap.
		once
			Result := pixmap_from_coords (5, 2)
		end

	general_delete_buffer: EV_PIXEL_BUFFER is
			-- Access to 'delete' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (5, 2)
		end

	general_copy_icon: EV_PIXMAP is
			-- Access to 'copy' pixmap.
		once
			Result := pixmap_from_coords (6, 2)
		end

	general_copy_buffer: EV_PIXEL_BUFFER is
			-- Access to 'copy' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (6, 2)
		end

	general_search_icon: EV_PIXMAP is
			-- Access to 'search' pixmap.
		once
			Result := pixmap_from_coords (7, 2)
		end

	general_search_buffer: EV_PIXEL_BUFFER is
			-- Access to 'search' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (7, 2)
		end

	general_previous_icon: EV_PIXMAP is
			-- Access to 'previous' pixmap.
		once
			Result := pixmap_from_coords (8, 2)
		end

	general_previous_buffer: EV_PIXEL_BUFFER is
			-- Access to 'previous' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (8, 2)
		end

	general_next_icon: EV_PIXMAP is
			-- Access to 'next' pixmap.
		once
			Result := pixmap_from_coords (9, 2)
		end

	general_next_buffer: EV_PIXEL_BUFFER is
			-- Access to 'next' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (9, 2)
		end

	general_up_icon: EV_PIXMAP is
			-- Access to 'up' pixmap.
		once
			Result := pixmap_from_coords (10, 2)
		end

	general_up_buffer: EV_PIXEL_BUFFER is
			-- Access to 'up' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (10, 2)
		end

	general_down_icon: EV_PIXMAP is
			-- Access to 'down' pixmap.
		once
			Result := pixmap_from_coords (11, 2)
		end

	general_down_buffer: EV_PIXEL_BUFFER is
			-- Access to 'down' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (11, 2)
		end

	general_toogle_icon: EV_PIXMAP is
			-- Access to 'toogle' pixmap.
		once
			Result := pixmap_from_coords (12, 2)
		end

	general_toogle_buffer: EV_PIXEL_BUFFER is
			-- Access to 'toogle' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (12, 2)
		end

	debugger_callstack_depth_icon: EV_PIXMAP is
			-- Access to 'callstack depth' pixmap.
		once
			Result := pixmap_from_coords (1, 3)
		end

	debugger_callstack_depth_buffer: EV_PIXEL_BUFFER is
			-- Access to 'callstack depth' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 3)
		end

	debugger_error_icon: EV_PIXMAP is
			-- Access to 'error' pixmap.
		once
			Result := pixmap_from_coords (2, 3)
		end

	debugger_error_buffer: EV_PIXEL_BUFFER is
			-- Access to 'error' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 3)
		end

	debugger_expand_info_icon: EV_PIXMAP is
			-- Access to 'expand info' pixmap.
		once
			Result := pixmap_from_coords (3, 3)
		end

	debugger_expand_info_buffer: EV_PIXEL_BUFFER is
			-- Access to 'expand info' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 3)
		end

	debugger_set_sizes_icon: EV_PIXMAP is
			-- Access to 'set sizes' pixmap.
		once
			Result := pixmap_from_coords (4, 3)
		end

	debugger_set_sizes_buffer: EV_PIXEL_BUFFER is
			-- Access to 'set sizes' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 3)
		end

	debugger_show_hex_value_icon: EV_PIXMAP is
			-- Access to 'show hex value' pixmap.
		once
			Result := pixmap_from_coords (5, 3)
		end

	debugger_show_hex_value_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show hex value' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (5, 3)
		end

	breakpoints_enable_icon: EV_PIXMAP is
			-- Access to 'enable' pixmap.
		once
			Result := pixmap_from_coords (6, 3)
		end

	breakpoints_enable_buffer: EV_PIXEL_BUFFER is
			-- Access to 'enable' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (6, 3)
		end

	breakpoints_disable_icon: EV_PIXMAP is
			-- Access to 'disable' pixmap.
		once
			Result := pixmap_from_coords (7, 3)
		end

	breakpoints_disable_buffer: EV_PIXEL_BUFFER is
			-- Access to 'disable' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (7, 3)
		end

	new_feature_icon: EV_PIXMAP is
			-- Access to 'feature' pixmap.
		once
			Result := pixmap_from_coords (1, 4)
		end

	new_feature_buffer: EV_PIXEL_BUFFER is
			-- Access to 'feature' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 4)
		end

	new_class_icon: EV_PIXMAP is
			-- Access to 'class' pixmap.
		once
			Result := pixmap_from_coords (2, 4)
		end

	new_class_buffer: EV_PIXEL_BUFFER is
			-- Access to 'class' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 4)
		end

	new_cluster_icon: EV_PIXMAP is
			-- Access to 'cluster' pixmap.
		once
			Result := pixmap_from_coords (3, 4)
		end

	new_cluster_buffer: EV_PIXEL_BUFFER is
			-- Access to 'cluster' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 4)
		end

	new_expression_icon: EV_PIXMAP is
			-- Access to 'expression' pixmap.
		once
			Result := pixmap_from_coords (4, 4)
		end

	new_expression_buffer: EV_PIXEL_BUFFER is
			-- Access to 'expression' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 4)
		end

	new_library_icon: EV_PIXMAP is
			-- Access to 'library' pixmap.
		once
			Result := pixmap_from_coords (5, 4)
		end

	new_library_buffer: EV_PIXEL_BUFFER is
			-- Access to 'library' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (5, 4)
		end

	new_assembly_icon: EV_PIXMAP is
			-- Access to 'assembly' pixmap.
		once
			Result := pixmap_from_coords (6, 4)
		end

	new_assembly_buffer: EV_PIXEL_BUFFER is
			-- Access to 'assembly' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (6, 4)
		end

	completion_remember_size_icon: EV_PIXMAP is
			-- Access to 'remember size' pixmap.
		once
			Result := pixmap_from_coords (1, 5)
		end

	completion_remember_size_buffer: EV_PIXEL_BUFFER is
			-- Access to 'remember size' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 5)
		end

	completion_filter_icon: EV_PIXMAP is
			-- Access to 'filter' pixmap.
		once
			Result := pixmap_from_coords (2, 5)
		end

	completion_filter_buffer: EV_PIXEL_BUFFER is
			-- Access to 'filter' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 5)
		end

	completion_show_disambiguants_icon: EV_PIXMAP is
			-- Access to 'show disambiguants' pixmap.
		once
			Result := pixmap_from_coords (3, 5)
		end

	completion_show_disambiguants_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show disambiguants' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 5)
		end

	completion_show_signature_icon: EV_PIXMAP is
			-- Access to 'show signature' pixmap.
		once
			Result := pixmap_from_coords (4, 5)
		end

	completion_show_signature_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show signature' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 5)
		end

	completion_show_alias_icon: EV_PIXMAP is
			-- Access to 'show alias' pixmap.
		once
			Result := pixmap_from_coords (5, 5)
		end

	completion_show_alias_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show alias' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (5, 5)
		end

	completion_show_return_type_icon: EV_PIXMAP is
			-- Access to 'show return type' pixmap.
		once
			Result := pixmap_from_coords (6, 5)
		end

	completion_show_return_type_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show return type' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (6, 5)
		end

	completion_show_assigner_icon: EV_PIXMAP is
			-- Access to 'show assigner' pixmap.
		once
			Result := pixmap_from_coords (7, 5)
		end

	completion_show_assigner_buffer: EV_PIXEL_BUFFER is
			-- Access to 'show assigner' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (7, 5)
		end

	bon_persistent_icon: EV_PIXMAP is
			-- Access to 'persistent' pixmap.
		once
			Result := pixmap_from_coords (1, 6)
		end

	bon_persistent_buffer: EV_PIXEL_BUFFER is
			-- Access to 'persistent' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (1, 6)
		end

	bon_interfaces_icon: EV_PIXMAP is
			-- Access to 'interfaces' pixmap.
		once
			Result := pixmap_from_coords (2, 6)
		end

	bon_interfaces_buffer: EV_PIXEL_BUFFER is
			-- Access to 'interfaces' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (2, 6)
		end

	bon_effective_icon: EV_PIXMAP is
			-- Access to 'effective' pixmap.
		once
			Result := pixmap_from_coords (3, 6)
		end

	bon_effective_buffer: EV_PIXEL_BUFFER is
			-- Access to 'effective' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (3, 6)
		end

	bon_deferred_icon: EV_PIXMAP is
			-- Access to 'deferred' pixmap.
		once
			Result := pixmap_from_coords (4, 6)
		end

	bon_deferred_buffer: EV_PIXEL_BUFFER is
			-- Access to 'deferred' pixmap pixel buffer.
		once
			Result := pixel_buffer_from_coords (4, 6)
		end


feature {NONE} -- Access

	pixel_width: INTEGER is 10
			-- Element width

	pixel_height: INTEGER is 10
			-- Element width

	width: INTEGER is 12
			-- Matrix width

	height: INTEGER is 6
			-- Matrix height

feature {NONE} -- Query

	frozen pixmap_from_coords (a_x: INTEGER; a_y: INTEGER): EV_PIXMAP is
			-- Retrieves a pixmap from matrix coordinates `a_x', `a_y'	
		require
			a_x_positive: a_x > 0
			a_x_small_enough: a_x <= width
			a_y_positive: a_y > 0
			a_y_small_enough: a_y <= height
		local
			l_x_offset: INTEGER
			l_y_offset: INTEGER
			l_pw: INTEGER
			l_ph: INTEGER
			l_rectangle: like rectangle
		do
			l_pw := pixel_width
			l_ph := pixel_height
			l_x_offset := ((a_x - 1) * (l_pw + 1)) + 1
			l_y_offset := ((a_y - 1) * (l_ph + 1)) + 1

			l_rectangle := rectangle
			l_rectangle.set_x (l_x_offset)
			l_rectangle.set_y (l_y_offset)
			l_rectangle.set_width (l_pw)
			l_rectangle.set_height (l_ph)
			Result := raw_matrix.implementation.sub_pixmap (l_rectangle)
		ensure
			result_attached: Result /= Void
		end

	frozen pixel_buffer_from_coords (a_x: INTEGER; a_y: INTEGER): EV_PIXEL_BUFFER is
			-- Retrieves a pixmap from matrix coordinates `a_x', `a_y'	
		require
			a_x_positive: a_x > 0
			a_x_small_enough: a_x <= width
			a_y_positive: a_y > 0
			a_y_small_enough: a_x <= height
		local
			l_x_offset: INTEGER
			l_y_offset: INTEGER
			l_pw: INTEGER
			l_ph: INTEGER
			l_rectangle: like rectangle
		do
			l_pw := pixel_width
			l_ph := pixel_height
			l_x_offset := ((a_x - 1) * (l_pw + 1)) + 1
			l_y_offset := ((a_y - 1) * (l_ph + 1)) + 1

			l_rectangle := rectangle
			l_rectangle.set_x (l_x_offset)
			l_rectangle.set_y (l_y_offset)
			l_rectangle.set_width (l_pw)
			l_rectangle.set_height (l_ph)

			Result := raw_buffer.sub_pixel_buffer (l_rectangle)
		ensure
			result_attached: Result /= Void
		end

feature {NONE} -- Implementation


	raw_matrix: EV_PIXMAP is
				-- raw matrix pixmap
			once
				create Result
				raw_buffer.draw_on_to (Result)
			ensure
				result_attached: Result /= Void
			end

	raw_buffer: EV_PIXEL_BUFFER
			-- raw matrix pixel buffer

	frozen rectangle: EV_RECTANGLE is
			-- Reusable rectangle for `pixmap_from_constant'.
		once
			create Result
		end

invariant
	raw_buffer_attached: raw_buffer /= Void

indexing
	copyright: "Copyright (c) 1984-2006, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
		Eiffel Software
		356 Storke Road, Goleta, CA 93117 USA
		Telephone 805-685-1006, Fax 805-685-6869
		Website http://www.eiffel.com
		Customer support http://support.eiffel.com
	]"

end -- class {ES_PIXMAPS_10X10}
