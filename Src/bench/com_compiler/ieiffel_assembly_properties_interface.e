indexing
	description: "Eiffel Assembly Properties (for Ace file). Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_ASSEMBLY_PROPERTIES_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	version_user_precondition: BOOLEAN is
			-- User-defined preconditions for `version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	culture_user_precondition: BOOLEAN is
			-- User-defined preconditions for `culture'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	public_key_token_user_precondition: BOOLEAN is
			-- User-defined preconditions for `public_key_token'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_local_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_local'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	cluster_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `cluster_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	prefix1_user_precondition: BOOLEAN is
			-- User-defined preconditions for `prefix1'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_prefix_user_precondition (pbstr_prefix: STRING): BOOLEAN is
			-- User-defined preconditions for `set_prefix'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_prefix_read_only_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_prefix_read_only'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	name: STRING is
			-- Assembly name.
		require
			name_user_precondition: name_user_precondition
		deferred

		end

	version: STRING is
			-- Assembly version.
		require
			version_user_precondition: version_user_precondition
		deferred

		end

	culture: STRING is
			-- Assembly culture.
		require
			culture_user_precondition: culture_user_precondition
		deferred

		end

	public_key_token: STRING is
			-- Assembly public key token
		require
			public_key_token_user_precondition: public_key_token_user_precondition
		deferred

		end

	is_local: BOOLEAN is
			-- Is the assembly local
		require
			is_local_user_precondition: is_local_user_precondition
		deferred

		end

	cluster_name: STRING is
			-- Assembly cluster name.
		require
			cluster_name_user_precondition: cluster_name_user_precondition
		deferred

		end

	prefix1: STRING is
			-- Prefix.
		require
			prefix1_user_precondition: prefix1_user_precondition
		deferred

		end

	set_prefix (pbstr_prefix: STRING) is
			-- Prefix.
			-- `pbstr_prefix' [in].  
		require
			set_prefix_user_precondition: set_prefix_user_precondition (pbstr_prefix)
		deferred

		end

	is_prefix_read_only: BOOLEAN is
			-- Is assembly prefix read only.
		require
			is_prefix_read_only_user_precondition: is_prefix_read_only_user_precondition
		deferred

		end

end -- IEIFFEL_ASSEMBLY_PROPERTIES_INTERFACE

