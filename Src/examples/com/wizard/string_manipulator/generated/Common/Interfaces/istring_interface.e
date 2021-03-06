note
	description: "String manipulation interface String Manipulator Library"
	generator: "Automatically generated by the EiffelCOM Wizard."

deferred class
	ISTRING_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Basic Operations

	string: STRING
			-- Manipulated string
		deferred

		end

	set_string (a_string: STRING)
			-- Set manipulated string with `a_string'.
			-- `a_string' [in].  
		deferred

		end

	replace_substring (s: STRING; start_pos: INTEGER; end_pos: INTEGER)
			-- Copy the characters of `s' to positions `start_pos' .. `end_pos'.
			-- `s' [in].  
			-- `start_pos' [in].  
			-- `end_pos' [in].  
		deferred

		end

	prune_all (c: CHARACTER)
			-- Remove all occurrences of `c'.
			-- `c' [in].  
		deferred

		end

end -- ISTRING_INTERFACE


