indexing
	description: "Eiffel Feature Descriptor. Eiffel language compiler library. Help file: "
	Note: "Automatically generated by the EiffelCOM Wizard."

deferred class
	IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE

inherit
	ECOM_INTERFACE

feature -- Status Report

	name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	external_name_user_precondition: BOOLEAN is
			-- User-defined preconditions for `external_name'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	written_class_user_precondition: BOOLEAN is
			-- User-defined preconditions for `written_class'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	evaluated_class_user_precondition: BOOLEAN is
			-- User-defined preconditions for `evaluated_class'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	signature_user_precondition: BOOLEAN is
			-- User-defined preconditions for `signature'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	description_user_precondition: BOOLEAN is
			-- User-defined preconditions for `description'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	parameters_user_precondition: BOOLEAN is
			-- User-defined preconditions for `parameters'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	return_type_user_precondition: BOOLEAN is
			-- User-defined preconditions for `return_type'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	feature_location_user_precondition (pbstr_path: CELL [STRING]; pul_line: INTEGER_REF): BOOLEAN is
			-- User-defined preconditions for `feature_location'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	all_callers_user_precondition: BOOLEAN is
			-- User-defined preconditions for `all_callers'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	all_callers_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `all_callers_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	local_callers_user_precondition: BOOLEAN is
			-- User-defined preconditions for `local_callers'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	local_callers_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `local_callers_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendant_callers_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendant_callers'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendant_callers_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendant_callers_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	implementers_user_precondition: BOOLEAN is
			-- User-defined preconditions for `implementers'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	implementers_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `implementers_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	ancestor_versions_user_precondition: BOOLEAN is
			-- User-defined preconditions for `ancestor_versions'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	ancestor_versions_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `ancestor_versions_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendant_versions_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendant_versions'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	descendant_versions_count_user_precondition: BOOLEAN is
			-- User-defined preconditions for `descendant_versions_count'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	exported_to_all_user_precondition: BOOLEAN is
			-- User-defined preconditions for `exported_to_all'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_once_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_once'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_external_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_external'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_deferred_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_deferred'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_constant_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_constant'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_frozen_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_frozen'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_infix_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_infix'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_prefix_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_prefix'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_attribute_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_attribute'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_procedure_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_procedure'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_function_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_function'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_unique_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_unique'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	is_obsolete_user_precondition: BOOLEAN is
			-- User-defined preconditions for `is_obsolete'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_precondition_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_precondition'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

	has_postcondition_user_precondition: BOOLEAN is
			-- User-defined preconditions for `has_postcondition'.
			-- Redefine in descendants if needed.
		do
			Result := True
		end

feature -- Basic Operations

	name: STRING is
			-- Feature name.
		require
			name_user_precondition: name_user_precondition
		deferred

		end

	external_name: STRING is
			-- Feature external name.
		require
			external_name_user_precondition: external_name_user_precondition
		deferred

		end

	written_class: STRING is
			-- Name of class where feature is written in.
		require
			written_class_user_precondition: written_class_user_precondition
		deferred

		end

	evaluated_class: STRING is
			-- Name of class where feature was evaluated in.
		require
			evaluated_class_user_precondition: evaluated_class_user_precondition
		deferred

		end

	signature: STRING is
			-- Feature signature.
		require
			signature_user_precondition: signature_user_precondition
		deferred

		end

	description: STRING is
			-- Feature description.
		require
			description_user_precondition: description_user_precondition
		deferred

		end

	parameters: IENUM_PARAMETER_INTERFACE is
			-- Feature parameters.
		require
			parameters_user_precondition: parameters_user_precondition
		deferred

		end

	return_type: STRING is
			-- Feature return type.
		require
			return_type_user_precondition: return_type_user_precondition
		deferred

		end

	feature_location (pbstr_path: CELL [STRING]; pul_line: INTEGER_REF) is
			-- Feature location, full path to file and line number
			-- `pbstr_path' [out].  
			-- `pul_line' [out].  
		require
			non_void_pbstr_path: pbstr_path /= Void
			non_void_pul_line: pul_line /= Void
			feature_location_user_precondition: feature_location_user_precondition (pbstr_path, pul_line)
		deferred

		ensure
			valid_pbstr_path: pbstr_path.item /= Void
		end

	all_callers: IENUM_FEATURE_INTERFACE is
			-- List of all feature callers, including callers of ancestor and descendant versions.
		require
			all_callers_user_precondition: all_callers_user_precondition
		deferred

		end

	all_callers_count: INTEGER is
			-- Number of all callers.
		require
			all_callers_count_user_precondition: all_callers_count_user_precondition
		deferred

		end

	local_callers: IENUM_FEATURE_INTERFACE is
			-- List of feature callers.
		require
			local_callers_user_precondition: local_callers_user_precondition
		deferred

		end

	local_callers_count: INTEGER is
			-- Number of local callers.
		require
			local_callers_count_user_precondition: local_callers_count_user_precondition
		deferred

		end

	descendant_callers: IENUM_FEATURE_INTERFACE is
			-- List of feature callers, including callers of descendant versions.
		require
			descendant_callers_user_precondition: descendant_callers_user_precondition
		deferred

		end

	descendant_callers_count: INTEGER is
			-- Number of descendant callers.
		require
			descendant_callers_count_user_precondition: descendant_callers_count_user_precondition
		deferred

		end

	implementers: IENUM_FEATURE_INTERFACE is
			-- List of implementers.
		require
			implementers_user_precondition: implementers_user_precondition
		deferred

		end

	implementers_count: INTEGER is
			-- Number of feature implementers.
		require
			implementers_count_user_precondition: implementers_count_user_precondition
		deferred

		end

	ancestor_versions: IENUM_FEATURE_INTERFACE is
			-- List of ancestor versions.
		require
			ancestor_versions_user_precondition: ancestor_versions_user_precondition
		deferred

		end

	ancestor_versions_count: INTEGER is
			-- Number of ancestor versions.
		require
			ancestor_versions_count_user_precondition: ancestor_versions_count_user_precondition
		deferred

		end

	descendant_versions: IENUM_FEATURE_INTERFACE is
			-- List of descendant versions.
		require
			descendant_versions_user_precondition: descendant_versions_user_precondition
		deferred

		end

	descendant_versions_count: INTEGER is
			-- Number of descendant versions.
		require
			descendant_versions_count_user_precondition: descendant_versions_count_user_precondition
		deferred

		end

	exported_to_all: BOOLEAN is
			-- Is feature exported to all classes?
		require
			exported_to_all_user_precondition: exported_to_all_user_precondition
		deferred

		end

	is_once: BOOLEAN is
			-- Is once feature?
		require
			is_once_user_precondition: is_once_user_precondition
		deferred

		end

	is_external: BOOLEAN is
			-- Is external feature?
		require
			is_external_user_precondition: is_external_user_precondition
		deferred

		end

	is_deferred: BOOLEAN is
			-- Is deferred feature?
		require
			is_deferred_user_precondition: is_deferred_user_precondition
		deferred

		end

	is_constant: BOOLEAN is
			-- Is constant?
		require
			is_constant_user_precondition: is_constant_user_precondition
		deferred

		end

	is_frozen: BOOLEAN is
			-- is frozen feature?
		require
			is_frozen_user_precondition: is_frozen_user_precondition
		deferred

		end

	is_infix: BOOLEAN is
			-- Is infix?
		require
			is_infix_user_precondition: is_infix_user_precondition
		deferred

		end

	is_prefix: BOOLEAN is
			-- Is prefix?
		require
			is_prefix_user_precondition: is_prefix_user_precondition
		deferred

		end

	is_attribute: BOOLEAN is
			-- Is attribute?
		require
			is_attribute_user_precondition: is_attribute_user_precondition
		deferred

		end

	is_procedure: BOOLEAN is
			-- Is procedure?
		require
			is_procedure_user_precondition: is_procedure_user_precondition
		deferred

		end

	is_function: BOOLEAN is
			-- Is function?
		require
			is_function_user_precondition: is_function_user_precondition
		deferred

		end

	is_unique: BOOLEAN is
			-- Is unique?
		require
			is_unique_user_precondition: is_unique_user_precondition
		deferred

		end

	is_obsolete: BOOLEAN is
			-- Is obsolete feature?
		require
			is_obsolete_user_precondition: is_obsolete_user_precondition
		deferred

		end

	has_precondition: BOOLEAN is
			-- Does feature have precondition?
		require
			has_precondition_user_precondition: has_precondition_user_precondition
		deferred

		end

	has_postcondition: BOOLEAN is
			-- Does feature have postcondition?
		require
			has_postcondition_user_precondition: has_postcondition_user_precondition
		deferred

		end

end -- IEIFFEL_FEATURE_DESCRIPTOR_INTERFACE

