indexing
	description: "Formatter displaying class information in a text area."
	author: "Xavier Rousselot"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EB_CLASS_TEXT_FORMATTER

inherit
	EB_CLASS_INFO_FORMATTER
		redefine
			new_button
		end
		
	EB_SHARED_INTERFACE_TOOLS

feature -- Access

	new_button: EV_TOOL_BAR_RADIO_BUTTON is
			-- Create a new toolbar button and associate it with `Current'.
		do
			Result := Precursor {EB_CLASS_INFO_FORMATTER}
			Result.drop_actions.extend (~on_class_drop)
		end

	widget: EV_WIDGET is
			-- Graphical representation of the information provided.
		do
			if editor = Void or else class_cmd = Void then
				Result := empty_widget
			else
				Result := internal_widget
			end
		end

feature -- Status setting

	set_editor (an_editor: EB_CLICKABLE_EDITOR) is
			-- Set `editor' to `an_editor'.
			-- Used to share an editor between several formatters.
		require
			an_editor_non_void: an_editor /= Void
		do
			editor := an_editor
			internal_widget := an_editor.widget
--			editor.drop_actions.extend (~on_class_drop)
		end

feature -- Formatting

	format is
			-- Refresh `widget'.
		do
			if
				selected and then
				displayed and then
				class_cmd /= Void
			then
				if must_format then
					display_temp_header
					generate_text
				end
				if not last_was_error then
					if editor.current_text /= formatted_text then
						if has_breakpoints and not Eiffel_system.System.il_generation then
							editor.show_breakpoints
						else
							editor.hide_breakpoints
						end
						editor.process_text (formatted_text)
					end
					if editable then
						editor.enable_editable
					else
						editor.disable_editable
					end
				else
					editor.clear_window
					editor.display_message (Warning_messages.w_Formatter_failed)
				end
				display_header
				must_format := last_was_error
			end
		end

feature {NONE} -- Implementation

	reset_display is
			-- Clear all graphical output.
		do
			editor.clear_window
		end

	editor: EB_CLICKABLE_EDITOR
			-- Output editor.

	on_class_drop (cs: CLASSI_STONE) is
			-- Notify `manager' of the dropping of `cs'.
		do
			if not selected then
				execute
			end
--			if cs.class_i /= associated_class.lace_class then
				manager.set_stone (cs)
--			end
		end

	editable: BOOLEAN is
			-- Is the text generated by `Current' editable?
		do
			Result := False
		end

	internal_widget: EV_WIDGET
			-- Widget corresponding to `editor's text area.

	empty_widget: EV_WIDGET is
			-- Widget displayed when no information can be displayed.
		local
			def: EV_STOCK_COLORS
		do
			create def
			create {EV_CELL} Result
			Result.set_background_color (def.White)
			Result.drop_actions.extend (~on_class_drop) 
		end

end -- class EB_CLASS_TEXT_FORMATTER
