indexing
	description: "Objects that provide access to constants used."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	GB_CONSTANTS
	
inherit
	ANY	
		undefine
			default_create, copy, is_equal
		end

feature -- Access

	Gb_main_window_title: STRING is "Graphical builder"
		-- Title to be displayed in GB_MAIN_WINDOW.
		
	Gb_display_window_title: STRING is "Display window"
		-- Title to be displayed in GB_DISPLAY_WINDOW.
		
	Gb_builder_window_title: STRING is "Builder window"
		-- Title to be displayed in GB_BUILDER_WINDOW.
		
	Gb_object_editor_window_title: STRING is "Object editor"
		-- Title to be displayed in GB_OBJECT_EDITOR.

	
	
feature -- Menu texts.
	
	Gb_file_menu_text: STRING is "&File"
		-- Text of file menu.
		
	Gb_file_exit_menu_text: STRING is "&Exit"
		
	Gb_help_about_menu_text: STRING is "&About"
	
	Gb_help_menu_text: STRING is "&Help"
	
	Gb_project_menu_text: STRING is "Project"
	
	Gb_project_menu_build_text: STRING is "Build"

	Gb_project_menu_settings_text: STRING is "&Settings"
	
	Gb_view_menu_text: STRING is "&View"
	
feature -- String representations of class names.

	Gb_primitive_object_class_name: STRING is "GB_PRIMITIVE_OBJECT"
	
	Ev_window_string: STRING is "EV_WINDOW"
	
	Ev_titled_window_string: STRING is "EV_TITLED_WINDOW"

feature -- Miscellaneous

	Internal_properties_string: STRING is "Internal_properties"
		-- Xml tag used to store properties stored by GB_OBJECT
		-- but not in the interface of Vision2.
	
feature -- Directories

	gb_ev_directory: FILE_NAME is
		do
			create Result.make_from_string ((create {EIFFEL_ENV}).Eiffel_installation_dir_name)
			Result.extend ("build")
			Result.extend ("interface")
		end
	
feature -- Default values

	Minimum_width_of_object_editor: INTEGER is 120
		-- The minimum width allowed for a GB_OBJECT_EDITOR

feature -- Generation constants

	template_file_location: FILE_NAME is
			-- Location of templates.
		do
			create Result.make_from_string ((create {EIFFEL_ENV}).Eiffel_installation_dir_name)		
			Result.extend ("build")
			Result.extend ("templates")
		end
		

	window_template_file_name: FILE_NAME is
			-- `Result' is location of build template file,
			-- including the name.
		do
			Result := template_file_location
			Result.extend ("build_class_template.e")
		end
		
	application_template_file_name: FILE_NAME is
			-- `Result' is location of build application template file,
			-- including the name.
		do
			Result := template_file_location
			Result.extend ("build_application_template.e")
		end
		
	windows_ace_file_name: FILE_NAME is
			-- `Result' is location of windows ace file template.
		do
			Result := template_file_location
			Result.extend ("windows")
			Result.extend ("ace_template.ace")
		end
		
	unix_ace_file_name: FILE_NAME is
			-- `Result' is location of windows ace file template.
		do
			Result := template_file_location
			Result.extend ("unix")
			Result.extend ("ace_template.ace")
		end
		
	class_name_tag: STRING is
			-- `Result' is tag used in templates
			-- for the class name.
		once
			Result := "<CLASS_NAME>"
		end
		
	create_tag: STRING is
			-- `Result' is tag used in templates
			-- for the creation of widgets.
		once
			Result := "<CREATE>"
		end
		
	build_tag: STRING is
			-- `Result' is tag used in templates
			-- for buiilding of the widget heirarchy.
		once
			Result := "<BUILD>"
		end
		
	set_tag: STRING is
			-- `Result' is tag used in templates
			-- for the setting of widgets properties.
		once
			Result := "<SET>"
		end
		
	local_tag: STRING is
			-- `Result' is tag used in templates
			-- for local definitions.
		once
			Result := "<LOCAL>"
		end
		
	main_window_tag: STRING is
			-- `Result' is tag used in templates
			-- for the main window declaration.
		once
			Result := "<MAIN_WINDOW>"
		end
		
	project_location_tag: STRING is
			-- `Result' is tag used in ace templates
			-- for the project location.
		once
			Result := "<PROJECT_LOCATION>"
		end
		
		
		
	indent: STRING is
			-- String representing standard indent
			-- for code generation.
		once
			Result := "%N%T%T%T"
		end
		
	Local_object_name_prepend_string: STRING is "l_"
			-- generated local variables are of the form
			-- `Result' + short type + number.
			-- i.e. l_button1
			
	Generation_directory: STRING is "generated"
		-- Directory name to hold the generated files.
		
		
feature -- XML saving

	filename: FILE_NAME is
			-- File to be generated.
		local
			accessible_status: GB_ACCESSIBLE_SYSTEM_STATUS
		do
			create accessible_status
			create Result.make_from_string (accessible_status.system_status.current_project_settings.project_location)
			Result.extend ("system_interface.xml")
		end		
		
	component_filename: FILE_NAME is
			-- Location of component file.
		do
			create Result.make_from_string ((create {EIFFEL_ENV}).Eiffel_installation_dir_name)
			Result.extend ("build")
			Result.extend ("temp")
			Result.extend ("xml_components.xml")
		end
		
	project_filename: STRING is "project.bpr"
		-- File name for project settings.
		
	project_file_filter: STRING is "*.bpr"
		-- Filter to be used for file dialogs searching
		-- for build projects.
		
	xml_format: STRING is "<?xml version=%"1.0%" encoding=%"UTF-8%"?>"
		-- XML format type, included at start of `document'.
		
feature -- XML constants


	True_string: STRING is "True"
		-- String constant representing True.
		
	False_string: STRING is "False"
		-- String constant representing False.
		
	Item_string: STRING is "item"
		-- String constant representing "item".
		
	Name_string: STRING is "name"
		-- String constant representing "name".
	
	Schema_instance: STRING is "http://www.w3.org/1999/XMLSchema-instance"
		-- Schema information for inclusion in XML files.
	
feature -- Dialogs

	b_OK: STRING is "OK"
	
	b_Cancel: STRING is "Cancel"
	
	b_Apply: STRING is "Apply"

	Save_prompt: STRING is "Do you wish to save the current project?"
	
feature -- Warning Dialogs

	Invalid_project_warning: STRING is "Invalid build project file. Please select a different file."
		-- Warning displayed when a user attempts to open an invalid build project.

	Duplicate_name_warning_part1: STRING is "An object exists with the name '"
		-- First part of warning used when a name that already exists is entered.
		
	Duplicate_name_warning_part2: STRING is "'. Object names must be unique.%N%NSelecting 'Modify' will allow editing of current invalid name%NSelecting 'Cancel' will restore old name."
		-- Second part of warning used when a name that already exists is entered.

	Delete_component_warning: STRING is "Are you sure you wish to delete the component from the system?"

	Class_invalid_name_warning: STRING is " is not a valid Class name.%NClass names should only include%N%
		%alphanumeric characters or underscores,%Nand start with an alphabetic character.%N%
		%please select a different Class name."

	Component_invalid_name_warning: STRING is " is not a valid Component name.%NComponent names should only include%N%
		%alphanumeric characters or underscores,%Nand start with an alphabetic character.%N%
		%please select a different component name."
		
	Component_identical_name_warning: STRING is " is already used as a component name.%NPlease enter a unique component name."

end -- class GB_CONSTANTS
