class
	TEST2 [G]

feature

	g
		local
			list1: LINKED_LIST [G]
			list2: LINKED_LIST [attached G]
			list3: LINKED_LIST [detachable G]
		do
			create list1.make
			create list2.make
			create list3.make
			io.put_string (list1.generating_type.name_32.to_string_8) io.put_new_line
			io.put_string (list2.generating_type.name_32.to_string_8) io.put_new_line
			io.put_string (list3.generating_type.name_32.to_string_8) io.put_new_line
		end

end
