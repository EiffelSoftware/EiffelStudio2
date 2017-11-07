note
	description: "Summary description for {WSF_URI_RESPONSE_HANDLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WSF_URI_RESPONSE_HANDLER

inherit
	WSF_HANDLER

	WSF_URI_HANDLER

feature -- Response

	response (req: WSF_REQUEST): WSF_RESPONSE_MESSAGE
		require
			is_valid_context: is_valid_context (req)
		deferred
		ensure
			Result_attached: Result /= Void
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Olivier Ligot, Colin Adams, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
