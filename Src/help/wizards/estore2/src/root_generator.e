indexing
	description: "Generate Root Class"
	author: "pascalf"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT_GENERATOR


creation
	make

feature -- Initialization

	make (ex: EXAMPLE_GENERATOR;s,t,u,v: STRING) is
		require
			ex /= Void and s /= Void
		do
			example := ex
			result_string := clone(s)
			result_string.replace_substring_all("<FL1>",ex.a_repository_name)
			result_string.replace_substring_all("<FL2>",ex.a_request_name)
			result_string.replace_substring_all("<FL3>",ex.a_request)
			result_string.replace_substring_all("<FL4>",t)
			result_string.replace_substring_all("<FL5>",u)
			result_string.replace_substring_all("<FL6>",v)
		ensure
			result_string /= Void and example /= Void
			set: example = ex
		end

feature -- Implementation

	example: EXAMPLE_GENERATOR

	result_string: STRING

invariant
	example /= Void
	result_string /= Void
end -- class ROOT_GENERATOR
