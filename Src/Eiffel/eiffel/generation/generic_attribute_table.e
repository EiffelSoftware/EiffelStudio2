note
	description: "[
			Representation of a table of attributes originated from an attribute
			of a formal generic type for the final Eiffel executable.
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class GENERIC_ATTRIBUTE_TABLE

inherit

	ATTR_TABLE [ROUT_ENTRY]
		rename
			generate_loop_initialization as generate_attribute_loop_initialization,
			generate as generate_attribute_table
		undefine
			is_routine_table,
			tmp_poly_table,
			merge,
			extend
		redefine
			is_polymorphic,
			new_entry,
			write
		end

	ROUT_TABLE
		rename
			generate as generate_routine_table
		undefine
			is_attribute_table, write_for_type
		redefine
			is_polymorphic,
			new_entry,
			write
		end

create
	make

feature -- Status report

	is_polymorphic (a_type: TYPE_A; a_context_type: CLASS_TYPE): BOOLEAN
			-- Is the table polymorphic from entry indexed by `type_id' to
			-- the maximum entry id?
		do
			Result := Precursor {ATTR_TABLE} (a_type, a_context_type) or else Precursor {ROUT_TABLE} (a_type, a_context_type)
		end

feature -- Access

	new_entry (f: FEATURE_I; c: INTEGER): ENTRY
			-- New entry corresponding to `f' in class of class ID `c'
		do
			Result := f.new_rout_entry
			Result.set_class_id (c)
		end

feature -- Code generation

	write
			-- Generate table using writer.
		do
			generate_attribute_table (Attr_generator)
			generate_routine_table (Rout_generator)
		end

note
	copyright:	"Copyright (c) 2007, Eiffel Software"
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
