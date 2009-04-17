note
	description: "[
		Generates a tree of XB_TAGs
	]"
	legal: "See notice at end of class."
	status: "Prototyping phase"
	date: "$Date$"
	revision: "$Revision$"

class
	XP_XML_PARSER_CALLBACKS

inherit
	XM_CALLBACKS
	ERROR_SHARED_ERROR_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_parser: XM_PARSER; a_path: STRING)
			-- Create XB_XML_PARSER_CALLBACKS.
		require
			a_path_is_valid: not a_path.is_empty
		do
			parser := a_parser
			path := a_path
			create root_tag.make ("xeb", "html", Html_tag_name, current_debug_information)
			create tag_stack.make (10)
			create html_buf.make_empty
			create state_html.make (Current)
			create state_tag.make (Current)
			state := state_html
			controller_class := "STRING"
		ensure
			html_buf_is_empty: html_buf.is_empty
			tag_stack_is_empty: tag_stack.is_empty
		end

feature -- Constants

	Html_tag_name: STRING = "XTAG_XEB_HTML_TAG"
	Output_tag_name: STRING = "XTAG_XEB_OUTPUT_CALL_TAG"

	Reading_html: INTEGER = 0
	Reading_tag: INTEGER = 1

	Configuration_tag: STRING = "page"

	parser: XM_PARSER

feature -- Access

	path: STRING
			-- The path of the file to which is being read

	controller_class: STRING
			-- The class of the handling controller

	state: XP_CALLBACK_STATE
			-- The current state of the parser

	state_tag: XP_TAG_CALLBACK_STATE
			-- The instance for the state = tag

	state_html: XP_HTML_CALLBACK_STATE
			-- The instance for the state = html

	html_buf: STRING
			-- Stores html text until a tag is created from it

	root_tag: XP_TAG_ELEMENT
			-- Represents the root of the XB_TAG tree

	tag_stack: ARRAYED_STACK [XP_TAG_ELEMENT]
			-- The stack is used to generate the tree

	taglibs: HASH_TABLE [XTL_TAG_LIBRARY, STRING]
			-- Tag library which should be used

	put_taglibs (a_taglibs: HASH_TABLE [XTL_TAG_LIBRARY, STRING])
			-- Adds a taglib to the parser
		do
			taglibs := a_taglibs
			taglibs.put (generate_configuration_taglib, Configuration_tag)
		end

feature -- Document

	on_start
			-- Called when parsing starts.
		do
			tag_stack.wipe_out
			tag_stack.put (root_tag)
			create {XP_HTML_CALLBACK_STATE} state.make (Current)
		ensure then
			only_root_on_stack: tag_stack.count = 1
		end

	on_finish
			-- Called when parsing finished.
		do
			if not html_buf.is_empty then
				create_html_tag_put
			end
		ensure then
			only_root_on_stack: tag_stack.count = 1
			buffer_is_empty: html_buf.is_empty
		end

	on_xml_declaration (a_version: STRING; an_encoding: STRING; a_standalone: BOOLEAN)
			-- XML declaration.		
		do
			--error_manager.set_last_error (create {XERROR_PARSE}.make (["Xml declarations not yet supported " + current_debug_information + " in " + path]), false)
		end

feature -- Errors

	on_error (a_message: STRING)
			-- Event producer detected an error.
		do
			error_manager.set_last_error (create {XERROR_PARSE}.make ([a_message + current_debug_information + "%N in '" + path + "'%N"]), false)
		end

feature -- Meta

	on_processing_instruction (a_name: STRING; a_content: STRING)
			-- Processing instruction.
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		do
			error_manager.set_last_error (create {XERROR_PARSE}.make (["INSTRUCTIONS not yet implemented"]), False)
		end

	on_comment (a_content: STRING)
			-- Processing a comment.
			-- Atomic: single comment produces single event
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		do
			--if state = Reading_tag then
			--	state := Reading_html
			--end
			--html_buf.append ("<!--" + a_content + "-->")
		end

feature -- Tag

	on_start_tag (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING)
			-- Start of start tag.
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		local
			l_prefix: STRING
			l_local_part: STRING
			l_tmp_tag: XP_TAG_ELEMENT
			l_class_name: STRING
			l_taglib: XTL_TAG_LIBRARY
		do
			if attached a_prefix then
				l_prefix := a_prefix
			else
				l_prefix := ""
			end

			if attached a_local_part then
				l_local_part := a_local_part
			else
				l_local_part := ""
			end

			state.on_start_tag (a_namespace, l_prefix, l_local_part)
		ensure then
			stack_bigger_or_html_tag: (tag_stack.count = old tag_stack.count) implies state = Reading_html
		end

	on_attribute (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING; a_value: STRING)
			-- Start of attribute.
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		local
			l_namespace: STRING
			l_prefix: STRING
			l_local_part: STRING
			l_value: STRING
			taglib: XTL_TAG_LIBRARY
		do
			if attached a_namespace then
				l_namespace := a_namespace
			else
				l_namespace := ""
			end
			if attached a_prefix then
				l_prefix := a_prefix
			else
				l_prefix := ""
			end
			if attached a_local_part then
				l_local_part := a_local_part
			else
				l_local_part := ""
			end
			if attached a_value then
				l_value := a_value
			else
				l_value := ""
			end

			state.on_attribute (l_namespace, l_prefix, l_local_part, l_value)
		ensure then
			stack_does_not_change: tag_stack.count = old tag_stack.count
		end

	on_start_tag_finish
			-- End of start tag.
		do
			state.on_start_tag_finish
		end

	on_end_tag (a_namespace: STRING; a_prefix: STRING; a_local_part: STRING)
			-- End tag.
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		local
			l_prefix: STRING
			l_local_part: STRING
		do
			if attached a_prefix then
				l_prefix := a_prefix
			else
				l_prefix := ""
			end

			if attached a_local_part then
				l_local_part := a_local_part
			else
				l_local_part := ""
			end

			state.on_end_tag (a_namespace, l_prefix, l_local_part)
		end

feature -- Content

	on_content (a_content: STRING)
			-- Text content.
			-- NOT atomic: two on_content events may follow each other
			-- without a markup event in between.
			-- Warning: strings may be polymorphic, see XM_STRING_MODE.
		do
			--state := Reading_html
			state.on_content (a_content)
			--html_buf.append (a_content)
		end

feature {XP_CALLBACK_STATE} -- Implementation

	get_tag_lib (id: STRING): XTL_TAG_LIBRARY
			-- Returns tag library with the name `id'
		require
			id_is_valid: not id.is_empty
		do
			Result := taglibs [id]
		end

	create_html_tag_with_text (s: STRING)
			-- Creates a XB_TAG from `s' and adds it to top element on stack.
		require
			s_is_valid: not s.is_empty
		local
			l_tag: XP_TAG_ELEMENT
		do
			if not s.is_empty then
				create l_tag.make ("xeb", "html", Html_tag_name, current_debug_information)
				tag_stack.item.put_subtag (l_tag)
			end
		end

	create_html_tag_with_text_put (s: STRING)
			-- Creates a XB_TAG from s and adds it to top element on stack and then pushes it onto the stack.
		local
			l_tag: XP_TAG_ELEMENT
		do
			if not s.is_empty then
				create l_tag.make ("xeb", "html", Html_tag_name, current_debug_information)
				l_tag.put_attribute ("text", s)
				l_tag.multiline_argument := True
				tag_stack.item.put_subtag (l_tag)
			end
		end

	create_html_tag_put
			-- Creates a XB_TAG from html_buf and adds it to top element on stack then pushes it onto the stack.
		do
			create_html_tag_with_text_put (html_buf.out)
				-- Don't use html_buf (instead of html_buf.out), since it will be wiped_out in the html_tag as well
			html_buf.wipe_out
		ensure
			html_buf_is_empty: html_buf.is_empty
			tag_stack_didnt_change: tag_stack.count = old tag_stack.count
		end

	process_dynamic_html_attribute (local_part, value: STRING)
			-- Extracts the name of the feature from the value
			-- Generates an html tag element and an output call
		require
			local_part_is_valid: not local_part.is_empty
		local
			l_tag: XP_TAG_ELEMENT
			feature_name: STRING
		do
			html_buf.append (" " + local_part + "=%"")
			create_html_tag_put
			create l_tag.make ("xeb", "output", Output_tag_name, current_debug_information)
			feature_name := strip_off_dynamic_tags (value)
			l_tag.put_attribute ("value", feature_name)
			tag_stack.item.put_subtag (l_tag)
				-- Don't put it on the stack
			html_buf.append ("%"")
		ensure
			tag_stack_didnt_change: tag_stack.count = old tag_stack.count
		end

	process_dynamic_tag_attribute (local_part, value: STRING)
			-- And adds an attribute
		require
			local_part_is_valid: not local_part.is_empty
		local
			feature_name: STRING
		do
			feature_name := strip_off_dynamic_tags (value)
			tag_stack.item.put_attribute (local_part, "controller." + feature_name)
		end

	strip_off_dynamic_tags (a_string: STRING): STRING
			-- Strips off the "%=" and ending "%"		
		require
			a_string_is_valid: a_string.starts_with ("%%=") and a_string.ends_with ("%%")
		do
			Result := a_string.substring (3, a_string.count - 1)
		end

	current_debug_information: STRING
			-- Queries the parser for row and column
		do
			if parser.position /= Void then
				Result := "line: " + parser.position.row.out + " column: " + parser.position.column.out + " path: " + path
			else
				Result := "Could not determine position!"
			end
		end

	set_state_html
			-- Sets the state to the html object
		do
			state := state_html
		end

	set_state_tag
			-- Sets the state to the tag object
		do
			state := state_tag
		end

	generate_configuration_taglib: XTL_HARDWIRED_TAG_LIB
			-- Generates the tablig with the page configurations
		do
			create Result.make_hard_wired (Configuration_tag)
			Result.put (create {XTL_AGENT_TAG_DESCRIPTION}.make_with_agent ("controller", agent controller_configuration_handler))
		end

	controller_configuration_handler (id, value: STRING)
			-- Handles #Configuration_tag:controller tags
		do
			if id.is_equal ("class") then
				controller_class := value
			end
		end

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
