indexing
	description	: "Wizard Step."
	author		: "Generated by the Wizard wizard"
	revision	: "1.0.0"

class
	WIZARD_THIRD_STATE

inherit
	WIZARD_INTERMEDIARY_STATE_WINDOW
		redefine
			update_state_information,
			proceed_with_current_info,
			build
		end
		
	GB_SHARED_TOOLS
	
	GB_WIDGET_UTILITIES
	
	GB_SHARED_SYSTEM_STATUS
	
	GB_CONSTANTS

create
	make

feature -- Basic Operation

	build is 
			-- Build entries.
		do
				-- Force the window back to the smallest size it can be.
				-- As we do not know the minimum_size, just make it as small
				-- as possible, and its size will be constrained to
				-- the widgets inside.
				-- This is needed if we are coming here, from the fourth state.
			first_window.set_minimum_size (100, 100)
			first_window.set_size (dialog_unit_to_pixels(503), dialog_unit_to_pixels(385))
			main_window.hide_all_floating_tools
			first_window.set_size (dialog_unit_to_pixels(503), dialog_unit_to_pixels(385))
			first_window.disable_user_resize
			first_window.disable_maximize
			create locals_grouped.make_with_text ("Group attribute declarations e.g. button1, button2: EV_BUTTON")
			if project_settings.grouped_locals then
				locals_grouped.enable_select
			end
			locals_grouped.select_actions.extend (agent update_locals_grouped)
			
			create attributes_local.make_with_text ("Generate attributes as locals")
			if project_settings.attributes_local.is_equal (True_string) then
				attributes_local.enable_select
			end
			attributes_local.select_actions.extend (agent update_attributes_local)
			
			create debugging_information.make_with_text ("Build debugging information in generated features")
			if project_settings.debugging_output then
				debugging_information.enable_select
			end
			debugging_information.select_actions.extend (agent update_debugging_information)
			
			create client_of_window.make_with_text ("Generated code is client of EV_TITLED_WINDOW")
			if project_settings.client_of_window then
				client_of_window.enable_select
			end
			client_of_window.select_actions.extend (agent update_client_information)
			
			-- Effectively removed from wizard, as it is not very important.
			-- For now, it can just stay here, but if it is really going to be
			-- removed for good, then just take it out.
			--choice_box.extend (locals_grouped)
			choice_box.extend (attributes_local)
			choice_box.extend (debugging_information)
			choice_box.extend (client_of_window)
			set_updatable_entries(<<>>)
		end		

	proceed_with_current_info is
			-- User has clicked next, go to next step.
		do
			Precursor
			proceed_with_new_state(create {WIZARD_FOURTH_STATE}.make(wizard_information))
		end
		
	update_state_information is
			-- Check User Entries
		do
			Precursor
		end

feature {NONE} -- Implementation

	display_state_text is
			-- Set the messages for this state.
		do
			title.set_text ("Code generation")
			subtitle.set_text ("Select generation options.")
			message.set_text ("Select desired code generation options:")
		end
		
	update_locals_grouped is
			-- Update project_settings based on state of `locals_grouped'.
		do
			if locals_grouped.is_selected then
				project_settings.enable_grouped_locals
			else
				project_settings.disable_grouped_locals
			end
		end
		
	update_attributes_local is
			-- Update project_settings based on state of `attributes_local'.
		do
				--| FIXME really handle all three states that now exist. Julian
			if attributes_local.is_selected then
				project_settings.set_attributes_locality (True_string)
			else
				project_settings.set_attributes_locality (Optimal_string)
			end
		end
		
	update_debugging_information is
			-- Update project_settings based on state of `debugging_information'.
		do
			if debugging_information.is_selected then
				project_settings.enable_debugging_output
			else
				project_settings.disable_debugging_output
			end
		end
		
	update_client_information is
			-- Update project_Settings based on state of `client_of_window'.
		do
			if client_of_window.is_selected then
				project_settings.enable_client_of_window
			else
				project_settings.disable_client_of_window
			end
		end
		

	locals_grouped: EV_CHECK_BUTTON
		-- Should all local declarations be grouped, or individual?
	
	attributes_local: EV_CHECK_BUTTON
		-- Should attributes be declared locally, or as attributes
		-- of the class?
	
	debugging_information: EV_CHECK_BUTTON
		-- Should debugging information be generated for each
		-- connected event?
		
	client_of_window: EV_CHECK_BUTTON
		-- Should generated code be a client of EV_WINDOW?
	
	project_settings: GB_PROJECT_SETTINGS is
			-- `Result' is current project settings of the system.
		do
			Result := system_status.current_project_settings
		end

end -- class WIZARD_THIRD_STATE
