indexing
	description: "Eiffel Cluster Properties (for Ace file).  Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_name_user_precondition (return_value: STRING): BOOLEAN is
			-- User-defined preconditions for `set_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	cluster_path_user_precondition: BOOLEAN is
			-- User-defined preconditions for `cluster_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_cluster_path_user_precondition (path: STRING): BOOLEAN is
			-- User-defined preconditions for `set_cluster_path'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	override_user_precondition: BOOLEAN is
			-- User-defined preconditions for `override'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_override_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_override'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_library_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_library'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_is_library_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_is_library'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	all1_user_precondition: BOOLEAN is
			-- User-defined preconditions for `all1'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_all_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_all'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	use_system_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `use_system_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_use_system_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_use_system_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_require_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_require_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_require_by_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_require_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_ensure_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_ensure_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_ensure_by_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_ensure_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_check_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_check_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_check_by_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_check_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_loop_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_loop_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_loop_by_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_loop_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluate_invariant_by_default_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluate_invariant_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	set_evaluate_invariant_by_default_user_precondition (return_value: BOOLEAN): BOOLEAN is
			-- User-defined preconditions for `set_evaluate_invariant_by_default'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	excluded_user_precondition: BOOLEAN is
			-- User-defined preconditions for `excluded'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	add_exclude_user_precondition (dir_name: STRING): BOOLEAN is
			-- User-defined preconditions for `add_exclude'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	remove_exclude_user_precondition (dir_name: STRING): BOOLEAN is
			-- User-defined preconditions for `remove_exclude'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	name: STRING is
			-- Cluster name.
		require
			name_user_precondition: name_user_precondition
		deferred

		end

	set_name (return_value: STRING) is
			-- Cluster name.
			-- `return_value' [in].  
		require
			set_name_user_precondition: set_name_user_precondition (return_value)
		deferred

		end

	cluster_path: STRING is
			-- Full path to cluster.
		require
			cluster_path_user_precondition: cluster_path_user_precondition
		deferred

		end

	set_cluster_path (path: STRING) is
			-- Full path to cluster.
			-- `path' [in].  
		require
			set_cluster_path_user_precondition: set_cluster_path_user_precondition (path)
		deferred

		end

	override: BOOLEAN is
			-- Should this cluster classes take priority over other classes with same name.
		require
			override_user_precondition: override_user_precondition
		deferred

		end

	set_override (return_value: BOOLEAN) is
			-- Should this cluster classes take priority over other classes with same name.
			-- `return_value' [in].  
		require
			set_override_user_precondition: set_override_user_precondition (return_value)
		deferred

		end

	is_library: BOOLEAN is
			-- Should this cluster be treated as library?
		require
			is_library_user_precondition: is_library_user_precondition
		deferred

		end

	set_is_library (return_value: BOOLEAN) is
			-- Should this cluster be treated as library?
			-- `return_value' [in].  
		require
			set_is_library_user_precondition: set_is_library_user_precondition (return_value)
		deferred

		end

	all1: BOOLEAN is
			-- Should all subclusters be included?
		require
			all1_user_precondition: all1_user_precondition
		deferred

		end

	set_all (return_value: BOOLEAN) is
			-- Should all subclusters be included?
			-- `return_value' [in].  
		require
			set_all_user_precondition: set_all_user_precondition (return_value)
		deferred

		end

	use_system_default: BOOLEAN is
			-- Should use system default?
		require
			use_system_default_user_precondition: use_system_default_user_precondition
		deferred

		end

	set_use_system_default (return_value: BOOLEAN) is
			-- Should use system default?
			-- `return_value' [in].  
		require
			set_use_system_default_user_precondition: set_use_system_default_user_precondition (return_value)
		deferred

		end

	evaluate_require_by_default: BOOLEAN is
			-- Should preconditions be evaluated by default?
		require
			evaluate_require_by_default_user_precondition: evaluate_require_by_default_user_precondition
		deferred

		end

	set_evaluate_require_by_default (return_value: BOOLEAN) is
			-- Should preconditions be evaluated by default?
			-- `return_value' [in].  
		require
			set_evaluate_require_by_default_user_precondition: set_evaluate_require_by_default_user_precondition (return_value)
		deferred

		end

	evaluate_ensure_by_default: BOOLEAN is
			-- Should postconditions be evaluated by default?
		require
			evaluate_ensure_by_default_user_precondition: evaluate_ensure_by_default_user_precondition
		deferred

		end

	set_evaluate_ensure_by_default (return_value: BOOLEAN) is
			-- Should postconditions be evaluated by default?
			-- `return_value' [in].  
		require
			set_evaluate_ensure_by_default_user_precondition: set_evaluate_ensure_by_default_user_precondition (return_value)
		deferred

		end

	evaluate_check_by_default: BOOLEAN is
			-- Should check assertions be evaluated by default?
		require
			evaluate_check_by_default_user_precondition: evaluate_check_by_default_user_precondition
		deferred

		end

	set_evaluate_check_by_default (return_value: BOOLEAN) is
			-- Should check assertions be evaluated by default?
			-- `return_value' [in].  
		require
			set_evaluate_check_by_default_user_precondition: set_evaluate_check_by_default_user_precondition (return_value)
		deferred

		end

	evaluate_loop_by_default: BOOLEAN is
			-- Should loop assertions be evaluated by default?
		require
			evaluate_loop_by_default_user_precondition: evaluate_loop_by_default_user_precondition
		deferred

		end

	set_evaluate_loop_by_default (return_value: BOOLEAN) is
			-- Should loop assertions be evaluated by default?
			-- `return_value' [in].  
		require
			set_evaluate_loop_by_default_user_precondition: set_evaluate_loop_by_default_user_precondition (return_value)
		deferred

		end

	evaluate_invariant_by_default: BOOLEAN is
			-- Should class invariants be evaluated by default?
		require
			evaluate_invariant_by_default_user_precondition: evaluate_invariant_by_default_user_precondition
		deferred

		end

	set_evaluate_invariant_by_default (return_value: BOOLEAN) is
			-- Should class invariants be evaluated by default?
			-- `return_value' [in].  
		require
			set_evaluate_invariant_by_default_user_precondition: set_evaluate_invariant_by_default_user_precondition (return_value)
		deferred

		end

	excluded: ECOM_ARRAY [STRING] is
			-- List of excluded directories.
		require
			excluded_user_precondition: excluded_user_precondition
		deferred

		end

	add_exclude (dir_name: STRING) is
			-- Add a directory to exclude.
			-- `dir_name' [in].  
		require
			add_exclude_user_precondition: add_exclude_user_precondition (dir_name)
		deferred

		end

	remove_exclude (dir_name: STRING) is
			-- Remove a directory to exclude.
			-- `dir_name' [in].  
		require
			remove_exclude_user_precondition: remove_exclude_user_precondition (dir_name)
		deferred

		end

end -- IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

