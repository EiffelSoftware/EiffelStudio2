indexing
	description: "Implemented `IEiffelSystemAssemblies' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB

inherit
	IEIFFEL_SYSTEM_ASSEMBLIES_INTERFACE

	ECOM_STUB

feature -- Access

	last_exception: IEIFFEL_EXCEPTION_INTERFACE is
			-- Last execption to occur
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	flush_assemblies is
			-- Wipe out current list of assemblies
		do
			-- Put Implementation here.
		end

	add_assembly (bstr_prefix: STRING; bstr_cluster_name: STRING; bstr_file_name: STRING; vb_copy_locally: BOOLEAN) is
			-- Add an assembly to the project.
			-- `bstr_prefix' [in].  
			-- `bstr_cluster_name' [in].  
			-- `bstr_file_name' [in].  
			-- `vb_copy_locally' [out].  
		do
			-- Put Implementation here.
		end

	store is
			-- Save changes.
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelSystemAssemblies_impl_stub %"ecom_EiffelComCompiler_IEiffelSystemAssemblies_impl_stub_s.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_SYSTEM_ASSEMBLIES_IMPL_STUB

