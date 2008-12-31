note 
	description: "Source code generator for cast expression"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$$"
	revision: "$$"

class
	CODE_CAST_EXPRESSION

inherit
	CODE_EXPRESSION

create
	make

feature {NONE} -- Initialization

	make (a_target_type: like target_type; a_source: like source)
			-- Initialize `target_type'.
		require
			non_void_target_type: a_target_type /= Void
			non_void_source: a_source /= Void
		do
			target_type := a_target_type
			source := a_source
		ensure
			target_type_set: target_type = a_target_type
			source_set: source = a_source
		end
		
feature -- Access

	source: STRING
			-- Cast variable
			
	target_type: CODE_TYPE_REFERENCE
			-- Type of cast target
			
	code: STRING
			-- | Result := " ?= `expression_to_cast'"
			-- Eiffel code of cast expression
		do
			Result := source
		end
		
feature -- Status Report
		
	type: CODE_TYPE_REFERENCE
			-- Type
		do
			Result := target_type
		end
		
invariant
	non_void_target_type: target_type /= Void
	non_void_source: source /= Void
	
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
end -- class CODE_CAST_EXPRESSION

