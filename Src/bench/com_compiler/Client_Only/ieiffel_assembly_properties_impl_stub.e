indexing
	description: "Implemented `IEiffelAssemblyProperties' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_ASSEMBLY_PROPERTIES_IMPL_STUB

inherit
	IEIFFEL_ASSEMBLY_PROPERTIES_INTERFACE

	ECOM_STUB

feature -- Access

	assembly_name: STRING is
			-- Assembly name.
		do
			-- Put Implementation here.
		end

	assembly_version: STRING is
			-- Assembly version.
		do
			-- Put Implementation here.
		end

	assembly_culture: STRING is
			-- Assembly culture.
		do
			-- Put Implementation here.
		end

	assembly_public_key_token: STRING is
			-- Assembly public key token
		do
			-- Put Implementation here.
		end

	is_local: BOOLEAN is
			-- Is the assembly local
		do
			-- Put Implementation here.
		end

	assembly_cluster_name: STRING is
			-- Assembly cluster name.
		do
			-- Put Implementation here.
		end

	assembly_prefix: STRING is
			-- Prefix.
		do
			-- Put Implementation here.
		end

	is_prefix_read_only: BOOLEAN is
			-- Is assembly prefix read only.
		do
			-- Put Implementation here.
		end

feature -- Basic Operations

	set_assembly_prefix (return_value: STRING) is
			-- Prefix.
			-- `return_value' [in].  
		do
			-- Put Implementation here.
		end

	create_item is
			-- Initialize `item'
		do
			item := ccom_create_item (Current)
		end

feature {NONE}  -- Externals

	ccom_create_item (eif_object: IEIFFEL_ASSEMBLY_PROPERTIES_IMPL_STUB): POINTER is
			-- Initialize `item'
		external
			"C++ [new ecom_eiffel_compiler::IEiffelAssemblyProperties_impl_stub %"ecom_eiffel_compiler_IEiffelAssemblyProperties_impl_stub.h%"](EIF_OBJECT)"
		end

end -- IEIFFEL_ASSEMBLY_PROPERTIES_IMPL_STUB

