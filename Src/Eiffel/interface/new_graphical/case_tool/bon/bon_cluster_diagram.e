note
	description: "Objects that is a bon view for a eiffel cluster graph"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BON_CLUSTER_DIAGRAM

inherit
	EIFFEL_CLUSTER_DIAGRAM
		redefine
			default_view_name
		end

create
	make,
	make_without_interactions

create {BON_CLUSTER_DIAGRAM}
	make_filled

feature {NONE} -- Initialization

	make (a_graph: like model; a_tool: like context_editor)
			-- Initialize as context in `a_tool' showing `a_graph'.
		require
			a_graph_not_void: a_graph /= Void
			a_tool_not_void: a_tool /= Void
		do
			is_uml := False
			make_with_model_and_factory (a_graph, create {BON_FACTORY})
			context_editor := a_tool
		end

feature {EB_DIAGRAM_HTML_GENERATOR} -- Initialization

	make_without_interactions (a_graph: like model)
			-- Create a BON_CLUSTER_DIAGRAM showing `a_graph'.
		require
			a_graph_not_void: a_graph /= Void
		do
			make_with_model_and_factory (a_graph, create {BON_FACTORY})
		end

feature -- Access

	default_view_name: STRING
			-- Name for the default view.
		do
			Result := "DEFAULT:BON"
		end

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

end -- class BON_CLUSTER_DIAGRAM
