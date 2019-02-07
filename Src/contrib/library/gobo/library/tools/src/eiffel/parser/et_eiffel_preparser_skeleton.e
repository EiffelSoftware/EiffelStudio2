note

	description:

		"Eiffel preparser skeletons"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2017, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_EIFFEL_PREPARSER_SKELETON

inherit

	ET_EIFFEL_SCANNER_SKELETON
		rename
			make as make_eiffel_scanner
		redefine
			reset
		end

	ET_AST_NULL_PROCESSOR
		rename
			make as make_ast_processor,
			process_identifier as process_ast_identifier,
			process_c1_character_constant as process_ast_c1_character_constant,
			process_c2_character_constant as process_ast_c2_character_constant,
			process_regular_manifest_string as process_ast_regular_manifest_string
		redefine
			process_cluster
		end

feature {NONE} -- Initialization

	make (a_system_processor: like system_processor)
			-- Create a new Eiffel preparser.
		require
			a_system_processor_not_void: a_system_processor /= Void
		do
			create eiffel_buffer.make_with_size (std.input, Initial_eiffel_buffer_size)
			make_eiffel_scanner ("unknown file", a_system_processor)
		ensure
			system_processor_set: system_processor = a_system_processor
		end

feature -- Initialization

	reset
			-- Reset parser before parsing next input.
		do
			precursor
			eiffel_buffer.set_end_of_file
			class_keyword_found := False
			last_classname := Void
		end

feature -- Status report

	class_keyword_found: BOOLEAN
			-- Has a 'class' keyword been found?

feature -- Access

	last_classname: detachable ET_CLASS_NAME
			-- Last classname found

feature -- Parsing

	process_cluster (a_cluster: ET_CLUSTER)
			-- Traverse `a_cluster' (recursively) and build a mapping
			-- between class names and filenames. Classes are added to
			-- `universe.classes', but are not parsed.
			--
			-- The queries `current_system.preparse_*_mode' govern the way
			-- preparsing works. Read the header comments of these features
			-- for more details.
		do
			preparse_cluster (a_cluster)
		end

	preparse_file (a_filename: STRING; a_cluster: ET_CLUSTER)
			-- Analyze the file `a_filename' in `a_cluster' to determine the
			-- class(es) that it contains. When in shallow mode, it is assumed
			-- to contain excactly one class whose name is 'CLASSNAME' if the
			-- filename is of the form 'classname.e'. In single mode the file
			-- is expected to contain exactly one class, whose name does not
			-- necessarily match the filename. In multiple mode the file may
			-- contain several classes.
			--
			-- The queries `current_system.preparse_*_mode' govern the way
			-- preparsing works. Read the header comments of these features
			-- for more details.
		require
			a_filename_not_void: a_filename /= Void
			a_filename_not_empty: not a_filename.is_empty
			a_cluster_not_void: a_cluster /= Void
		local
			l_file: KL_TEXT_INPUT_FILE
			l_time_stamp: INTEGER
			l_basename: STRING
			l_class_name: ET_IDENTIFIER
			l_class: ET_MASTER_CLASS
			old_group: ET_PRIMARY_GROUP
		do
			old_group := group
			group := a_cluster
			if system_processor.preparse_shallow_mode then
					-- With the "shallow" algorithm the time-stamp is only set when
					-- parsing the class.
				l_time_stamp := tokens.unknown_class.time_stamp
				l_basename := file_system.basename (a_filename)
				create l_class_name.make (l_basename.substring (1, l_basename.count - 2))
				l_class := current_universe.master_class (l_class_name)
				preparse_class (l_class, a_filename, l_time_stamp)
			else
				l_file := tmp_file
				l_file.reset (a_filename)
					-- Get time-stamp of the file.
				l_time_stamp := l_file.time_stamp
					-- Scan Eiffel file `l_file' to find the name of the class it
					-- contains. The file is supposed to contain exactly one class
					-- unless `current_system.preparse_multiple_mode' is set.
				l_file.open_read
				if l_file.is_open_read then
					filename := a_filename
					input_buffer := eiffel_buffer
					eiffel_buffer.set_file (l_file)
					yy_load_input_buffer
					read_token
					if attached last_classname as l_last_classname then
						l_class := current_universe.master_class (l_last_classname)
						preparse_class (l_class, a_filename, l_time_stamp)
						if system_processor.preparse_multiple_mode then
							from
								class_keyword_found := False
								last_classname := Void
								read_token
							until
								not attached last_classname as l_last_other_classname
							loop
								l_class := current_universe.master_class (l_last_other_classname)
								preparse_class (l_class, a_filename, l_time_stamp)
								class_keyword_found := False
								last_classname := Void
								read_token
							end
						end
					else
							-- No class name found.
						error_handler.report_syntax_error (filename, current_position)
					end
					reset
					l_file.close
				else
					error_handler.report_gcaab_error (a_cluster, a_filename)
				end
			end
			group := old_group
		end

feature {NONE} -- Parsing

	preparse_cluster (a_cluster: ET_CLUSTER)
			-- Traverse `a_cluster' (recursively) and build a mapping
			-- between class names and filenames. Classes are added to
			-- `current_universe.classes', but are not parsed.
			--
			-- The queries `current_system.preparse_*_mode' govern the way
			-- preparsing works. Read the header comments of these features
			-- for more details.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_filename: STRING
			l_dir_name: STRING
			l_dir: KL_DIRECTORY
			l_entry: STRING
			l_class: detachable ET_CLASS
			l_classes: detachable DS_ARRAYED_LIST [ET_CLASS]
			l_cell: detachable DS_CELL [detachable ET_CLASS]
			l_class_name: ET_IDENTIFIER
			l_already_preparsed: BOOLEAN
			i, nb: INTEGER
			old_group: ET_PRIMARY_GROUP
		do
			old_group := group
			group := a_cluster
			l_already_preparsed := a_cluster.is_preparsed
			a_cluster.set_preparsed (True)
			if not a_cluster.is_abstract and then (not l_already_preparsed or else ((system_processor.preparse_readonly_mode or else not a_cluster.is_read_only) and then (system_processor.preparse_override_mode implies a_cluster.is_override))) then
				error_handler.report_preparsing_status (a_cluster)
				l_dir_name := Execution_environment.interpreted_string (a_cluster.full_pathname)
				l_dir_name := file_system.canonical_pathname (l_dir_name)
				l_dir := tmp_directory
				l_dir.reset (l_dir_name)
				l_dir.open_read
				if l_dir.is_open_read then
					from l_dir.read_entry until l_dir.end_of_input loop
						l_entry := l_dir.last_entry
						if a_cluster.is_valid_eiffel_filename (l_entry) then
							l_filename := file_system.pathname (l_dir_name, l_entry)
							l_class := Void
							if l_already_preparsed then
									-- This cluster has already been traversed. Therefore
									-- we are only interested in new or modified classes.
								if l_cell = Void then
									create l_cell.make (Void)
								else
									l_cell.put (Void)
								end
								create l_class_name.make (l_entry.substring (1, l_entry.count - 2))
								current_universe.master_class (l_class_name).local_classes_do_if (agent l_cell.put ({ET_CLASS}?), agent {ET_CLASS}.is_in_group (a_cluster))
								if attached l_cell.item as l_local_class and then attached l_local_class.filename as l_local_class_filename and then file_system.same_pathnames (l_local_class_filename, l_filename) then
									l_class := l_local_class
								else
									if l_classes = Void then
										l_classes := current_universe.classes_in_group (a_cluster)
									end
									l_class := Void
									nb := l_classes.count
									from i := 1 until i > nb loop
										l_class := l_classes.item (i)
										if attached l_class.filename as l_class_filename and then file_system.same_pathnames (l_class_filename, l_filename) then
											i := nb + 1
										else
											l_class := Void
											i := i + 1
										end
									end
								end
							end
							if l_class = Void then
									-- This file is either new or has been marked as modified.
									-- We need to analyze it again.
								preparse_file (l_filename, a_cluster)
							end
						elseif a_cluster.is_recursive and then a_cluster.is_valid_directory_name (l_entry) then
							if file_system.directory_exists (file_system.pathname (l_dir_name, l_entry)) then
								a_cluster.add_recursive_cluster (l_entry)
							end
						end
						l_dir.read_entry
					end
					l_dir.close
				else
					error_handler.report_gcaaa_error (a_cluster, l_dir_name)
				end
			end
			build_provider_constraint (a_cluster)
			build_dependant_constraint (a_cluster)
			if attached a_cluster.subclusters as l_subclusters then
				preparse_clusters (l_subclusters)
			end
			group := old_group
		end

	preparse_class (a_class: ET_MASTER_CLASS; a_filename: STRING; a_time_stamp: INTEGER)
			-- The file `a_filename' with time-stamp `a_time_stamp' is assumed
			-- to contain a class with the same name as `a_class' in `current_universe'.
			-- Check to see whether this class already existed, and if so whether
			-- overriding rules apply or whether we have a name clash.
			--
			-- The queries `current_system.preparse_*_mode' govern the way
			-- preparsing works. Read the header comments of these features
			-- for more details.
		require
			a_class_not_void: a_class /= Void
			a_filename_not_void: a_filename /= Void
			a_filename_not_empty: not a_filename.is_empty
		local
			l_new_class: ET_CLASS
		do
			create l_new_class.make (a_class.name)
			current_system.register_class (l_new_class)
			l_new_class.set_filename (a_filename)
			l_new_class.set_time_stamp (a_time_stamp)
			l_new_class.set_group (group)
			a_class.add_last_local_class (l_new_class)
		end

	preparse_clusters (a_clusters: ET_CLUSTERS)
			-- Traverse `a_clusters' (recursively) and build a mapping
			-- between class names and filenames in each cluster. Classes
			-- are added to `current_universe.classes', but are not parsed.
			--
			-- The queries `current_system.preparse_*_mode' govern the way
			-- preparsing works. Read the header comments of these features
			-- for more details.
		require
			a_clusters_not_void: a_clusters /= Void
		local
			l_clusters: DS_ARRAYED_LIST [ET_CLUSTER]
			l_cluster: ET_CLUSTER
			i, nb: INTEGER
			l_readonly_mode: BOOLEAN
			l_override_mode: BOOLEAN
			l_dir_name: STRING
		do
			l_readonly_mode := system_processor.preparse_readonly_mode
			l_override_mode := system_processor.preparse_override_mode
			l_clusters := a_clusters.clusters
			nb := l_clusters.count
			from i := 1 until i > nb loop
				l_cluster := l_clusters.item (i)
				if l_cluster.is_preparsed and then l_cluster.is_implicit and then (l_readonly_mode or else not l_cluster.is_read_only) and then (l_override_mode implies l_cluster.is_override) then
					l_dir_name := Execution_environment.interpreted_string (l_cluster.full_pathname)
					if not file_system.directory_exists (l_dir_name) then
						l_clusters.remove (i)
						nb := nb - 1
					else
						preparse_cluster (l_cluster)
						i := i + 1
					end
				else
					preparse_cluster (l_cluster)
					i := i + 1
				end
			end
		end

feature -- Error handling

	report_error (a_message: STRING)
			-- Print error message.
		do
			error_handler.report_syntax_error (filename, current_position)
		end

feature {NONE} -- Input buffer

	eiffel_buffer: YY_FILE_BUFFER
			-- Eiffel file input buffer

feature {NONE} -- Constants

	Initial_eiffel_buffer_size: INTEGER = 500
			-- Initial size for `eiffel_buffer';
			-- No need to have a very large buffer, we just scan the
			-- beginning of the class to determine its name

feature {NONE} -- Implementation

	tmp_directory: KL_DIRECTORY
			-- Temporary directory object
		do
			Result := shared_directory
			if not Result.is_closed then
				create Result.make (dummy_name)
			end
		ensure
			directory_not_void: Result /= Void
			directory_closed: Result.is_closed
		end

	shared_directory: KL_DIRECTORY
			-- Shared directory object
		once
			create Result.make (dummy_name)
		ensure
			directory_not_void: Result /= Void
		end

invariant

	eiffel_buffer_not_void: eiffel_buffer /= Void

end
