class TEST1 [G]

feature
	
	create_new_list is
			-- 
		local
			l_list: LINKED_LIST [like Current]
		do
			create l_list.make
			io.put_string (l_list.generating_type.name_32.as_string_8)
			io.put_new_line
		end
		
end
