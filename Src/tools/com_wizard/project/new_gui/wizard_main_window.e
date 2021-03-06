﻿note
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	WIZARD_MAIN_WINDOW

inherit
	WIZARD_MAIN_WINDOW_IMP

	WIZARD_VALIDITY_CHECKER
		undefine
			default_create,
			copy,
			is_equal
		end

	WIZARD_SHARED_GENERATION_ENVIRONMENT
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	WIZARD_SHARED_PROFILE_MANAGER
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

	WIZARD_SETTINGS_CONSTANTS
		export
			{NONE} all
		undefine
			default_create,
			copy,
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Properly initialize current.
		do
			initialize_checker
			default_create
		end

	user_initialization
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			l_accel: EV_ACCELERATOR
		do
			notebook.set_item_text (settings_box, "General Settings")
			notebook.set_item_text (generation_options_outter_box, "Generation Options")
			notebook.set_item_text (output_box, "Output")
			notebook.item_tab (settings_box).set_pixmap (settings_png)
			notebook.item_tab (generation_options_outter_box).set_pixmap (settings_png)
			notebook.item_tab (output_box).set_pixmap (output_png)

			close_request_actions.extend (agent on_exit)
			com_project_box.hide
			destination_folder_box.setup ("Generate files into:", "destination_key", "Browse for destination folder", agent destination_folder_validity)
			validity_change_request_actions.extend (agent initialize_generate_button)
			eiffel_project_box.validity_change_request_actions.extend (agent initialize_generate_button)
			com_project_box.validity_change_request_actions.extend (agent initialize_generate_button)
			update_environment
			project_box.focus_lost_actions.extend (agent on_project_focus_lost)

			-- Setup project box last so that profile change actions are registered
			project_box.set_max_count (10000)
			project_box.exclude_from_profile
			project_box.set_default_text (Profile_manager.Default_profile)
			project_box.set_save_on_return (False)
			project_box.setup ("Current project:", Profile_manager.Profiles_key, agent on_project_change, agent on_project_enter, agent on_project_select)
--			project_box.initialize_focus
			Profile_manager.active_profile_save_actions.extend (agent project_type_profile_item)
			Profile_manager.active_profile_save_actions.extend (agent component_type_profile_item)
			Profile_manager.active_profile_save_actions.extend (agent compile_target_profile_item)
			Profile_manager.active_profile_save_actions.extend (agent backup_profile_item)
			Profile_manager.active_profile_save_actions.extend (agent overwrite_profile_item)
			Profile_manager.active_profile_save_actions.extend (agent marshaller_profile_item)
			Profile_manager.active_profile_change_actions.extend (agent update_buttons)
			update_buttons
			initialize_generate_button

			create l_accel.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.Key_tab), True, False, False)
			l_accel.actions.extend (agent on_next)
			accelerators.extend (l_accel)
			create l_accel.make_with_key_combination (create {EV_KEY}.make_with_code ({EV_KEY_CONSTANTS}.Key_tab), True, False, True)
			l_accel.actions.extend (agent on_previous)
			accelerators.extend (l_accel)

			set_icon_pixmap (Wizard_ico)
		end

feature -- Basic Operations

	update_environment
			-- Update environment according to interface content.
		local
			l_text: READABLE_STRING_32
		do
			if eiffel_project_radio_button.is_selected then
				environment.set_is_eiffel_interface
			elseif com_server_project_radio_button.is_selected then
				environment.set_is_new_component
			else
				environment.set_is_client
			end
			if in_process_radio_button.is_selected then
				environment.set_is_in_process
			else
				environment.set_is_out_of_process
			end
			l_text := destination_folder_box.value
			if not destination_folder_validity (l_text).is_error then
				environment.set_destination_folder (l_text)
			end
			environment.set_compile_c (compile_c_code_check_button.is_selected)
			environment.set_compile_eiffel (compile_eiffel_check_button.is_selected)
			if backup_radio_button.is_selected then
				environment.set_backup (True)
				environment.set_cleanup (False)
			elseif cleanup_radio_button.is_selected then
				environment.set_backup (False)
				environment.set_cleanup (True)
			elseif overwrite_radio_button.is_selected then
				environment.set_backup (False)
				environment.set_cleanup (False)
			end
		end

feature {WIZARD_OUTPUT_BOX} -- Implementation

	on_generate
			-- Save all information and start generation.
		do
			check
				is_valid: is_valid
			end
			output_box.set_destination_folder (destination_folder_box.value)
			notebook.select_item (output_box)
			if eiffel_project_box.is_show_requested then
				eiffel_project_box.save_values
			end
			destination_folder_box.save_combo_text
			project_box.save_combo_text
			start_generation
		end

feature {NONE} -- Implementation

	on_help
			-- Called by `select_actions' of `help_menu_item'.
		local
			l_help_engine: EB_HELP_ENGINE
		do
			create l_help_engine.make
			l_help_engine.show (create {EB_HELP_CONTEXT}.make_absolute ("/tools/wizards/com/index.html"))
		end

	on_about
			-- Called by `select_actions' of `about_menu_item'.
			-- Show about dialog box
		local
			l_about_dialog: WIZARD_ABOUT_DIALOG
		do
			create l_about_dialog
			l_about_dialog.show_modal_to_window (Current)
		end

	on_project_change (a_project_name: READABLE_STRING_32): WIZARD_VALIDITY_STATUS
			-- Set `current_project' with `a_project_name'.
		require
			non_void_project_name: a_project_name /= Void
		do
			Result := project_name_validity (a_project_name)
			if Result.is_error then
				project_button.disable_sensitive
			else
				project_button.enable_sensitive
				if Profile_manager.available_profiles.has (a_project_name) then
					project_button.set_text ("Load")
				else
					project_button.set_text ("New")
				end
				if not project_button.is_default_push_button then
					project_button.enable_default_push_button
				end
			end
			initialize_generate_button
			in_delete_mode := False
			project_selected := False
		end

	on_project_select
			-- Project was selected from list or `return' was pressed.
			-- If return was pressed
		do
			Profile_manager.set_active_profile (project_box.value)
			update_environment
			project_button.set_text ("Delete")
			if project_box.is_default_selected then
				project_button.disable_sensitive
			else
				project_button.enable_sensitive
			end
			project_box.save_combo_text
			initialize_generate_button
			project_button.disable_default_push_button
			in_delete_mode := True
			project_selected := True
		end

	on_project_enter
			-- Save project if name is valid and different.
			-- Start generation if name is valid and same as selected.
		local
			l_project_name, l_active_profile: STRING_32
		do
			l_project_name := project_box.value
			if not project_name_validity (l_project_name).is_error then
				l_active_profile := Profile_manager.active_profile
				if l_active_profile /= Void and then l_active_profile.is_equal (l_project_name) and not project_selected and first_generate_button.is_sensitive and not in_delete_mode then
					on_generate
				elseif not in_delete_mode then
					on_project_select
				end
			end
			project_selected := False
		end

	on_project_focus_lost
			-- 	Project text box focus is lost, create project if `new' wasn't clicked.
		local
			l_active_profile: STRING_32
		do
			l_active_profile := Profile_manager.active_profile
			if l_active_profile /= Void and then not l_active_profile.same_string_general (project_box.value) then
				on_project_enter
--				focus_lost := not project_button.select_actions
			end
		end

	on_project_button_select
			-- Called by `select_actions' of `project_button'.
			-- Remove selected profile, load or create profile depending on mode.
		do
			if not focus_lost then
				if in_delete_mode then
					profile_manager.remove_active_profile
					project_box.remove_active_item
				end
				on_project_enter
			else
				focus_lost := False
			end
		end

	on_select_eiffel_project
			-- Called by `select_actions' of `eiffel_project_radio_button'.
			-- Show Eiffel project settings.
			-- Update environment.
		do
			com_project_box.hide
			eiffel_project_box.show
			initialize_generate_button
			environment.set_is_eiffel_interface
			Profile_manager.save_active_profile
		end

	on_select_com_server
			-- Called by `select_actions' of `com_server_project_radio_button'.
			-- Show COM project settings.
			-- Update environment.
		do
			eiffel_project_box.hide
			com_project_box.show
			com_project_box.show_marshaller
			initialize_generate_button
			environment.set_is_new_component
			Profile_manager.save_active_profile
		end

	on_select_com_client
			-- Called by `select_actions' of `com_client_project_radio_button'.
			-- Show COM project settings.
			-- Update environment.
		do
			eiffel_project_box.hide
			com_project_box.show
			com_project_box.hide_marshaller
			initialize_generate_button
			environment.set_is_client
			Profile_manager.save_active_profile
		end

	on_select_in_process
			-- Called by `select_actions' of `in_process_radio_button'.
			-- Set environment accordingly.
		do
			if in_process_radio_button.is_selected then
				environment.set_is_in_process
			else
				environment.set_is_out_of_process
			end
			Profile_manager.save_active_profile
		end

	on_select_out_of_process
			-- Called by `select_actions' of `out_of_process_radio_button'.
			-- Set environment accordingly.
		do
			if out_of_process_radio_button.is_selected then
				environment.set_is_out_of_process
			else
				environment.set_is_in_process
			end
			Profile_manager.save_active_profile
		end

	on_select_compile_eiffel
			-- Called by `select_actions' of `compile_eiffel_check_button'.
			-- Set environment accordingly.
		do
			environment.set_compile_eiffel (compile_eiffel_check_button.is_selected)
			Profile_manager.save_active_profile
		end

	on_select_compile_c
			-- Called by `select_actions' of `compile_c_code_check_button'.
			-- Disable no Eiffel compilation check box if selected.
			-- Set environment accordingly.
		do
			if compile_c_code_check_button.is_selected then
				environment.set_compile_c (True)
				if compile_eiffel_check_button_was_selected then
					compile_eiffel_check_button.enable_select
				end
				compile_eiffel_check_button.enable_sensitive
			else
				compile_eiffel_check_button_was_selected := compile_eiffel_check_button.is_selected
				compile_eiffel_check_button.disable_select
				compile_eiffel_check_button.disable_sensitive
				environment.set_compile_c (False)
			end
			Profile_manager.save_active_profile
		end

	on_select_backup
			-- Called by `select_actions' of `backup_radio_button'.
			-- Update environment
		do
			environment.set_backup (True)
			environment.set_cleanup (False)
			Profile_manager.save_active_profile
		end

	on_select_cleanup
			-- Called by `select_actions' of `cleanup_radio_button'.
			-- Update environment
		do
			environment.set_backup (False)
			environment.set_cleanup (True)
			Profile_manager.save_active_profile
		end

	on_select_overwrite
			-- Called by `select_actions' of `overwrite_radio_button'.
			-- Update environment
		do
			environment.set_backup (False)
			environment.set_cleanup (False)
			Profile_manager.save_active_profile
		end

	on_exit
			-- Called by `select_actions' of `exit_button'.
		do
			if eiffel_project_box.is_show_requested then
				eiffel_project_box.save_values
			end
			destination_folder_box.save_combo_text
			project_box.save_combo_text;
			((create {EV_ENVIRONMENT}).application).destroy
		end

	on_previous
			-- Select first notebook page
		local
			l_index: INTEGER
		do
			l_index := notebook.selected_item_index
			l_index := l_index - 1
			if l_index < 1 then
				l_index := notebook.count
			end
			notebook.select_item (notebook.i_th (l_index))
		end

	on_next
			-- Select second notebook page
		local
			l_index: INTEGER
		do
			l_index := notebook.selected_item_index
			l_index := l_index + 1
			if l_index > notebook.count then
				l_index := 1
			end
			notebook.select_item (notebook.i_th (l_index))
		end

feature {NONE} -- Implementation

	start_generation
			-- Start files generation
		local
			l_worker_thread: EV_THREAD_WORKER
		do
			environment.set_no_abort
			create l_worker_thread.make
			is_running := True
			first_generate_button.disable_sensitive
			second_generate_button.disable_sensitive
			output_box.disable_generate_button
			l_worker_thread.do_work (agent run, agent output_box.process_event)
			is_running := False
			initialize_generate_button
		end

	run (a_event_raiser: ROUTINE [EV_THREAD_EVENT])
			-- Run wizard and handle events with `a_event_handler'.
		local
			l_manager: WIZARD_MANAGER
		do
			set_progress_report (create {WIZARD_PROGRESS_REPORT}.make (a_event_raiser))
			set_message_output (create {WIZARD_MESSAGE_OUTPUT}.make (a_event_raiser))
			create l_manager
			l_manager.run
			l_manager := Void
		end

	project_name_validity (a_project_name: READABLE_STRING_32): WIZARD_VALIDITY_STATUS
			-- Is `a_project_name' a valid project name?
		require
			non_void_project_name: a_project_name /= Void
		local
			i, l_count: INTEGER
			l_symbols: ARRAY [CHARACTER]
			l_is_valid: BOOLEAN
		do
			l_is_valid := not a_project_name.is_empty
			if l_is_valid then
				l_symbols := forbidden_registry_key_name_symbols
				from
					i := 1
					l_count := l_symbols.count
				until
					i > l_count or not l_is_valid
				loop
					l_is_valid := not a_project_name.has (l_symbols.item (i))
					i := i + 1
				end
			end
			if l_is_valid then
				create Result.make_success ({WIZARD_VALIDITY_STATUS_IDS}.Project_name)
			else
				create Result.make_error ({WIZARD_VALIDITY_STATUS_IDS}.Project_name)
			end
			set_status (Result)
		end

	destination_folder_validity (a_folder: READABLE_STRING_32): WIZARD_VALIDITY_STATUS
			-- Check whether destination folder is correctly initialized.
			-- Initialize environment accordingly
		local
			l_success: BOOLEAN
		do
			l_success := not a_folder.is_empty
			if l_success then
				create Result.make_success ({WIZARD_VALIDITY_STATUS_IDS}.Destination_folder)
				environment.set_destination_folder (a_folder)
			else
				create Result.make_error ({WIZARD_VALIDITY_STATUS_IDS}.Destination_folder)
			end
			set_status (Result)
		end

	initialize_generate_button
			-- Add and remove dummy error to trigger initialization of Generate button sensitivity state.
		do
			if (not is_running and is_valid and
					(not eiffel_project_box.is_show_requested or eiffel_project_box.is_valid) and
					(not com_project_box.is_show_requested or com_project_box.is_valid)) then
				first_generate_button.enable_sensitive
				second_generate_button.enable_sensitive
				output_box.enable_generate_button
			else
				first_generate_button.disable_sensitive
				second_generate_button.disable_sensitive
				output_box.disable_generate_button
			end
		end

	project_type_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for project type
		local
			l_encoded_project: STRING
		do
			if eiffel_project_radio_button.is_selected then
				l_encoded_project := Eiffel_project_code
			elseif com_server_project_radio_button.is_selected then
				l_encoded_project := Server_project_code
			else
				l_encoded_project := Client_project_code
			end
			create Result.make (Project_type_key, l_encoded_project)
		end

	component_type_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for component type
		local
			l_encoded_component: STRING
		do
			if in_process_radio_button.is_selected then
				l_encoded_component := In_process_code
			else
				l_encoded_component := Out_of_process_code
			end
			create Result.make (Component_type_key, l_encoded_component)
		end

	compile_target_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for compilation target
		local
			l_target: STRING
		do
			if compile_c_code_check_button.is_selected then
				if compile_eiffel_check_button.is_selected then
					l_target := Both_compile_code
				else
					l_target := C_compile_code
				end
			else
				l_target := None_code
			end
			create Result.make (Compile_target_key, l_target)
		end

	backup_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for compilation target
		local
			l_backup: STRING
		do
			if backup_radio_button.is_selected then
				l_backup := True_code
			else
				l_backup := None_code
			end
			create Result.make (Backup_key, l_backup)
		end

	overwrite_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for compilation target
		local
			l_overwrite: STRING
		do
			if overwrite_radio_button.is_selected then
				l_overwrite := True_code
			else
				l_overwrite := None_code
			end
			create Result.make (Overwrite_key, l_overwrite)
		end

	marshaller_profile_item: WIZARD_PROFILE_ITEM
			-- Profile item for compilation target
		local
			l_use_marshaller: STRING
		do
			if com_project_box.marshaller_check_button.is_selected then
				l_use_marshaller := True_code
			else
				l_use_marshaller := None_code
			end
			create Result.make (Marshaller_key, l_use_marshaller)
		end

	update_buttons
			-- Initialize check and radio buttons
		local
			l_value: STRING_32
		do
			Profile_manager.set_save_blocked (True)
			Profile_manager.search_active_profile (Project_type_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.same_string_general (Eiffel_project_code) then
					eiffel_project_radio_button.enable_select
				elseif l_value.same_string_general (Server_project_code) then
					com_server_project_radio_button.enable_select
				elseif l_value.same_string_general (Client_project_code) then
					com_client_project_radio_button.enable_select
				end
			else
				com_client_project_radio_button.enable_select
			end
			Profile_manager.search_active_profile (Component_type_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.is_equal (In_process_code) then
					in_process_radio_button.enable_select
				else
					out_of_process_radio_button.enable_select
				end
			else
				in_process_radio_button.enable_select
			end
			Profile_manager.search_active_profile (Compile_target_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.same_string_general (Both_compile_code) then
					compile_eiffel_check_button.enable_select
					compile_c_code_check_button.enable_select
				elseif l_value.same_string_general (C_compile_code) then
					compile_c_code_check_button.enable_select
					compile_eiffel_check_button.disable_select
				else
					compile_c_code_check_button.disable_select
				end
			else
				compile_eiffel_check_button.enable_select
				compile_c_code_check_button.enable_select
			end
			cleanup_radio_button.enable_select
			Profile_manager.search_active_profile (Backup_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.is_equal (True_code) then
					backup_radio_button.enable_select
				end
			end
			Profile_manager.search_active_profile (Overwrite_key)
			if Profile_manager.found then
				l_value := Profile_manager.found_item.value
				if l_value.is_equal (True_code) then
					overwrite_radio_button.enable_select
				end
			end
			Profile_manager.set_save_blocked (False)
		end

feature {NONE} -- Private Access

	project_selected: BOOLEAN
			-- Was project selected from profiles list?

	in_delete_mode: BOOLEAN
			-- Is project button in delete mode?

	is_running: BOOLEAN
			-- Is wizard currently running?

	focus_lost: BOOLEAN
			-- Was focus from project textbox lost?

	compile_eiffel_check_button_was_selected: BOOLEAN
			-- Save state of compile eiffel check box to restore it when enabled again

	is_valid_eiffel_project: BOOLEAN
			-- Are settings for Eiffel project valid?

	is_valid_com_project: BOOLEAN
			-- Are settings for COM project valid?

	forbidden_registry_key_name_symbols: ARRAY [CHARACTER]
			-- Forbidden symols for registry key name,
		once
			Result := <<'*', '?', ':', '<', '>', '|', '\', '"'>>
		end

note
	copyright:	"Copyright (c) 1984-2018, Eiffel Software"
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
