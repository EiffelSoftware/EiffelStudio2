indexing 
	description: "WIZARD_ABOUT_DIALOG class created by Resource Bench."

class 
	WIZARD_ABOUT_DIALOG

inherit
	WEL_MODAL_DIALOG
		redefine
			setup_dialog
		end

	APPLICATION_IDS
		export
			{NONE} all
		end

creation
	make

feature {NONE} -- Initialization

	make (a_parent: WEL_COMPOSITE_WINDOW) is
			-- Create the dialog.
		require
			a_parent_not_void: a_parent /= Void
			a_parent_exists: a_parent.exists
		do
			make_by_id (a_parent, Wizard_about_dialog_constant)
			create about_text.make_by_id (Current, About_static_constant)
		end

feature -- Access

	about_text: WEL_STATIC
			-- About text

feature -- Behaviour

	setup_dialog is
			-- Initialize dialog.
		do
			about_text.set_text (About_eiffelcom)
		end

feature {NONE} -- Implementation

	About_eiffelcom: STRING is "EiffelCOM 5.1 %N%
						%February 13, 2002 %N%N%
						%Copyright (C) 1999-2001%N%
						%Interactive Software Engineering Inc. %N%N%
						%ISE Building %N%
						%360 Storke Road, Goleta, %N%
						%CA 93117 USA %N%N%
						%Tel: (805)685-1006   Fax: (805)695-6869 %N%
						%Email: <info@eiffel.com> %N%
						%Webpage: http://www.eiffel.com %N%N%
						%Support Webpage: http://support.eiffel.com"

end -- class WIZARD_ABOUT_DIALOG

--|-------------------------------------------------------------------
--| This class was automatically generated by Resource Bench
--| Copyright (C) 1996-1997, Interactive Software Engineering, Inc.
--|
--| 360 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------
