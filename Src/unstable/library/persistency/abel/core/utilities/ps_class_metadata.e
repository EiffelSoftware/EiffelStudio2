note
	description: "[
		This class collects all relevant information about inheritance structure and fields in a single class.
		It only collects information that is independent of the actual generic parameters, if any.
		
		Note that for ease of implementation `Current' is attached to an actual PS_TYPE_METADATA and takes most information from there.
	]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_CLASS_METADATA

inherit

	ANY
		redefine
			is_equal
		end

--	REFACTORING_HELPER
--		undefine
--			is_equal
--		end

create
	make

feature -- Access

	name: IMMUTABLE_STRING_8
			--The class name of the Eiffel class.

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result:= name.is_equal (other.name)
		end

--	is_basic_type: BOOLEAN
--			-- Is `Current' of an ABEL basic type (STRING or expanded types)?
--		do
--			Result := internal_type.is_basic_type
--		end

--	is_generic: BOOLEAN
--			-- Does `Current' have generic parameters?
--		do
--			Result := internal_type.is_generic_derivation
--		end

--	generic_parameter_count: INTEGER
--			-- The number of generic parameters of `Current'.
--		do
--			Result := internal_type.generic_parameter_count
--		ensure
--			non_negative: Result >= 0
--			positive_if_generic: is_generic implies Result > 0
--		end

--	has_attribute (attribute_name: STRING): BOOLEAN
--			-- Does `Current' have an attribute with name `name'?
--		do
--			Result := internal_type.has_attribute (attribute_name)
--		end

--feature -- Attributes

--	attribute_count: INTEGER
--			-- The number of attributes in `Current'.
--		do
--			Result := internal_type.attribute_count
--		end

--	attributes: LIST [STRING]
--			-- List of name of the attributes.
--		do
--			Result := internal_type.attributes
--		end

--	field_index (attribute_name: STRING): INTEGER
--			-- The field index of `attribute_name', to be used for INTERNAL.
--		require
--			attribute_present: has_attribute (attribute_name)
--		do
--			Result := internal_type.field_index (attribute_name)
--		ensure
--			within_bounds: 0 < Result and Result <= attribute_count
--		end

--feature -- Type generation

--	direct_type: PS_TYPE_METADATA
--			-- The dynamic type that is generated by `Current'.
--		require
--			not_generic: not is_generic
--		do
--			Result := manager.create_metadata_from_type (reflection.type_of_type (reflection.dynamic_type_from_string (name)))
--		end

--	generically_derived_type (parameters: LIST [PS_TYPE_METADATA]): PS_TYPE_METADATA
--			-- The generic type of `Current' with actual generic parameters `parameters'.
--		require
--			all_parameters_defined: parameters.count = generic_parameter_count
--		do
--			to_implement ("Check if this is actually possible with the limitations of INTERNAL")
--			check
--				not_implemented: False
--			end
--			Result := direct_type -- Void safety complaint
--		ensure
--			direct_type_if_no_parameter: parameters.is_empty implies Result.is_equal (direct_type)
--		end

--feature -- Inheritance

--	proper_ancestors: LIST [PS_CLASS_METADATA]
--			-- The proper ancestors.

--	proper_descendants: LIST [PS_CLASS_METADATA]
--			-- The proper descendants.

feature {NONE} -- Initialization

	make (type_metadata: PS_TYPE_METADATA; a_manager: PS_METADATA_FACTORY)
			-- Initialize `Current'.
		do
--			create reflection
			name := type_metadata.type.name.to_string_8
--			manager := a_manager
--			internal_type := type_metadata
--			proper_ancestors := calculate_proper_ancestors (type_metadata)
--			proper_descendants := calculate_proper_descendants (type_metadata)
		end

--	calculate_proper_ancestors (type_metadata: PS_TYPE_METADATA): LIST [PS_CLASS_METADATA]
--			-- Get the proper ancestors of `Current'.
--		local
--			type_names: LINKED_LIST [STRING]
--			local_class_name: STRING
--		do
--			create {LINKED_LIST [PS_CLASS_METADATA]} Result.make
--			create type_names.make
--			across
--				type_metadata.supertypes as type_cursor
--			loop
--				local_class_name := reflection.class_name_of_type (type_cursor.item.type.type_id)
--				if not type_names.has (local_class_name) and local_class_name /= name then
--					type_names.extend (local_class_name)
--					Result.extend (type_cursor.item.base_class)
--				end
--			end
--		end

--	calculate_proper_descendants (type_metadata: PS_TYPE_METADATA): LIST [PS_CLASS_METADATA]
--			-- Get the proper descendants of `Current'.
--		local
--			type_names: LINKED_LIST [STRING]
--			local_class_name: STRING
--		do
--			create {LINKED_LIST [PS_CLASS_METADATA]} Result.make
--			create type_names.make
--			across
--				type_metadata.subtypes as type_cursor
--			loop
--				local_class_name := reflection.class_name_of_type (type_cursor.item.type.type_id)
--				if not type_names.has (local_class_name) and local_class_name /= name then
--					type_names.extend (local_class_name)
--					Result.extend (type_cursor.item.base_class)
--				end
--			end
--		end

--	manager: PS_METADATA_FACTORY
--			-- A manager to create new types.

--	internal_type: PS_TYPE_METADATA
--			-- The type metadata that was used at creation time. It is easier to look up many things there.

--	reflection: INTERNAL
--			-- Reflection facility.

end
