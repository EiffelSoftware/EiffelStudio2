note
	description: "Tabbed editor manager for one window of EiffelStudio"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

class
	EB_EDITORS_MANAGER

inherit
	EB_RECYCLABLE
		redefine
			internal_detach_entities
		end

	SHARED_EIFFEL_PROJECT
		export
			{NONE} all
		end

	EB_SHARED_ID_SOLUTION
		export
			{NONE} all
		end

	EB_PIXMAPABLE_ITEM_PIXMAP_FACTORY
		export
			{NONE} all
		end

	EB_CONSTANTS
		export
			{NONE} all
		end

	EC_ENCODING_UTINITIES
		export
			{NONE} all
		end

create
	make

feature -- Initialization

	make (a_dev_win: EB_DEVELOPMENT_WINDOW)
			-- Initialization
		require
			a_dev_win_attached: a_dev_win /= Void
		do
				-- Set editor manager on the window
			a_dev_win.set_editors_manager (Current)

				-- Ensure the editor manager is recycled when the development window is
			a_dev_win.auto_recycle (Current)

			create editors_internal.make (0)

				-- Action sequences
			create editor_switched_actions
			create editor_created_actions
			create editor_closed_actions

			editor_switched_actions.extend (agent on_editor_switched)

			create editor_number_factory.make
			build_observer_lists
			development_window := a_dev_win
			docking_manager := a_dev_win.docking_manager
			register_action (docking_manager.tab_drop_actions, agent ((a_dev_win.commands).new_tab_cmd).execute_with_stone_content)

			set_veto_pebble_function (agent on_veto_tab_drop_action)
			docking_manager.tab_drop_actions.set_veto_pebble_function (veto_pebble_function_internal)

			if veto_pebble_function_internal = Void then
				docking_manager.tab_drop_actions.set_veto_pebble_function (agent default_veto_func)
			end
			create_editor
			register_action (docking_manager.main_area_drop_action, agent create_editor_beside_content (?, Void))
			if veto_pebble_function_internal = Void then
				docking_manager.main_area_drop_action.set_veto_pebble_function (agent default_veto_func)
			end
		ensure
			editors_internal_not_void: editors_internal /= Void
			editors_not_empty: not editors_internal.is_empty
			docking_manager_attached: docking_manager = a_dev_win.docking_manager
			development_window_not_void: development_window = a_dev_win
			history_observer_list_internal_not_void: history_observer_list_internal /= Void
			edition_observer_list_internal_not_void: edition_observer_list_internal /= Void
			cursor_observer_list_internal_not_void: cursor_observer_list_internal /= Void
			selection_observer_list_internal_not_void: selection_observer_list_internal /= Void
			lines_observer_list_internal_not_void: lines_observer_list_internal /= Void
		end

feature -- Access

	unsaved_editors: like editors_internal
			-- Unsaved editors
		local
			l_editors: like editors
		do
			create Result.make (0)
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				if l_editors.item.changed then
					Result.extend (l_editors.item)
				end
				l_editors.forth
			end
		end

	current_editor: EB_SMART_EDITOR
			-- Current editor
		do
			if editors_internal.has (last_focused_editor) then
				Result := last_focused_editor
			elseif not editors_internal.is_empty then
				-- We return a random editor
				if editors_internal.off then
					editors_internal.start
				end
				Result := editors_internal.item
			end
		end

	editor_with_stone (a_stone: STONE) : like current_editor
			-- Editor that has `a_stone', or editing the same path file.
		local
			l_fake_editor: EB_FAKE_SMART_EDITOR
		do
			if a_stone /= Void then
				Result := editor_with_stone_internal (editors, a_stone)
				if Result = Void and then fake_editors /= Void then
					Result := editor_with_stone_internal (fake_editors, a_stone)
					l_fake_editor ?= Result
					if l_fake_editor /= Void then
						init_editor
						change_fake_to_real (last_created_editor, l_fake_editor, l_fake_editor.content)
					end
				end
			end
		end

	editor_with_class (a_file_name: FILE_NAME) : like current_editor
			-- Editor editing a class with `a_file_name'
		require
			a_file_name_attached: a_file_name /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
			l_classi_stone: CLASSI_STONE
			l_external_file_stone: EXTERNAL_FILE_STONE
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after or Result /= Void
			loop
				l_classi_stone ?= l_editors.item.stone
				l_external_file_stone ?= l_editors.item.stone
				if l_classi_stone /= Void then
					if l_classi_stone.file_name.is_equal (a_file_name) then
						Result := l_editors.item
					end
				elseif l_external_file_stone /= Void then
					if l_external_file_stone.file_name.is_equal (a_file_name) then
						Result := l_editors.item
					end
				end
				l_editors.forth
			end
		end

	editors: like editors_internal
			-- Clone of all editors
		do
			Result := editors_internal.twin
		end

	editor_count: INTEGER
			-- Number of editors under management.
		do
			Result := editors_internal.count
			if fake_editors /= Void then
				Result := Result + fake_editors.count
			end
		end

	development_window: EB_DEVELOPMENT_WINDOW
			-- Associated development window.

	editor_editing (a_class_i: CLASS_I) : like editors_internal
			-- Editors contain `a_class_i'
		require
			a_class_i_attached: a_class_i /= Void
		local
			l_stone: CLASSI_STONE
			l_editors: like editors
		do
			create Result.make (0)
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_stone ?= l_editors.item.stone
				if l_stone /= Void and then l_stone.class_i /= Void and then a_class_i = l_stone.class_i then
					Result.extend (l_editors.item)
				end
				l_editors.forth
			end
		ensure
			Result_not_void: Result /= Void
		end

	last_focused_editor: like current_editor
			-- Last focused editor

	last_created_editor: like current_editor
			-- Last created editor

	open_classes: HASH_TABLE [STRING, STRING]
			-- Open classes. [ID, title]
		local
			l_classc_stone: CLASSC_STONE
			l_editors: like editors
			l_id: STRING
		do
			create Result.make (editors_internal.count)
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_classc_stone ?= l_editors.item.stone
				if l_classc_stone /= Void then
					check
						class_not_void: l_classc_stone.class_i /= Void
						config_class_not_void: l_classc_stone.class_i.config_class /= Void
					end
					l_id := id_of_class (l_classc_stone.class_i.config_class)
					Result.put (l_id, l_editors.item.docking_content.unique_title.as_string_8)
				end
				l_editors.forth
			end
		ensure
			not_void: Result /= Void
		end

	open_fake_classes: HASH_TABLE [STRING, STRING]
			-- Opened classes that in fake editors. [ID, title]
		local
			l_contents: ARRAYED_LIST [SD_CONTENT]
			l_fake_editor: EB_FAKE_SMART_EDITOR_CELL
			l_classc_stone: CLASSC_STONE
			l_id: STRING
		do
			create Result.make (1)
			from
				l_contents := docking_manager.contents.twin
				l_contents.start
			until
				l_contents.after
			loop
				if l_contents.item.type = {SD_ENUMERATION}.editor then
					l_fake_editor ?= l_contents.item.user_widget
					if l_fake_editor /= Void then
						l_classc_stone ?= l_fake_editor.stone
						if l_classc_stone /= Void then
							check
								class_not_void: l_classc_stone.class_i /= Void
								config_class_not_void: l_classc_stone.class_i.config_class /= Void
							end
							l_id := id_of_class (l_classc_stone.class_i.config_class)
							Result.put (l_id, l_contents.item.unique_title.as_string_8)
						end
					end
				end
				l_contents.forth
			end
		ensure
			not_void: Result /= Void
		end

	open_clusters: HASH_TABLE [STRING, STRING]
			-- Open clusters. [ID, title]
		local
			l_cluster_stone: CLUSTER_STONE
			l_editors: like editors
			l_id: STRING
		do
			create Result.make (editors_internal.count)
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_cluster_stone ?= l_editors.item.stone
				if l_cluster_stone /= Void then
					l_id := id_of_group (l_cluster_stone.group)
					Result.put (l_id, l_editors.item.docking_content.unique_title.as_string_8)
				end
				l_editors.forth
			end
		end

	open_fake_clusters: HASH_TABLE [STRING, STRING]
			-- Opened clusters that in fake editors. [ID, title]
		local
			l_contents: ARRAYED_LIST [SD_CONTENT]
			l_fake_editor: EB_FAKE_SMART_EDITOR_CELL
			l_cluster_stone: CLUSTER_STONE
			l_id: STRING
		do
			create Result.make (1)
			from
				l_contents := docking_manager.contents.twin
				l_contents.start
			until
				l_contents.after
			loop
				if l_contents.item.type = {SD_ENUMERATION}.editor then
					l_fake_editor ?= l_contents.item.user_widget
					if l_fake_editor /= Void then
						l_cluster_stone ?= l_fake_editor.stone
						if l_cluster_stone /= Void then
							l_id := id_of_group (l_cluster_stone.group)
							Result.put (l_id, l_contents.item.unique_title.as_string_8)
						end
					end
				end
				l_contents.forth
			end
		ensure
			not_void: Result /= Void
		end

	changed_classes: ARRAYED_LIST [CLASS_I]
			-- All classes with unsaved changes
		require
			changed: changed
		local
			l_classc_stone: CLASSC_STONE
			l_classi_stone: CLASSI_STONE
			l_editors: like editors
			l_cursor: CURSOR
		do
			create Result.make (editors_internal.count)
			l_editors := editors
			l_cursor := l_editors.cursor
			from
				l_editors.start
			until
				l_editors.after
			loop
				if l_editors.item.changed then
					l_classc_stone ?= l_editors.item.stone
					if l_classc_stone /= Void then
						Result.extend (l_classc_stone.class_i)
					else
						l_classi_stone ?= l_editors.item.stone
						if l_classi_stone /= Void then
							Result.extend (l_classi_stone.class_i)
						end
					end
				end
				l_editors.forth
			end
			l_editors.go_to (l_cursor)
		ensure
			not_void: Result /= Void
			not_result_is_empty: not Result.is_empty
			editors_unmoved: editors.cursor.is_equal (editors.cursor)
		end

feature {NONE} -- Access

	docking_manager: SD_DOCKING_MANAGER
			-- Docking manager, containing the editors

feature -- Actions

	editor_created_actions: ACTION_SEQUENCE [TUPLE [editor: EB_SMART_EDITOR]]
			-- Actions call when a new editor is created.

	editor_closed_actions: ACTION_SEQUENCE [TUPLE [editor: EB_SMART_EDITOR]]
			-- Actions call when a new editor is created.

	editor_switched_actions: ACTION_SEQUENCE [TUPLE [editor: EB_SMART_EDITOR]]
			-- Actions after editor switched from one document to another

feature {NONE} -- Action handlers

	on_editor_switched (a_editor: EB_SMART_EDITOR)
			-- Editor is switched.
		require
			a_editor_attached: a_editor /= Void
		do
			if not a_editor.is_recycled then
				if development_window.editors_manager /= Void then
						-- During initialization of Current, the editor manager will be Void for the development window
					development_window.set_stone (a_editor.stone)
				end
			end
		end

	on_veto_tab_drop_action (a_stone: ANY; a_content: SD_CONTENT): BOOLEAN
			-- Veto function for tab area drop actions
		do
			-- `a_content' can be void or its type is editor type
			Result := a_content = Void or else a_content.type = {SD_ENUMERATION}.editor
			if Result then
				Result := default_veto_func (a_stone, a_content)
			end
		end

feature -- Status report

	is_class_editing (a_file_name: STRING) : BOOLEAN
			-- Editor editing a class with `a_file_name'
		require
			a_file_name_attached: a_file_name /= Void
		local
			l_editors: like editors_internal
			l_classi_stone: CLASSI_STONE
			l_external_file_stone: EXTERNAL_FILE_STONE
			l_fn: STRING
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after or Result
			loop
				l_classi_stone ?= l_editors.item.stone
				l_external_file_stone ?= l_editors.item.stone
				if l_classi_stone /= Void then
					l_fn := l_classi_stone.file_name
					if l_fn /= Void and then l_fn.is_equal (a_file_name.string) then
						Result := True
					end
				elseif l_external_file_stone /= Void then
					l_fn := l_external_file_stone.file_name
					if l_fn /= Void and then l_fn.string.is_equal (a_file_name) then
						Result := True
					end
				end
				l_editors.forth
			end
		end

	changed : BOOLEAN
			-- Any editor is changed?
		local
			l_editors: like editors_internal
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after or Result
			loop
				Result := l_editors.item.changed
				l_editors.forth
			end
		end

	full_loaded: BOOLEAN
			-- Have all editor full loaded?
		local
			l_editors: like editors_internal
		do
			Result := True
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after or not Result
			loop
				Result := l_editors.item.text_is_fully_loaded
				l_editors.forth
			end
		end

	show_formatting_marks: BOOLEAN
			-- Show formating marks?

	not_backuped: INTEGER
			-- Number of editors not backuped last time

	stone_acceptable (a_stone: ANY): BOOLEAN
			-- Is `a_stone' suitable for a new editor?
		do
			if veto_pebble_function_internal /= Void then
				if last_focused_editor /= Void then
					Result := veto_pebble_function_internal.item ([a_stone, last_focused_editor.docking_content])
				else
					Result := veto_pebble_function_internal.item ([a_stone, void])
				end
			else
				if last_focused_editor /= Void then
					Result := default_veto_func (a_stone, last_focused_editor.docking_content)
				else
					Result := default_veto_func (a_stone, void)
				end
			end
		end

feature -- Editor observer

	add_edition_observer (a_text_observer: TEXT_OBSERVER)
			-- Add observer for all editors.
		require
			a_text_abserver_attached: a_text_observer /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				if l_editors.item.text_displayed /= Void then
					l_editors.item.text_displayed.add_edition_observer (a_text_observer)
					if a_text_observer /= Void and then not edition_observer_list_internal.has (a_text_observer) then
						edition_observer_list_internal.extend (a_text_observer)
					end
				end
				l_editors.forth
			end
		end

	add_history_observer (history_observer: UNDO_REDO_OBSERVER)
			-- Add history observer for all editors.
		require
			history_observer_attached: history_observer /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_editors.item.text_displayed.history.add_observer (history_observer)
				history_observer_list_internal.extend (history_observer)
				l_editors.forth
			end
		end

	remove_history_observer (history_observer: UNDO_REDO_OBSERVER)
			-- Remove observer for all editors.
		require
			history_observer_attached: history_observer /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_editors.item.text_displayed.history.remove_observer (history_observer)
				history_observer_list_internal.prune_all (history_observer)
				l_editors.forth
			end
		end

	add_cursor_observer (a_cursor_observer: TEXT_OBSERVER)
			-- Add cursor observer for all editors.
		require
			a_cursor_abserver_attached: a_cursor_observer /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				if not l_editors.item.text_displayed.is_notifying then
					l_editors.item.text_displayed.add_cursor_observer (a_cursor_observer)
					if a_cursor_observer /= Void and then not cursor_observer_list_internal.has (a_cursor_observer) then
						cursor_observer_list_internal.extend (a_cursor_observer)
					end
				end
				l_editors.forth
			end
		end

feature -- Element change

	create_editor
			-- Create a new editor.
		do
			create_editor_beside_content (Void, exist_content)
		end

	create_editor_beside_content (a_stone: STONE; a_content: SD_CONTENT)
			-- Create an editor beside `a_content'. Meanwile set `a_stone' to the editor if `a_stone' is not void.
			-- Set top if the a_content is void.
		local
			l_content: SD_CONTENT
		do
			if editor_with_stone (a_stone) = Void then
				init_editor
				l_content := create_docking_content (editor_number_factory.new_editor_name, last_created_editor, a_content)
				last_created_editor.set_docking_content (l_content)
			end

			if a_stone /= Void then
				on_drop (a_stone, last_created_editor)
			end
		end

	close_editor (a_editor: like current_editor)
			-- Close an editor.
		require
			a_editor_attached: a_editor /= Void
		do
			on_close (a_editor)
		end

	close_all_editor
			-- Close all editor
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				close_editor_perform (l_editors.item)
				l_editors.forth
			end
				-- Not sure if this is needed!
			create editors_internal.make (5)
		end

	set_veto_pebble_function (a_func: FUNCTION [ANY, TUPLE [ANY, SD_CONTENT], BOOLEAN])
			-- Set veto pebble_function for all editors.
		require
			a_func_attached: a_func /= Void
		local
			l_editors: ARRAYED_LIST [like current_editor]
		do
			l_editors := editors
			veto_pebble_function_internal := a_func
			from
				l_editors.start
			until
				l_editors.after
			loop
				l_editors.item.drop_actions.set_veto_pebble_function (a_func)
				if l_editors.item.docking_content /= Void then
					l_editors.item.docking_content.drop_actions.set_veto_pebble_function (a_func)
				end
				l_editors.forth
			end
		ensure
			set: veto_pebble_function_internal = a_func
		end

	restore_editors (a_open_classes: HASH_TABLE [STRING, STRING]; a_open_clusters: HASH_TABLE [STRING, STRING]): BOOLEAN
			-- Restore editors.
			-- If really have editors to open, then result is True, otherwise is False
		require
			a_open_classes_attached: a_open_classes /= Void
			a_open_clusters_attached: a_open_clusters /= Void
		local
			l_classi_stone: CLASSI_STONE
			l_classc_stone: CLASSC_STONE
			l_cluster_stone: CLUSTER_STONE
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
			l_group: CONF_GROUP
			l_content: SD_CONTENT
			l_editor_numbers: ARRAYED_LIST [INTEGER]
		do
			-- After this operation, the place holder zone will be inserted by docking library
			close_all_editor
			if not a_open_classes.is_empty or not a_open_clusters.is_empty then
				is_opening_editors := True

				create l_editor_numbers.make (a_open_classes.count + a_open_clusters.count)
				create fake_editors.make (10)
					-- Restore open classes.
				from
					a_open_classes.start
				until
					a_open_classes.after
				loop
					l_conf_class := class_of_id (a_open_classes.item_for_iteration)
					if l_conf_class /= Void then
						l_content := create_docking_content_fake_one (a_open_classes.key_for_iteration)

						fake_editors.extend (last_created_editor)

						l_content.set_long_title (l_conf_class.name)
						l_content.set_short_title (l_conf_class.name)

						l_class_i ?= l_conf_class
						check
							l_class_i_not_void: l_class_i /= Void
						end
						l_content.set_pixmap (pixmap_from_class_i (l_class_i))
						l_editor_numbers.extend (editor_number_factory.editor_number_from_title (a_open_classes.key_for_iteration))
						if l_class_i.is_compiled then
							create l_classc_stone.make (l_class_i.compiled_class)
							last_created_editor.set_stone (l_classc_stone)
							update_content_description (l_classc_stone, last_created_editor.docking_content)
						else
							create l_classi_stone.make (l_class_i)
							last_created_editor.set_stone (l_classi_stone)
							update_content_description (l_classi_stone, last_created_editor.docking_content)
						end
						Result := True
					end
					a_open_classes.forth
				end
					-- Restore open clusters,
				from
					a_open_clusters.start
				until
					a_open_clusters.after
				loop
					l_group := group_of_id (a_open_clusters.item_for_iteration)
					if l_group /= Void then
						create l_cluster_stone.make (l_group)
						l_content := create_docking_content_fake_one (a_open_clusters.key_for_iteration)
						fake_editors.extend (last_created_editor)
						l_content.set_long_title (l_group.name)
						l_content.set_short_title (l_group.name)
						l_content.set_pixmap (pixmap_from_group (l_group))
						l_editor_numbers.extend (editor_number_factory.editor_number_from_title (a_open_clusters.key_for_iteration))
						last_created_editor.set_stone (l_cluster_stone)
						update_content_description (l_cluster_stone, last_created_editor.docking_content)
						Result := True
					end
					a_open_clusters.forth
				end
				editor_number_factory.set_editors_numbers (l_editor_numbers)
				is_opening_editors := False
			end
		ensure
			not_opening_editors: not is_opening_editors
		end

	fake_editors: ARRAYED_LIST [EB_SMART_EDITOR]
			-- Fake editors which is for fast opening Eiffel Studio.

	show_editors_possible
			-- Show editors which are possible to show.
		local
			l_snapshot: like fake_editors
		do
			if fake_editors /= Void then
				from
					l_snapshot := fake_editors.twin
					l_snapshot.start
				until
					l_snapshot.after
				loop
					if l_snapshot.item /= Void and then l_snapshot.item.docking_content.user_widget.is_displayed then
						on_focus (l_snapshot.item)
					end
					l_snapshot.forth
				end
			end
			synchronize_with_docking_manager
		end

	update_content_description (a_stone: STONE; a_content: SD_CONTENT)
			-- Update `a_content''s detail and description text which are readed from `a_stone'.
		local
			l_class_stone: CLASSI_STONE
			l_cluster_stone: CLUSTER_STONE
			l_shared: SD_SHARED
			l_name: STRING_8
		do
			if a_content /= Void then
				l_class_stone ?= a_stone
				l_cluster_stone ?= a_stone
				if l_class_stone /= Void then
					a_content.set_description (interface_names.l_eiffel_class)
					l_name := l_class_stone.file_name
					if l_name /= Void then
						a_content.set_detail (l_name)
						a_content.set_tab_tooltip (l_name)
					else
						a_content.set_tab_tooltip (Void)
					end
				elseif l_cluster_stone /= Void then
					a_content.set_description (interface_names.l_eiffel_cluster)

					l_name := l_cluster_stone.group.location.evaluated_path
					if l_name /= Void and l_cluster_stone.path /= Void then
						l_name := l_name + l_cluster_stone.path
					end

					if l_name /= Void then
						a_content.set_detail (l_name)
						a_content.set_tab_tooltip (l_name)
					else
						a_content.set_tab_tooltip (Void)
					end
				else
					-- We don't know this kind of stone.
					create l_shared
					a_content.set_description (l_shared.interface_names.zone_navigation_no_description_available)
					a_content.set_detail (l_shared.interface_names.zone_navigation_no_detail_available)
					a_content.set_tab_tooltip (Void)
				end
			end
		end

feature -- Basic operations

	select_editor (a_editor: like current_editor; a_force_focus: BOOLEAN)
			-- Give `a_editor' focus.
			-- `a_force_focus' means if force unmaximized other tool to show `a_editor'.
		require
			a_editor_attached: a_editor /= Void
		do
			if editors_internal.has (a_editor) then
				if docking_manager.has_content (a_editor.docking_content) then
					if a_force_focus then
						a_editor.docking_content.set_focus
					else
						a_editor.docking_content.set_focus_no_maximized (a_editor.docking_content.user_widget)
					end
					if a_editor.editor_drawing_area.is_sensitive and a_editor.editor_drawing_area.is_displayed then
						a_editor.editor_drawing_area.set_focus
					end
				end
			end
		end

	backup_all
			-- Back up all changed editor.
		local
			l_editors: like editors_internal
		do
			not_backuped := 0
			l_editors := editors
			from
				l_editors.start
			until
				l_editors.after
			loop
				back_up_editor (l_editors.item)
				l_editors.forth
			end
		end

	toggle_formatting_marks
			-- Toggle formatting marks.
		local
			l_editors: like editors
		do
			from
				l_editors := editors
				l_editors.start
			until
				l_editors.after
			loop
				check
					show_formatting_marks = l_editors.item.view_invisible_symbols
				end
				l_editors.item.toggle_view_invisible_symbols
				l_editors.forth
			end
			show_formatting_marks := not show_formatting_marks
		end

feature -- Memory management

	internal_recycle
			-- Memory management
		local
			l_editors: like editors
		do
			from
				l_editors := editors_internal
				l_editors.start
			until
				l_editors.after
			loop
				if not l_editors.item.is_recycled then
					l_editors.item.recycle
				end
				l_editors.forth
			end
			l_editors.wipe_out
			if fake_editors /= Void then
				from
					l_editors := fake_editors
					l_editors.start
				until
					l_editors.after
				loop
					if not l_editors.item.is_recycled then
						l_editors.item.recycle
					end
					l_editors.forth
				end
				l_editors.wipe_out
			end
			editor_created_actions.wipe_out
			editor_closed_actions.wipe_out
			editor_switched_actions.wipe_out
			docking_manager.tab_drop_actions.set_veto_pebble_function (Void)
		end

	internal_detach_entities
			-- <Precursor>
		do
			development_window := Void
			docking_manager := Void
			editors_internal := Void
			fake_editors := Void
			fake_editors := Void
			last_created_editor := Void
			editor_closed_actions := Void
			development_window := Void
			docking_manager := Void
			edition_observer_list_internal := Void
			history_observer_list_internal := Void
			veto_pebble_function_internal := Void
			lines_observer_list_internal := Void
			editor_number_factory := Void
			editors_internal := Void
			editor_created_actions := Void
			editor_switched_actions := Void
			cursor_observer_list_internal := Void
			selection_observer_list_internal := Void
			on_show_imp_agent := Void
			last_focused_editor := Void
			Precursor
		end

feature {NONE} -- Access

	editors_internal: ARRAYED_LIST [like current_editor]
			-- Actual list of editors.

feature {NONE} -- Observer

	history_observer_list_internal:ARRAYED_LIST [UNDO_REDO_OBSERVER]
		-- List of history observers.

	edition_observer_list_internal: ARRAYED_LIST [TEXT_OBSERVER]
		-- List of editor observers.

	cursor_observer_list_internal: ARRAYED_LIST [TEXT_OBSERVER]
		-- List of cursor observers.

	selection_observer_list_internal: ARRAYED_LIST [TEXT_OBSERVER]
		-- List of editor observers.

	lines_observer_list_internal: ARRAYED_LIST [TEXT_OBSERVER]
		-- List of editor observers.

	build_observer_lists
			-- Build all internal observer lists.
		do
			create edition_observer_list_internal.make (0)
			create history_observer_list_internal.make (0)
			create cursor_observer_list_internal.make (0)
			create selection_observer_list_internal.make (0)
			create lines_observer_list_internal.make (0)
		end

	add_observers (a_editor: like current_editor)
			-- Add exsiting observers for a new editor.
		do
			from
				edition_observer_list_internal.start
			until
				edition_observer_list_internal.after
			loop
				a_editor.add_edition_observer (edition_observer_list_internal.item)
				edition_observer_list_internal.forth
			end
			from
				history_observer_list_internal.start
			until
				history_observer_list_internal.after
			loop
				a_editor.add_history_observer (history_observer_list_internal.item)
				history_observer_list_internal.forth
			end
			from
				cursor_observer_list_internal.start
			until
				cursor_observer_list_internal.after
			loop
				a_editor.add_cursor_observer (cursor_observer_list_internal.item)
				cursor_observer_list_internal.forth
			end
			from
				selection_observer_list_internal.start
			until
				selection_observer_list_internal.after
			loop
				a_editor.add_selection_observer (selection_observer_list_internal.item)
				selection_observer_list_internal.forth
			end
			a_editor.drop_actions.set_veto_pebble_function (veto_pebble_function_internal)
		end

feature {NONE} -- Agents

	on_focus (a_editor: like current_editor)
			-- Invoke when `a_editor' is focusing.
		local
			l_fake_editor: EB_FAKE_SMART_EDITOR
			l_editor: EB_SMART_EDITOR
			l_ignore: BOOLEAN
		do
			if not is_opening_editors then
				l_fake_editor ?= a_editor
				if l_fake_editor /= Void then
					-- Maybe called by `on_show_imp' (`on_show_imp' called by `on_show') on same editor more than once.
					l_ignore := has_editor_with_long_title (l_fake_editor.content.long_title)
					if not l_ignore then
						init_editor
						change_fake_to_real (last_created_editor, l_fake_editor, l_fake_editor.content)
						l_editor := last_created_editor
					end
				else
					l_editor := a_editor
				end

				if not l_ignore then
					if not editors_internal.is_empty and then not editors_internal.off then
						last_focused_editor := a_editor
					else
						last_focused_editor := Void
					end
					validate_editor (l_editor)
					editor_switched_actions.call ([l_editor])
					if l_editor.editor_drawing_area /= Void and then l_editor.editor_drawing_area.is_displayed and l_editor.editor_drawing_area.is_sensitive then
						l_editor.editor_drawing_area.set_focus
					end
				end
			end
		end

	on_fake_focus (a_editor: like current_editor)
			-- Handle `focus_in_actions' of fake editors.
		local
			l_env: EV_ENVIRONMENT
		do
			if on_show_imp_agent /= Void then
				create l_env
				l_env.application.remove_idle_action (on_show_imp_agent)
				on_show_imp_agent := Void
			end

			on_focus (a_editor)
		end

	on_show (a_editor: like current_editor)
			-- Handle `show_actions' of fake editors.
		local
			l_env: EV_ENVIRONMENT
		do
			-- show actions of same editor maybe called more than once.
			if on_show_imp_agent = Void then
				on_show_imp_agent := agent on_show_imp (a_editor)
				create l_env
				l_env.application.do_once_on_idle (on_show_imp_agent)
			end
		ensure
			registed: on_show_imp_agent /= Void
		end

	on_show_imp (a_editor: like current_editor)
			-- Invoke when `a_editor' is shown, and `a_editor' is fake focus editor.
		local
			l_last_focused_editor: like last_focused_editor
		do
			if not is_opening_editors then
				if last_focused_editor /= Void then
					l_last_focused_editor := last_focused_editor
				end
				on_focus (a_editor)
				-- When changing fake editor to real one, we don't want to change `last_focused_editor'.
				if l_last_focused_editor /= Void and a_editor /= Void and then a_editor.docking_content /= l_last_focused_editor.docking_content then
					on_focus (l_last_focused_editor)
				end
			end
			on_show_imp_agent := Void
		ensure
			cleared: on_show_imp_agent = Void
		end

	on_drop (a_stone: STONE; a_editor: like current_editor)
			-- Invoke when a stone is dropped on `a_editor'.
		local
			l_editor : like current_editor
		do
			if a_stone /= Void and then a_stone.is_valid then
				development_window.set_dropping_on_editor (true)
				l_editor := editor_with_stone (a_stone)
				if l_editor = Void then
					l_editor := a_editor
				end
				if l_editor /= Void then
					-- Following line will change fake editor to real editor if `l_editor' is fake editor
					l_editor.docking_content.set_focus

					-- If `l_editor' is fake editor, `editor_drawing_area' is void
					if
						{draw: EV_DRAWING_AREA} a_editor.editor_drawing_area and then
						(draw.is_displayed and draw.is_sensitive)
					then
						a_editor.editor_drawing_area.set_focus
					end
				end

				update_content_description (a_stone, l_editor.docking_content)
				development_window.set_stone (a_stone)
				development_window.set_dropping_on_editor (false)
			end
		end

	on_close (a_editor: like current_editor)
			-- Closing an editor callback.
		do
			if a_editor.changed then
				if a_editor /= current_editor then
					-- If `a_editor' changed and not focused, we must focus it, then notify our users whether to save it.
					-- We have to give the focus to the editor (see bug#14247) since when closing an editor
					-- we do a lot of things (see {EB_SAVE_FILE_COMMAND}.execute for details).

					-- In perfect case, we should only switch to the editor if something wrong happen, but
					-- that need to change a lot of codes...
					select_editor (a_editor, False)
				end

				-- Editor changed, we make sure save command is sensitive
				-- Sometimes, `save_cmd' is disabled when saving class file
				-- See bug#13499
				development_window.save_cmd.enable_sensitive

				development_window.save_and (agent close_editor_perform (a_editor))
			else
				close_editor_perform (a_editor)
			end
		end

feature {NONE} -- Implementation

	is_opening_editors: BOOLEAN
		-- If Current opening more than one editors?

	on_show_imp_agent: PROCEDURE [ANY, TUPLE]
			-- Agent created by `on_show', cleared by `on_show_imp' or `on_fake_focus'.

	editor_number_factory: EB_EDITOR_NUMBER_FACTORY
			-- Produce editor number and internal names.

	veto_pebble_function_internal: FUNCTION [ANY, TUPLE [ANY, SD_CONTENT], BOOLEAN]
			-- Veto pebble function.

	close_editor_perform (a_editor: like current_editor)
			-- Perform closing editor.
		local
			l_editors: like editors_internal
			l_fake_editors: like fake_editors
		do
			l_editors := editors_internal
			if l_editors.has (a_editor) then
				l_editors.prune_all (a_editor)
			else
				l_fake_editors := fake_editors
				if l_fake_editors.has (a_editor) then
					l_fake_editors.prune_all (a_editor)
				end
			end

			editor_number_factory.remove_editor_name (a_editor.docking_content.unique_title)
			a_editor.docking_content.close
			editor_closed_actions.call ([a_editor])
			a_editor.recycle
			if editors_internal.is_empty then
				last_created_editor := Void
			end
			if last_focused_editor /= Void then
				select_editor (last_focused_editor, True)
			end
		end

	validate_editor (a_editor: like current_editor)
			-- Locate `a_editor' in `editor_internal'. If not exist, start `editor_internal'.
		do
			editors_internal.start
			editors_internal.search (a_editor)
			if editors_internal.exhausted then
				editors_internal.start
			end
		end

	exist_content : SD_CONTENT
			-- A docking content that exists. Void if not.
		do
			if not editors_internal.is_empty then
				Result := current_editor.docking_content
			end
		end

	init_editor
			-- Initial an editor.
		do
			create last_created_editor.make (development_window)
			last_created_editor.set_is_main_editor (True)
			if show_formatting_marks /= last_created_editor.view_invisible_symbols then
				last_created_editor.toggle_view_invisible_symbols
			end
			last_created_editor.widget.set_minimum_size (0, 0)
			add_observers (last_created_editor)
			if veto_pebble_function_internal = Void then
				last_created_editor.drop_actions.set_veto_pebble_function (agent default_veto_func)
			end
			register_action (last_created_editor.drop_actions, agent on_drop (?, last_created_editor))
			editors_internal.extend (last_created_editor)
			if editors_internal.off then
				editors_internal.start
			end
		ensure
			last_created_editor_not_void: last_created_editor /= Void
			formatting_marks_set: show_formatting_marks = last_created_editor.view_invisible_symbols
		end

	has_editor_with_long_title (a_title: STRING_GENERAL): BOOLEAN
			-- Does `editors_internal' has a editor's content's long title is `a_title'?
		local
			l_editors: like editors_internal
		do
			from
				l_editors := editors_internal.twin
				l_editors.start
			until
				l_editors.after or Result
			loop
				if l_editors.item.docking_content.long_title.is_equal (a_title) then
					Result := True
				end
				l_editors.forth
			end
		end

	create_docking_content (a_unique_title: STRING; a_editor: like current_editor; a_content: SD_CONTENT): SD_CONTENT
			-- Create a docking content with `a_editor' in it.
			-- This content is set close to a_content if a_content is not void.
		require
			a_unique_title_not_void: a_unique_title /= Void
			a_editor_not_void: a_editor /= Void
		do
			create Result.make_with_widget_title_pixmap (a_editor.widget, Pixmaps.icon_pixmaps.general_document_icon , a_unique_title)

			register_action (Result.drop_actions, agent on_drop (?, a_editor))
			if veto_pebble_function_internal = Void then
				Result.drop_actions.set_veto_pebble_function (agent default_veto_func)
			end

			docking_manager.contents.extend (Result)
			register_action (Result.focus_in_actions, agent on_focus (a_editor))
			register_action (Result.close_request_actions, agent on_close (a_editor))
			Result.set_type ({SD_ENUMERATION}.editor)
			if a_content /= Void then
				Result.set_tab_with (a_content, development_window.preferences.editor_data.new_tab_at_left)
			else
				Result.set_default_editor_position
			end
		ensure
			create_docking_content_not_void: Result /= Void
		end

	create_docking_content_fake_one (a_unique_title: STRING): SD_CONTENT
			-- Create a fake docking content.
		require
			not_void: a_unique_title /= Void
		do
			create Result.make_with_widget_title_pixmap (create {EB_FAKE_SMART_EDITOR_CELL}, Pixmaps.icon_pixmaps.general_document_icon , a_unique_title)
			create {EB_FAKE_SMART_EDITOR} last_created_editor.make (Result)
			last_created_editor.set_docking_content (Result)

				-- We must register drop actions for fake editors, see bug#14530
				-- Note: the parameter `last_create_editor' for agent is fake editor
			register_action (Result.drop_actions, agent on_drop (?, last_created_editor))
			if veto_pebble_function_internal = Void then
				Result.drop_actions.set_veto_pebble_function (agent default_veto_func)
			end

				-- When fake editor first time showing, we change it to a real one.
			register_action (Result.focus_in_actions, agent on_fake_focus (last_created_editor))
			register_action (Result.show_actions, agent on_show (last_created_editor))
			Result.close_request_actions.extend (agent on_close (last_created_editor))

			docking_manager.contents.extend (Result)
			Result.set_type ({SD_ENUMERATION}.editor)
		end

	change_fake_to_real (a_editor, a_fake_editor: like current_editor; a_content: SD_CONTENT)
			-- Change fake editor to real editors.
		require
			not_void: a_editor /= Void
			not_void: a_content /= Void
		do
			a_content.set_user_widget (a_editor.widget)

			-- We wipe out the `drop_aciton' which registered in `create_docking_content_fake_one'
			a_content.drop_actions.wipe_out

			register_action (a_content.drop_actions, agent on_drop (?, a_editor))
			if veto_pebble_function_internal = Void then
				a_content.drop_actions.set_veto_pebble_function (agent default_veto_func)
			end

			a_content.show_actions.wipe_out

			a_content.focus_in_actions.wipe_out
			register_action (a_content.focus_in_actions, agent on_focus (a_editor))
			-- There are fake content close request actions which should be removed first.
			a_content.close_request_actions.wipe_out
			register_action (a_content.close_request_actions, agent on_close (a_editor))

			a_editor.set_docking_content (a_content)
			a_editor.set_stone (a_fake_editor.stone)

			fake_editors.start
			fake_editors.prune (a_fake_editor)
		ensure
			not_has: not fake_editors.has (a_fake_editor)
		end

	build_class_name (a_path: STRING): STRING
			-- Build the class name of the text if exists --not well solved
		local
			l_class_name:STRING
			l_list_string: LIST [STRING]
		do
			l_class_name := a_path
			l_list_string := l_class_name.split (operating_environment.directory_separator)
			l_class_name := l_list_string [l_list_string.count]
			if l_class_name.has ('.') then
				Result := l_class_name.substring (1,
														l_class_name.last_index_of ('.', l_class_name.count) - 1)
			end
			Result.to_upper
		end

	back_up_editor (a_editor: like current_editor)
			-- Back up `a_editor'.
		require
			a_editor_not_void: a_editor /= Void
		local
			retried: BOOLEAN
			tmp_name: FILE_NAME
			tmp_file: RAW_FILE
			l_encoding: ENCODING
			l_stream: STRING
			l_text: STRING_32
		do
			if not retried then
				if a_editor.changed then
					tmp_name := a_editor.file_name
					if tmp_name /= Void then
						tmp_name := tmp_name.twin
						tmp_name.add_extension ("swp")
						create tmp_file.make (tmp_name)
						if
							not tmp_file.exists and then
							tmp_file.is_creatable
						then
							tmp_file.open_append
							l_encoding := a_editor.encoding
							l_text := a_editor.wide_text
							l_stream := convert_to_stream (l_text, l_encoding)
							tmp_file.put_string (l_stream)
							tmp_file.close
						end
					end
				end
			else
				not_backuped := not_backuped + 1
			end
		rescue
			retried := True
			retry
		end

	editor_with_stone_internal (a_editors: ARRAYED_LIST [EB_SMART_EDITOR]; a_stone: STONE): EB_SMART_EDITOR
			-- Quey a editor which from `a_editors' has `a_stone'.
		require
			not_void: a_editors /= Void
		local
			l_file_stone1, l_file_stone2: FILED_STONE
		do
			from
				a_editors.start
			until
				a_editors.after or Result /= Void
			loop
				if a_editors.item.stone /= Void and then equal (a_stone, a_editors.item.stone) then
					Result := a_editors.item
				else
					l_file_stone1 ?= a_stone
					l_file_stone2 ?= a_editors.item.stone
					if
						(l_file_stone1 /= Void and l_file_stone2 /= Void) and then
						(l_file_stone1.is_valid and l_file_stone2.is_valid) and then
						equal (l_file_stone1.file_name, l_file_stone2.file_name)
					then
						Result := a_editors.item
					end
				end
				a_editors.forth
			end
		end

	synchronize_with_docking_manager
			-- Becaues sometimes the editors datas we saved will not synchronized with docking editors data,
			-- we want to make sure it's synchronized here.
		local
			l_contents: ARRAYED_LIST [SD_CONTENT]
		do
			from
				l_contents := docking_manager.contents.twin
				l_contents.start
			until
				l_contents.after
			loop
				if l_contents.item.type = {SD_ENUMERATION}.editor then
					if not l_contents.item.is_visible then
						-- This editor not exists in saved docking layout, we should remove it.
						remove_editor_of_content (l_contents.item)

						-- Remove it from docking manager too.
						l_contents.item.close
					end
				end
				l_contents.forth
			end
		end

	remove_editor_of_content (a_content: SD_CONTENT)
			-- Remove editor related with `a_content'.
		local
			l_editors: like editors
			l_editor: EB_SMART_EDITOR
			l_found: BOOLEAN
		do
			from
				l_editors := editors
				l_editors.start
			until
				l_editors.after or l_found
			loop
				if l_editors.item.docking_content = a_content then
					editors_internal.start
					editors_internal.prune (l_editors.item)
					l_found := True
				end
				l_editors.forth
			end
			if not l_found then
				from
					fake_editors.start
				until
					fake_editors.after or l_found
				loop
					if fake_editors.item.docking_content = a_content then
						l_editor := fake_editors.item
						fake_editors.start
						fake_editors.prune (l_editor)
						l_found := True
					else
						fake_editors.forth
					end
				end
			end
		end

	default_veto_func (a_stone: ANY; a_content: SD_CONTENT): BOOLEAN
			-- Default veto function
		local
			l_cluster_stone: CLUSTER_STONE
			l_filed_stone: FILED_STONE
		do
			l_filed_stone ?= a_stone
			if l_filed_stone /= Void then
				Result := True
			else
				l_cluster_stone ?= a_stone
				if l_cluster_stone /= Void then
					Result := True
				end
			end
		end

note
	copyright: "Copyright (c) 1984-2008, Eiffel Software"
	license:   "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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

end
