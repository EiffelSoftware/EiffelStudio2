indexing
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	TOOL_BAR_CONTROL_PANEL

inherit
	TOOL_BAR_CONTROL_PANEL_IMP

	DOCKING_MANAGER_HODLER
		undefine
			default_create, copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_manager: SD_DOCKING_MANAGER; a_window: like window) is
			-- Set `docking_manager' with `a_manager'.
		require
			a_manager_not_void: a_manager /= Void
		do
			docking_manager := a_manager
			window := a_window
			default_create
		ensure
			docking_manager_not_void: docking_manager /= Void
			window_not_void: window /= Void
		end

feature {NONE} -- Initialization

	user_initialization is
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
			refresh_toolbar_list
		end

feature {NONE} -- Implementation

	 refresh_toolbar_list is
	 		-- Refresh tool bar list.
	 	local
	 		l_contents: ACTIVE_LIST [SD_TOOL_BAR_CONTENT]
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_item: EV_LIST_ITEM
	 	do
	 		toolbar_list.wipe_out
			l_contents := docking_manager.tool_bar_manager.contents
			from
				l_contents.start
			until
				l_contents.after
			loop
				l_content := l_contents.item
				create l_item.make_with_text (l_content.title)
				l_item.set_data (l_content)
				toolbar_list.extend (l_item)
				l_contents.forth
			end
	 	end

	selected_content: SD_TOOL_BAR_CONTENT is
			-- Selected content
		local
	 		l_item: EV_LIST_ITEM
		do
			l_item := toolbar_list.selected_item
			if l_item /= Void then
				Result ?= l_item.data
			end
		end

	close_content (a_content: SD_TOOL_BAR_CONTENT) is
			-- Close content
		require
			a_content_not_void: a_content /= Void
		do
			a_content.close
			refresh_toolbar_list
		end

	selected_direction: INTEGER is
			-- Selected direction
		do
			if up_radio_button.is_selected then
				Result := {SD_ENUMERATION}.top
			elseif down_radio_button.is_selected then
				Result := {SD_ENUMERATION}.bottom
			elseif left_radio_button.is_selected then
				Result := {SD_ENUMERATION}.left
			elseif right_radio_button.is_selected then
				Result := {SD_ENUMERATION}.right
			end
		end

	setup_sensitivity (a_item: SD_TOOL_BAR_ITEM) is
			-- Setup sensitivity every other item.s
		require
			a_item_not_void: a_item /= Void
		local
			l_item: SD_TOOL_BAR_BUTTON
		do
			l_item ?= a_item
			if l_item /= Void then
				if next_disable_sensitivity then
					l_item.disable_sensitive
					next_disable_sensitivity := False
				else
					next_disable_sensitivity := True
				end
			end
		end

	button_clicked (a_button: SD_TOOL_BAR_BUTTON) is
			-- On button clicked.
		require
			a_button_not_void: a_button /= Void
		local
			l_dialog: EV_INFORMATION_DIALOG
		do
			create l_dialog.make_with_text (a_button.text.as_string_32 + " was clicked.")
			l_dialog.show_modal_to_window (window)
		end

	next_disable_sensitivity: BOOLEAN

	sd_shared: SD_SHARED
			-- Docking icons, etc.
		once
			create Result
		end

feature {NONE} -- Implementation

	on_toolbar_selected is
			-- Called by `select_actions' of `toolbar_list'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
		do
			l_content := selected_content
			if l_content /= Void then
				title_field.set_text (l_content.title)
			else
				title_field.set_text ("")
			end
		end

	on_create_toolbar_item_selected is
			-- Called by `select_actions' of `create_toolbar_button'.
		local
			l_content: SD_TOOL_BAR_CONTENT
		do
			create l_content.make_with_tool_bar ("Toolbar #" + new_widget_number.out, create {EV_TOOL_BAR})
			l_content.close_request_actions.extend (agent close_content (l_content))
			docking_manager.tool_bar_manager.contents.extend (l_content)
			l_content.set_top ({SD_ENUMERATION}.top)
			refresh_toolbar_list
		end

	on_add_button_button_selected is
			-- Called by `select_actions' of `add_button_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_button: SD_TOOL_BAR_BUTTON
		do
			l_content := selected_content
			if l_content /= Void then
				create l_button.make
				l_button.set_text ("Button #" + new_widget_number.out)
				l_button.set_pixel_buffer (sd_shared.icons.close_all)
				l_button.select_actions.extend (agent button_clicked (l_button))
				setup_sensitivity (l_button)
				l_content.items.extend (l_button)
			end
		end

	on_add_toggle_button_selected is
			-- Called by `select_actions' of `add_toggle_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_button: SD_TOOL_BAR_TOGGLE_BUTTON
		do
			l_content := selected_content
			if l_content /= Void then
				create l_button.make
				l_button.set_text ("Button #" + new_widget_number.out)
				l_button.set_pixel_buffer (sd_shared.icons.close_all)
				l_button.select_actions.extend (agent button_clicked (l_button))
				setup_sensitivity (l_button)
				l_content.items.extend (l_button)
			end
		end

	on_add_radio_button_selected is
			-- Called by `select_actions' of `add_radio_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_dialog: RADIO_BUTTON_CREATION_DIALOG
		do
			l_content := selected_content
			if l_content /= Void then
				create l_dialog
				l_dialog.ok_actions.extend (agent on_radio_button_created (l_dialog))
				l_dialog.show_modal_to_window (window)
			end
		end

	on_add_menu_button_button_selected is
			-- Called by `select_actions' of `add_menu_button_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_button: SD_TOOL_BAR_MENU_ITEM
	 		l_menu: EV_MENU
		do
			l_content := selected_content
			if l_content /= Void then
				create l_button.make
				l_button.set_text ("Button #" + new_widget_number.out)
				l_button.set_pixel_buffer (sd_shared.icons.close_all)
				l_button.select_actions.extend (agent button_clicked (l_button))
				setup_sensitivity (l_button)
				create l_menu.make_with_text ("Menu")
				l_menu.extend (create {EV_MENU_ITEM}.make_with_text ("Menu Item"))
				l_menu.extend (create {EV_MENU_ITEM}.make_with_text ("Menu Item"))
				l_button.set_menu (l_menu)
				l_content.items.extend (l_button)
			end
		end

	on_radio_button_created (a_dialog: RADIO_BUTTON_CREATION_DIALOG) is
		require
			a_dialog_not_void: a_dialog /= Void
		local
			l_font: EV_FONT
			l_width: INTEGER
			l_content: SD_TOOL_BAR_CONTENT
	 		l_button: SD_TOOL_BAR_RADIO_BUTTON
	 		l_f_button: SD_TOOL_BAR_FONT_BUTTON
	 		l_w_button: SD_TOOL_BAR_WIDTH_BUTTON
		do
			l_content := selected_content
			if l_content /= Void then
				if a_dialog.is_normal then
					create l_button.make
					l_button.set_text ("Button #" + new_widget_number.out)
					l_button.set_pixel_buffer (sd_shared.icons.close_all)
					l_button.select_actions.extend (agent button_clicked (l_button))
					setup_sensitivity (l_button)
					l_content.items.extend (l_button)
				elseif a_dialog.is_font then
					create l_f_button.make
					l_font := a_dialog.font
					if l_font /= Void then
						l_f_button.set_font (l_font)
						l_f_button.set_text ("Button #" + new_widget_number.out)
						l_f_button.set_pixel_buffer (sd_shared.icons.close_all)
						l_f_button.select_actions.extend (agent button_clicked (l_f_button))
						setup_sensitivity (l_f_button)
						l_content.items.extend (l_f_button)
					end
				elseif a_dialog.is_width then
					create l_w_button.make
					l_width := a_dialog.max_width
					l_w_button.set_maximum_width (l_width)
					l_w_button.set_text ("Button #" + new_widget_number.out)
					l_w_button.set_pixel_buffer (sd_shared.icons.close_all)
					l_w_button.select_actions.extend (agent button_clicked (l_w_button))
					setup_sensitivity (l_w_button)
					l_content.items.extend (l_w_button)
				end
			end
		end

	on_add_build_in_widget_button_selected is
			-- Called by `select_actions' of `add_build_in_widget_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_widget: MINI_TOOL_BAR
	 		l_widget_item: SD_TOOL_BAR_WIDGET_ITEM
		do
			l_content := selected_content
			if l_content /= Void then
				create l_widget
				create l_widget_item.make (l_widget)
				l_content.items.extend (l_widget_item)
			end
		end

	on_add_resizable_button_selected is
			-- Called by `select_actions' of `add_resizable_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_widget: MINI_TOOL_BAR
	 		l_widget_item: SD_TOOL_BAR_RESIZABLE_ITEM
		do
			l_content := selected_content
			if l_content /= Void then
				create l_widget
				create l_widget_item.make (l_widget)
				l_content.items.extend (l_widget_item)
			end
		end

	on_add_separator_button_selected is
			-- Called by `select_actions' of `add_separator_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_sep: SD_TOOL_BAR_SEPARATOR
		do
			l_content := selected_content
			if l_content /= Void then
				create l_sep.make
				l_content.items.extend (l_sep)
			end
		end


	on_show_button_selected is
			-- Called by `select_actions' of `show_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
		do
			l_content := selected_content
			if l_content /= Void then
				l_content.show
			end
		end

	on_hide_button_selected is
			-- Called by `select_actions' of `hide_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
		do
			l_content := selected_content
			if l_content /= Void then
				l_content.hide
			end
		end

	on_close_button_selected is
			-- Called by `select_actions' of `close_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
		do
			l_content := selected_content
			if l_content /= Void then
				close_content (l_content)
			end
		end

	on_set_title_button_selected is
			-- Called by `select_actions' of `set_title_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
		do
			l_content := selected_content
			if l_content /= Void then
				l_content.set_title (title_field.text)
				refresh_toolbar_list
			end
		end

	on_set_top_button_selected is
			-- Called by `select_actions' of `set_top_button'.
		local
	 		l_content: SD_TOOL_BAR_CONTENT
	 		l_direction: INTEGER
		do
			l_content := selected_content
			if l_content /= Void then
				l_direction := selected_direction
				l_content.set_top (l_direction)
			end
		end

feature {NONE} -- Number

	new_widget_number: INTEGER is
			-- New widget number
		do
			Result := widget_number + 1
			widget_number := Result
		end

	widget_number: INTEGER;

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


end
