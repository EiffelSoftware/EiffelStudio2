indexing
	description: "Objects that represent the Vision2 appliation%
		%generated by build."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	<APPLICATION>

inherit
	EV_APPLICATION

create
	make_and_launch
	
feature {NONE} -- Initialization

	make_and_launch is
			-- Create `Current', build and display `main_window',
			-- then launch the application.
		do
			default_create
			create main_window
			main_window.show
			launch
		end
		
feature {NONE} -- Implementation

	main_window: <MAIN_WINDOW>
		-- Main window of `Current'.

end -- class <APPLICATION>
