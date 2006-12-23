indexing
	description: "Caller/callee criterion property manager used in metric criterion grid"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_CALLER_CRITERION_MANAGER

inherit
	EB_METRIC_DOMAIN_PROPERTY_MANAGER
		redefine
			criterion_type,
			load_properties,
			store_properties,
			on_before_dialog_display
		end

create
	make

feature -- Properties management

	load_properties (a_criterion: like criterion_type) is
			-- Load porperties from `a_criterion' into current manager
		do
			Precursor (a_criterion)
			property_item.set_is_only_current_version (a_criterion.only_current_version)
		end

	store_properties (a_criterion: like criterion_type) is
			-- Store properties in current manager into `a_criterion'.
		do
			Precursor (a_criterion)
			if property_item.is_only_current_version then
				a_criterion.enable_only_current_version
			else
				a_criterion.disable_only_current_version
			end
		end

feature{NONE} -- Implementation

	criterion_type: EB_METRIC_CALLER_CALLEE_CRITERION
			-- Anchor type

	on_before_dialog_display (a_dialog: EB_METRIC_DOMAIN_PROPERTY_DIALOG) is
			-- Action to be performed before `a_dialog' is displayed
		do
			a_dialog.set_grid_item (property_item)
			a_dialog.property_area.feature_vertion_area.show
		end

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


end
