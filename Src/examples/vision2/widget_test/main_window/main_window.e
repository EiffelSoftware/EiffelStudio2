indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MAIN_WINDOW

inherit
	MAIN_WINDOW_IMP
	
	WIDGET_TEST_SHARED
		undefine
			copy, default_create, is_equal
		end

feature {NONE} -- Initialization

	user_initialization is
			-- called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		local
			type_selector: GB_TYPE_SELECTOR
			editor: GB_OBJECT_EDITOR
			controller: TEST_CONTROLLER
			event_selector: EVENT_SELECTOR
		do
				-- Create the editor and parent.
			create editor
			object_editor.extend (editor)

				-- Create the type selector and parent.
			create type_selector
			widget_selector_parent.extend (type_selector)
			
				-- Create the test controller.
			create controller.make_with_text_control (test_class_display)
			controller_parent.extend (controller)
			
			create event_selector.make_with_list (event_selector_list, event_output)
			register_type_change_agent (agent event_selector.rebuild)
			
			register_type_change_agent (agent parent_test_widget)
		end

feature {NONE} -- Implementation

	set_window_title (a_widget: EV_WIDGET) is
			-- Assign a title to `Current', reflecting type
			-- of widget that is currently being tested.
		do
			set_title ("Testing - " + test_widget_type + ".")
		end
		

	parent_test_widget (a_widget: EV_WIDGET) is
			-- Ensure `a_widget' is parented in
			-- `widget_holder'.
		do
			widget_holder.wipe_out
			widget_holder.extend (a_widget)
		end
	
end -- class MAIN_WINDOW

