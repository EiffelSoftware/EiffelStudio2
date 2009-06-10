note
	description: "[
		GET version of REQUEST
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	XH_GET_REQUEST

inherit
	XH_REQUEST
	redefine
		method
	end

create
	make_from_message,
	make_empty,
	make_goto_request

feature -- Access

	method: CHARACTER = 'G'

feature -- Implementation

	read_uri (a_the_request: STRING): STRING
			-- <Precursor>
		local
			l_i: INTEGER
		do
			if a_the_request.has_substring ("?") then
				l_i := a_the_request.substring_index ("?",1)
				Result := a_the_request.substring (5, l_i-1)
			else
				l_i := a_the_request.substring_index ("HTTP",1)
				Result := a_the_request.substring (5, l_i-2)
			end
		ensure then
			Result_attached: Result /= Void
		end

	call_pre_handler (a_servlet: XWA_SERVLET; a_response: XH_RESPONSE)
			-- <Precursor>
			-- Calls prehandle_get_request
		do
			-- Do nothing
		end

end
