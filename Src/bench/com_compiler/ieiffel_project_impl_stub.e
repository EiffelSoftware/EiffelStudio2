indexing
	description: "Implemented `IEiffelProject' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_PROJECT_IMPL_STUB

inherit
	IEIFFEL_PROJECT_INTERFACE

	ECOM_STUB

feature -- Access

	project_file_name: STRING is
			-- Full path to .epr file.
		do
			-- Put Implementation here.
		end

	ace_file_name: STRING is
			-- Full path to Ace file.
		do
			-- Put Implementation here.
		end

	project_directory: STRING is
			-- Project directory.
		do
			-- Put Implementation here.
		end

	is_valid_project: BOOLEAN is
			-- Is project valid?
		do
			-- Put Implementation here.
		end

	last_exception: IEIFFEL_EXCEPTION_INTERFACE is
			-- Last exception raised
		do
			-- Put Implementation here.
		end

	compiler: IEIFFEL_COMPILER_INTERFACE is
			-- Compiler.
		do
			-- Put Implementation here.
		end

	is_compiled: BOOLEAN is
			-- Has system been compiled?
		do
			-- Put Implementation here.
		end

	project_has_updated: BOOLEAN is
			-- Has the project updated since last compilation?
		do
			-- Put Implementation here.
		end

	system_browser: IEIFFEL_SYSTEM_BROWSER_INTERFACE is
			-- System Browser.
		do
			-- Put Implementation here.
		end

	project_properties: IEIFFEL_PROJECT_PROPERTIES_INTERFACE is
			-- Project Properties.
		do
			-- Put Implementation here.
		end

	completion_information: IEIFFEL_COMPLETION_INFO_INTERFACE is
			-- Completion information
		do
			-- Put Implementation here.
		end

	html_documentation_generator: IEIFFEL_HTML_DOCUMENTATION_GENERATOR_INTERFACE is
			-- Help documentation generator
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	retrieve_eiffel_project (bstr_project_file_name: STRING) is
			-- Retrieve Eiffel Project
			-- `bstr_project_file_name' [in].  
		do
			-- Put Implementation here.
		end

	create_eiffel_project (bstr_ace_file_name: STRING; bstr_project_directory: STRING) is
			-- Create new Eiffel project from an existing ace file.
			-- `bstr_ace_file_name' [in].  
			-- `bstr_project_directory' [in].  
		do
			-- Put Implementation here.
		end

	generate_new_eiffel_project (bstr_project_name: STRING; bstr_ace_file_name: STRING; bstr_root_class_name: STRING; bstr_creation_routine: STRING; bstr_project_directory: STRING) is
			-- Create new Eiffel project from scratch.
			-- `bstr_project_name' [in].  
			-- `bstr_ace_file_name' [in].  
			-- `bstr_root_class_name' [in].  
			-- `bstr_creation_routine' [in].  
			-- `bstr_project_directory' [in].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_PROJECT_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelProject_impl_stub %"ecom_EiffelComCompiler_IEiffelProject_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_PROJECT_IMPL_STUB

