-- This file has been generated by EWG. Do not edit. Changes will be lost!

class COLOR_PICKER_INFO_STRUCT

inherit

	EWG_STRUCT

	COLOR_PICKER_INFO_STRUCT_EXTERNAL
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

	get_thecolor: POINTER is
		obsolete "Use `thecolor' instead."
			-- Access member `theColor'
		require
			exists: exists
		do
			Result := get_thecolor_external (item)
		ensure
			result_correct: Result = get_thecolor_external (item)
		end

	thecolor: POINTER is
			-- Access member `theColor'
		require
			exists: exists
		do
			Result := get_thecolor_external (item)
		ensure
			result_correct: Result = get_thecolor_external (item)
		end

	set_thecolor (a_value: POINTER) is
			-- Set member `theColor'
		require
			exists: exists
		do
			set_thecolor_external (item, a_value)
		end

	get_dstprofile: POINTER is
		obsolete "Use `dstprofile' instead."
			-- Access member `dstProfile'
		require
			exists: exists
		do
			Result := get_dstprofile_external (item)
		ensure
			result_correct: Result = get_dstprofile_external (item)
		end

	dstprofile: POINTER is
			-- Access member `dstProfile'
		require
			exists: exists
		do
			Result := get_dstprofile_external (item)
		ensure
			result_correct: Result = get_dstprofile_external (item)
		end

	set_dstprofile (a_value: POINTER) is
			-- Set member `dstProfile'
		require
			exists: exists
		do
			set_dstprofile_external (item, a_value)
		ensure
			a_value_set: a_value = dstprofile
		end

	get_flags: INTEGER is
		obsolete "Use `flags' instead."
			-- Access member `flags'
		require
			exists: exists
		do
			Result := get_flags_external (item)
		ensure
			result_correct: Result = get_flags_external (item)
		end

	flags: INTEGER is
			-- Access member `flags'
		require
			exists: exists
		do
			Result := get_flags_external (item)
		ensure
			result_correct: Result = get_flags_external (item)
		end

	set_flags (a_value: INTEGER) is
			-- Set member `flags'
		require
			exists: exists
		do
			set_flags_external (item, a_value)
		ensure
			a_value_set: a_value = flags
		end

	get_placewhere: INTEGER is
		obsolete "Use `placewhere' instead."
			-- Access member `placeWhere'
		require
			exists: exists
		do
			Result := get_placewhere_external (item)
		ensure
			result_correct: Result = get_placewhere_external (item)
		end

	placewhere: INTEGER is
			-- Access member `placeWhere'
		require
			exists: exists
		do
			Result := get_placewhere_external (item)
		ensure
			result_correct: Result = get_placewhere_external (item)
		end

	set_placewhere (a_value: INTEGER) is
			-- Set member `placeWhere'
		require
			exists: exists
		do
			set_placewhere_external (item, a_value)
		ensure
			a_value_set: a_value = placewhere
		end

	get_dialogorigin: POINTER is
		obsolete "Use `dialogorigin' instead."
			-- Access member `dialogOrigin'
		require
			exists: exists
		do
			Result := get_dialogorigin_external (item)
		ensure
			result_correct: Result = get_dialogorigin_external (item)
		end

	dialogorigin: POINTER is
			-- Access member `dialogOrigin'
		require
			exists: exists
		do
			Result := get_dialogorigin_external (item)
		ensure
			result_correct: Result = get_dialogorigin_external (item)
		end

	set_dialogorigin (a_value: POINTER) is
			-- Set member `dialogOrigin'
		require
			exists: exists
		do
			set_dialogorigin_external (item, a_value)
		end

	get_pickertype: INTEGER is
		obsolete "Use `pickertype' instead."
			-- Access member `pickerType'
		require
			exists: exists
		do
			Result := get_pickertype_external (item)
		ensure
			result_correct: Result = get_pickertype_external (item)
		end

	pickertype: INTEGER is
			-- Access member `pickerType'
		require
			exists: exists
		do
			Result := get_pickertype_external (item)
		ensure
			result_correct: Result = get_pickertype_external (item)
		end

	set_pickertype (a_value: INTEGER) is
			-- Set member `pickerType'
		require
			exists: exists
		do
			set_pickertype_external (item, a_value)
		ensure
			a_value_set: a_value = pickertype
		end

	get_eventproc: POINTER is
		obsolete "Use `eventproc' instead."
			-- Access member `eventProc'
		require
			exists: exists
		do
			Result := get_eventproc_external (item)
		ensure
			result_correct: Result = get_eventproc_external (item)
		end

	eventproc: POINTER is
			-- Access member `eventProc'
		require
			exists: exists
		do
			Result := get_eventproc_external (item)
		ensure
			result_correct: Result = get_eventproc_external (item)
		end

	set_eventproc (a_value: POINTER) is
			-- Set member `eventProc'
		require
			exists: exists
		do
			set_eventproc_external (item, a_value)
		ensure
			a_value_set: a_value = eventproc
		end

-- TODO: function pointers not yet callable from
--		struct, use corresponding callback class instead
	get_colorproc: POINTER is
		obsolete "Use `colorproc' instead."
			-- Access member `colorProc'
		require
			exists: exists
		do
			Result := get_colorproc_external (item)
		ensure
			result_correct: Result = get_colorproc_external (item)
		end

	colorproc: POINTER is
			-- Access member `colorProc'
		require
			exists: exists
		do
			Result := get_colorproc_external (item)
		ensure
			result_correct: Result = get_colorproc_external (item)
		end

	set_colorproc (a_value: POINTER) is
			-- Set member `colorProc'
		require
			exists: exists
		do
			set_colorproc_external (item, a_value)
		ensure
			a_value_set: a_value = colorproc
		end

-- TODO: function pointers not yet callable from
--		struct, use corresponding callback class instead
	get_colorprocdata: INTEGER is
		obsolete "Use `colorprocdata' instead."
			-- Access member `colorProcData'
		require
			exists: exists
		do
			Result := get_colorprocdata_external (item)
		ensure
			result_correct: Result = get_colorprocdata_external (item)
		end

	colorprocdata: INTEGER is
			-- Access member `colorProcData'
		require
			exists: exists
		do
			Result := get_colorprocdata_external (item)
		ensure
			result_correct: Result = get_colorprocdata_external (item)
		end

	set_colorprocdata (a_value: INTEGER) is
			-- Set member `colorProcData'
		require
			exists: exists
		do
			set_colorprocdata_external (item, a_value)
		ensure
			a_value_set: a_value = colorprocdata
		end

	get_prompt: POINTER is
		obsolete "Use `prompt' instead."
			-- Access member `prompt'
		require
			exists: exists
		do
			Result := get_prompt_external (item)
		ensure
			result_correct: Result = get_prompt_external (item)
		end

	prompt: POINTER is
			-- Access member `prompt'
		require
			exists: exists
		do
			Result := get_prompt_external (item)
		ensure
			result_correct: Result = get_prompt_external (item)
		end

	get_minfo: POINTER is
		obsolete "Use `minfo' instead."
			-- Access member `mInfo'
		require
			exists: exists
		do
			Result := get_minfo_external (item)
		ensure
			result_correct: Result = get_minfo_external (item)
		end

	minfo: POINTER is
			-- Access member `mInfo'
		require
			exists: exists
		do
			Result := get_minfo_external (item)
		ensure
			result_correct: Result = get_minfo_external (item)
		end

	set_minfo (a_value: POINTER) is
			-- Set member `mInfo'
		require
			exists: exists
		do
			set_minfo_external (item, a_value)
		end

	get_newcolorchosen: INTEGER is
		obsolete "Use `newcolorchosen' instead."
			-- Access member `newColorChosen'
		require
			exists: exists
		do
			Result := get_newcolorchosen_external (item)
		ensure
			result_correct: Result = get_newcolorchosen_external (item)
		end

	newcolorchosen: INTEGER is
			-- Access member `newColorChosen'
		require
			exists: exists
		do
			Result := get_newcolorchosen_external (item)
		ensure
			result_correct: Result = get_newcolorchosen_external (item)
		end

	set_newcolorchosen (a_value: INTEGER) is
			-- Set member `newColorChosen'
		require
			exists: exists
		do
			set_newcolorchosen_external (item, a_value)
		ensure
			a_value_set: a_value = newcolorchosen
		end

	get_filler: INTEGER is
		obsolete "Use `filler' instead."
			-- Access member `filler'
		require
			exists: exists
		do
			Result := get_filler_external (item)
		ensure
			result_correct: Result = get_filler_external (item)
		end

	filler: INTEGER is
			-- Access member `filler'
		require
			exists: exists
		do
			Result := get_filler_external (item)
		ensure
			result_correct: Result = get_filler_external (item)
		end

	set_filler (a_value: INTEGER) is
			-- Set member `filler'
		require
			exists: exists
		do
			set_filler_external (item, a_value)
		ensure
			a_value_set: a_value = filler
		end

end
