indexing

	Status: "See notice at end of class";
	Date: "$Date$"
	Revision: "$Revision$"
	Access: change, modify, update, insert, delete
	Product: EiffelStore
	Database: All_Bases

class DB_CHANGE

inherit

	DB_STATUS_USE
		export
			{ANY} is_connected
			{ANY} is_ok
		end

	DB_EXEC_USE
		export
			{NONE} all
		end

	DB_EXPRESSION

	DB_CONSTANT

creation -- Creation procedure

	make

feature -- Basic operations

	modify (request: STRING) is
			-- Execute `request' to modify persistent objects.
			-- When using the DBMS layer the request must be
			-- SQL-like compliant.
		require
			connected: is_connected
			request_exists: request /= Void
			is_ok: is_ok
		do
			implementation.modify (request)
			last_query := request
			if not is_ok and then is_tracing then
				trace_output.putstring (error_message)
				trace_output.new_line
			end			
		ensure
			last_query_changed: last_query = request
		end

	execute_query is
			-- Execute `modify' with `last_query'.
		do
			modify (last_query)
		end

feature {NONE} -- Implementation

	implementation: DB_CHANGE_I
		-- Handle reference to specific database implementation

feature {NONE} -- Initialization

	make is
			-- Create an interface object to change active base.
		do
			implementation := handle.database.db_change_i
			!! ht.make (name_table_size)
			implementation.set_ht (ht)
		end
	
end -- class DB_CHANGE


--|----------------------------------------------------------------
--| EiffelStore: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <eiffel@eiffel.com>
--|----------------------------------------------------------------
