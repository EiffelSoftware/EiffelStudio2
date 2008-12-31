note
	description: "Objects that represent an EV_DIALOG.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GB_SYSTEM_WINDOW

inherit
	GB_SYSTEM_WINDOW_IMP

	GB_NAMING_UTILITIES
		undefine
			default_create, copy, is_equal
		end

	GB_CONSTANTS
		undefine
			default_create, copy, is_equal
		end

	EIFFEL_RESERVED_WORDS
		export
			{NONE} all
		undefine
			default_create, copy, is_equal
		end

create
	make_with_components

feature {NONE} -- Initialization

	components: GB_INTERNAL_COMPONENTS
		-- Access to a set of internal components for an EiffelBuild instance.

	make_with_components (a_components: GB_INTERNAL_COMPONENTS)
			-- Create `Current' and assign `a_components' to `components'.
		require
			a_components_not_void: a_components /= Void
		do
			components := a_components
			default_create
		ensure
			components_set: components = a_components
		end

feature {NONE} -- Initialization

	user_initialization
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
				-- Set up default buttons.
			set_default_cancel_button (cancel_button)

				-- Closing window
			close_request_actions.wipe_out
			close_request_actions.put_front (agent cancel_pressed)
			show_actions.extend (agent set_focus_to_notebook)
			show_actions.extend (agent display_project_information)
		end

feature {NONE} -- Events

	attributes_local_selected
			-- Called by `select_actions' of `attributes_local_check_button'.
		do
			attribute_class_box.disable_sensitive
		end

	attributes_class_selected
			-- Called by `select_actions' of `attributes_class_check_button'.
		do
			attribute_class_box.enable_sensitive
		end

	class_build_type_selected
			-- Called by `select_actions' of `project_radio_button'.
		do
			rebuild_ace_file_check_button.disable_sensitive
			project_specific_name_holder.disable_sensitive
		end


	project_build_type_selected
			-- Called by `select_actions' of `class_radio_button'.
		do
			rebuild_ace_file_check_button.enable_sensitive
			project_specific_name_holder.enable_sensitive
		end


	ok_pressed
			-- Called by `select_actions' of `ok_button'.
		do
			validate_settings
			if last_validation_successful then
					-- Store the settings into the current project
					-- settings.
				store_project_information
					-- Save the current project settings to disk.
				components.system_status.current_project_settings.save
				hide
			end
			components.commands.update
		end


	cancel_pressed
			-- Called by `select_actions' of `cancel_button'.
		do
			hide
			components.commands.update
		end

	generate_to_current_project_location_radio_button_selected
			-- Called by `select_actions' of `generate_to_current_project_location_radio_button'.
		do
			browse_for_generation_location_button.disable_sensitive
			generation_location_display.disable_sensitive
				-- Now set the generation location back to empty.
			project_settings.set_generation_location ("")
		end

	generate_to_specified_location_radio_button_selected
			-- Called by `select_actions' of `generate_to_specified_location_radio_button'.
		do
			browse_for_generation_location_button.enable_sensitive
			generation_location_display.enable_sensitive
				-- Now set the generation location to the contents of `generation_location_display'.
			project_settings.set_generation_location (generation_location_display.text)
		end

	browse_for_generation_location_button_selected
			-- Called by `select_actions' of `browse_for_generation_location_button'.
		local
			directory_dialog: EV_DIRECTORY_DIALOG
		do
			create directory_dialog
			directory_dialog.show_modal_to_window (Current)
			if directory_dialog.selected_button.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
				generation_location_display.set_text (directory_dialog.directory)
				generation_location_display.set_tooltip (generation_location_display.text)
			end
		end

feature {NONE} -- Implementation

	display_project_information
			-- Update all members of `tab_list' to display
			-- details held in project currently being developed
			-- in the system.
		require else
			project_open: components.system_status.project_open
		do
				-- Firstly displaying the project location.
			location_field.set_text (project_settings.project_location)
			location_field.set_tooltip ("%"" + location_field.text + "%" (This entry is the location of the project, and may not be modified)")

				-- Then display all information for "Build" tab.
			application_class_name_field.set_text (project_settings.application_class_name)
			project_class_name_field.set_text (project_settings.project_name)
			constants_class_name_field.set_text (project_settings.constants_class_name)
			if project_settings.complete_project then
				project_radio_button.enable_select
			else
				class_radio_button.enable_select
			end
			if project_settings.rebuild_ace_file then
				rebuild_ace_file_check_button.enable_select
			else
				rebuild_ace_file_check_button.disable_select
			end

				-- Then display all information for "Generation" tab
			if project_settings.grouped_locals then
				local_check_button.enable_select
			else
				local_check_button.disable_select
			end
			if project_settings.debugging_output then
				debugging_check_button.enable_select
			else
				debugging_check_button.disable_select
			end
			if project_settings.attributes_local.is_equal (True_string) then
				attributes_local_check_button.enable_select
			elseif project_settings.attributes_local.is_equal (False_string) then
				attributes_class_check_button.enable_select
				attributes_exported_check_button.enable_select
			elseif project_settings.attributes_local.is_equal (False_optimal_string) then
				attributes_class_check_button.enable_select
				attributes_optimal_check_button.enable_select
			elseif project_settings.attributes_local.is_equal (False_non_exported_string) then
				attributes_class_check_button.enable_select
				attributes_not_exported_check_button.enable_Select
			end
			if project_settings.load_constants then
				load_constants_check_button.enable_select
			else
				load_constants_check_button.disable_select
			end

			if project_settings.generation_location.is_empty then
				generate_to_current_project_location_radio_button.enable_select
			else
				generation_location_display.set_text (project_settings.generation_location)
				generate_to_specified_location_radio_button.enable_select
			end
		end

	store_project_information
			-- Update project settings to reflect information
			-- entered into `Current'.
		require
			project_open: components.system_status.project_open
		do
				-- Firstly stors all information from "Build" tab.
				--	project_settings.set_main_window_class_name (main_window_class_name_field.text.as_upper)
			project_settings.set_application_class_name (application_class_name_field.text.as_upper)
			project_settings.set_project_name (project_class_name_field.text)
			project_settings.set_constants_class_name (constants_class_name_field.text.as_upper)
			if project_radio_button.is_selected then
				project_settings.enable_complete_project
			else
				project_settings.disable_complete_project
			end
			if rebuild_ace_file_check_button.is_selected then
				project_settings.enable_rebuild_ace_file
			else
				project_settings.disable_rebuild_ace_file
			end

				-- Now store all information from "Generation" tab.
			if local_check_button.is_selected then
				project_settings.enable_grouped_locals
			else
				project_settings.disable_grouped_locals
			end
			if debugging_check_button.is_selected then
				project_settings.enable_debugging_output
			else
				project_settings.disable_debugging_output
			end
			if attributes_local_check_button.is_selected then
				project_settings.set_attributes_locality (True_string)
			elseif attributes_not_exported_check_button.is_selected then
				project_settings.set_attributes_locality (false_non_exported_string)
			elseif attributes_optimal_check_button.is_selected then
				project_settings.set_attributes_locality (False_optimal_string)
			elseif attributes_exported_check_button.is_selected then
				project_settings.set_attributes_locality (false_string)
			end
			if load_constants_check_button.is_selected then
				project_settings.enable_constant_loading
			else
				project_settings.disable_constant_loading
			end
			if generate_to_specified_location_radio_button.is_selected then
				project_settings.set_generation_location (generation_location_display.text)
			else
				project_settings.set_generation_location ("")
			end
		end


	validate_settings
			-- Validate all settings in `Current'.
		local
			warning_dialog: EV_WARNING_DIALOG
			application_name_lower, class_name_lower, project_name_lower,
			invalid_text, warning_message, constant_name_lower: STRING
			windows: ARRAYED_LIST [GB_OBJECT]
			l_boolean: BOOLEAN
		do
			create hashed_names.make (4)
					-- Check for invalid eiffel names as language specification.
			last_validation_successful := True
			application_name_lower := application_class_name_field.text.as_lower
			project_name_lower := project_class_name_field.text.as_lower
			constant_name_lower := constants_class_name_field.text.as_lower
			if not valid_class_name (application_name_lower) then
				invalid_text := application_name_lower
			elseif not valid_class_name (project_name_lower) then
				invalid_text := project_name_lower
			elseif not valid_class_name (constant_name_lower) then
				invalid_text := constant_name_lower
			end
			if invalid_text /= Void then
				warning_message := Class_invalid_name_warning
			else
				warning_message := Reserved_word_warning
			end
				-- Check for names that are Eiffel reserved words.
			if reserved_words.has (application_name_lower) then
				invalid_text := application_name_lower
			elseif reserved_words.has (class_name_lower) then
				invalid_text := class_name_lower
			elseif reserved_words.has (project_name_lower) then
				invalid_text := project_name_lower
			elseif reserved_words.has (constant_name_lower) then
				invalid_text := constant_name_lower
			end
			if invalid_text = Void then
				warning_message := " Conflicts with either:%N%NA class name specified in this dialog, or%NA class name of a window.%N%NPlease resolve this conflict, or select %"Cancel%" to revert back to the previous settings."
			else
				invalid_text := "'" + invalid_text
			end

			windows := components.tools.widget_selector.objects
			from
				windows.start
			until
				windows.off
			loop
				l_boolean := add_hashed_name (windows.item.name.as_lower)
				l_boolean := add_hashed_name ((windows.item.name + Class_implementation_extension).as_lower)
				windows.forth
			end
			if not add_hashed_name (constant_name_lower) then
				invalid_text := "The constant class name %"" + constant_name_lower + "%""
			end
			if not add_hashed_name (application_name_lower) then
				invalid_text := "The application class name %"" + application_name_lower + "%""
			end
			if not add_hashed_name (project_name_lower) then
				invalid_text := "The project class name %"" + project_name_lower + "%""
			end

			if invalid_text /= Void then
			--	select_in_parent
				create warning_dialog.make_with_text (invalid_text + warning_message)
				warning_dialog.show_modal_to_window (components.tools.main_window)
				last_validation_successful := False
			end
		end

	hashed_names: HASH_TABLE [STRING, STRING]
		-- All names that current class names are not permitted to use.

	add_hashed_name (a_name: STRING): BOOLEAN
			-- Add `a_name' to `hashed_names', with `Result' indicating if
			-- the name was already included.
		do
			Result := not hashed_names.has (a_name)
			hashed_names.put (a_name, a_name)
		end

	last_validation_successful: BOOLEAN
		-- Was last call to `validate_settings' succesful?
		-- True if all valication succeeded.

	project_settings: GB_PROJECT_SETTINGS
			-- `Result' is access to current project settings.
		do
			Result := components.system_status.current_project_settings
		end

	set_focus_to_notebook
			-- Assign focus to `main_notebook'
		do
			main_notebook.set_focus
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


end -- class GB_SYSTEM_WINDOW

