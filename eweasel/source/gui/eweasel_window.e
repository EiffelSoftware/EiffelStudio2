﻿note
	description: "[
			Objects that represent an EV_TITLED_WINDOW.
			The original version of this class was generated by EiffelBuild.
		]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EWEASEL_WINDOW

inherit
	EWEASEL_WINDOW_IMP

	EW_SHARED_OBJECTS
		undefine
			default_create,
			copy
		end

feature {NONE} -- Initialization

	user_initialization
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			exit_menu_item.select_actions.extend (agent destroy)
			close_request_actions.extend (agent destroy)
			set_output (output_control)
			tests_list.enable_multiple_selection
			configuration_menu_item.select_actions.extend (agent open_configuration)
			save_menu_item.select_actions.extend (agent save_configuration)
			save_as_menu_item.select_actions.extend (agent save_new_configuration)
			keep_check_button.select_actions.extend (agent toggle_keep_options)
			include_directory_browse_button.select_actions.extend (agent set_include_directory)
			ise_eiffel_var_browse_button.select_actions.extend (agent set_ise_eiffel_directory)
			eweasel_directory_browse_button.select_actions.extend (agent set_eweasel_directory)
			test_output_directory_browse_button.select_actions.extend_kamikaze (agent set_test_output_directory)
			control_file_browse_button.select_actions.extend (agent set_control_file)
			test_load_button.select_actions.extend (agent load_catalog)
			tests_save_button.select_actions.extend (agent save_catalog)
			save_output_button.select_actions.extend (agent save_output)
			tests_run_button.select_actions.extend (agent run_tests)
			clear_output_button.select_actions.extend (agent output_text.set_text (""))
		end

	user_create_interface_objects
			-- <Precursor>
		do
		end

feature {NONE} -- Configuration

	update_configuration
			-- Update the current configuration to match widgets
		require
			have_configuration: configuration /= Void
		do
			configuration.set_platform_type (platform_combo_box.selected_item.text)
			configuration.set_output_directory (test_output_directory_text_field.text)
			configuration.set_include_directory (include_directory_text_field.text)
			configuration.set_control_file (control_file_text_field.text)
			configuration.set_eiffel_installation_directory (ise_eiffel_var_text_field.text)
			configuration.set_eweasel_installation_directory (eweasel_directory_text_field.text)
			configuration.set_keep_eifgens (keep_eifgen_check_buttons.is_selected)
			if keep_check_button.is_selected then
				if all_test_keep_radio.is_selected then
					configuration.set_keep_tests ("all")
				elseif passed_test_keep_radio.is_selected then
					configuration.set_keep_tests ("passed")
				elseif failed_test_keep_radio.is_selected then
					configuration.set_keep_tests ("failed")
				end
			else
				configuration.set_keep_tests ("none")
			end
		end

	open_configuration
			-- Open an previously saved configuration
		local
			l_filename: STRING
			l_configuration: like configuration
		do
			l_configuration := configuration
			configuration := Void
			l_filename := open_file
			if l_filename /= Void then
				create configuration.make (l_filename)
				if configuration.is_valid then
					update_interface
					save_menu_item.enable_sensitive
					output.append ("New configuration loaded from " + l_filename + "%N", True)
				else
					configuration := l_configuration
					output.append_error ("Could not open configuration file at " + l_filename + "%N", True)
				end
			end
		end

	save_configuration
			-- Save current settings to existing configuration file
		require
			have_configuration: configuration /= Void
		do
			update_configuration
			configuration.save
			save_menu_item.enable_sensitive
		end

	save_new_configuration
			-- Save current settings to a new configuration file
		local
			l_save_dialog: EV_FILE_SAVE_DIALOG
			l_filter: STRING
		do
			create l_save_dialog
			l_filter := ".xml"
			l_save_dialog.filters.extend (["*.xml", "Files of type (" + l_filter + ")"])
			l_save_dialog.show_modal_to_window (Current)
			if l_save_dialog.selected_button_name.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_save) then
				if l_save_dialog.file_name.substring_index_in_bounds (l_filter, l_save_dialog.file_name.count - l_filter.count, l_save_dialog.file_name.count) /= 0 then
					create configuration.make_new (l_save_dialog.file_name)
				else
					create configuration.make_new (l_save_dialog.file_name + l_filter)
				end
				save_configuration
			end
		end

	configuration: EWEASEL_CONFIGURATION
			-- Loaded configuration

feature {NONE} -- File

	set_include_directory
			-- Select a new include/control directory
		local
			l_dir_name: STRING
		do
			l_dir_name := open_directory
			if l_dir_name /= Void then
				output.append ("New include directory specified at " + l_dir_name, True)
				include_directory_text_field.set_text (l_dir_name)
			end
		end

	set_ise_eiffel_directory
			-- Select a new ISE_EIFFEL directory
		local
			l_dir_name: STRING
		do
			l_dir_name := open_directory
			if l_dir_name /= Void then
				output.append ("New ISE_EIFFEL directory specified at " + l_dir_name, True)
				ise_eiffel_var_text_field.set_text (l_dir_name)
			end
		end

	set_eweasel_directory
			-- Select a new EWEASEL directory
		local
			l_dir_name: STRING
		do
			l_dir_name := open_directory
			if l_dir_name /= Void then
				output.append ("New EWEASEL location specified at " + l_dir_name, True)
				eweasel_directory_text_field.set_text (l_dir_name)
			end
		end

	set_test_output_directory
			-- Select a new test output directory
		local
			l_dir_name: STRING
		do
			l_dir_name := open_directory
			if l_dir_name /= Void then
				output.append ("New test output directory specified at " + l_dir_name, True)
				test_output_directory_text_field.set_text (l_dir_name)
			end
		end

	set_control_file
			-- Select a new control file for test initialization
		local
			l_file_name: STRING
		do
			l_file_name := open_file
			if l_file_name /= Void then
				output.append ("New control file specified at " + l_file_name, True)
				control_file_text_field.set_text (l_file_name)
			end
		end

	load_catalog
			-- Load a new catalog of tests
		local
			l_file_name: STRING
		do
			if configuration /= Void and then configuration.is_valid then
				l_file_name := open_file
				if l_file_name /= Void then
					load_tests (l_file_name)
					display_tests
					configuration.set_catalog_file (l_file_name)
				end
			else
				output.append_error ("Cannot load a catalog because this configuration is not valid or has not been saved.%
					%Please supply all required configuration options and/or save the configuration.", True)
			end
		end

	save_catalog
			-- Save SELECTED tests into a new catalog
		do
			if tests_list.selected_item /= Void then
				save_tests (save_file)
			else
				output.append_error ("At least one test must be selected to save into a catalog", True)
			end
		end

	save_output
			-- Save output information.
		local
			l_file: PLAIN_TEXT_FILE
		do
			if attached save_file as n then
				create l_file.make_open_write (n)
				l_file.put_string (output_text.text)
				l_file.close
			end
		end

	copy_file (file, target: FILE)
			-- Copy contents of `file' to `target'
		require
			files_not_void: file /= Void and target /= Void
			source_files_exists: file.exists
			source_file_not_already_open: not file.is_open_read
			target_file_not_already_open: not target.is_open_write
		do
			file.open_read
			target.open_write
			file.start
			target.start
			file.copy_to (target)
			file.close
			target.close
		ensure
			files_closed: file.is_closed and target.is_closed
		end

feature {NONE} -- Implementation (GUI)

	output_control: EWEASEL_GRAPHICAL_OUTPUT
			-- Output interface
		once
			create Result.make (output_text)
		end

	update_interface
			-- Upadte interface components to reflect `configuration'
		require
			has_configuration: configuration /= Void
			configuration_valid: configuration.is_valid
		do
			include_directory_text_field.set_text (configuration.include_directory)
			test_output_directory_text_field.set_text (configuration.output_directory)
			control_file_text_field.set_text (configuration.control_file)
			ise_eiffel_var_text_field.set_text (configuration.eiffel_installation_directory)
			eweasel_directory_text_field.set_text (configuration.eweasel_installation_directory)
			if configuration.keep_tests.is_equal ("none") then
				keep_check_button.disable_select
			else
				keep_check_button.enable_select
				if configuration.keep_tests.is_equal ("all") then
					all_test_keep_radio.enable_select
				elseif configuration.keep_tests.is_equal ("failed") then
					failed_test_keep_radio.enable_select
				elseif configuration.keep_tests.is_equal ("passed") then
					passed_test_keep_radio.enable_select
				end
			end
			if configuration.keep_eifgens then
				keep_eifgen_check_buttons.enable_select
			else
				keep_eifgen_check_buttons.disable_select
			end
			if configuration.platform_type.is_equal ("windows") then
				platform_combo_box.i_th (1).enable_select
			elseif configuration.platform_type.is_equal ("win64") then
				platform_combo_box.i_th (1).enable_select
			elseif configuration.platform_type.is_equal ("dotnet") then
				platform_combo_box.i_th (2).enable_select
			elseif configuration.platform_type.is_equal ("unix") then
				platform_combo_box.i_th (3).enable_select
			end
			if configuration.catalog_file /= Void then
				load_tests (configuration.catalog_file)
				display_tests
			end
		end

	toggle_keep_options
			-- Toggle keep option radios
		do
			if keep_check_button.is_selected then
				keep_options_radio_box.enable_sensitive
			else
				keep_options_radio_box.disable_sensitive
			end
		end

	open_file: STRING
			-- Open an file from dialog and return filename.  Void otherwise.
		local
			l_open_dialog: EV_FILE_OPEN_DIALOG
		do
			create l_open_dialog
			l_open_dialog.show_modal_to_window (Current)
			if l_open_dialog.selected_button_name.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_open) then
				Result := l_open_dialog.file_name
			end
		end

	save_file: READABLE_STRING_32
			-- Save a file from dialog and return filename.  Void otherwise.
		local
			l_save_dialog: EV_FILE_SAVE_DIALOG
		do
			create l_save_dialog
			l_save_dialog.show_modal_to_window (Current)
			if l_save_dialog.selected_button_name.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_save) then
				Result := l_save_dialog.file_name
			end
		end

	open_directory: STRING
			-- Open an directory from dialog and return directory name.  Void otherwise.
		local
			l_open_dialog: EV_DIRECTORY_DIALOG
		do
			create l_open_dialog
			l_open_dialog.show_modal_to_window (Current)
			if l_open_dialog.selected_button_name.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok) then
				Result := l_open_dialog.directory
			end
		end

	display_tests
			-- Display loaded tests
		local
			l_test: EW_NAMED_EIFFEL_TEST
			l_list_item: EV_MULTI_COLUMN_LIST_ROW
		do
			if tests /= Void and then not tests.is_empty then
				from
					tests_list.wipe_out
					tests.start
					tests_list.set_column_titles (<<"Name", "Type">>)
				until
					tests.after
				loop
					l_test := tests.item
					create l_list_item
					l_list_item.extend (l_test.test_name)
					l_list_item.set_data (l_test)
					if l_test.keywords.count > 1 then
						l_list_item.extend (l_test.keywords.i_th (2))
					end
					tests_list.extend (l_list_item)
					tests.forth
				end
			end
		end

feature {NONE} -- Implementation

	eweasel: EW_EWEASEL_MT
			-- Eweasel

	eweasel_args: ARRAY [STRING]
			-- Arguments for eweasel built from gui values
		require
			has_configuration: configuration /= Void
			configuration_valid: configuration.is_valid
		local
			l_string: STRING
			l_arr: ARRAYED_LIST [STRING]
		do
			create l_arr.make (20)

				-- Application
			l_string :=  ((create {EXECUTION_ENVIRONMENT}).command_line.command_line)
			l_arr.extend (l_string)

			l_string :=  "-define"
			l_arr.extend (l_string)
			l_string :=  "EWEASEL"
			l_arr.extend (l_string)
			l_string :=  configuration.eweasel_installation_directory
			l_arr.extend (l_string)

			l_string :=  "-init"
			l_arr.extend (l_string)
			l_string :=  configuration.control_file
			l_arr.extend (l_string)

			l_string :=  "-output"
			l_arr.extend (l_string)
			l_string :=  configuration.output_directory
			l_arr.extend (l_string)

			l_string :=  "-define"
			l_arr.extend (l_string)
			l_string :=  "ISE_EIFFEL"
			l_arr.extend (l_string)
			l_string :=  configuration.eiffel_installation_directory
			l_arr.extend (l_string)

			l_string :=  "-define"
			l_arr.extend (l_string)
			l_string :=  "ISE_PLATFORM"
			l_arr.extend (l_string)
			l_string :=  configuration.platform_type
			l_arr.extend (l_string)

			l_string :=  "-define"
			l_arr.extend (l_string)
			l_string :=  "INCLUDE"
			l_arr.extend (l_string)
			l_string :=  configuration.include_directory
			l_arr.extend (l_string)

			l_string :=  "-define"
			l_arr.extend (l_string)
			l_string :=  "PLATFORM_TYPE"
			l_arr.extend (l_string)
			l_string :=  configuration.platform_type
			if l_string.is_case_insensitive_equal ("dotnet") then
				l_string := "DOTNET"
			elseif l_string.is_case_insensitive_equal ("win64") or l_string.is_case_insensitive_equal ("windows") then
				l_string := "WINDOWS"
			else
				l_string := "UNIX"
			end
			l_arr.extend (l_string)

			l_arr.extend ("-define")
			l_arr.extend (l_string)
			l_arr.extend ("1")

			if configuration.catalog_file /= Void then
				l_string :=  "-catalog"
				l_arr.extend (l_string)
				l_string := configuration.catalog_file
				l_arr.extend (l_string)
			end

			if not configuration.keep_eifgens then
				l_string := "-clean"
				l_arr.extend (l_string)
			end

			if not configuration.keep_tests.is_equal ("none") then
				l_string := "-keep"
				l_arr.extend (l_string)
				l_string := configuration.keep_tests
				l_arr.extend (l_string)
			end

			create Result.make_empty
			Result.rebase (0)
			from
				l_arr.start
			until
				l_arr.after
			loop
				Result.force (l_arr.item, l_arr.index - 1)
				l_arr.forth
			end
		end

	tests: ARRAYED_LIST [EW_NAMED_EIFFEL_TEST]
			-- Loaded tests

	load_tests (file: STRING)
			-- Load tests from test catalog file
		local
			tcf: EW_TEST_CATALOG_FILE
		do
			create tcf.make (file)
			create eweasel.make (eweasel_args)
			tcf.parse (eweasel.environment)
			if tcf.last_ok then
				create tests.make (tcf.last_catalog.all_tests.count)
				tests.append (tcf.last_catalog.all_tests)
				output.append ("Catalog loaded " + file, True)
			else
				output.append_error ("Error parsing test catalog, unable to open", True)
			end
		end

	save_tests (a_filename: READABLE_STRING_32)
			-- Save SELECTED tests into a new catalog.
		local
			l_tests: ARRAYED_LIST [EW_NAMED_EIFFEL_TEST]
			l_catalog: PLAIN_TEXT_FILE
		do
			if a_filename /= Void then
				if tests_list.selected_item /= Void then
					create l_catalog.make_open_write (a_filename)
					l_catalog.put_string ("source_path%T $BUGS")
					l_catalog.put_new_line
					l_catalog.put_new_line

					from
						create l_tests.make (tests_list.selected_items.count)
						tests_list.start
					until
						tests_list.after
					loop
						if tests_list.item.is_selected then
							if attached {EW_NAMED_EIFFEL_TEST} tests_list.item.data as l_test then
								l_catalog.put_string ("test%T")
								l_catalog.put_string (l_test.test_name + "%T")
								l_catalog.put_string (l_test.last_source_directory_component + "%T")
								l_catalog.put_string ("tcf ")
								from
									l_test.keywords.start
								until
									l_test.keywords.after
								loop
									l_catalog.put_string (l_test.keywords.item + " ")
									l_test.keywords.forth
								end
								l_catalog.put_new_line
							end
						end
						tests_list.forth
					end
					l_catalog.close
				else
					output.append_error ("At least one test must be selected to save into a catalog", True)
				end
			end
		end

	run_tests
			-- Run selected tests
		require
			eweasel_ready: eweasel /= Void and configuration.is_valid
		local
			l_old_catalog_file: STRING
			l_temp_file: PLAIN_TEXT_FILE
		do
			update_configuration
			if eweasel.args_ok then
				if tests_list.selected_item /= Void then
					create l_temp_file.make_create_read_write ("temp_catalog")
					l_old_catalog_file := configuration.catalog_file
					configuration.set_catalog_file ("temp_catalog")
					save_tests (l_temp_file.path.name)
					load_tests (l_temp_file.name)
					eweasel.execute
					configuration.set_catalog_file (l_old_catalog_file)
					l_temp_file.close
					l_temp_file.delete
				else
					output.append_error ("At least one test must be selected to execute", True)
				end
			end
		end

note
	copyright: "[
			Copyright (c) 1984-2017, University of Southern California, Eiffel Software and contributors.
			All rights reserved.
		]"
	license:   "Your use of this work is governed under the terms of the GNU General Public License version 2"
	copying: "[
			This file is part of the EiffelWeasel Eiffel Regression Tester.

			The EiffelWeasel Eiffel Regression Tester is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License version 2 as published
			by the Free Software Foundation.

			The EiffelWeasel Eiffel Regression Tester is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License version 2 for more details.

			You should have received a copy of the GNU General Public
			License version 2 along with the EiffelWeasel Eiffel Regression Tester
			if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA
		]"

end
