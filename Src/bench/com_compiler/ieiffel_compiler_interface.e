indexing
	description: "Eiffel Compiler.  Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_COMPILER_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	compile_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compile'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	finalize_user_precondition: BOOLEAN is
			-- User-defined preconditions for `finalize'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_successful_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_successful'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freezing_occurred_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freezing_occurred'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	compiler_version_user_precondition: BOOLEAN is
			-- User-defined preconditions for `compiler_version'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	freeze_command_arguments_user_precondition: BOOLEAN is
			-- User-defined preconditions for `freeze_command_arguments'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	remove_file_locks_user_precondition: BOOLEAN is
			-- User-defined preconditions for `remove_file_locks'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	compile is
			-- Compile.
		require
			compile_user_precondition: compile_user_precondition
		deferred

		end

	finalize is
			-- Finalize.
		require
			finalize_user_precondition: finalize_user_precondition
		deferred

		end

	is_successful: BOOLEAN is
			-- Was last compilation successful?
		require
			is_successful_user_precondition: is_successful_user_precondition
		deferred

		end

	freezing_occurred: BOOLEAN is
			-- Did last compile warrant a call to finish_freezing?
		require
			freezing_occurred_user_precondition: freezing_occurred_user_precondition
		deferred

		end

	compiler_version: STRING is
			-- Compiler version.
		require
			compiler_version_user_precondition: compiler_version_user_precondition
		deferred

		end

	freeze_command_name: STRING is
			-- Eiffel Freeze command name
		require
			freeze_command_name_user_precondition: freeze_command_name_user_precondition
		deferred

		end

	freeze_command_arguments: STRING is
			-- Eiffel Freeze command arguments
		require
			freeze_command_arguments_user_precondition: freeze_command_arguments_user_precondition
		deferred

		end

	remove_file_locks is
			-- Remove file locks
		require
			remove_file_locks_user_precondition: remove_file_locks_user_precondition
		deferred

		end

end -- IEIFFEL_COMPILER_INTERFACE

