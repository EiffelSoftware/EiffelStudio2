indexing

	description: 
		"EiffelVision label"
	status: "See notice at end of class"
	id: "$Id$"
	date: "$Date$"
	revision: "$Revision$"

class 
	EV_LABEL

inherit

	EV_PRIMITIVE
		redefine
			make, implementation
		end
	
	EV_BAR_ITEM
	
	EV_TEXT_CONTAINER
		redefine
			implementation
		end
		
creation
	
	make

feature {NONE} -- Initialization

        make (par: EV_CONTAINER) is
                        -- Create a label with, `par' as
                        -- parent
		do
			!EV_LABEL_IMP!implementation.make (par)
			widget_make (par)
		end
		

feature {NONE} -- Implementation

	implementation: EV_LABEL_I
			-- Implementation of label
	
end -- class EV_LABEL
