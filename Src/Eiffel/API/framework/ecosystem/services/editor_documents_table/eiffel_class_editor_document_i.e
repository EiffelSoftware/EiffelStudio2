note
	description: "[
		A specialized editor document used to handle Eiffel classes.
		
		Note: Service is not yet in effect. This was developed early in 6.2 but was not used. Hopefully it
		      will be available in a release post 6.2.
		      
		      Please do not use the service until it is available as the interface may change.
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision $"

deferred class
	EIFFEL_CLASS_EDITOR_DOCUMENT_I

inherit
	EDITOR_DOCUMENT_I

feature -- Access

	moniker: STRING_32
			-- Document moniker
		do
			Result := class_i.file_name.out.as_string_32
		end

	class_i: CLASS_I
			-- Class associated with open document
		require
			is_interface_usable: is_interface_usable
		deferred
		ensure
			result_attached: Result /= Void
		end

;note
	copyright:	"Copyright (c) 1984-2007, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
