indexing
	description: "browse folder library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IFOLDER_BROWSER_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	folder_name_user_precondition (result1: CELL [STRING]): BOOLEAN is
			-- User-defined preconditions for `folder_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_starting_folder_user_precondition (result1: CELL [STRING]): BOOLEAN is
			-- User-defined preconditions for `set_starting_folder'.
			-- Redefine in descendants if needed.
		do
			Result := result1.item /= Void and then not result1.item.is_empty
		end

feature -- Basic Operations

	folder_name (result1: CELL [STRING]) is
			-- Folder chosen by the user.
			-- `result1' [out].  
		require
			non_void_result1: result1 /= Void
			folder_name_user_precondition: folder_name_user_precondition (result1)
		deferred

		ensure
			valid_result1: result1.item /= Void
		end

	set_starting_folder (result1: CELL [STRING]) is
			-- Set initial folder name.
			-- `result1' [in].  
		require
			non_void_result1: result1 /= Void
			valid_result1: result1.item /= Void
			set_starting_folder_user_precondition: set_starting_folder_user_precondition (result1)
		deferred

		end

end -- IFOLDER_BROWSER_INTERFACE

