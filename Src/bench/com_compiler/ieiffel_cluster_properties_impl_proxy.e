indexing
	description: "Implemented `IEiffelClusterProperties' Interface."
	Note: "Automatically generated by the EiffelCOM Wizard."

class
	IEIFFEL_CLUSTER_PROPERTIES_IMPL_PROXY

inherit
	IEIFFEL_CLUSTER_PROPERTIES_INTERFACE

	ECOM_QUERIABLE

creation
	make_from_other,
	make_from_pointer

feature {NONE}  -- Initialization

	make_from_pointer (cpp_obj: POINTER) is
			-- Make from pointer
		do
			initializer := ccom_create_ieiffel_cluster_properties_impl_proxy_from_pointer(cpp_obj)
			item := ccom_item (initializer)
		end

feature -- Access

	name: STRING is
			-- Cluster name.
		do
			Result := ccom_name (initializer)
		end

	cluster_path: STRING is
			-- Full path to cluster.
		do
			Result := ccom_cluster_path (initializer)
		end

	override: BOOLEAN is
			-- Should this cluster classes take priority over other classes with same name?
		do
			Result := ccom_override (initializer)
		end

	is_library: BOOLEAN is
			-- Should this cluster be treated as library?
		do
			Result := ccom_is_library (initializer)
		end

	all1: BOOLEAN is
			-- Should all subclusters be included?
		do
			Result := ccom_all1 (initializer)
		end

	use_system_default: BOOLEAN is
			-- Should use system default?
		do
			Result := ccom_use_system_default (initializer)
		end

	evaluate_require_by_default: BOOLEAN is
			-- Should preconditions be evaluated by default?
		do
			Result := ccom_evaluate_require_by_default (initializer)
		end

	evaluate_ensure_by_default: BOOLEAN is
			-- Should postconditions be evaluated by default?
		do
			Result := ccom_evaluate_ensure_by_default (initializer)
		end

	evaluate_check_by_default: BOOLEAN is
			-- Should check assertions be evaluated by default?
		do
			Result := ccom_evaluate_check_by_default (initializer)
		end

	evaluate_loop_by_default: BOOLEAN is
			-- Should loop assertions be evaluated by default?
		do
			Result := ccom_evaluate_loop_by_default (initializer)
		end

	evaluate_invariant_by_default: BOOLEAN is
			-- Should class invariants be evaluated by default?
		do
			Result := ccom_evaluate_invariant_by_default (initializer)
		end

	excluded: IENUM_CLUSTER_EXCLUDES_INTERFACE is
			-- List of excluded directories.
		do
			Result := ccom_excluded (initializer)
		end

	parent_name: STRING is
			-- Name of the parent cluster.
		do
			Result := ccom_parent_name (initializer)
		end

	has_parent: BOOLEAN is
			-- Does the current cluster have a parent cluster?
		do
			Result := ccom_has_parent (initializer)
		end

	subclusters: IENUM_CLUSTER_PROP_INTERFACE is
			-- List subclusters (list of IEiffelClusterProperties*).
		do
			Result := ccom_subclusters (initializer)
		end

	has_children: BOOLEAN is
			-- Does the current cluster have children?
		do
			Result := ccom_has_children (initializer)
		end

	cluster_id: INTEGER is
			-- Cluster identifier.
		do
			Result := ccom_cluster_id (initializer)
		end

	is_eiffel_library: BOOLEAN is
			-- Is the cluster in the Eiffel library
		do
			Result := ccom_is_eiffel_library (initializer)
		end

	expanded_cluster_path: STRING is
			-- Full path to cluster with ISE_EIFFEL env var expanded.
		do
			Result := ccom_expanded_cluster_path (initializer)
		end

	cluster_namespace: STRING is
			-- Cluster namespace.
		do
			Result := ccom_cluster_namespace (initializer)
		end

feature -- Status Report

	last_error_code: INTEGER is
			-- Last error code.
		do
			Result := ccom_last_error_code (initializer)
		end

	last_error_description: STRING is
			-- Last error description.
		do
			Result := ccom_last_error_description (initializer)
		end

	last_error_help_file: STRING is
			-- Last error help file.
		do
			Result := ccom_last_error_help_file (initializer)
		end

	last_source_of_exception: STRING is
			-- Last source of exception.
		do
			Result := ccom_last_source_of_exception (initializer)
		end

feature -- Basic Operations

	set_cluster_path (pbstr_path: STRING) is
			-- Full path to cluster.
			-- `pbstr_path' [in].  
		do
			ccom_set_cluster_path (initializer, pbstr_path)
		end

	set_override (pvb_override: BOOLEAN) is
			-- Should this cluster classes take priority over other classes with same name?
			-- `pvb_override' [in].  
		do
			ccom_set_override (initializer, pvb_override)
		end

	set_is_library (pvb_library: BOOLEAN) is
			-- Should this cluster be treated as library?
			-- `pvb_library' [in].  
		do
			ccom_set_is_library (initializer, pvb_library)
		end

	set_all (pvb_all: BOOLEAN) is
			-- Should all subclusters be included?
			-- `pvb_all' [in].  
		do
			ccom_set_all (initializer, pvb_all)
		end

	set_use_system_default (pvb_use_defaults: BOOLEAN) is
			-- Should use system default?
			-- `pvb_use_defaults' [in].  
		do
			ccom_set_use_system_default (initializer, pvb_use_defaults)
		end

	set_assertions (vb_check: BOOLEAN; vb_require: BOOLEAN; vb_ensure: BOOLEAN; vb_loop: BOOLEAN; vb_invariant: BOOLEAN) is
			-- Set assertions for cluster.
			-- `vb_check' [in].  
			-- `vb_require' [in].  
			-- `vb_ensure' [in].  
			-- `vb_loop' [in].  
			-- `vb_invariant' [in].  
		do
			ccom_set_assertions (initializer, vb_check, vb_require, vb_ensure, vb_loop, vb_invariant)
		end

	add_exclude (bstr_name: STRING) is
			-- Add a item to exclude.
			-- `bstr_name' [in].  
		do
			ccom_add_exclude (initializer, bstr_name)
		end

	remove_exclude (bstr_name: STRING) is
			-- Remove a item from being excluded.
			-- `bstr_name' [in].  
		do
			ccom_remove_exclude (initializer, bstr_name)
		end

	set_cluster_namespace (pbstr_namespace: STRING) is
			-- Cluster namespace.
			-- `pbstr_namespace' [in].  
		do
			ccom_set_cluster_namespace (initializer, pbstr_namespace)
		end

feature {NONE}  -- Implementation

	delete_wrapper is
			-- Delete wrapper
		do
			ccom_delete_ieiffel_cluster_properties_impl_proxy(initializer)
		end

feature {NONE}  -- Externals

	ccom_name (cpp_obj: POINTER): STRING is
			-- Cluster name.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_cluster_path (cpp_obj: POINTER): STRING is
			-- Full path to cluster.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_cluster_path (cpp_obj: POINTER; pbstr_path: STRING) is
			-- Full path to cluster.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_override (cpp_obj: POINTER): BOOLEAN is
			-- Should this cluster classes take priority over other classes with same name?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_override (cpp_obj: POINTER; pvb_override: BOOLEAN) is
			-- Should this cluster classes take priority over other classes with same name?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_is_library (cpp_obj: POINTER): BOOLEAN is
			-- Should this cluster be treated as library?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_is_library (cpp_obj: POINTER; pvb_library: BOOLEAN) is
			-- Should this cluster be treated as library?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_all1 (cpp_obj: POINTER): BOOLEAN is
			-- Should all subclusters be included?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_all (cpp_obj: POINTER; pvb_all: BOOLEAN) is
			-- Should all subclusters be included?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_use_system_default (cpp_obj: POINTER): BOOLEAN is
			-- Should use system default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_use_system_default (cpp_obj: POINTER; pvb_use_defaults: BOOLEAN) is
			-- Should use system default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_BOOLEAN)"
		end

	ccom_evaluate_require_by_default (cpp_obj: POINTER): BOOLEAN is
			-- Should preconditions be evaluated by default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_evaluate_ensure_by_default (cpp_obj: POINTER): BOOLEAN is
			-- Should postconditions be evaluated by default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_evaluate_check_by_default (cpp_obj: POINTER): BOOLEAN is
			-- Should check assertions be evaluated by default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_evaluate_loop_by_default (cpp_obj: POINTER): BOOLEAN is
			-- Should loop assertions be evaluated by default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_evaluate_invariant_by_default (cpp_obj: POINTER): BOOLEAN is
			-- Should class invariants be evaluated by default?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_set_assertions (cpp_obj: POINTER; vb_check: BOOLEAN; vb_require: BOOLEAN; vb_ensure: BOOLEAN; vb_loop: BOOLEAN; vb_invariant: BOOLEAN) is
			-- Set assertions for cluster.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_BOOLEAN,EIF_BOOLEAN,EIF_BOOLEAN,EIF_BOOLEAN,EIF_BOOLEAN)"
		end

	ccom_excluded (cpp_obj: POINTER): IENUM_CLUSTER_EXCLUDES_INTERFACE is
			-- List of excluded directories.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_add_exclude (cpp_obj: POINTER; bstr_name: STRING) is
			-- Add a item to exclude.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_remove_exclude (cpp_obj: POINTER; bstr_name: STRING) is
			-- Remove a item from being excluded.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_parent_name (cpp_obj: POINTER): STRING is
			-- Name of the parent cluster.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_has_parent (cpp_obj: POINTER): BOOLEAN is
			-- Does the current cluster have a parent cluster?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_subclusters (cpp_obj: POINTER): IENUM_CLUSTER_PROP_INTERFACE is
			-- List subclusters (list of IEiffelClusterProperties*).
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_has_children (cpp_obj: POINTER): BOOLEAN is
			-- Does the current cluster have children?
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_cluster_id (cpp_obj: POINTER): INTEGER is
			-- Cluster identifier.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_INTEGER"
		end

	ccom_is_eiffel_library (cpp_obj: POINTER): BOOLEAN is
			-- Is the cluster in the Eiffel library
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_BOOLEAN"
		end

	ccom_expanded_cluster_path (cpp_obj: POINTER): STRING is
			-- Full path to cluster with ISE_EIFFEL env var expanded.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_cluster_namespace (cpp_obj: POINTER): STRING is
			-- Cluster namespace.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](): EIF_REFERENCE"
		end

	ccom_set_cluster_namespace (cpp_obj: POINTER; pbstr_namespace: STRING) is
			-- Cluster namespace.
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](EIF_OBJECT)"
		end

	ccom_delete_ieiffel_cluster_properties_impl_proxy (a_pointer: POINTER) is
			-- Release resource
		external
			"C++ [delete ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]()"
		end

	ccom_create_ieiffel_cluster_properties_impl_proxy_from_pointer (a_pointer: POINTER): POINTER is
			-- Create from pointer
		external
			"C++ [new ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"](IUnknown *)"
		end

	ccom_item (cpp_obj: POINTER): POINTER is
			-- Item
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]():EIF_POINTER"
		end

	ccom_last_error_code (cpp_obj: POINTER): INTEGER is
			-- Last error code
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]():EIF_INTEGER"
		end

	ccom_last_error_description (cpp_obj: POINTER): STRING is
			-- Last error description
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_error_help_file (cpp_obj: POINTER): STRING is
			-- Last error help file
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

	ccom_last_source_of_exception (cpp_obj: POINTER): STRING is
			-- Last source of exception
		external
			"C++ [ecom_EiffelComCompiler::IEiffelClusterProperties_impl_proxy %"ecom_EiffelComCompiler_IEiffelClusterProperties_impl_proxy_s.h%"]():EIF_REFERENCE"
		end

end -- IEIFFEL_CLUSTER_PROPERTIES_IMPL_PROXY

