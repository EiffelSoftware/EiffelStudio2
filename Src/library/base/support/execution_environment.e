indexing

	description:
		"The objects available from the environment at time of execution";

	status: "See notice at end of class";
	date: "$Date$";
	revision: "$Revision$"


class EXECUTION_ENVIRONMENT

feature -- Access

	command_line: ARGUMENTS is
			-- Command line that was used to start current execution
		once
			!!Result
		end

	current_working_directory: STRING is
			-- Directory of current execution
		external
			"C | <dir.h>"
		alias
			"dir_current"
		end

	default_shell: STRING is
			-- Default shell
		once
			Result := get ("SHELL")
			if Result = Void then
				Result := ""
			end
		end

	get (s: STRING): STRING is
			-- Value of `s' if it is an environment variable and has been set;
			-- void otherwise.
		require
			s_exists: s /= Void
		local
			ext: ANY;
			c_string: POINTER;
			void_pointer: POINTER
		do
			ext := s.to_c
			c_string := eif_getenv($ext)
			if c_string /= void_pointer then
				!!Result.make (0)
				Result.from_c (c_string)
			end
		end

	home_directory_name: STRING is
			-- Directory name corresponding to the home directory.
		require
			home_directory_supported: Operating_environment.home_directory_supported
		do
			Result := eif_home_directory_name
		end

	root_directory_name: STRING is
			-- Directory name corresponding to the root directory.
		require
			root_directory_supported: Operating_environment.root_directory_supported
		do
			Result := eif_home_directory_name
		end

feature -- Status

	return_code : INTEGER
			-- Status code set by last call to `system' or `put'

feature -- Status setting

	change_working_directory (path: STRING) is
			-- Set the current directory to `path'
		do
			return_code := eif_chdir (path.to_c)
		end

	put (value,key: STRING) is
			-- Set the environment variable `key' to `value'.
		require
			key_exists: key /= Void
			key_meaningful: key.count > 0
			value_exists: value /= Void
		local
			v_to_c, k_to_c: ANY;
		do
			v_to_c := value.to_c
			k_to_c := key.to_c
			return_code := eif_putenv(v_to_c, k_to_c)
		ensure
			variable_set: (return_code = 0) implies (value.is_equal (get (key)))
		end

	system (s: STRING) is
			-- Pass to the operating system a request to execute `s'.
			-- If `s' is empty, use the default shell as command.
		require
			s_exists: s /= Void
		local
			ext : ANY
		do
			if s.empty then
				ext := default_shell.to_c
			else
				ext := s.to_c
			end
			return_code := system_call ($ext)
		end

feature {NONE} -- External

	eif_getenv (s : POINTER): POINTER is
			-- Value of environment variable `s'
		external
			"C | <misc.h>"
		end

	eif_putenv (v, k: ANY): INTEGER is
			-- Set `s' in the environment.
		external
			"C | <misc.h>"
		end

	eif_chdir (s: ANY): INTEGER is
			-- Set the current directory to `path'
		external
			"C | <dir.h>"
		end;

	system_call (s : POINTER): INTEGER is
			-- Pass to the operating system a request to execute `s'.
		external
			"C | <misc.h>"
		alias
			"eif_system"
		end

	eif_home_directory_name: STRING is
			-- Directory name corresponding to the home directory
		external
			"C | <path_name.h>"
		end

	eif_root_directory_name: STRING is
			-- Directory name corresponding to the root directory
		external
			"C | <path_name.h>"
		end

end -- class EXECUTION_ENVIRONMENT



--|----------------------------------------------------------------
--| EiffelBase: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1997 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
