note
	description: "Root class for this application."
	author: "Generated by the New Vision2 Application Wizard."
	date: "$Date$"
	revision: "1.1.0"

class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			l_app: EV_APPLICATION
		do
			create l_app
			prepare
				-- The next instruction launches GUI message processing.
				-- It should be the last instruction of a creation procedure
				-- that initializes GUI objects. Any other processing should
				-- be done either by agents associated with GUI elements
				-- or in a separate processor.
			l_app.launch
				-- No code should appear here,
				-- otherwise GUI message processing will be stuck in SCOOP mode.
		end

	prepare
			-- Prepare the first window to be displayed.
			-- Perform one call to first window to avoid
			-- violation of the invariant of class EV_APPLICATION.
		do
				-- create and initialize the first window.
			create main_window

				-- Show the first window.
				--| TODO: Remove this line if you don't want the first
				--|       window to be shown at the start of the program.
			main_window.show
		end

feature {NONE} -- Implementation

	main_window: MAIN_WINDOW
			-- Main window.



end
