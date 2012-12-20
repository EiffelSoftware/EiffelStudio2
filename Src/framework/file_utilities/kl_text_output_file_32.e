note
	description: "Same as {KL_TEXT_OUTPUT_FILE} with names in {STRING_32}."
	date: "$Date$"
	revision: "$Revision$"

class
	KL_TEXT_OUTPUT_FILE_32

inherit
	KL_TEXT_OUTPUT_FILE
		rename
			make as kl_make,
			make_with_name as make
		export
			{ANY} path
		redefine
			make
		end

create
	make, make_with_path

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_GENERAL)
			-- Create a new file named `a_name'.
			-- (`a_name' should follow the pathname convention
			-- of the underlying platform. For pathname conversion
			-- use KI_FILE_SYSTEM.pathname_from_file_system.)
		local
			u: UTF_CONVERTER
		do
			name := u.utf_32_string_to_utf_8_string_8 (a_name)
			Precursor (a_name)
		end

;note
	copyright: "Copyright (c) 2012, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
