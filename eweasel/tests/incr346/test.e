class TEST

inherit
	TEST1 -- [TEST3]

create
	make

feature
	
	make
		do
			try
		end

	stoat (a, b: INTEGER)
		do
			weasel (a, b)
		end
	
	weasel (a, b: INTEGER)
		external "C inline"
		alias "[
			printf("%d %d\n", $a, $b);
			]"
		end

end
