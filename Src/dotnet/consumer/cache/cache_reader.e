indexing
	description: "Read content of Eiffel Assembly Cache"

class
	CACHE_READER

inherit
	CACHE_PATH
		export
			{ANY} all
		end

feature -- Access

	consumed_assemblies: ARRAY [CONSUMED_ASSEMBLY] is
			-- Assemblies in EAC
		do
			if is_initialized then
				Result := info.assemblies			
			end
		end

	consumed_type (t: TYPE): CONSUMED_TYPE is
			-- Consumed type corresponding to `t'.
		local
			des: EIFFEL_XML_DESERIALIZER
		do
			create des
			des.deserialize (absolute_type_path (t))
			Result ?= des.deserialized_object
		end
	
	client_assemblies (assembly: CONSUMED_ASSEMBLY): ARRAY [CONSUMED_ASSEMBLY] is
			-- List of assemblies in EAC depending on `assembly'.
		require
			non_void_assembly: assembly /= Void
		local
			i, j, index: INTEGER
			assemblies: like consumed_assemblies
			converter: CACHE_CONVERSION
			a: ASSEMBLY
			names: NATIVE_ARRAY [ASSEMBLY_NAME]
			ca: CONSUMED_ASSEMBLY
		do
			create Result.make (1, 0)
			assemblies := consumed_assemblies
			index := 1
			create converter
			from
				i := 1
			until
				i > assemblies.count
			loop
				a := converter.assembly (assemblies.item (i))
				if converter.successful then
					names := a.get_referenced_assemblies
					from
						j := 0
					until
						j = names.get_length
					loop
						create ca.make_from_name (names.item (j))
						if ca.is_equal (assembly) then
							Result.force (ca, index)
							index := index + 1
						end
						j := j + 1
					end
					i := i + 1					
				end
			end
		end
		
feature -- Status Report

	is_initialized: BOOLEAN is
			-- Is EAC correctly installed?
		do
			Result := (create {RAW_FILE}.make ((create {CACHE_PATH}).Absolute_info_path)).exists
		end

	is_assembly_in_cache (aname: ASSEMBLY_NAME): BOOLEAN is
			-- Is `aname' in EAC?
		do
			if aname.get_public_key_token /= Void then
				Result := (create {DIRECTORY}.make (absolute_assembly_path (aname))).exists			
			end
		end
	
	is_type_in_cache (t: TYPE): BOOLEAN is
			-- Is `t' in EAC?
		do
			if  t.get_assembly.get_name.get_public_key_token /= Void then
				Result := (create {RAW_FILE}.make (absolute_type_path (t))).exists			
			end
		end
		
feature {CACHE_WRITER} -- Implementation

	info: CACHE_INFO is
			-- Information on EAC content
		local
			des: EIFFEL_XML_DESERIALIZER
		do
			create des
			des.deserialize ((create {CACHE_PATH}).Absolute_info_path)
			if des.successful then
				Result ?= des.deserialized_object
			end
		ensure
			non_void_if_initialized: is_initialized implies Result /= Void
		end		

end -- class CACHE_READER
