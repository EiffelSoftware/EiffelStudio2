indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AST_FEATURE_REPLICATION_GENERATOR

inherit
	AST_ITERATOR
		redefine
			process_access_id_as,
			process_access_assert_as,
			process_require_as,
			process_require_else_as,
			process_ensure_as,
			process_ensure_then_as
		end

	SHARED_SERVER

	SHARED_INHERITED
		undefine
			copy, is_equal
		end

	COMPILER_EXPORTER

feature -- Processing

	process_replicated_feature (a_feature: FEATURE_I; a_parent_c: PARENT_C; a_selected: BOOLEAN; a_current_class: CLASS_C; old_t, new_t: FEATURE_TABLE)
			-- Perform processing on replicated feature `a_feature'.
			-- `a_parent_c' may be Void if a replicated feature is redefined.
		require
			a_feature_valid: a_feature /= Void
			a_feature_replicated: a_feature.is_replicated
			a_current_class_not_void: a_current_class /= Void
			a_feature_replicated_in_current_class: not system.has_old_feature_replication implies a_feature.access_in = a_current_class.class_id
		local
			l_feature_as: FEATURE_AS
			l_old_feature: FEATURE_I
			l_body_index: INTEGER
			l_body: FEATURE_AS
			l_feature_name_id: INTEGER
			l_compute_new_body_index: BOOLEAN
			l_old_feature_equivalent: BOOLEAN
		do
				-- Reset state flags
			needs_explicit_replication := False

			feature_i := a_feature
			parent_c := a_parent_c
				-- `parent_c' may be Void if `a_feature' is the result of a redefinition or undefinition.
				-- If this is the case then we don't need to perform any processing as the AST is already at the level of access_in.
				-- This means that the byte nodes get generated
			if a_parent_c /= Void then
					-- We need to perform a deep twin of the feature a.s.
					-- so that there is no aliasing between AST nodes.
				l_feature_as := body_server.item (a_feature.body_index).deep_twin

					-- Process replicated AST body content to account for renames within the same inheritance branch.
					-- We can also check to see if explicit replication needs to be performed.
				safe_process (l_feature_as.body.content)

				if not (a_feature.is_once and then a_selected) then
						-- We do not want to regenerate a new body index for 'once' routines.
						-- unless there is explicit replication.
						-- Reuse previous feature information if available.
					l_feature_name_id := a_feature.feature_name_id
					if old_t /= Void then
						l_old_feature := old_t.item_id (l_feature_name_id)
					end

					if l_old_feature /= Void and then l_old_feature.is_replicated_directly then
							-- Reuse the previous id.
						l_body_index := l_old_feature.body_index
							-- Set ID of feature AS to be that of the previous feature.
						l_body := l_old_feature.body


						if l_body = Void then
							l_compute_new_body_index := True
						else
								-- Reuse old feature ID.
							l_feature_as.set_id (l_old_feature.id)

							l_old_feature_equivalent := l_body.is_equivalent (l_feature_as)
								-- If True then nothing has changed from the previous compilation
								-- so we can reuse old routine.
						end
					else
						l_compute_new_body_index := True
					end

					if not l_old_feature_equivalent then
						if l_compute_new_body_index then
								-- Create a new id for the feature body and index
							l_body_index := System.body_index_counter.next_id
							l_feature_as.set_id (System.feature_as_counter.next_id)
						end
							-- Mark feature as changed so that it gets melted.
						inherit_table.changed_features.extend (l_feature_name_id)
					else
							-- Reuse replicated feature body.
						l_feature_as := l_body
					end

						-- Make sure that replicated features always gets stored to disk even if no change has been made.
					tmp_ast_server.body_force (l_feature_as, l_body_index)
					tmp_ast_server.reactivate (l_body_index)

					a_feature.set_body_index (l_body_index)

						-- We need to add the replicated feature as to the class as
						-- so that it may be stored to disk for incrementality
						--| FIXME IEK We need a better mechanism for doing this.
					a_current_class.ast.replicated_features.extend (l_feature_as)
					a_current_class.replicated_features_list.extend (a_feature.rout_id_set.first)

						-- Set replicated AST flag so that we know a new body and index has been created.
					a_feature.set_has_replicated_ast (True)

						-- Copy the routine id to avoid aliasing from other descendents of inherited routine.
					a_feature.set_rout_id_set (a_feature.rout_id_set.twin)
				end
					-- Set direct replication flag so that it is easy to determine
					-- whether the feature has been replicated in the current class
					-- Currently once a feature is marked as replicated (by its type) it
					-- is not unreplicated if then inherited by a descendent so we need
					-- a flag to distinguish the two types of replicated features.
				a_feature.set_is_replicated_directly (True)
			else
					-- This routine is either joined or redefined in `a_current_class', if redefined
					-- in current class then we need to set it as directly replicated so that
					-- VMCS errors are correctly detected.
				a_feature.set_is_replicated_directly (a_current_class.class_id = a_feature.written_in)
			end
		end

feature -- Access

	feature_i: FEATURE_I
		-- Feature that is currently being processed

	parent_c: PARENT_C
		-- Parent class used for detecting AST manipulation

feature {NONE} -- Implementation

	process_renaming (a_access_inv_as: ACCESS_INV_AS) is
			-- Process renaming for unqualified call.
		require
			access_inv_as_not_void: a_access_inv_as /= Void
		local
			l_renaming: RENAMING
			l_feature_name: ID_AS
		do
			l_feature_name := a_access_inv_as.feature_name
			if
				parent_c /= Void and then
				not a_access_inv_as.is_argument and then
				not a_access_inv_as.is_local and then
				not a_access_inv_as.is_qualified and then
				not a_access_inv_as.is_object_test_local and then
				not a_access_inv_as.is_tuple_access
			then
				if parent_c.is_renaming (l_feature_name.name_id) then
						-- The unqualified routine call to `l_feature_name' is being renamed in the branch so
						-- therefore we need to perform the textual update.
					l_renaming := parent_c.renaming.item (l_feature_name.name_id)
					a_access_inv_as.set_class_id (System.current_class.class_id)
					a_access_inv_as.wipe_out
					debug ("Feature Replication")
						print ("{" + System.current_class.name + "}." + feature_i.feature_name + " is calling " + l_feature_name.name + " when it should be calling " + System.names.item (l_renaming.feature_name_id) + "%N")
					end
					l_feature_name.set_name (l_renaming.names_heap.item (l_renaming.feature_name_id))

					needs_explicit_replication := needs_explicit_replication or else parent_c.is_redefining (l_feature_name.name_id)
				end
			end
		end


	process_access_id_as (l_as: ACCESS_ID_AS) is
			-- <Precursor>
		do
			process_renaming (l_as)
			Precursor (l_as)
		end

	process_access_assert_as (l_as: ACCESS_ASSERT_AS) is
			-- <Precursor>
		do
			process_renaming (l_as)
			Precursor (l_as)
		end

	process_require_as (l_as: REQUIRE_AS)
			-- <Precursor>
		do
			Precursor (l_as)
			safe_process (l_as.full_assertion_list)
		end

	process_require_else_as (l_as: REQUIRE_ELSE_AS)
			-- <Precursor>
		do
			Precursor (l_as)
			safe_process (l_as.full_assertion_list)
		end

	process_ensure_as (l_as: ENSURE_AS)
			-- <Precursor>
		do
			Precursor (l_as)
			safe_process (l_as.full_assertion_list)
		end

	process_ensure_then_as (l_as: ENSURE_THEN_AS)
			-- <Precursor>
		do
			Precursor (l_as)
			safe_process (l_as.full_assertion_list)
		end

	needs_explicit_replication: BOOLEAN
		-- Flags whether a routine needs to be explicitly replicated
		-- ie: An unqualified call to a renamed feature that has also been redefined in the branch.
		-- Used for detemining whether a once function needs a new body index.

end
