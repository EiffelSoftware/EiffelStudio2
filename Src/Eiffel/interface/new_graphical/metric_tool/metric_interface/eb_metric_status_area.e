indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_STATUS_AREA

inherit
	EB_METRIC_STATUS_AREA_IMP

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			is_equal,
			copy,
			default_create
		end

	EB_METRIC_TOOL_INTERFACE
		undefine
			is_equal,
			copy,
			default_create
		end

create
	make

feature{NONE} -- Initialization

	make (a_tool: like metric_tool) is
			-- Initialize `metric_tool' with `a_tool'.
		require
			a_tool_attached: a_tool /= Void
		do
			set_metric_tool (a_tool)
			default_create
		ensure
			metric_tool_set: metric_tool = a_tool
		end

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_text: EV_TEXT_FIELD
		do
			create l_text
			status_text.disable_edit
			status_text.set_background_color (l_text.background_color)
			status_lbl.set_text (metric_names.t_status)
			attach_non_editable_warning_to_text (metric_names.t_text_not_editable, status_text, metric_tool_window)
		end

feature {NONE} -- Implementation



indexing
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


end -- class EB_METRIC_STATUS_AREA2

