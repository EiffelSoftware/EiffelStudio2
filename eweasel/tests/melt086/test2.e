class
	TEST2 [G, H -> ANY]

inherit
	TEST3 [H]
		redefine
			value
		end

create
	make

feature

	make 
		do
			print (value)
		end

	value: H
		do
			print (([Precursor]).generating_type)
			io.put_new_line

			print ((<< Precursor >>).generating_type)
			io.put_new_line
		end

end
