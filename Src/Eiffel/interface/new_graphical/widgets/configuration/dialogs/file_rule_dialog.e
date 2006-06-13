indexing
	description: "Dialog to edit file rules."
	date: "$Date$"
	revision: "$Revision$"

class
	FILE_RULE_DIALOG

inherit
	PROPERTY_DIALOG [ARRAYED_LIST [CONF_FILE_RULE]]
		redefine
			initialize
		end

	CONF_INTERFACE_NAMES
		undefine
			default_create,
			copy
		end

	EB_LAYOUT_CONSTANTS
		undefine
			default_create,
			copy
		redefine
			default_button_width
		end

feature {NONE} -- Initialization

	initialize is
			-- Initialization
		local
			l_btn: EV_BUTTON
			hb: EV_HORIZONTAL_BOX
		do
			Precursor
			enable_user_resize

			create notebook
			element_container.extend (notebook)

			create hb
			element_container.extend (hb)
			element_container.disable_item_expand (hb)
			hb.set_padding (default_padding_size)

			hb.extend (create {EV_CELL})
			create l_btn.make_with_text_and_action (dialog_file_rule_add_rule, agent on_add)
			hb.extend (l_btn)
			hb.disable_item_expand (l_btn)
			l_btn.set_minimum_width (default_button_width)
			create remove_button.make_with_text_and_action (dialog_file_rule_remove_rule, agent on_remove)
			hb.extend (remove_button)
			hb.disable_item_expand (remove_button)
			remove_button.set_minimum_width (default_button_width)
			cancel_button.set_minimum_width (default_button_width)
			ok_button.set_minimum_width (default_button_width)

			show_actions.extend (agent on_show)
		end

feature {NONE} -- GUI Elements

	default_button_width: INTEGER is 80

	notebook: EV_NOTEBOOK
			-- Notebook for the file rule tabs.

	remove_button: EV_BUTTON
			-- Remove button to remove rules.

feature {NONE} -- Agents

	on_show is
			-- Fill in value.
		local
			l_tab: FILE_RULE_TAB
			l_new_value: like value
			l_fr: CONF_FILE_RULE
		do
			notebook.wipe_out
			if value /= Void and then not value.is_empty then
					-- create a copy of the value, so that we can cancel without modifying anything
				create l_new_value.make (value.count)
				from
					value.start
				until
					value.after
				loop
					l_fr := value.item.twin
					l_new_value.force (l_fr)
					create l_tab.make (l_fr)
					notebook.extend (l_tab)
					notebook.set_item_text (l_tab, dialog_file_rule_file_rule_x (value.index))
					value.forth
				end
				value := l_new_value
				notebook.selection_actions.extend (agent on_show_tab)
				remove_button.enable_sensitive
			else
				remove_button.disable_sensitive
			end
		end

	on_show_tab is
			-- Show a tab.
		do
			if notebook.selected_item /= Void then
				notebook.selected_item.show
			end
		end

	on_remove is
			-- Remove a file rule.
		do
			if notebook.selected_item /= Void and value /= Void then
				value.go_i_th (notebook.selected_item_index)
				value.remove
				notebook.go_i_th (notebook.selected_item_index)
				notebook.remove
				if value.is_empty then
					remove_button.disable_sensitive
				end
			end
		end

	on_add is
			-- Add a new file rule.
		local
			l_fr: CONF_FILE_RULE
			l_tab: FILE_RULE_TAB
		do
			if value = Void then
				create value.make (1)
			end
			create l_fr.make
			value.force (l_fr)
			create l_tab.make (l_fr)
			notebook.extend (l_tab)
			notebook.set_item_text (l_tab, dialog_file_rule_file_rule_x (value.count))
			notebook.select_item (l_tab)
			remove_button.enable_sensitive
		end

invariant
	elements_created: is_initialized implies notebook /= Void

end
