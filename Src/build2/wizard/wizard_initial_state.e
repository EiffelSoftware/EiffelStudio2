indexing
	description	: "Wizard Initial Step"
	author		: "Generated by the Wizard wizard"
	revision	: "1.0.0"

class
	WIZARD_INITIAL_STATE

inherit
	WIZARD_INITIAL_STATE_WINDOW
		redefine
			proceed_with_current_info,
			make
		end
		
	GB_SHARED_TOOLS
	
	GB_SHARED_SYSTEM_STATUS
	
	GB_SHARED_XML_HANDLER

creation
	make

feature -- Initialization is

	make (an_info: like wizard_information) is
			-- Create `Current' and initialize.
		do
			Precursor {WIZARD_INITIAL_STATE_WINDOW} (an_info)
			
				-- Set up the build interface if not already done.
			if main_window.is_empty then
				main_window.build_interface
				xml_handler.load_components	
			end
		end
		

feature {NONE} -- Implementation

	proceed_with_current_info is 
			-- Go to next step.
		do
			Precursor
				-- The first state is not needed for the current project options,
				-- when launched fromVisualStudio. The second state may still be
				-- needed if other options are selected.
			proceed_with_new_state(Create {WIZARD_SECOND_STATE}.make(wizard_information))
		end

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Welcome to the%NEiffel Build Wizard")
			message.set_text ("This wizard enables you to develop a new Eiffel Vision2 project.%
				%%N%NEiffel Build will be launched as part of this process, which will%
				%%Nenable a non trivial interface to be developed if so desired.")
		end
	
	pixmap_icon_location: FILE_NAME is
			--
		once
			create Result.make_from_string ("eiffel_wizard_icon.png")
		end
		

end -- class WIZARD_INITIAL_STATE
