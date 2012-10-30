note
	description: "Objects that represent an EV_TITLED_WINDOW.%
		%The original version of this class was generated by EiffelBuild."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_ARCHIVE_PANEL

inherit
	EB_METRIC_ARCHIVE_PANEL_IMP

	EB_METRIC_PANEL
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_CONSTANTS
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_SHARED_PREFERENCES
		undefine
			copy,
			is_equal,
			default_create
		end

	EB_METRIC_INTERFACE_PROVIDER
		undefine
			copy,
			is_equal,
			default_create
		end

	EXCEPTIONS
		undefine
			copy,
			is_equal,
			default_create
		end

	TRANSFER_MANAGER_BUILDER
		undefine
			copy,
			is_equal,
			default_create
		end

	EIFFEL_LAYOUT
		export
			{NONE} all
		undefine
			copy,
			is_equal,
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_tool: like metric_tool)
			-- Initialize `metric_tool' with `a_tool'.
		require
			a_tool_attached: a_tool /= Void
		local
			l_pref: STRING_PREFERENCE
		do
			metric_tool := a_tool
			create calculator
			calculator.step_actions.extend (agent on_stop_metric_evaluation)
			calculator.step_actions.extend (agent on_process_gui)
			install_agents (metric_tool)

				-- Setup timers.
			create internal_timer.make_with_interval (0)
			create current_archive_timer.make_with_interval (0)
			create reference_archive_timer.make_with_interval (0)
			on_unit_order_change_agent := agent on_unit_order_change

				-- Setup `open_file_dialog'.
			l_pref := preferences.dialog_data.last_opened_metric_browse_archive_directory_preference
			if l_pref.value = Void or else l_pref.value.is_empty then
				l_pref.set_value (eiffel_layout.user_projects_path)
			end
			create open_file_dialog.make_with_preference (l_pref)
			open_file_dialog.set_title (metric_names.t_select_archive)
			open_file_dialog.filters.extend (["*.xml", metric_names.e_xml_files])
			open_file_dialog.filters.extend (["*.*", metric_names.e_all_files])

			create domain_selector.make
			create metric_selector.make (True)

			default_create
			set_is_metric_reloaded (True)

			append_drop_actions (
				<<
					comparison_area_cell,
					empty_cell,
					empty_cell2,
					comparison_toolbar_cell,
					comparison_area,
					reference_empty_area,
					current_archive_empty_area,
					comparison_empty_cell
				>>,
				metric_tool
			)
		end

	user_initialization
			-- Called by `initialize'.
			-- Any custom user initialization that
			-- could not be performed in `initialize',
			-- (due to regeneration of implementation class)
			-- can be added here.
		do
				-- Setup domain selector.
			domain_selector.setup_delayed_domain_item_buttons (True, False, False)
			domain_selector.set_context_menu_factory (metric_tool.develop_window.menus.context_menu_factory)
				-- Setup metric selector.
			metric_selector.double_click_actions.extend (agent on_pointer_double_click_on_metric_item)
			metric_selector.set_context_menu_factory (metric_tool.develop_window.menus.context_menu_factory)

				-- Setup toolbar.
			run_btn.set_pixmap (pixmaps.icon_pixmaps.debug_run_icon)
			run_btn.select_actions.extend (agent on_run_archive)
			stop_btn.set_pixmap (pixmaps.icon_pixmaps.debug_stop_icon)

			domain_selection_area.extend (domain_selector)
			metric_selection_area.extend (metric_selector)

			new_archive_browse_btn.select_actions.extend (agent on_open_new_archive (agent on_new_archive_file_name_selected))
			new_archive_file_name_text.change_actions.extend (agent on_new_archive_file_name_changes (internal_timer, new_archive_file_name_text, agent on_new_archive_checked))
			current_metric_archive_text.change_actions.extend (agent on_current_metric_archive_text_change)
			reference_metric_archive_text.change_actions.extend (agent on_reference_metric_archive_text_change)

			stop_btn.disable_sensitive
			stop_btn.select_actions.extend (agent on_stop_metric_evaluation_button_pressed)
			clean_btn.disable_select
			clean_btn.disable_sensitive

			compare_btn.set_pixmap (pixmaps.icon_pixmaps.debug_run_icon)
			browse_reference_archive_btn.select_actions.extend (agent on_open_new_archive (agent on_comparison_archive_selected (reference_metric_archive_text)))
			browse_current_archive_btn.select_actions.extend (agent on_open_new_archive (agent on_comparison_archive_selected (current_metric_archive_text)))
			compare_btn.select_actions.extend (agent do metric_tool.show_feedback_dialog (metric_names.t_analysing_archive, agent on_compare_archives, metric_tool.develop_window) end)
			run_btn.set_tooltip (metric_names.f_start_archive)
			stop_btn.set_tooltip (metric_names.f_stop_archive)
			new_archive_browse_btn.set_tooltip (metric_names.f_select_exist_archive_file)
			clean_btn.set_tooltip (metric_names.f_clean_archive)
			compare_btn.set_tooltip (metric_names.f_compare_archive)
			compare_btn.set_text (metric_names.t_compare)
			browse_current_archive_btn.set_tooltip (metric_names.f_select_current_archive)
			browse_reference_archive_btn.set_tooltip (metric_names.f_select_reference_archive)
			run_btn.disable_sensitive
			domain_selector.domain_change_actions.extend (agent on_domain_change)
			new_archive_file_lbl.set_text (metric_names.coloned_string (metric_names.t_location, True))
			clean_btn.set_text (metric_names.t_clean)
			archive_definition_frame.set_text (metric_names.t_archive_management)
			archive_comparison_area.set_text (metric_names.t_archive_comparison)
			source_domain_lbl.set_text (metric_names.t_select_source_domain)
			metric_lbl.set_text (metric_names.t_select_metric)
			reference_archive_lbl.set_text (metric_names.t_select_reference_archive)
			current_archive_lbl.set_text (metric_names.t_select_current_archive)

			preferences.metric_tool_data.unit_order_preference.change_actions.extend (on_unit_order_change_agent)
		end

feature -- Access

	domain_selector: EB_METRIC_DOMAIN_SELECTOR
			-- Domain selector

	metric_selector: EB_METRIC_SELECTOR
			-- Metric selector

	last_reference_archive: LIST [EB_METRIC_ARCHIVE_NODE]
			-- Last reference archive

	last_current_archive: LIST [EB_METRIC_ARCHIVE_NODE]
			-- Last current archive

feature -- Status report

	is_cancel_evaluation_requested: BOOLEAN
			-- Is cancel metric evaluation requested?

	is_current_metric_archive_ok: BOOLEAN
			-- Is file specified in `current_metric_archive_text' valid?

	is_reference_metric_archive_ok: BOOLEAN
			-- Is file specified in `reference_metric_archive_text' valid?

	is_new_archive_file_selected: BOOLEAN
			-- Is new archive file selected?

	is_new_archive_file_exists: BOOLEAN
			-- Does selected new archive file exist?

	is_new_archive_file_valid: BOOLEAN
			-- Does selected archive file contain valid metric archive?

	is_last_load_successful: BOOLEAN
			-- Is last `load_archive' successful?

	is_original_starter: BOOLEAN
			-- Is this panel the original panel in which metric evaluation starts?

feature -- Basic operations

	set_is_original_starter (b: BOOLEAN)
			-- Set `is_original_starter' with `b'.
		do
			is_original_starter := b
		ensure
			is_original_starter_set: is_original_starter = b
		end

	set_is_cancel_evaluation_requested (b: BOOLEAN)
			-- Set `is_cancel_evaluation_requested' with `b'.
		do
			is_cancel_evaluation_requested := b
		ensure
			is_cancel_evaluation_requested_set: is_cancel_evaluation_requested = b
		end

	force_drop_stone (a_stone: STONE)
			-- Force to drop `a_stone' in `domain_selector'.
		do
			domain_selector.on_drop (a_stone)
		end

feature -- Actions

	on_open_new_archive (a_selection_agent: PROCEDURE [ANY, TUPLE])
			-- Action to be performed to open a dialog to select a file name when create/update a metric archive
			-- When user press "OK" in `open_file_dialog', `a_selection_agent' will be invoked.
		require
			a_selection_agent_attached: a_selection_agent /= Void
		do
			open_file_dialog.open_actions.wipe_out
			open_file_dialog.open_actions.extend (a_selection_agent)
			open_file_dialog.show_modal_to_window (metric_tool_window)
		end

	on_new_archive_file_name_selected
			-- Action to be performed when user selected a file name for metric archive create/update
		do
			new_archive_file_name_text.set_text (open_file_dialog.file_name)
		end

	on_new_archive_file_name_changes (a_timer: EV_TIMEOUT; a_text_field: EV_TEXT_FIELD; a_agent: PROCEDURE [ANY, TUPLE [BOOLEAN, BOOLEAN, LIST [EB_METRIC_ARCHIVE_NODE]]])
			-- Action to be performed when text in `new_archive_file_name_text' changes
		do
			a_timer.actions.wipe_out
			a_timer.actions.extend_kamikaze (agent check_archive_validity (a_text_field, a_agent, a_timer))
			a_timer.set_interval (500)
		end

	on_new_archive_checked (a_file_exist: BOOLEAN; a_valid: BOOLEAN; a_archive: LIST [EB_METRIC_ARCHIVE_NODE])
			-- Action to be performed when archive file specified in `new_archive_file_name_text' is checked
			-- If `a_valid' is True, `a_archive' is the archive, otherwise, `a_archive' is Void.
		do
			is_new_archive_file_exists := a_file_exist
			is_new_archive_file_valid := a_valid
			if a_file_exist then
				if a_valid then
					new_archive_file_name_text.set_tooltip (tooltip_from_archive (a_archive))
					clean_btn.set_tooltip (metric_names.f_clean_archive)
				else
					new_archive_file_name_text.set_tooltip (metric_names.t_selected_archive_not_valid)
					clean_btn.set_tooltip (metric_names.t_selected_archive_not_valid)
				end
				is_new_archive_file_selected := True
			else
				clean_btn.remove_tooltip
				new_archive_file_name_text.remove_tooltip
				is_new_archive_file_selected := not new_archive_file_name_text.text.is_empty
			end
			set_is_up_to_date (False)
			update_ui
		end

	on_run_archive
			-- Action to be performed to start metric calcuation for generating archive information
		local
			l_selected_metrics: LIST [STRING]
			l_msg: STRING_GENERAL
			l_file_name: STRING_32
			l_archive: LIST [EB_METRIC_ARCHIVE_NODE]
			l_archive_tbl: HASH_TABLE [EB_METRIC_ARCHIVE_NODE, STRING]
		do
			set_is_cancel_evaluation_requested (False)
			l_selected_metrics := metric_selector.selected_metrics
			l_msg := check_selected_metrics (l_selected_metrics)
			if l_msg /= Void then
				(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (l_msg, metric_tool_window, Void)
			else
				l_file_name := new_archive_file_name_text.text
				create {ARRAYED_LIST [EB_METRIC_ARCHIVE_NODE]} l_archive.make (l_selected_metrics.count)
				metric_manager.on_archive_calculation_starts (Current)
				calculator.calculate_archive (archive_calculatation_task (l_selected_metrics, domain_selector.domain))

				metric_manager.on_archive_calculation_stops (Current)
				if calculator.has_error then
					display_status_message (calculator.last_error_message)
				else
					l_archive.append (calculator.calculated_archives)
					if not clean_btn.is_selected then
						l_archive_tbl := metric_archive_from_file (l_file_name)
						if l_archive_tbl /= Void then
							l_archive := merge_archive_from_archive_table (l_archive_tbl, l_archive)
						end
					end
					metric_manager.clear_last_error
					metric_manager.store_metric_archive (l_file_name, l_archive)
					display_status_message ("")
					on_new_archive_checked (True, True, l_archive)
					on_reference_metric_archive_text_change
					on_current_metric_archive_text_change
					if metric_manager.has_error then
						display_message (metric_manager.last_error.message)
						metric_manager.clear_last_error
					else
						display_message (metric_names.t_metric_archive_calculation_finished)
					end
				end
			end
		end

	on_stop_metric_evaluation (a_item: QL_ITEM)
			-- Action to be performed when metric evaluation is stopped
		local
			l_domain_generator: QL_CLASS_DOMAIN_GENERATOR
		do
			if is_cancel_evaluation_requested then
				create l_domain_generator
				if is_eiffel_compiling then
					l_domain_generator.error_handler.insert_interrupt_error (metric_names.e_interrupted_by_compile)
				else
					l_domain_generator.error_handler.insert_interrupt_error (metric_names.e_interrupted_by_user)
				end
			end
		end

	on_stop_metric_evaluation_button_pressed
			-- Action to be performed when stop button is pressed.
		do
			set_is_cancel_evaluation_requested (True)
		end

	on_comparison_archive_selected (a_text_field: EV_TEXT_FIELD)
			-- Action to be performed when reference metric archive or current metric archive is selected
		do
			a_text_field.set_text (open_file_dialog.file_name)
		end

	on_reference_archive_checked (a_file_exist: BOOLEAN; a_valid: BOOLEAN; a_archive: LIST [EB_METRIC_ARCHIVE_NODE])
			-- Action to be performed when archive file specified in `reference_metric_archive_text' is checked
			-- If `a_valid' is True, `a_archive' is the archive, otherwise, `a_archive' is Void.
		do
			is_reference_metric_archive_ok := a_valid
			if a_valid then
				reference_metric_archive_text.set_foreground_color (default_foreground_color)
				reference_metric_archive_text.set_tooltip (tooltip_from_archive (a_archive))
			else
				if a_file_exist then
					reference_metric_archive_text.set_tooltip (metric_names.t_selected_archive_not_valid)
				else
					reference_metric_archive_text.set_tooltip (metric_names.t_selected_file_not_exists)
				end
			end
			last_reference_archive := a_archive
			set_is_up_to_date (False)
			update_ui
		end

	on_current_archive_checked (a_file_exist: BOOLEAN; a_valid: BOOLEAN; a_archive: LIST [EB_METRIC_ARCHIVE_NODE])
			-- Action to be performed when archive file specified in `current_metric_archive_text' is checked
			-- If `a_valid' is True, `a_archive' is the archive, otherwise, `a_archive' is Void.
		do
			is_current_metric_archive_ok := a_valid
			if a_valid then
				current_metric_archive_text.set_foreground_color (default_foreground_color)
				current_metric_archive_text.set_tooltip (tooltip_from_archive (a_archive))
			else
				if a_file_exist then
					current_metric_archive_text.set_tooltip (metric_names.t_selected_archive_not_valid)
				else
					current_metric_archive_text.set_tooltip (metric_names.t_selected_file_not_exists)
				end
			end
			last_current_archive := a_archive
			set_is_up_to_date (False)
			update_ui
		end

	on_compare_archives
			-- Action to be performed when user wants to compare selected archives
		local
			l_cur_archive: STRING_32
			l_ref_archive: STRING_32
			l_ref_arc: LIST [EB_METRIC_ARCHIVE_NODE]
			l_cur_arc: LIST [EB_METRIC_ARCHIVE_NODE]
			l_is_ref_ok: BOOLEAN
			l_is_cur_ok: BOOLEAN
			l_error: BOOLEAN
		do
			prepare_file_name (reference_metric_archive_text)
			l_ref_archive ?= reference_metric_archive_text.data
			if l_ref_archive /= Void then
				l_ref_archive.left_adjust
				l_ref_archive.right_adjust
				if not l_ref_archive.is_empty then
					l_ref_arc := load_archive (l_ref_archive)
					l_error := not is_last_load_successful
					l_is_ref_ok := is_last_load_successful
				end
			else
				l_error := True
			end
			if not l_error then
				prepare_file_name (current_metric_archive_text)
				l_cur_archive ?= current_metric_archive_text.data
				if l_cur_archive /= Void then
					l_cur_archive.left_adjust
					l_cur_archive.right_adjust
					if not l_cur_archive.is_empty then
						l_cur_arc := load_archive (l_cur_archive)
						l_error := not is_last_load_successful
						l_is_cur_ok := is_last_load_successful
					end
				else
					l_error := True
				end
			end
			if not l_error then
				if l_is_ref_ok or l_is_cur_ok then
					metric_tool.register_archive_result_for_display (l_ref_arc, l_cur_arc)
					metric_tool.go_to_result
				else
					display_message (metric_names.t_no_archive_selected)
				end
			end
		end

	on_pointer_double_click_on_metric_item (a_name: STRING)
			-- Action to be performed when pointer double clicks on a metric named `a_name' in `metric_selector'.
		require
			a_name_attached: a_name /= Void
		do
			if metric_manager.has_metric (a_name) then
				metric_tool.go_to_definition (metric_manager.metric_with_name (a_name), False)
			end
		end

	on_domain_change (a_domain: EB_METRIC_DOMAIN)
			-- Action to be performed when domain in `domain_selector' changes
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_reference_metric_archive_text_change
			-- Action to be performed when text in `reference_metric_archive_text' changes
		do
			on_new_archive_file_name_changes (reference_archive_timer, reference_metric_archive_text, agent on_reference_archive_checked)
		end

	on_current_metric_archive_text_change
			-- Action to be performed when text in `current_metric_archive_text' changes
		do
			on_new_archive_file_name_changes (current_archive_timer, current_metric_archive_text, agent on_current_archive_checked)
		end

	on_metric_sent_to_history (a_archive: EB_METRIC_ARCHIVE_NODE; a_panel: ANY)
			-- Action to be performed when metric calculation information contained in `a_archive' has been sent to history
		do
		end

	on_metric_renamed (a_old_name, a_new_name: STRING)
			-- Action to be performed when a metric with `a_old_name' has been renamed to `a_new_name'.
		do
		end

feature {NONE} -- Implementation

	open_file_dialog: EB_FILE_OPEN_DIALOG
			-- Dialog to select a file

	internal_timer: EV_TIMEOUT
			-- Internal timer

	reference_archive_timer: EV_TIMEOUT
			-- Timer used in `reference_metric_archive_text'

	current_archive_timer: EV_TIMEOUT
			-- Timer used in `current_metric_archive_text'

	check_archive_validity (a_text_field: EV_TEXT_FIELD; a_action: PROCEDURE [ANY, TUPLE [a_file_exist: BOOLEAN; a_archive_valid: BOOLEAN; a_archive: LIST [EB_METRIC_ARCHIVE_NODE]]]; a_timer: EV_TIMEOUT)
			-- Check validity of archive defined in `a_text_field' and invoke `a_action' after checking.
			-- If the specified archive file doesn't exist, the first boolean argument (a_file_exist) of `a_action' will be False, otherwise True.
			-- If the archive file exists, the second will be set to True if the archive is valid, otherwise False.
			-- If `a_archive_valid' is True, `a_archive' is the archive, otherwise, `a_archive' is Void.
		require
			a_text_field_attached: a_text_field /= Void
			a_action_attached: a_action /= Void
			a_timer_attached: a_timer /= Void
		local
			l_dir: DIRECTORY_32
			l_file: RAW_FILE_32
			l_file_name: STRING_32
			l_archive: LIST [EB_METRIC_ARCHIVE_NODE]
		do
			l_file_name := a_text_field.text
			if not l_file_name.is_empty then
				create l_file.make (l_file_name)
				create l_dir.make (l_file_name)
				if l_file.exists and then not l_file.is_directory then
					metric_tool.show_feedback_dialog (metric_names.t_analysing_archive, agent metric_manager.load_metric_archive (l_file_name), metric_tool.develop_window)
					l_archive := metric_manager.last_loaded_metric_archive
					a_action.call ([True, not metric_manager.has_error, l_archive])
					metric_manager.clear_last_error
				elseif not l_dir.exists then
					a_action.call ([False, False, Void])
				end
				a_timer.set_interval (0)
			end
		end

	check_selected_metrics (a_list: LIST [STRING]): STRING_GENERAL
			-- Check validity of metrics whose names are in `a_list'.
			-- Return message if error occurs, otherwise, return Void.
		require
			a_list_attached: a_list /= Void
		do
			if a_list.is_empty then
				Result := metric_names.e_no_metric_is_selected
			else
				from
					a_list.start
				until
					a_list.after or Result /= Void
				loop
					if not metric_manager.is_metric_valid (a_list.item) then
						Result := metric_names.t_metric.as_string_32 + " %"" + a_list.item + "%" " + metric_names.t_metric_is_not_valid + "."
					else
						a_list.forth
					end
				end
			end
		end

	metric_archive_from_file (a_file_name: STRING_32): HASH_TABLE [EB_METRIC_ARCHIVE_NODE, STRING]
			-- Metric archive from file `a_file_name'.
			-- Key is metric name, value is the metric archive for that metric.
			-- Void if error occurs.
		local
			l_archive: LIST [EB_METRIC_ARCHIVE_NODE]
			l_metric_manager: like metric_manager
		do
			l_metric_manager := metric_manager
			l_metric_manager.clear_last_error
			l_metric_manager.load_metric_archive (a_file_name)
			l_archive := l_metric_manager.last_loaded_metric_archive
			if not l_metric_manager.has_error then
				create Result.make (l_archive.count)
				from
					l_archive.start
				until
					l_archive.after
				loop
					Result.force (l_archive.item, l_archive.item.metric_name.as_lower)
					l_archive.forth
				end
			end
		end

	merge_archive_from_archive_table (a_tbl: HASH_TABLE [EB_METRIC_ARCHIVE_NODE, STRING]; a_list: LIST [EB_METRIC_ARCHIVE_NODE]): LIST [EB_METRIC_ARCHIVE_NODE]
			-- Merge new metric archive information into `a_tbl'.
		require
			a_tbl_attached: a_tbl /= Void
			a_list_attached: a_list /= Void
		do
			from
				a_list.start
			until
				a_list.after
			loop
				a_tbl.force (a_list.item, a_list.item.metric_name.as_lower)
				a_list.forth
			end
			create {LINKED_LIST [EB_METRIC_ARCHIVE_NODE]} Result.make
			from
				a_tbl.start
			until
				a_tbl.after
			loop
				Result.extend (a_tbl.item_for_iteration)
				a_tbl.forth
			end
		ensure
			result_attached: Result /= Void
		end

	default_foreground_color: EV_COLOR
			-- Default foreground_color is
		do
			Result := (create {EV_STOCK_COLORS}).default_foreground_color
		ensure
			result_attached: Result /= Void
		end

	tooltip_from_archive (a_archive: LIST [EB_METRIC_ARCHIVE_NODE]): STRING_GENERAL
			-- Tooltip from `a_archive' describing how many metric are archived in `a_archive' and what are they.
		require
			a_archive_attached: a_archive /= Void
		do
			Result := metric_names.f_metrics_in_archive (a_archive.count)
		end

	prepare_file_name (a_text_field: EV_TEXT_FIELD)
			-- Prepare file name specified in `a_text_field'.
		require
			a_text_field_attached: a_text_field /= Void
		local
			url_address, http, ftp, file: STRING_32
			l_is_file: BOOLEAN
		do
			url_address := a_text_field.text.twin
			a_text_field.set_data (Void)
			if url_address /= Void and then not url_address.is_empty then
				http := url_address.substring (1, 7).as_lower
				ftp := url_address.substring (1, 6).as_lower
				file := url_address.substring (1, 7).as_lower
				if file.same_string_general ("file://") then
					l_is_file := True
					url_address := url_address.substring (8, url_address.count)
				elseif ftp.same_string_general ("ftp://") or http.same_string_general ("http://") then
				else
					l_is_file := True
				end
			else
				l_is_file := True
			end
			if l_is_file then
					-- It is a local file.
				a_text_field.set_data (url_address)
			else
					-- It is a network address.
				if a_text_field = current_metric_archive_text then
					a_text_field.set_data (save_file_from_url (url_address, "transferred_current_archive.xml"))
				elseif a_text_field = reference_metric_archive_text then
					a_text_field.set_data (save_file_from_url (url_address, "transferred_reference_archive.xml"))
				end
			end
		end

	save_file_from_url (a_url_address: STRING_32; a_target_file_name: STRING_32): STRING_32
			-- Save file from url address `a_url_address' and return the saved file name in local machine.
		require
			a_url_address_attached: a_url_address /= Void
			a_target_file_name_attached: a_target_file_name /= Void
		local
			file_name: STRING_32
			target_file: STRING_32
			file: PLAIN_TEXT_FILE
			u: FILE_UTILITIES
		do
			u.create_directory (metric_manager.userdefined_metrics_path)
			file := u.make_text_file_in (a_target_file_name, metric_manager.userdefined_metrics_path)
			file_name := u.file_name (file).as_string_32

			if file.exists then
				(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_warning_prompt_with_cancel (
					metric_names.err_archive_file_name_exists (file_name), metric_tool_window, agent overwrite_action, agent abort_overwrite_action)
			end
			if not file.exists or overwrite then
				target_file := {STRING_32} "file://"
				target_file.append_string_general (file_name)
				transfer_manager_builder.set_timeout (10)
				transfer_manager_builder.wipe_out
				transfer_manager_builder.add_transaction (a_url_address.as_string_32, target_file)
				if not transfer_manager_builder.last_added_source_correct then
					(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (
						metric_names.err_unable_to_read_from_url (a_url_address), metric_tool_window, Void)
				elseif not transfer_manager_builder.last_added_target_correct then
					(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (
						metric_names.err_unable_to_load_archive_file (file_name), metric_tool_window, Void)
				else
					transfer_manager_builder.build_manager
					metric_tool_window.set_pointer_style (metric_tool.develop_window.Wait_cursor)
					transfer_manager_builder.transfer
					metric_tool_window.set_pointer_style (metric_tool.develop_window.Standard_cursor)
					if transfer_manager_builder.transfer_succeeded then
						Result := file_name
					else
						(create {ES_SHARED_PROMPT_PROVIDER}).prompts.show_error_prompt (
							metric_names.err_transfer_file (transfer_manager_builder.error_reason), metric_tool_window, Void)
					end
				end
			end
		end

	calculator: EB_METRIC_ARCHIVE_CALCULATOR
			-- Archive calculator	

	archive_calculatation_task (a_metric_names: LIST [STRING]; a_input_domain: EB_METRIC_DOMAIN): LIST [TUPLE [EB_METRIC, EB_METRIC_DOMAIN, BOOLEAN, BOOLEAN, EB_METRIC_VALUE_TESTER]]
			-- Archive calculation task from `a_metric_names' and `a_input_domain'
		require
			a_metric_names_attached: a_metric_names /= Void
			not_a_metric_names_is_empty: not a_metric_names.is_empty
			a_input_domain_attached: a_input_domain /= Void
			a_input_domain_valid: a_input_domain.is_valid
		do
			create {LINKED_LIST [TUPLE [EB_METRIC, EB_METRIC_DOMAIN, BOOLEAN, BOOLEAN, EB_METRIC_VALUE_TESTER]]} Result.make
			from
				a_metric_names.start
			until
				a_metric_names.after
			loop
				Result.extend ([metric_manager.metric_with_name (a_metric_names.item), a_input_domain, False, False, Void])
				a_metric_names.forth
			end
		ensure
			result_attached: Result /= Void
		end

feature -- Overwritting

	overwrite: BOOLEAN
		-- Overwrite file?

	overwrite_action
			-- Action to be performed on clicking on `yes_button' in `confirm_dialog'.
		do
			overwrite := True
		end

	abort_overwrite_action
			-- Action to be performed on clicking on `no_button' in `confirm_dialog'.
		do
			overwrite := False
		end

	load_archive (a_file_name: STRING_32): LIST [EB_METRIC_ARCHIVE_NODE]
			-- Load archive from file `a_file_name'.
		require
			a_file_name_attached: a_file_name /= Void
		do
			metric_manager.clear_last_error
			metric_manager.load_metric_archive (a_file_name)
			Result := metric_manager.last_loaded_metric_archive
			is_last_load_successful := not metric_manager.has_error
			if not is_last_load_successful then
				display_error_message
			end
		end

feature {NONE} -- Recycle

	internal_recycle
			-- To be called when the button has became useless.
		do
			preferences.metric_tool_data.unit_order_preference.change_actions.prune_all (on_unit_order_change_agent)
			uninstall_agents (metric_tool)
			domain_selector.recycle
			metric_selector.recycle
		end

feature{NONE} -- Actions

	on_project_loaded
			-- Action to be performed when project loaded
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_project_unloaded
			-- Action to be performed when project unloaded
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_compile_start
			-- Action to be performed when Eiffel compilation starts
		do
			if is_archive_calculating then
				on_stop_metric_evaluation_button_pressed
				metric_manager.on_archive_calculation_stops (Current)
			end
			set_is_up_to_date (False)
			update_ui
		end

	on_compile_stop
			-- Action to be performed when Eiffel compilation stops
		do
			set_is_up_to_date (False)
			set_is_metric_reloaded (True)
			update_ui
		end

	on_metric_evaluation_start (a_data: ANY)
			-- Action to be performed when metric evaluation starts
			-- `a_data' can be the metric tool panel from which metric evaluation starts.
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_metric_evaluation_stop (a_data: ANY)
			-- Action to be performed when metric evaluation stops
			-- `a_data' can be the metric tool panel from which metric evaluation stops.
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_archive_calculation_start (a_data: ANY)
			-- Action to be performed when metric archive calculation starts
			-- `a_data' can be the metric tool panel from which metric archive calculation starts.
		local
			l_panel: like Current
		do
			set_is_up_to_date (False)
			l_panel ?= a_data
			set_is_original_starter (l_panel /= Void and then (l_panel = Current))
			update_ui
		end

	on_archive_calculation_stop (a_data: ANY)
			-- Action to be performed when metric archive calculation stops
			-- `a_data' can be the metric tool panel from which metric archive calculation stops.
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_metric_loaded
			-- Action to be performed when metrics loaded in `metric_manager'
		do
			set_is_metric_reloaded (True)
			set_is_up_to_date (False)
			update_ui
		end

	on_history_recalculation_start (a_data: ANY)
			-- Action to be performed when archive history recalculation starts
			-- `a_data' can be the metric tool panel from which metric history recalculation starts.
		do
			set_is_up_to_date (False)
			update_ui
		end

	on_history_recalculation_stop (a_data: ANY)
			-- Action to be performed when archive history recalculation stops
			-- `a_data' can be the metric tool panel from which metric history recalculation stops.
		do
			set_is_up_to_date (False)
			update_ui
		end

feature{NONE} -- UI Update

	update_ui
			-- Update interface
		do
			if is_selected and then not is_up_to_date then
				if is_eiffel_compiling or is_metric_evaluating or is_history_recalculationg_running or not is_project_loaded then
					disable_sensitive
				else
					enable_sensitive
					if is_archive_calculating then
						archive_comparison_area.disable_sensitive
						metric_selector.disable_sensitive
						domain_selector.disable_sensitive
						run_btn.disable_sensitive
						new_archive_file_area.disable_sensitive
						run_btn.disable_sensitive
						if is_original_starter then
							stop_btn.enable_sensitive
						else
							stop_btn.disable_sensitive
						end
					else
						new_archive_file_area.enable_sensitive
						archive_comparison_area.enable_sensitive
						stop_btn.disable_sensitive
						metric_selector.enable_sensitive
						metric_tool.load_metrics_and_display_error (False, metric_names.t_loading_metrics)
						if not metric_tool.is_metric_validation_checked.item then
							metric_tool.check_metric_validation (metric_tool.develop_window)
						end
						if is_metric_reloaded then
							set_is_metric_reloaded (False)
							metric_selector.load_metrics (True)
							metric_selector.try_to_selected_last_metric
							if metric_selector.last_selected_metric = Void then
								metric_selector.select_first_metric
							end
						end
						domain_selector.enable_sensitive
						domain_selector.block_domain_change_actions
						domain_selector.refresh
						domain_selector.resume_domain_change_actions
						if is_new_archive_file_selected and then domain_selector.domain.is_valid then
							run_btn.enable_sensitive
						else
							run_btn.disable_sensitive
						end
						if is_new_archive_file_selected and then is_new_archive_file_exists then
							if is_new_archive_file_valid then
								clean_btn.enable_sensitive
								new_archive_file_name_text.set_foreground_color (default_foreground_color)
							else
								new_archive_file_name_text.set_foreground_color (red_color)
								clean_btn.disable_sensitive
								clean_btn.enable_select
							end
						else
							clean_btn.disable_select
							clean_btn.disable_sensitive
							new_archive_file_name_text.set_foreground_color (default_foreground_color)
						end
						if is_reference_metric_archive_ok or is_current_metric_archive_ok then
							compare_btn.enable_sensitive
						else
							compare_btn.disable_sensitive
						end
						if is_current_metric_archive_ok then
							current_metric_archive_text.set_foreground_color (default_foreground_color)
						else
							current_metric_archive_text.set_foreground_color (red_color)
						end
						if is_reference_metric_archive_ok then
							reference_metric_archive_text.set_foreground_color (default_foreground_color)
						else
							reference_metric_archive_text.set_foreground_color (red_color)
						end
					end
				end
				set_is_up_to_date (True)
			end
		end

invariant
	open_file_dialog_attached: open_file_dialog /= Void
	internal_timer_attached: internal_timer /= Void
	reference_archive_timer_attached: reference_archive_timer /= Void
	current_archive_timer_attched: current_archive_timer /= Void
	domain_selector_attached: domain_selector /= Void
	metric_selector_attached: metric_selector /= Void
	calculator_attached: calculator /= Void

note
	copyright:	"Copyright (c) 1984-2009, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			 Eiffel Software
			 5949 Hollister Ave., Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class EB_METRIC_ARCHIVE_PANEL


