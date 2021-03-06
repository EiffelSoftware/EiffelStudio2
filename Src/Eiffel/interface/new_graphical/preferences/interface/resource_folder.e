note
	description: "Class which encapsulates the information relative to a resource category."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "pascalf"
	date: "$Date$"
	revision: "$Revision$"

class
	RESOURCE_FOLDER

create
	make

feature -- Initialization

	make (imp: RESOURCE_FOLDER_I)
		do
			implementation := imp
		end

feature -- Access

	name: STRING
			-- Id of Current, it is unique.
		do
			Result := implementation.name
		end

	description: STRING
			-- Description of Current.
		do
			Result := implementation.description
		end

	icon: STRING
			-- Icon name of Current if any, Void otherwise
		do
			Result := implementation.icon
		end

	is_visible: BOOLEAN
			-- Should this folder be displayed?
		do
			Result := implementation.is_visible
		end

	resource_list: LINKED_LIST [RESOURCE]
			-- List of resources.
		do
			Result := implementation.resource_list
		end

	child_list: LINKED_LIST [RESOURCE_FOLDER]
			-- List of Categories.
		local
			child_list_i: LINKED_LIST [RESOURCE_FOLDER_I]
		do
			child_list_i := implementation.child_list
			create Result.make
			from
				child_list_i.start
			until
				child_list_i.after
			loop
				Result.extend (child_list_i.item.interface)
				child_list_i.forth
			end
		end

feature {NONE} -- Implementation

	implementation: RESOURCE_FOLDER_I;

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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

end -- class RESOURCE_FOLDER
