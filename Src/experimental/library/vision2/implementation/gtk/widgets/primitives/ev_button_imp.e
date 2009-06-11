note
	description:
		"Eiffel Vision button. GTK implementation."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "press, push, label, pixmap"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_BUTTON_IMP

inherit
	EV_BUTTON_I
		redefine
			interface
		end

	EV_PRIMITIVE_IMP
		redefine
			interface,
			make,
			old_make,
			set_foreground_color,
			foreground_color_pointer,
			on_focus_changed,
			needs_event_box,
			event_widget
		end

	EV_PIXMAPABLE_IMP
		redefine
			interface,
			make
		end

	EV_TEXTABLE_IMP
		redefine
			interface,
			make,
			align_text_left,
			align_text_center,
			align_text_right
		end

	EV_FONTABLE_IMP
		redefine
			interface,
			make,
			fontable_widget
		end

	EV_BUTTON_ACTION_SEQUENCES_IMP
		export
			{EV_INTERMEDIARY_ROUTINES} select_actions_internal
		end

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: like interface)
			-- Connect interface and initialize `c_object'.
		do
			assign_interface (an_interface)
		end

	new_gtk_button: POINTER
		do
			Result := {EV_GTK_EXTERNALS}.gtk_button_new
		end

	make
			-- `Precursor' initialization,
			-- create button box to hold label and pixmap.
		do
			set_c_object (new_gtk_button)
			pixmapable_imp_initialize
			textable_imp_initialize
			initialize_button_box
			align_text_center
			Precursor {EV_PRIMITIVE_IMP}
		end

	initialize_button_box
			-- Create and initialize button box.
		local
			box: POINTER
			hbox: POINTER
		do
			box := {EV_GTK_EXTERNALS}.gtk_alignment_new (0, 0, 0, 0)
			{EV_GTK_EXTERNALS}.gtk_container_add (visual_widget, box)
			hbox := {EV_GTK_EXTERNALS}.gtk_hbox_new (False, 0)
			{EV_GTK_EXTERNALS}.gtk_widget_show (hbox)
			{EV_GTK_EXTERNALS}.gtk_container_add (box, hbox)
			{EV_GTK_EXTERNALS}.gtk_container_add (hbox, pixmap_box)
			{EV_GTK_EXTERNALS}.gtk_misc_set_padding (text_label, 4, 0)
			{EV_GTK_EXTERNALS}.gtk_container_add (hbox, text_label)
			{EV_GTK_EXTERNALS}.gtk_widget_show (box)
		ensure
			button_box /= default_pointer
		end

	fontable_widget: POINTER
			-- Pointer to the widget that may have fonts set.
		do
			Result := text_label
		end

	event_widget: POINTER
			-- Widget that handles the events.
		do
			Result := visual_widget
		end

	needs_event_box: BOOLEAN
			-- Does `a_widget' need an event box?
		do
			Result := True
		end

feature -- Access

	is_default_push_button: BOOLEAN
			-- Is this button currently a default push button
			-- for a particular container?

feature -- Status Setting

	align_text_center
			-- Display `text' centered.
		do
			Precursor {EV_TEXTABLE_IMP}
			{EV_GTK_EXTERNALS}.gtk_alignment_set (button_box, 0.5, 0.5, 0, 0)
		end

	align_text_left
			-- Display `text' left aligned.
		do
			Precursor {EV_TEXTABLE_IMP}
			{EV_GTK_EXTERNALS}.gtk_alignment_set (button_box, 0.0, 0.5, 0, 0)
		end

	align_text_right
			-- Display `text' right aligned.
		do
			Precursor {EV_TEXTABLE_IMP}
			{EV_GTK_EXTERNALS}.gtk_alignment_set (button_box, 1.0, 0.5, 0, 0)
		end

	enable_default_push_button
			-- Set the style of the button corresponding
			-- to the default push button.
		do
			enable_can_default
		end

	disable_default_push_button
			-- Remove the style of the button corresponding
			-- to the default push button.
		do
			is_default_push_button := False
			{EV_GTK_EXTERNALS}.gtk_widget_unset_flags (visual_widget, {EV_GTK_ENUMS}.gtk_has_default_enum)
			{EV_GTK_EXTERNALS}.gtk_widget_queue_draw (visual_widget)
		end

	enable_can_default
			-- Allow the style of the button to be the default push button.
		do
			is_default_push_button := True
			{EV_GTK_EXTERNALS}.gtk_widget_set_flags (visual_widget, {EV_GTK_ENUMS}.gtk_has_default_enum)
			{EV_GTK_EXTERNALS}.gtk_widget_queue_draw (visual_widget)
		end

	set_foreground_color (a_color: EV_COLOR)
		do
			Precursor {EV_PRIMITIVE_IMP} (a_color)
			real_set_foreground_color (text_label, a_color)
		end

feature {NONE} -- implementation

	on_focus_changed (a_has_focus: BOOLEAN)
			-- Called from focus intermediary agents when focus for `Current' has changed.
			-- if `a_has_focus' then `Current' has just received focus.
		local
			top_level_dialog_imp: detachable EV_DIALOG_IMP
			rad_but: detachable EV_RADIO_BUTTON_IMP
		do
			Precursor {EV_PRIMITIVE_IMP} (a_has_focus)
			top_level_dialog_imp ?= top_level_window_imp
			if
				top_level_dialog_imp /= Void
			then
				if a_has_focus then
					rad_but ?= Current
					if rad_but = Void then
						-- We do not want radio buttons to affect current push button behavior
						top_level_dialog_imp.set_current_push_button (interface)
					end
				elseif top_level_dialog_imp.internal_current_push_button = interface then
					top_level_dialog_imp.set_current_push_button (Void)
				end
			end
		end

	foreground_color_pointer: POINTER
			-- Pointer to fg color for `Current'.
		do
			Result := {EV_GTK_EXTERNALS}.gtk_style_struct_text (
				{EV_GTK_EXTERNALS}.gtk_rc_get_style (text_label)
			)
		end

	button_box: POINTER
			-- GtkHBox in button.
			-- Holds label and pixmap.
		do
			Result := {EV_GTK_EXTERNALS}.gtk_bin_struct_child (visual_widget)
		end

feature {EV_ANY, EV_ANY_I} -- implementation

	interface: detachable EV_BUTTON note option: stable attribute end;
			-- Provides a common user interface to platform dependent
			-- functionality implemented by `Current'

invariant
	button_box_not_null: is_usable implies button_box /= NULL

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EV_BUTTON_IMP
