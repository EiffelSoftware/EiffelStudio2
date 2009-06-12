note
	description: "[
		Parses command line arguments that configure the translator.
	]"
	legal: "See notice at end of class."
	status: "Prototyping phase"
	date: "$Date$"
	revision: "$Revision$"

class
	XT_ARGUMENT_PARSER

inherit
	ARGUMENT_OPTION_PARSER
		rename
			make as make_option_parser
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize the argument parser.
		do
			make_option_parser (False)
			set_is_showing_argument_usage_inline (False)
		end

feature -- Access

feature -- Status report

	project_name: STRING
			-- The name of the project
		require
			is_successful: is_successful
		do
			Result := ""
			if attached option_of_name (project_name_switch) as l_option then
				Result := l_option.value
			end
		ensure
			not_Result_is_detached_or_empty: Result /= Void and then not Result.is_empty
		end

	tag_lib_path: FILE_NAME
			-- The tag_lib_path
		require
			is_successful: is_successful
		do
			create Result.make
			if attached option_of_name (tag_lib_path_switch) as l_option then
				create Result.make_from_string (l_option.value)
			end
		ensure
			not_Result_is_detached_or_empty: Result /= Void and then not Result.is_empty
		end


	output_path: FILE_NAME
			-- The output_path
		require
			is_successful: is_successful
		do
			create Result.make
			if attached option_of_name (output_path_switch) as l_option then
				create Result.make_from_string (l_option.value)
			end
		ensure
			not_Result_is_detached_or_empty: Result /= Void and then not Result.is_empty
		end

	input_path: FILE_NAME
			-- The input_path
		require
			is_successful: is_successful
		do
			create Result.make
			if attached option_of_name (input_path_switch) as l_option then
				create Result.make_from_string (l_option.value)
			end
		ensure
			not_Result_is_detached_or_empty: Result /= Void and then not Result.is_empty
		end

	debug_level: INTEGER
			-- The debug_level
		require
			is_successful: is_successful
		do
			Result := 0
			if has_option (debug_level_switch) and then attached option_of_name (debug_level_switch) as l_option then
				if l_option.value.is_integer then
					Result := l_option.value.to_integer
				end
			end
		end

feature {NONE} -- Access: Usage

	name: STRING = "Xebra Translator"
			-- <Precursor>

	version: STRING
			-- <Precursor>
		once
--			create Result.make (3)
--			Result.append_integer ({EIFFEL_ENVIRONMENT_CONSTANTS}.major_version)
--			Result.append_character ('.')
--			Result.append_integer ({EIFFEL_ENVIRONMENT_CONSTANTS}.minor_version)
			Result := "not implemented"
		end

	switches: ARRAYED_LIST [ARGUMENT_SWITCH]
			-- <Precursor>
		once
			create Result.make (1)
			Result.extend (create {ARGUMENT_VALUE_SWITCH}.make (project_name_switch, "Specifies the name of the project", False, False, "project_name", "Project name", False))
			Result.extend (create {ARGUMENT_FILE_OR_DIRECTORY_SWITCH}.make (input_path_switch, "Specifies the path to the directory with the input files", False, False, "input_path", "The input directory path", False))
			Result.extend (create {ARGUMENT_FILE_OR_DIRECTORY_SWITCH}.make (output_path_switch, "Specifies the path to the directory where the generated files will be written.", False, False, "ouput_path", "The output path", False))
			Result.extend (create {ARGUMENT_FILE_OR_DIRECTORY_SWITCH}.make (tag_lib_path_switch, "Specifies the path to the directory where the tag libraries are located.", False, False, "tag_lib", "The tag libraries directory", False))
			Result.extend (create {ARGUMENT_INTEGER_SWITCH}.make (debug_level_switch, "Specifies a debug level. 0: No debug output. 10: All debug ouput.", True, False, "debug_level", "The debug level (0-10)", False))
		end

feature {NONE} -- Switches

	project_name_switch: STRING = "n|project_name"
	input_path_switch: STRING = "i|input_path"
	output_path_switch: STRING = "o|output_path"
	tag_lib_path_switch: STRING = "t|tag_library_path"
	debug_level_switch: STRING = "d|debug_level"

end
