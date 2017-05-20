note
	description: "Summary description for {ECF_REMOVE_SAFE_COMMAND}."
	date: "$Date$"
	revision: "$Revision$"

class
	ECF_REMOVE_SAFE_COMMAND

inherit
	APPLICATION_COMMAND

create
	make

feature {NONE} -- Initialization

	make (a_name: detachable READABLE_STRING_8)
		do
			if a_name = Void then
				create name.make_from_string (default_name)
			else
				create name.make_from_string (a_name)
			end
		end

feature -- Access

	default_name: STRING_8 = "remove_safe"

	synopsis: STRING_32
		do
			Result := {STRING_32} "Remove useless -safe.ecf, update location to drop the '-safe', and create redirection -safe.ecf to .ecf."
		end

feature -- Execution

	process (args_src: ARGUMENT_SOURCE)
		local
			arg_parser: ECF_REMOVE_SAFE_ARGUMENT_PARSER
		do
			create arg_parser.make_with_source (args_src)
			arg_parser.set_is_usage_displayed_on_error (True)
			arg_parser.execute (agent execute (arg_parser))
		end

	execute (args: ECF_REMOVE_SAFE_ARGUMENT_PARSER)
		local
			app: ECF_REMOVE_SAFE
		do
			create app.make (args)
		end

note
	copyright: "Copyright (c) 1984-2016, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
