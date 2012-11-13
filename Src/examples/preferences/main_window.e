﻿note
	description	: "Main window for this application"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author		: "Generated by the New Vision2 Application Wizard."
	date		: "$Date$"
	revision	: "1.0.0"

class
	MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			create_interface_objects,
			is_in_default_state
		end

	INTERFACE_NAMES
		export
			{NONE} all
		undefine
			default_create, copy
		end

create
	default_create

feature -- Preference Testing

	initialize_standard_preferences
			-- Initialize preferences using standard manager, factory and preference types.
		local
				-- Standard
			l_factory: GRAPHICAL_PREFERENCE_FACTORY
			l_manager: PREFERENCE_MANAGER
			br: BOOLEAN_PREFERENCE
			ir: INTEGER_PREFERENCE
			ar: ARRAY_PREFERENCE
			ar32: ARRAY_STRING_32_PREFERENCE
			sr: STRING_PREFERENCE
			sr32: STRING_32_PREFERENCE
			fr: FONT_PREFERENCE
			cr: COLOR_PREFERENCE
			pp: PATH_PREFERENCE
			lst_s: STRING_LIST_PREFERENCE
			lst_p: PATH_LIST_PREFERENCE
			choice_s: STRING_CHOICE_PREFERENCE
			choice_p: PATH_CHOICE_PREFERENCE
			df: EV_FONT
			psf: PREFERENCES_STORAGE_FACTORY
			l_standard_preferences: like standard_preferences
		do
			create l_factory
			create psf

			--| Use file default.conf to load default values
			create l_standard_preferences.make_with_defaults_and_storage (<<"default.conf">>, psf.storage_for_basic)
			standard_preferences := l_standard_preferences

			create df.make_with_values (1, 6, 10, 8)
			df.preferred_families.extend ("verdana")
			df.preferred_families.extend ("arial")
			df.preferred_families.extend ("helvetica")

			--| Basic preferences under "examples"

			l_manager := l_standard_preferences.new_manager ("examples")
			ir := l_factory.new_integer_preference_value (l_manager, "examples.my_integer", 10)
			ar := l_factory.new_array_preference_value (l_manager, "examples.my_list", <<"1","2","3">>)
			ar := l_factory.new_array_preference_value (l_manager, "examples.my_list_as_choice", <<"1","2","3">>)
			ar.set_is_choice (True)
			if ar.selected_index = 0 then
				ar.set_selected_index (2)
			end

			--| Graphical preferences under "examples"

			fr := l_factory.new_font_preference_value (l_manager, "examples.my_font_preference", df)
			sr := l_factory.new_string_preference_value (l_manager, "examples.my_string_preference", "a string")
			sr := l_factory.new_string_preference_value (l_manager, "examples.driver_location", (create {DIRECTORY_NAME}.make_from_string ("C:\My Directory Location")).string)


			--| List and Choice of strings preferences under "examples"
			lst_s := l_factory.new_string_list_preference_value (l_manager, "examples.list.strings", <<{STRING_32} "你", {STRING_32} "好", {STRING_32} "吗">>)
			choice_s := l_factory.new_string_choice_preference_value (l_manager, "examples.choice.strings", lst_s.value)
			if choice_s.selected_index = 0 then
				choice_s.set_selected_index (2)
			end

			--| List and Choice of Paths preferences under "examples"
			lst_p := l_factory.new_path_list_preference_value (l_manager,
					"examples.list.paths",
					<<	create {PATH}.make_from_string ({STRING_32} "dir/你"),
						create {PATH}.make_from_string ({STRING_32} "dir/好"),
						create {PATH}.make_from_string ({STRING_32} "dir/吗")
					>>
				)
			choice_p := l_factory.new_path_choice_preference_value (l_manager, "examples.choice.paths", lst_p.value)
			if choice_p.selected_index = 0 then
				choice_p.set_selected_index (2)
			end

			--| Unicode,Path, ... value preferences under "examples"
			sr32 := l_factory.new_string_32_preference_value (l_manager, "examples.unicode.string_32", {STRING_32} "a unicode string 你好吗")
			pp := l_factory.new_path_preference_value (l_manager, "examples.my_path", create {PATH}.make_from_string ({STRING_32} "C:\unicode\folder\你好吗\here"))

			pp := l_factory.new_path_preference_value (l_manager, "examples.valid.existing_directory", (create {EXECUTION_ENVIRONMENT}).current_working_path)
			pp.require_existing_directory

			-- preference under "display"

			l_manager := l_standard_preferences.new_manager ("display")
			br := l_factory.new_boolean_preference_value (l_manager, "display.fullscreen_at_startup", True)
			cr := l_factory.new_color_preference_value (l_manager, "display.background_color", create {EV_COLOR}.make_with_8_bit_rgb (128, 2, 136))

			l_manager := l_standard_preferences.new_manager ("graphics")
			br := l_factory.new_boolean_preference_value (l_manager, "graphics.use_maximum_resolution", True)

--			l_standard_preferences.export_to_storage (create {PREFERENCES_STORAGE_XML}.make_with_location ("backup.conf"), False)
		end

	initialize_custom_preferences
			-- Initialize preferences using a custom manager (CUSTOM_MANAGER), which can create, in addition to the standard
			-- preference types the custom type DIRECTORY_RESOURCE.
		local
			l_manager: CUSTOM_MANAGER
			br: BOOLEAN_PREFERENCE
			dr: DIRECTORY_RESOURCE
			cr: COLOR_PREFERENCE
			psf: PREFERENCES_STORAGE_FACTORY
			l_custom_preferences: like custom_preferences
		do
			create psf
			create l_custom_preferences.make_with_storage (psf.storage_for_custom)
			custom_preferences := l_custom_preferences

			create l_manager.make (l_custom_preferences, "display")
			br := l_manager.new_boolean_preference_value (l_manager, "display.fullscreen_at_startup", True)
			cr := l_manager.new_color_preference_value (l_manager, "display.background_color", create {EV_COLOR}.make_with_8_bit_rgb (128, 128, 0))
			dr := l_manager.new_directory_preference_value ("display.driver_location", "C:\A Directory Location")

			create l_manager.make (l_custom_preferences, "graphics")
			br := l_manager.new_boolean_preference_value (l_manager, "graphics.use_maximum_resolution", True)
		end

	preference_window: detachable PREFERENCES_GRID_DIALOG
			-- The default preference interface widget

	custom_preference_window: detachable CUSTOM_PREFERENCE_DIALOG
			-- A custom preference interface widget

feature {NONE} -- Initialization

	standard_preferences: detachable PREFERENCES

	custom_preferences: detachable PREFERENCES

	create_interface_objects
		do
			create main_container
			Precursor
		end

	initialize
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}

			main_container := new_main_container
			extend (main_container)

				-- Execute `request_close_window' when the user clicks
				-- on the cross in the title bar.
			close_request_actions.extend (agent request_close_window)

				-- Set the title of the window
			set_title (Window_title)

				-- Set the initial size of the window
			set_size (Window_width, Window_height)
		end

	is_in_default_state: BOOLEAN
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

feature {NONE} -- Implementation, Close event

	request_close_window
			-- The user wants to close the window
		local
			question_dialog: EV_CONFIRMATION_DIALOG
		do
			create question_dialog.make_with_text (Label_confirm_close_window)
			question_dialog.show_modal_to_window (Current)

			if
				attached question_dialog.selected_button as but_txt and then
				but_txt.is_equal ((create {EV_DIALOG_CONSTANTS}).ev_ok)
			then
					-- Destroy the window
				destroy

					-- End the application
					--| TODO: Remove this line if you don't want the application
					--|       to end when the first window is closed..
				if attached (create {EV_ENVIRONMENT}).application as app then
					app.destroy
				end
			end
		end

feature {NONE} -- Implementation

	main_container: EV_VERTICAL_BOX
			-- Main container (contains all widgets displayed in this window)

	new_main_container: like main_container
			-- Create and populate `Result'.
		local
			basic_button,
			custom_button: EV_BUTTON
		do
			create Result
			Result.set_padding_width (3)
			Result.set_border_width (3)
			create basic_button.make_with_text ("Load preferences (normal view)")
			basic_button.select_actions.extend (agent show_standard_preference_window)
			Result.extend (basic_button)

			create custom_button.make_with_text ("Load preferences (custom view)")
			custom_button.select_actions.extend (agent show_custom_preference_window)
			Result.extend (custom_button)
		ensure
			result_created: Result /= Void
		end

	show_standard_preference_window
			-- Show preference window basic view
		local
			w: like preference_window
		do
			initialize_standard_preferences
			if attached standard_preferences as p then
				create w.make (p)
				preference_window := w
				w.show
			else
				check standard_preferences_exists: False end
			end
		end

	show_custom_preference_window
			-- Show preference window customized view
		local
			w: like custom_preference_window
		do
			initialize_custom_preferences
			if attached custom_preferences as p then
				create w.make_with_parent (p, Current)
				custom_preference_window := w
				w.show
			else
				check custom_preferences_exists: False end
			end
		end

feature {NONE} -- Implementation / Constants

	Window_title: STRING = "EiffelPreference Example"
			-- Title of the window.

	Window_width: INTEGER = 300
			-- Initial width for this window.

	Window_height: INTEGER = 100;
			-- Initial height for this window.

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class MAIN_WINDOW
