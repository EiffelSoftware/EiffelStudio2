-- This file has been generated by EWG. Do not edit. Changes will be lost!

class NAV_CBREC_STRUCT

inherit

	EWG_STRUCT

	NAV_CBREC_STRUCT_EXTERNAL
		export
			{NONE} all
		end

creation

	make_new_unshared,
	make_new_shared,
	make_unshared,
	make_shared

feature {NONE} -- Implementation

	sizeof: INTEGER is
		do
			Result := sizeof_external
		end

feature {ANY} -- Member Access

	get_version: INTEGER is
		obsolete "Use `version' instead."
			-- Access member `version'
		require
			exists: exists
		do
			Result := get_version_external (item)
		ensure
			result_correct: Result = get_version_external (item)
		end

	version: INTEGER is
			-- Access member `version'
		require
			exists: exists
		do
			Result := get_version_external (item)
		ensure
			result_correct: Result = get_version_external (item)
		end

	set_version (a_value: INTEGER) is
			-- Set member `version'
		require
			exists: exists
		do
			set_version_external (item, a_value)
		ensure
			a_value_set: a_value = version
		end

	context_struct: NAV_DIALOG_STRUCT is
			-- Access member `context'
		require
			exists: exists
		do
			create Result.make_shared (get_context_external (item))
		ensure
			result_not_void: Result /= Void
			result_has_correct_item: Result.item = context
		end

	set_context_struct (a_value: NAV_DIALOG_STRUCT) is
			-- Set member `context'
		require
			a_value_not_void: a_value /= Void
			exists: exists
		do
			set_context_external (item, a_value.item)
		ensure
			a_value_set: a_value.item = context
		end

	get_context: POINTER is
		obsolete "Use `context' instead."
			-- Access member `context'
		require
			exists: exists
		do
			Result := get_context_external (item)
		ensure
			result_correct: Result = get_context_external (item)
		end

	context: POINTER is
			-- Access member `context'
		require
			exists: exists
		do
			Result := get_context_external (item)
		ensure
			result_correct: Result = get_context_external (item)
		end

	set_context (a_value: POINTER) is
			-- Set member `context'
		require
			exists: exists
		do
			set_context_external (item, a_value)
		ensure
			a_value_set: a_value = context
		end

	window_struct: OPAQUE_WINDOW_PTR_STRUCT is
			-- Access member `window'
		require
			exists: exists
		do
			create Result.make_shared (get_window_external (item))
		ensure
			result_not_void: Result /= Void
			result_has_correct_item: Result.item = window
		end

	set_window_struct (a_value: OPAQUE_WINDOW_PTR_STRUCT) is
			-- Set member `window'
		require
			a_value_not_void: a_value /= Void
			exists: exists
		do
			set_window_external (item, a_value.item)
		ensure
			a_value_set: a_value.item = window
		end

	get_window: POINTER is
		obsolete "Use `window' instead."
			-- Access member `window'
		require
			exists: exists
		do
			Result := get_window_external (item)
		ensure
			result_correct: Result = get_window_external (item)
		end

	window: POINTER is
			-- Access member `window'
		require
			exists: exists
		do
			Result := get_window_external (item)
		ensure
			result_correct: Result = get_window_external (item)
		end

	set_window (a_value: POINTER) is
			-- Set member `window'
		require
			exists: exists
		do
			set_window_external (item, a_value)
		ensure
			a_value_set: a_value = window
		end

	get_customrect: POINTER is
		obsolete "Use `customrect' instead."
			-- Access member `customRect'
		require
			exists: exists
		do
			Result := get_customrect_external (item)
		ensure
			result_correct: Result = get_customrect_external (item)
		end

	customrect: POINTER is
			-- Access member `customRect'
		require
			exists: exists
		do
			Result := get_customrect_external (item)
		ensure
			result_correct: Result = get_customrect_external (item)
		end

	set_customrect (a_value: POINTER) is
			-- Set member `customRect'
		require
			exists: exists
		do
			set_customrect_external (item, a_value)
		end

	get_previewrect: POINTER is
		obsolete "Use `previewrect' instead."
			-- Access member `previewRect'
		require
			exists: exists
		do
			Result := get_previewrect_external (item)
		ensure
			result_correct: Result = get_previewrect_external (item)
		end

	previewrect: POINTER is
			-- Access member `previewRect'
		require
			exists: exists
		do
			Result := get_previewrect_external (item)
		ensure
			result_correct: Result = get_previewrect_external (item)
		end

	set_previewrect (a_value: POINTER) is
			-- Set member `previewRect'
		require
			exists: exists
		do
			set_previewrect_external (item, a_value)
		end

	get_eventdata: POINTER is
		obsolete "Use `eventdata' instead."
			-- Access member `eventData'
		require
			exists: exists
		do
			Result := get_eventdata_external (item)
		ensure
			result_correct: Result = get_eventdata_external (item)
		end

	eventdata: POINTER is
			-- Access member `eventData'
		require
			exists: exists
		do
			Result := get_eventdata_external (item)
		ensure
			result_correct: Result = get_eventdata_external (item)
		end

	set_eventdata (a_value: POINTER) is
			-- Set member `eventData'
		require
			exists: exists
		do
			set_eventdata_external (item, a_value)
		end

	get_useraction: INTEGER is
		obsolete "Use `useraction' instead."
			-- Access member `userAction'
		require
			exists: exists
		do
			Result := get_useraction_external (item)
		ensure
			result_correct: Result = get_useraction_external (item)
		end

	useraction: INTEGER is
			-- Access member `userAction'
		require
			exists: exists
		do
			Result := get_useraction_external (item)
		ensure
			result_correct: Result = get_useraction_external (item)
		end

	set_useraction (a_value: INTEGER) is
			-- Set member `userAction'
		require
			exists: exists
		do
			set_useraction_external (item, a_value)
		ensure
			a_value_set: a_value = useraction
		end

	get_reserved: POINTER is
		obsolete "Use `reserved' instead."
			-- Access member `reserved'
		require
			exists: exists
		do
			Result := get_reserved_external (item)
		ensure
			result_correct: Result = get_reserved_external (item)
		end

	reserved: POINTER is
			-- Access member `reserved'
		require
			exists: exists
		do
			Result := get_reserved_external (item)
		ensure
			result_correct: Result = get_reserved_external (item)
		end

end
