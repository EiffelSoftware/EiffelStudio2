note
	description: "[
		A {TAG_ELEMENT} is generated by parsing a "xeb"-file. {TAG_ELEMENT}s
		are combined to trees.
	]"
	author: "sandro"
	date: "$Date$"
	revision: "$Revision$"

class
	TAG_ELEMENT

create
	make

feature -- Initialization

	make (a_id: STRING; a_class_name: STRING)
			-- `a_class_name': The name of the corresponding TAG-class
		do
			class_name := a_class_name
			id := a_id
			create {ARRAYED_LIST [STRING]} controller_calls.make (1)
			create {ARRAYED_LIST [TAG_ELEMENT]} children.make (3)
			create {HASH_TABLE [STRING, STRING]} parameters.make (3)
		end

feature -- Access

	id: STRING
			-- The tag id

	class_name: STRING
			-- The name of the corresponding TAG-class

	parameters: HASH_TABLE [STRING, STRING]
			-- The parameters of the tag [value, id]

	children: LIST [TAG_ELEMENT]
			-- All the children of the tag

	controller_calls: LIST [STRING]
			-- All calls to the controller, which should be possible

feature -- Access

	has_children: BOOLEAN
			-- Are there any children?
		do
			Result := not children.is_empty
		end

	put_controller_call (a_call: STRING)
		do
			controller_calls.extend (a_call)
		end

	put_subtag (child: like Current)
			-- Adds a tag to the list of children.
		do
			children.extend (child)
		end

	put_attribute (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING; a_value: STRING)
			-- Sets the attribute of this tag.
		do
			parameters.put (a_value, a_local_part)
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
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
