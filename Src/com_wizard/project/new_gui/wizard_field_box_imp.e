indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	WIZARD_FIELD_BOX_IMP

inherit
	EV_VERTICAL_BOX
		redefine
			initialize, is_in_default_state
		end
			
	WIZARD_CONSTANTS
		undefine
			is_equal, default_create, copy
		end

-- This class is the implementation of an EV_TITLED_WINDOW generated by EiffelBuild.
-- You should not modify this code by hand, as it will be re-generated every time
-- modifications are made to the project.

feature {NONE}-- Initialization

	initialize is
			-- Initialize `Current'.
		do
			Precursor {EV_VERTICAL_BOX}
			initialize_constants
			
				-- Create all widgets.
			create field_label
			create field_combo
			
				-- Build_widget_structure.
			extend (field_label)
			extend (field_combo)
			
			field_label.set_text ("Field:")
			field_label.align_text_left
			set_padding_width (5)
			disable_item_expand (field_label)
			disable_item_expand (field_combo)
			
				--Connect events.
			field_combo.select_actions.extend (agent on_select)
			field_combo.change_actions.extend (agent on_change)
			field_combo.return_actions.extend (agent on_return)
			field_combo.focus_in_actions.extend (agent on_mouse_enter)
			field_combo.focus_out_actions.extend (agent on_mouse_leave)
				-- Close the application when an interface close
				-- request is recieved on `Current'. i.e. the cross is clicked.

				-- Call `user_initialization'.
			user_initialization
		end

feature -- Access

	field_combo: EV_COMBO_BOX
	field_label: EV_LABEL

feature {NONE} -- Implementation

	is_in_default_state: BOOLEAN is
			-- Is `Current' in its default state?
		do
			-- Re-implement if you wish to enable checking
			-- for `Current'.
			Result := True
		end
	
	user_initialization is
			-- Feature for custom initialization, called at end of `initialize'.
		deferred
		end
	
	on_select is
			-- Called by `select_actions' of `field_combo'.
		deferred
		end
	
	on_change is
			-- Called by `change_actions' of `field_combo'.
		deferred
		end
	
	on_return is
			-- Called by `return_actions' of `field_combo'.
		deferred
		end
	
	on_mouse_enter is
			-- Called by `focus_in_actions' of `field_combo'.
		deferred
		end
	
	on_mouse_leave is
			-- Called by `focus_out_actions' of `field_combo'.
		deferred
		end
	

end -- class WIZARD_FIELD_BOX_IMP
