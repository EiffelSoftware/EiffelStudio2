indexing
	description: "Provide reflection mechanisms to inspect EAC"
	date: "$Date$"
	revision: "$Revision$"

class
	CACHE_REFLECTION

inherit
	CACHE_READER
	
feature -- Access

	feature_name (t: TYPE; dotnet_name: STRING; args: NATIVE_ARRAY [TYPE]): STRING is
			-- Eiffel name of .NET function `dotnet_name' from type `t' with arguments `args'
		require
			non_void_type: t /= Void
			non_void_name: dotnet_name /= Void
			valid_name: not dotnet_name.is_empty
			valid_args: args /= Void implies args.count > 0
		local
			ct: CONSUMED_TYPE
			crt: CONSUMED_REFERENCED_TYPE
			fields: ARRAY [CONSUMED_FIELD] 
			procedures: ARRAY [CONSUMED_PROCEDURE]
			functions: ARRAY [CONSUMED_FUNCTION]
			constructors: ARRAY [CONSUMED_CONSTRUCTOR]
			found: BOOLEAN
			i, j, count: INTEGER
			ca: CONSUMED_ASSEMBLY
			cargs: ARRAY [CONSUMED_ARGUMENT]
			am: ARRAY [CONSUMED_ASSEMBLY]
		do
			i := t.get_hash_code
			types_cache.search (i)
			if types_cache.found then
				ct := types_cache.found_item
			else
				ct := consumed_type (t)
				if ct /= Void then
					types_cache.put (ct, i)
				end
			end
			am := assembly_mapping_array (t.assembly.get_name)
			if ct /= Void and am /= Void then
				ca := Consumed_assembly_factory.consumed_assembly (t.assembly)
				if dotnet_name.is_equal (Constructor_name) then
					constructors := ct.constructors
					if constructors /= Void then
						from
							i := 1
							count := constructors.count
						until
							i > count or found
						loop
							cargs := constructors.item (i).arguments
							if cargs.count = args.count then
								from
									j := 1
									found := True
								until
									j > cargs.count or not found
								loop
									crt := cargs.item (j).type
									found := crt.name.to_cil.equals (args.item (j - 1).full_name) and then
										am.item (crt.assembly_id).is_equal (Consumed_assembly_factory.consumed_assembly (args.item (j - 1).assembly))
									j := j + 1
								end
							end
							if found then
								Result := constructors.item (i).eiffel_name
							end
							i := i + 1
						end
					end
				elseif args /= Void then
					functions := ct.functions
					if functions /= Void then
						from
							i := 1
						until
							i > functions.count or found
						loop
							if functions.item (i).dotnet_name.is_equal (dotnet_name) then
								cargs := functions.item (i).arguments
								if cargs.count = args.count then
									from
										j := 1
										found := True
									until
										j > cargs.count or not found									
									loop
										crt := cargs.item (j).type
										found := crt.name.to_cil.equals (args.item (j - 1).full_name) and then
											am.item (crt.assembly_id).is_equal (Consumed_assembly_factory.consumed_assembly (args.item (j - 1).assembly))
										j := j + 1
									end
								end
							end
							if found then
								Result := functions.item (i).eiffel_name
							end
							i := i + 1
						end
					end
					if not found then
						procedures := ct.procedures
						if procedures /= Void then
							from
								i := 1
							until
								i > procedures.count or found
							loop
								if procedures.item (i).dotnet_name.is_equal (dotnet_name) then
									cargs := procedures.item (i).arguments
									if cargs.count = args.count then
										from
											j := 1
											found := True
										until
											j > cargs.count or not found
										loop
											crt := cargs.item (j).type
											found := crt.name.to_cil.equals (args.item (j - 1).full_name) and then
												am.item (crt.assembly_id).is_equal (Consumed_assembly_factory.consumed_assembly (args.item (j - 1).assembly))
											j := j + 1
										end
									end
								end
								if found then
									Result := procedures.item (i).eiffel_name
								end
								i := i + 1
							end
						end
					end
				else
					-- No arguments, search fields first
					fields := ct.fields
					if fields /= Void then
						from
							i := 1
						until
							i > fields.count or found
						loop
							found := fields.item (i).dotnet_name.is_equal (dotnet_name)
							if found then
								Result := fields.item (i).eiffel_name
							end
							i := i + 1
						end						
					end
					if not found then
						functions := ct.functions
						if functions /= Void then
							from
								i := 1
							until
								i > functions.count or found
							loop
								found := functions.item (i).dotnet_name.is_equal (dotnet_name)
								if found then
									Result := functions.item (i).eiffel_name
								end
								i := i + 1
							end
						end
					end
					if not found then
						procedures := ct.procedures
						if procedures /= Void then
							from
								i := 1
							until
								i > procedures.count or found
							loop
								found := procedures.item (i).dotnet_name.is_equal (dotnet_name)
								if found then
									Result := procedures.item (i).eiffel_name
								end
								i := i + 1
							end
						end
					end
				end
			end
		end
 
 	assembly_mapping_array (aname: ASSEMBLY_NAME): ARRAY [CONSUMED_ASSEMBLY] is
 			-- Assembly mapping for assembly `aname'.
 		require
 			non_void_name: aname /= Void
 			assembly_in_cache: is_assembly_in_cache (aname)
 		local
  			name: STRING
 		do
			create name.make_from_cil (aname.to_string)
			assemblies_mappings_cache.search (name)
			if assemblies_mappings_cache.found then
				Result := assemblies_mappings_cache.found_item
			else
				Result := assembly_mapping (aname).assemblies
				assemblies_mappings_cache.put (Result, name)
			end
  		end
 		
feature {NONE} -- Implementation

	Constructor_name: STRING is ".ctor"

	types_cache: CACHE [CONSUMED_TYPE, INTEGER] is
			-- Cache for loaded types
		once
			create Result.make (Max_cache_items)
		end

	assemblies_mappings_cache: CACHE [ARRAY [CONSUMED_ASSEMBLY], STRING] is
			-- Cache for assemblies ids mappings
		once
			create Result.make (Max_cache_items)
		end
		
	Max_cache_items: INTEGER is 20
			-- Maximum number of types stored in local cache

end -- class CACHE_REFLECTION
