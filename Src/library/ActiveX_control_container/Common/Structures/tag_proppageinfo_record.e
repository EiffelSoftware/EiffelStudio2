indexing
	description: "Control interfaces. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	TAG_PROPPAGEINFO_RECORD

inherit
	ECOM_STRUCTURE
		redefine
			make
		end

creation
	make,
	make_from_pointer

feature {NONE}  -- Initialization

	make is
			-- Make.
		do
			Precursor {ECOM_STRUCTURE}
		end

	make_from_pointer (a_pointer: POINTER) is
			-- Make from pointer.
		do
			make_by_pointer (a_pointer)
		end

feature -- Access

	cb: INTEGER is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_cb (item)
		end

	psz_title: STRING is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_psz_title (item)
		end

	size: TAG_SIZE_RECORD is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_size (item)
		ensure
			valid_size: Result.item /= default_pointer
		end

	psz_doc_string: STRING is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_psz_doc_string (item)
		end

	psz_help_file: STRING is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_psz_help_file (item)
		end

	dw_help_context: INTEGER is
			-- No description available.
		do
			Result := ccom_tag_proppageinfo_dw_help_context (item)
		end

feature -- Measurement

	structure_size: INTEGER is
			-- Size of structure
		do
			Result := c_size_of_tag_proppageinfo
		end

feature -- Basic Operations

	set_cb (a_cb: INTEGER) is
			-- Set `cb' with `a_cb'.
		do
			ccom_tag_proppageinfo_set_cb (item, a_cb)
		end

	set_psz_title (a_psz_title: STRING) is
			-- Set `psz_title' with `a_psz_title'.
		do
			ccom_tag_proppageinfo_set_psz_title (item, a_psz_title)
		end

	set_size (a_size: TAG_SIZE_RECORD) is
			-- Set `size' with `a_size'.
		require
			non_void_a_size: a_size /= Void
			valid_a_size: a_size.item /= default_pointer
		do
			ccom_tag_proppageinfo_set_size (item, a_size.item)
		end

	set_psz_doc_string (a_psz_doc_string: STRING) is
			-- Set `psz_doc_string' with `a_psz_doc_string'.
		do
			ccom_tag_proppageinfo_set_psz_doc_string (item, a_psz_doc_string)
		end

	set_psz_help_file (a_psz_help_file: STRING) is
			-- Set `psz_help_file' with `a_psz_help_file'.
		do
			ccom_tag_proppageinfo_set_psz_help_file (item, a_psz_help_file)
		end

	set_dw_help_context (a_dw_help_context: INTEGER) is
			-- Set `dw_help_context' with `a_dw_help_context'.
		do
			ccom_tag_proppageinfo_set_dw_help_context (item, a_dw_help_context)
		end

feature {NONE}  -- Externals

	c_size_of_tag_proppageinfo: INTEGER is
			-- Size of structure
		external
			"C [macro %"ecom_control_library_tagPROPPAGEINFO_s.h%"]"
		alias
			"sizeof(ecom_control_library::tagPROPPAGEINFO)"
		end

	ccom_tag_proppageinfo_cb (a_pointer: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_INTEGER"
		end

	ccom_tag_proppageinfo_set_cb (a_pointer: POINTER; arg2: INTEGER) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, ULONG)"
		end

	ccom_tag_proppageinfo_psz_title (a_pointer: POINTER): STRING is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_REFERENCE"
		end

	ccom_tag_proppageinfo_set_psz_title (a_pointer: POINTER; arg2: STRING) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, EIF_OBJECT)"
		end

	ccom_tag_proppageinfo_size (a_pointer: POINTER): TAG_SIZE_RECORD is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_REFERENCE"
		end

	ccom_tag_proppageinfo_set_size (a_pointer: POINTER; arg2: POINTER) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, ecom_control_library::tagSIZE *)"
		end

	ccom_tag_proppageinfo_psz_doc_string (a_pointer: POINTER): STRING is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_REFERENCE"
		end

	ccom_tag_proppageinfo_set_psz_doc_string (a_pointer: POINTER; arg2: STRING) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, EIF_OBJECT)"
		end

	ccom_tag_proppageinfo_psz_help_file (a_pointer: POINTER): STRING is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_REFERENCE"
		end

	ccom_tag_proppageinfo_set_psz_help_file (a_pointer: POINTER; arg2: STRING) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, EIF_OBJECT)"
		end

	ccom_tag_proppageinfo_dw_help_context (a_pointer: POINTER): INTEGER is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *):EIF_INTEGER"
		end

	ccom_tag_proppageinfo_set_dw_help_context (a_pointer: POINTER; arg2: INTEGER) is
			-- No description available.
		external
			"C++ [macro %"ecom_control_library_tagPROPPAGEINFO_s_impl.h%"](ecom_control_library::tagPROPPAGEINFO *, ULONG)"
		end

end -- TAG_PROPPAGEINFO_RECORD

