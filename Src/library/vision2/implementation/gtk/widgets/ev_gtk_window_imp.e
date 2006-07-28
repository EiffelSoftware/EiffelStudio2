indexing
	description: "Objects that ..."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_GTK_WINDOW_IMP

inherit
	EV_GTK_WIDGET_IMP
		redefine
			width,
			height,
			show,
			screen_x,
			screen_y
		end

feature {NONE} -- Agent functions.

	key_event_translate_agent: FUNCTION [EV_GTK_CALLBACK_MARSHAL, TUPLE [INTEGER, POINTER], TUPLE] is
			-- Translation agent used for key events
		once
			Result := agent (App_implementation.gtk_marshal).key_event_translate
		end

	set_focus_event_translate_agent: FUNCTION [EV_GTK_CALLBACK_MARSHAL, TUPLE [INTEGER, POINTER], TUPLE] is
			-- Translation agent used for set-focus events
		once
			Result := agent (App_implementation.gtk_marshal).set_focus_event_translate
		end

feature {NONE} -- Implementation

	parent_imp: EV_CONTAINER_IMP is
			-- Parent of `Current', always Void as windows cannot be parented
		do
			-- Return Void
		end

	width: INTEGER is
			-- Horizontal size measured in pixels.
		do
			if default_width /= -1 then
				Result := default_width
			else
				Result := Precursor
			end
		end

	height: INTEGER is
			-- Vertical size measured in pixels.
		do
			if default_height /= -1 then
				Result := default_height
			else
				Result := Precursor
			end
		end

	set_blocking_window (a_window: EV_WINDOW) is
			-- Set as transient for `a_window'.
		local
			win_imp: EV_WINDOW_IMP
			l_window: POINTER
		do
			if not is_destroyed then
				if a_window /= Void then
					win_imp ?= a_window.implementation
					l_window := win_imp.c_object
				end
				{EV_GTK_EXTERNALS}.gtk_window_set_transient_for (c_object, l_window)
			end
			internal_blocking_window := a_window
		end

	blocking_window: EV_WINDOW is
			-- Window this dialog is a transient for.
		do
			Result := internal_blocking_window
		end

	window_position_enum: INTEGER is
			-- GtkWindow positioning enum.
		do
			if blocking_window /= Void then
				Result := {EV_GTK_EXTERNALS}.Gtk_win_pos_center_on_parent_enum
			else
					-- We let the Window Manager decide where the window should be positioned.
				Result := {EV_GTK_EXTERNALS}.gtk_win_pos_none_enum
			end
		end

	internal_blocking_window: EV_WINDOW
			-- Window that `Current' is relative to.
			-- Implementation

	set_width (a_width: INTEGER) is
			-- Set the horizontal size to `a_width'.
		do
			set_size (a_width, height)
		end

	set_height (a_height: INTEGER) is
			-- Set the vertical size to `a_height'.
		do
			set_size (width, a_height)
		end

	set_size (a_width, a_height: INTEGER) is
			-- Set the horizontal size to `a_width'.
			-- Set the vertical size to `a_height'.
		do
			default_width := a_width
			default_height := a_height
				-- Both resizes are needed otherwise the original position gets reset on show.
			{EV_GTK_EXTERNALS}.gdk_window_resize ({EV_GTK_EXTERNALS}.gtk_widget_struct_window (c_object), default_width.max (minimum_width), default_height.max (minimum_height))
			{EV_GTK_EXTERNALS}.gtk_window_set_default_size (c_object, default_width.max (minimum_width), default_height.max (minimum_height))
		end

	default_width, default_height: INTEGER
			-- Default width and height for the window if set, -1 otherwise.
			-- (see. `gtk_window_set_default_size' for more information)

	x_position: INTEGER is
			-- X coordinate of `Current'
		do
			Result := screen_x
		end

	y_position: INTEGER is
			-- Y coordinate of `Current'
		do
			Result := screen_y
		end

	set_x_position (a_x: INTEGER) is
			-- Set horizontal offset to parent to `a_x'.
		do
			set_position (a_x, y_position)
		end

	set_y_position (a_y: INTEGER) is
			-- Set vertical offset to parent to `a_y'.
		do
			set_position (x_position, a_y)
		end

	set_position (a_x, a_y: INTEGER) is
			-- Set horizontal offset to parent to `a_x'.
			-- Set vertical offset to parent to `a_y'.
		do
			{EV_GTK_EXTERNALS}.gtk_window_move (c_object, a_x, a_y)
			positioned_by_user := True
		end

	positioned_by_user: BOOLEAN
		-- Has `Current' been positioned by the user?

	screen_x: INTEGER is
			-- Horizontal position of the window on screen,
		local
			temp_y: INTEGER
		do
			{EV_GTK_EXTERNALS}.gtk_window_get_position (c_object, $Result, $temp_y)
		end

	screen_y: INTEGER is
			-- Vertical position of the window on screen,
		local
			temp_x: INTEGER
		do
			{EV_GTK_EXTERNALS}.gtk_window_get_position (c_object, $temp_x, $Result)
		end

	default_wm_decorations: INTEGER is
			-- Default WM decorations of `Current'.
		do
			Result := 0 -- No decorations
		end

	show is
			-- Request that `Current' be displayed when its parent is.
		do
			{EV_GTK_EXTERNALS}.gtk_window_set_position (c_object, window_position_enum)
			{EV_GTK_EXTERNALS}.gtk_window_present (c_object)
		end

	show_modal_to_window (a_window: EV_WINDOW) is
			-- Show `Current' modal with respect to `a_window'.
		local
			l_window_imp: EV_WINDOW_IMP
			l_window_group: POINTER
		do
			l_window_imp ?= a_window.implementation
			l_window_group := {EV_GTK_EXTERNALS}.gtk_window_group_new
			{EV_GTK_EXTERNALS}.gtk_window_group_add_window (l_window_group, l_window_imp.c_object)
			{EV_GTK_EXTERNALS}.gtk_window_group_add_window (l_window_group, c_object)
			show_relative_to_window (a_window)
			{EV_GTK_EXTERNALS}.gtk_window_set_transient_for (c_object, l_window_imp.c_object)
			{EV_GTK_EXTERNALS}.gtk_grab_add (c_object)
			is_modal := True
			block
			is_modal := False
			set_blocking_window (Void)
			{EV_GTK_EXTERNALS}.gtk_grab_remove (c_object)
			{EV_GTK_EXTERNALS}.gtk_window_group_remove_window (l_window_group, l_window_imp.c_object)
			{EV_GTK_EXTERNALS}.gtk_window_group_remove_window (l_window_group, c_object)
			{EV_GTK_EXTERNALS}.object_unref (l_window_group)
		end

	is_modal: BOOLEAN
		-- Is `Current' shown modal to another window?

feature -- Basic operations

	show_relative_to_window (a_window: EV_WINDOW) is
			-- Show `Current' with respect to `a_window'.
		do
			set_blocking_window (a_window)
			show
				-- This extra call is needed otherwise the Window will not be transient.
			set_blocking_window (a_window)
		end

	block is
			-- Wait until window is closed by the user.
		local
			l_app_imp: like app_implementation
		do
			from
				l_app_imp := app_implementation
			until
				blocking_condition
			loop
				l_app_imp.event_loop_iteration (True)
			end
		end

	blocking_condition: BOOLEAN is
			-- Condition when blocking ceases if enabled.
		do
			Result := is_destroyed or else not is_show_requested
		end

feature {EV_ANY_I} -- Implementation

	forbid_resize is
			-- Forbid the resize of the window.
		do
			{EV_GTK_EXTERNALS}.gtk_window_set_policy (c_object, 0, 0, 0)
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class EV_GTK_WINDOW_IMP
