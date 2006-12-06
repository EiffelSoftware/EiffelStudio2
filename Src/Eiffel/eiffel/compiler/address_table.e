indexing
	description: "Address table indexed by class_id"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ADDRESS_TABLE

inherit
	HASH_TABLE [HASH_TABLE [ADDRESS_TABLE_ENTRY, INTEGER], INTEGER]
		rename
			make as make_hash_table,
			has_key as has_table_of_class,
			item as table_of_class,
			cursor as ht_cursor
		export
			{ADDRESS_TABLE} all
			{ANY} valid_key, merge, has_table_of_class, table_of_class, found_item
		end

	SHARED_CODE_FILES
		undefine
			is_equal, copy
		end

	SHARED_TABLE
		undefine
			is_equal, copy
		end

	SHARED_DECLARATIONS
		undefine
			is_equal, copy
		end

	COMPILER_EXPORTER
		undefine
			is_equal, copy
		end

	SHARED_GENERATION
		undefine
			is_equal, copy
		end

create {SYSTEM_I}
	make

feature -- Initialize

	make is
		do
			make_hash_table (100)
			create dollar_id_counter
		end

feature -- Access

	has_dollar_operator (class_id: INTEGER; feature_id: INTEGER): BOOLEAN is
			-- Is the feature in the table?
		require
			class_id_valid: class_id > 0
			feature_id_valid: feature_id > 0
		do
			if has_table_of_class (class_id) then
				if found_item.has_key (feature_id) then
					Result := found_item.found_item.has_dollar_op
				end
			end
		end

	class_has_dollar_operator (a_class_id: INTEGER): BOOLEAN is
			-- Does the class with class_id a_class_id has at least one dollar-operator ?
		local
			l_table_of_class:  like table_of_class
		do
			l_table_of_class := table_of_class (a_class_id)
			if l_table_of_class /= Void then
				from
					l_table_of_class.start
				until
					Result or l_table_of_class.after
				loop
					if l_table_of_class.item_for_iteration.has_dollar_op then
						Result := True
					else
						l_table_of_class.forth
					end
				end
			end
		end

	has_agent (a_class_id, a_feature_id: INTEGER; a_is_target_closed: BOOLEAN; o_map: like empty_omap): BOOLEAN is
			-- Is there an agent registered with the given parameters?
		do
			Result := has_table_of_class (a_class_id)
			if Result then
				Result := found_item.has_key (a_feature_id)
				if Result then
					Result := found_item.found_item.has (make_reordering (a_is_target_closed, o_map))
				end
			end
		end

	is_lazy (a_class_id, a_feature_id: INTEGER; a_is_target_closed: BOOLEAN; a_omap: like empty_omap): BOOLEAN is
			-- Is the agent with the given parameters lazy? Meaning that there is no ececil entry generated for it.
		require
			class_id_valid: a_class_id > 0 and then has_table_of_class (a_class_id)
			feature_id_valid: a_feature_id > 0 and then table_of_class (a_class_id).has (a_feature_id)
			has_reordering: table_of_class (a_class_id).item (a_feature_id).has (make_reordering (a_is_target_closed, a_omap))
		local
			l_table_of_class:  like table_of_class
			l_table_entry: ADDRESS_TABLE_ENTRY
		do
			l_table_of_class := table_of_class (a_class_id)
			l_table_entry := l_table_of_class.item (a_feature_id)
			Result :=
				l_table_entry.item (make_reordering (a_is_target_closed, a_omap)).frozen_age = new_frozen_age
		end

	id_of_dollar_feature (a_class_id, a_feature_id: INTEGER; a_class_type: CLASS_TYPE): INTEGER is
			-- The dispatch_table id for the given feature
		require
			a_class_type_not_void: a_class_type /= Void
			dollar_feature_valid: has_table_of_class (a_class_id) and then
								  found_item.has_key (a_feature_id) and then
								  found_item.found_item.has_dollar_op and then
								  found_item.found_item.dollar_ids.has (a_class_type.static_type_id)
		local
			l_table_of_class: like table_of_class
			l_table_entry: ADDRESS_TABLE_ENTRY
		do
			l_table_of_class := table_of_class (a_class_id)
			l_table_entry := l_table_of_class.item (a_feature_id)
			Result := l_table_entry.dollar_ids.item (a_class_type.static_type_id)
		end

	update_ids is
			-- Recalculates all the ids for the dollar_operator dispatch_table. There is no dispatch table for agents!
		local
			l_table_of_class:  like table_of_class
			l_class: CLASS_C
			l_types: TYPE_LIST
			l_type: CLASS_TYPE
			l_feature_id: INTEGER
			l_table_entry: ADDRESS_TABLE_ENTRY
			l_feature: FEATURE_I
			l_type_id: INTEGER
		do
			from
				start
			until
				after
			loop
				l_class := System.class_of_id (key_for_iteration)
				if l_class /= Void then
					from
						l_table_of_class := item_for_iteration
						l_table_of_class.start
					until
						l_table_of_class.after
					loop
						l_feature_id := l_table_of_class.key_for_iteration
						l_table_entry := l_table_of_class.item_for_iteration

						l_feature := l_class.feature_table.feature_of_feature_id (l_feature_id)
						if l_feature = Void and then l_class.is_eiffel_class_c then
								-- maybe its an inline agent
							l_feature := l_class.eiffel_class_c.inline_agent_of_id (l_feature_id)
						end
						if l_feature = Void then
							l_table_of_class.remove (l_feature_id)
						else
							if l_table_entry.has_dollar_op then
								from
									l_types := l_class.types
									l_types.start
								until
									l_types.after
								loop
									l_type := l_types.item
									l_type_id := l_type.static_type_id
									if not l_table_entry.dollar_ids.has (l_type_id) then
										l_table_entry.dollar_ids.put (dollar_id_counter.next, l_type_id)
									end
									l_types.forth
								end
							end
							from
								l_table_entry.start
							until
								l_table_entry.after
							loop
								l_table_entry.item_for_iteration.set_frozen_age (new_frozen_age)
								l_table_entry.forth
							end
							l_table_of_class.forth
						end
					end
				end
				forth
			end
			if new_frozen_age = 0 then
				new_frozen_age := 1
			else
				new_frozen_age := 0
			end
		end

feature -- Register

	record_dollar_op (a_class_id, a_feature_id: INTEGER) is
			-- Records a dollar op for the given feature in the address table
		require
			class_id_valid: a_class_id > 0
		local
			l_table_entry: ADDRESS_TABLE_ENTRY
		do
			if not has_dollar_operator (a_class_id, a_feature_id) then
				l_table_entry := force_new_table_entry (a_class_id, a_feature_id)
				l_table_entry.set_has_dollar_op
				System.set_freeze
			end
		ensure
			has_dollar_operator (a_class_id, a_feature_id)
		end

	record_agent (
		a_class_id, a_feature_id: INTEGER; a_is_target_closed, a_is_inline_agent: BOOLEAN; a_open_map: ARRAYED_LIST [INTEGER]) is
			-- Records an agent with the reordering (defined by a_open_map) to the specified feature in the address_table
		require
			class_id_valid: a_class_id > 0
		local
			l_table_entry: ADDRESS_TABLE_ENTRY
			l_omap: like empty_omap
		do
			l_table_entry := force_new_table_entry (a_class_id, a_feature_id)

			if a_is_inline_agent then
					-- An inline agent has only one reordering. We delete all the existing ones.
				l_table_entry.wipe_out
			end

			if a_open_map = Void then
				l_omap := empty_omap
			else
				l_omap := a_open_map
			end
			l_table_entry.force_reordering (a_is_target_closed, l_omap, new_frozen_age)
		ensure
			has_agent (a_class_id, a_feature_id, a_is_target_closed, a_open_map)
		end

feature {NONE} -- Insert

	force_new_table_entry (a_class_id, a_feature_id: INTEGER): ADDRESS_TABLE_ENTRY is
			-- Forces, that there is an address table entry for feature with id a_feature_id of the class with id a_class_id
		local
			l_table_of_class: like table_of_class
			l_table_entry: ADDRESS_TABLE_ENTRY
		do
			if not has_table_of_class (a_class_id) then
				create l_table_of_class.make (1)
				put (l_table_of_class, a_class_id)
			else
				l_table_of_class := found_item
			end

			l_table_entry := l_table_of_class.item (a_feature_id)
			if l_table_entry = Void then
				create l_table_entry.make
				l_table_of_class.force (l_table_entry, a_feature_id)
			end
			Result := l_table_entry
		ensure
			has_table_of_class (a_class_id)
		end

feature -- Generation

	generate (final_mode: BOOLEAN) is
		local
			class_id: INTEGER
			feature_id: INTEGER
			l_table_of_class:  like table_of_class
			buffer: GENERATION_BUFFER
			address_file, cecil_file: INDENT_FILE
			a_class: CLASS_C
			a_feature: FEATURE_I
			table_entry: ADDRESS_TABLE_ENTRY
			l_reordering: FEATURE_REORDERING
		do
			buffer := Generation_buffer
			buffer.clear_all

			buffer.put_string ("#include %"eif_eiffel.h%"%N")
			buffer.put_string ("#include %"eif_rout_obj.h%"%N")

			buffer.put_string ("#include %"eaddress")
			buffer.put_string (Dot_h)
			buffer.put_string ("%"%N%N")

			buffer.start_c_specific_code

			from
				start
			until
				after
			loop
				class_id := key_for_iteration
				a_class := System.class_of_id (class_id)
				System.set_current_class (a_class)
				if a_class /= Void then
					if (final_mode implies (not a_class.is_precompiled or else a_class.is_in_system)) then
						l_table_of_class := item_for_iteration
						from
							l_table_of_class.start
						until
							l_table_of_class.after
						loop
							feature_id := l_table_of_class.key_for_iteration
							table_entry := l_table_of_class.item_for_iteration

							a_feature := a_class.feature_table.feature_of_feature_id (feature_id)
							if a_feature = Void and then a_class.is_eiffel_class_c then
									-- maybe its an inline agent
								a_feature := a_class.eiffel_class_c.inline_agent_of_id (feature_id)
							end
							if a_feature = Void then
									-- Remove invalid entry or feature which has been converted
									-- from a routine to an attribute.
								l_table_of_class.remove (feature_id)
							else
									-- Feature exists
								if a_feature.used then
										-- Feature is not dead code removed

		debug ("DOLLAR")
		io.put_string ("ADDRESS_TABLE.generate_feature ")
		io.put_string (a_class.name)
		io.put_character (' ')
		io.put_string (a_feature.feature_name)
		io.put_new_line
		end
									if table_entry.has_dollar_op then
										generate_feature (a_class, a_feature, final_mode, buffer, False, False, Void, False)
									end

									from
										table_entry.start
									until
										table_entry.after
									loop
										l_reordering := table_entry.item_for_iteration
										if l_reordering.is_valid_for (a_feature) then
											l_reordering.set_frozen_age (new_frozen_age)
											generate_feature (a_class, a_feature, final_mode, buffer, True,
															  l_reordering.is_target_closed, l_reordering.open_map, True)
											if final_mode then
												generate_feature (a_class, a_feature, final_mode, buffer, True,
																  l_reordering.is_target_closed, l_reordering.open_map, False)
											end
											table_entry.forth
										else
											table_entry.forth
											table_entry.remove (l_reordering)
										end
									end
								end
								l_table_of_class.forth
							end
						end
						if l_table_of_class.is_empty then
							-- None of the features are valid
							remove (class_id)
						else
							forth
						end
					else
						forth
					end
				else
						-- Remove the invalid entry
					remove (class_id)
				end
			end

			create cecil_file.make_c_code_file (x_gen_file_name (final_mode, Ececil));
			if final_mode then
				buffer.end_c_specific_code
				buffer.put_in_file (cecil_file)
				cecil_file.close
			else
					-- Generate the dispatch table in Workbench mode
				generate_dispatch_table (buffer)
				buffer.end_c_specific_code
				buffer.put_in_file (cecil_file)
				cecil_file.close

			end

				-- Generate the extern declarations

			buffer.clear_all
			buffer.put_string ("#include %"eif_eiffel.h%"%N%
								%#include %"eif_rout_obj.h%"%N")

			buffer.start_c_specific_code
			Extern_declarations.generate (buffer)
			buffer.end_c_specific_code
			Extern_declarations.wipe_out

			if final_mode then
				create address_file.make_open_write (final_file_name ("eaddress", Dot_h, 1))
			else
				create address_file.make_open_write (workbench_file_name ("eaddress", Dot_h, 1))
			end

			buffer.put_in_file (address_file)
			address_file.close
		end

	calc_function_name (a_is_for_agent: BOOLEAN; a_feature_id, a_static_type_id: INTEGER;
						a_omap: ARRAYED_LIST [INTEGER]; a_oargs_encapsulated: BOOLEAN): STRING is
	 	local
	 		sep: STRING
		do
			if a_is_for_agent then
				if a_oargs_encapsulated then
					Result := "_f"
				else
					Result := "__f"
				end
			else
				Result := "f"
			end

			Result.append (Encoder.address_table_name (a_feature_id, a_static_type_id))
			if a_omap /= Void then
				from
					a_omap.start
					sep := "_"
				until
					a_omap.after
				loop
					Result.append (sep)
					Result.append (a_omap.item.out)
					a_omap.forth
				end
			end
		end

feature -- Generation helpers

	solved_type (context_type: CLASS_TYPE; type_a: TYPE_A): TYPE_C is
			-- Solved type associated with `context_type'.
		local
			s_type: TYPE_A
		do
			s_type := type_a.instantiated_in (context_type.type.type_a)
			Result := s_type.type_i.c_type
		end

	arg_types (context_type: CLASS_TYPE; args: FEAT_ARG): ARRAY [STRING] is
			-- Generate declaration of the argument types.
		require
			arg_non_void: args /= Void
		local
			i, nb: INTEGER
		do
			from
				i := 1
				nb := args.count
				create Result.make (1, nb + 1)
				Result.put ("EIF_REFERENCE", 1)
			until
				i > nb
			loop
				Result.put (solved_type (context_type, args.i_th (i)).c_string, i + 1)
				i := i + 1
			end
		end

feature {NONE} -- Generation

	generate_dispatch_table (buffer: GENERATION_BUFFER) is
			-- Generates the dispatch table for the dollar operators
		require
			buffer_exists: buffer /= Void
		local
			l_table_of_class: like table_of_class
			l_table_entry: ADDRESS_TABLE_ENTRY
			l_type_list: TYPE_LIST
			l_feature_id: INTEGER
			l_dollar_ids: HASH_TABLE [INTEGER, INTEGER]
			l_disp_tab: ARRAYED_LIST [TUPLE [static_type_id, feature_id: INTEGER]]
		do
			create l_disp_tab.make_filled (dollar_id_counter.value)
			from
				start
			until
				after
			loop
				from
					l_table_of_class := item_for_iteration
					l_type_list := System.class_of_id (key_for_iteration).types
					l_table_of_class.start
				until
					l_table_of_class.after
				loop
					l_table_entry := l_table_of_class.item_for_iteration
					l_feature_id := l_table_of_class.key_for_iteration

					if l_table_entry.has_dollar_op then
						from
							l_dollar_ids := l_table_entry.dollar_ids
							l_dollar_ids.start
						until
							l_dollar_ids.after
						loop
							l_disp_tab.put_i_th ([l_dollar_ids.key_for_iteration, l_feature_id], l_dollar_ids.item_for_iteration)
							l_dollar_ids.forth
						end
					end
					l_table_of_class.forth
				end
				forth
			end
			buffer.put_string ("%N%Nstatic fnptr feif_address_table[] = {%N(fnptr)0,%N")

			l_disp_tab.do_all (agent (l_buf: GENERATION_BUFFER; l_entry: TUPLE [static_type_id, feature_id: INTEGER])
				do
					l_buf.put_string (once "(fnptr)")
					if l_entry /= Void then
						l_buf.put_string (calc_function_name (False, l_entry.feature_id, l_entry.static_type_id, Void, False))
					else
						l_buf.put_string (once "0")
					end
					l_buf.put_string (once ",%N")
				end (buffer, ?))

			buffer.put_string ("};%N%Nfnptr *egc_address_table_init = feif_address_table;%N%N")
		end

	arg_names (nb: INTEGER): ARRAY [STRING] is
			-- Names of the arguments
		local
			i: INTEGER
			temp: STRING
		do
			from
				create Result.make (1, nb + 1)
				Result.put ("Current", 1)
				i := 1
			until
				i > nb
			loop
				temp := "arg"
				temp.append_integer (i)
				Result.put (temp, i + 1)
				i := i + 1
			end
		end

	generate_arg_list (buffer: GENERATION_BUFFER; current_name: STRING; nb: INTEGER) is
			-- Generate declaration of `n' arguments.
		local
			i: INTEGER
		do
			from
				buffer.put_string (current_name)
				i := 1
			until
				i > nb
			loop
				buffer.put_string (", arg")
				buffer.put_integer (i)
				i := i + 1
			end
		end

	generate_feature (a_class: CLASS_C; a_feature: FEATURE_I; final_mode: BOOLEAN; buffer: GENERATION_BUFFER;
					  is_for_agent, is_target_closed: BOOLEAN; omap: ARRAYED_LIST [INTEGER];
					  a_oargs_encapsulated: BOOLEAN) is
			-- Generate wrapper routine for `$f' if `is_for_agent' False.
			-- Generate wrapper routine for `agent f' if `is_for_agent' True.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			buffer_not_void: buffer /= Void
		local
			types: TYPE_LIST
			feature_id: INTEGER
			rout_id: INTEGER
			args: FEAT_ARG
			args_count: INTEGER
			has_arguments, is_function: BOOLEAN
			return_type: TYPE_A
			return_type_string: STRING
			c_return_type: TYPE_C
			a_types: like arg_types
			function_name: STRING
			cursor: CURSOR
			l_current_name: STRING
			l_is_implemented: BOOLEAN
			l_type: CLASS_TYPE
		do
			feature_id := a_feature.feature_id
			rout_id := a_feature.rout_id_set.first
			if a_feature.has_arguments then
				has_arguments := True
				args := a_feature.arguments
				args_count := args.count
			end
			return_type := a_feature.type
			is_function := a_feature.is_function

			if is_for_agent then
				if is_target_closed or omap.is_empty then
					l_current_name := "closed [1].element.rarg"
				else
					if a_oargs_encapsulated then
						l_current_name := "open [1].element.rarg"
					else
						l_current_name := "op_1"
					end
				end
			else
				l_current_name := "Current"
			end

				-- get class types and generate encapsulation for each of them
			from
				types := a_class.types
				types.start
			until
				types.after
			loop
				l_type := types.item
				cursor := types.cursor

				function_name := calc_function_name (is_for_agent, feature_id, l_type.static_type_id,
													 omap, a_oargs_encapsulated)

				buffer.put_string ("%T/* ")
				l_type.type.dump (buffer)
				buffer.put_string (" ")
				buffer.put_string (a_feature.feature_name)
				buffer.put_string (" */%N")

				c_return_type := solved_type (l_type, return_type)
				return_type_string := c_return_type.c_string

				if has_arguments then
					a_types := arg_types (l_type, args)
				else
					a_types := <<"EIF_REFERENCE">>
				end

				if is_for_agent then
					generate_signature_for_agent (buffer, a_types, return_type_string,
												  function_name, omap, a_oargs_encapsulated)
				else
					buffer.generate_pure_function_signature
						(return_type_string, function_name, True, buffer,
						arg_names (args_count), a_types)
				end
				if is_for_agent and (not final_mode or else system.keep_assertions) then
						-- We need to check the invariant in an agent call, thus `nstcall' needs to be set.
					buffer.put_string ("{%N%TGTCX%N%Tnstcall = 1;%N%T")
				else
					buffer.put_string ("{%N%T")
				end

				if is_function then
					buffer.put_string ("return ")
				end

				if
					final_mode and then
					not a_feature.is_inline_agent and then
					is_target_closed and then
					is_for_agent
				then
					buffer.put_string ("f_ptr (")
					generate_arg_list_for_rout (buffer, arg_tags (l_type, args), omap, a_oargs_encapsulated)
				else
					if a_feature.is_inline_agent then
						buffer.put_character ('(')
						c_return_type.generate_function_cast (buffer, a_types)
						function_name := Encoder.feature_name (l_type.static_type_id, a_feature.body_index)
						buffer.put_string (function_name)
						buffer.put_string (")(")
						extern_declarations.add_routine_with_signature (c_return_type,
							function_name, a_types)

						check
							is_for_agent
						end

						generate_arg_list_for_rout (buffer, arg_tags (l_type, args), omap, a_oargs_encapsulated)
					else
						if final_mode then
							l_is_implemented :=
								generate_final_c_body (buffer, a_feature, l_current_name, c_return_type, l_type, a_types)
						else
							l_is_implemented := True
							generate_workbench_c_body (buffer, a_feature, l_current_name, c_return_type, l_type, a_types)
						end
						if l_is_implemented then
							if is_for_agent then
								generate_arg_list_for_rout (buffer, arg_tags (l_type, args), omap, a_oargs_encapsulated)
							else
								generate_arg_list (buffer, l_current_name, args_count)
							end
						end
					end
				end
				buffer.put_string (");%N")

				buffer.put_string ("%N}%N%N")

				types.go_to (cursor)
				types.forth
			end
		end

	arg_tags (context_type: CLASS_TYPE; args: FEAT_ARG): ARRAY [STRING] is
			-- Generate union tag names for the argument types.
		require
			context_type_non_void: context_type /= Void
		local
			i, nb: INTEGER
		do
			if args /= Void then
				nb := args.count + 1
			else
				nb := 1
			end
			create Result.make (1, nb)
			Result.put ("rarg", 1)
			from
				i := 1
			until
				i = nb
			loop
				Result.put (solved_type (context_type, args.i_th (i)).union_tag, i + 1)
				i := i + 1
			end
		end

	generate_final_c_body (buffer: GENERATION_BUFFER; a_feature: FEATURE_I; a_current_name: STRING;
						   c_return_type: TYPE_C; a_type: CLASS_TYPE; a_types: like arg_types): BOOLEAN is
		local
			l_table_name, l_function_name: STRING
			l_entry: POLY_TABLE [ENTRY]
			l_rout_table: ROUT_TABLE
			l_rout_id: INTEGER
			l_type_id: INTEGER
		do
				-- Routine is always implemented unless found otherwise (Deferred routine
				-- with no implementation).

			Result := True

			l_rout_id := a_feature.rout_id_set.first
			l_entry :=  Eiffel_table.poly_table (l_rout_id)

			buffer.put_character ('(')
			if l_entry = Void then
					-- Function pointer associated to a deferred feature
					-- without any implementation
				c_return_type.generate_function_cast (buffer, <<"EIF_REFERENCE">>)
				buffer.put_string ("RTNR) (")
				buffer.put_string (a_current_name)
				Result := False
			else
				l_type_id := a_type.type_id
				if l_entry.is_polymorphic (l_type_id) then
					l_table_name := Encoder.table_name (l_rout_id)
					c_return_type.generate_function_cast (buffer, a_types)
					buffer.put_string (l_table_name)
					buffer.put_string ("[Dtype(")
					buffer.put_string (a_current_name)
					buffer.put_string (") - ")
					buffer.put_type_id (l_entry.min_used)
					buffer.put_string ("])(")
						-- Remember extern declarations
					Extern_declarations.add_routine_table (l_table_name)
						-- Mark table used.
					Eiffel_table.mark_used (l_rout_id)
				else
					l_rout_table ?= l_entry

					l_rout_table.goto_implemented (l_type_id)
					if l_rout_table.is_implemented then
						c_return_type.generate_function_cast (buffer, a_types)
						l_function_name := l_rout_table.feature_name
						buffer.put_string (l_function_name)
						buffer.put_string (")(")
						extern_declarations.add_routine_with_signature (c_return_type,
							l_function_name, a_types)
					else
							-- Function pointer associated to a deferred feature
							-- without any implementation. We mark `l_is_implemented'
							-- to False to not generate the argument list since
							-- RTNR takes only one argument.
						Result := False
						c_return_type.generate_function_cast (buffer, <<"EIF_REFERENCE">>)
						buffer.put_string ("RTNR) (")
						buffer.put_string (a_current_name)
					end
				end

			end
		end

	generate_workbench_c_body (buffer: GENERATION_BUFFER; a_feature: FEATURE_I; l_current_name: STRING;
						   	   c_return_type: TYPE_C; a_type: CLASS_TYPE; a_types: like arg_types) is
		local
			l_rout_id: INTEGER
			l_rout_info: ROUT_INFO
		do
			buffer.put_character ('(')
			l_rout_id := a_feature.rout_id_set.first
			c_return_type.generate_function_cast (buffer, a_types)

			if
				Compilation_modes.is_precompiling or else
				a_type.associated_class.is_precompiled
			then
				l_rout_info := System.rout_info_table.item (l_rout_id)
				buffer.put_string ("RTVPF(")
				buffer.put_class_id (l_rout_info.origin)
				buffer.put_string (gc_comma)
				buffer.put_integer (l_rout_info.offset)
			else
				buffer.put_string ("RTVF(")
				buffer.put_static_type_id (a_type.static_type_id)
				buffer.put_string (gc_comma)
				buffer.put_integer (a_feature.feature_id)
			end
			buffer.put_string (gc_comma)
			buffer.put_string_literal (a_feature.feature_name)
			buffer.put_string (gc_comma)
			buffer.put_string (l_current_name)
			buffer.put_string ("))(")
		end

	generate_arg_list_for_rout (a_buf: GENERATION_BUFFER; a_tags : ARRAY [STRING];
								a_omap: ARRAYED_LIST [INTEGER]; a_oargs_encapsulated: BOOLEAN) is
			-- Generate declaration of `n' arguments for routine objects.
		local
			i, j, k, o: INTEGER
			sep: STRING
		do
			from
				i := 1
				j := 1
				k := 1
				a_omap.start
				if not a_omap.after then
					o := a_omap.item
				else
					o := {INTEGER}.max_value
				end
				sep := ", "
			until
				i > a_tags.count
			loop
				if i > 1 then
					a_buf.put_string (sep)
				end
				if i = o then
					if a_oargs_encapsulated then
						a_buf.put_string ("open [")
						a_buf.put_string (k.out)
						a_buf.put_string ("].element.")
						a_buf.put_string (a_tags.item (i))
						k := k + 1
					else
						a_buf.put_string ("op_")
						a_buf.put_String (o.out)
					end
					a_omap.forth
					if not a_omap.after then
						o := a_omap.item
					else
						o := {INTEGER}.max_value
					end
				else
					a_buf.put_string ("closed [")
					a_buf.put_integer (j)
					a_buf.put_string ("].element.")
					a_buf.put_string (a_tags.item (i))
					j := j + 1
				end
				i := i + 1
			end
		end

	generate_signature_for_agent (a_buf: GENERATION_BUFFER; a_types: like arg_types;
								  a_return_type, a_name: STRING; a_omap: ARRAYED_LIST [INTEGER];
								  a_oargs_encapsulated: BOOLEAN) is
			--
		local
			l_arg_names, l_arg_types: ARRAY [STRING]
			i, o, l_arg_count: INTEGER
		do
			if a_oargs_encapsulated then
				l_arg_count := 3
			else
				l_arg_count := 2 + a_omap.count
			end

			create l_arg_names.make (1, l_arg_count)
			create l_arg_types.make (1, l_arg_count)

			tmp_buffer.clear_all
			tmp_buffer.put_string (a_return_type)
			tmp_buffer.put_string ("(*f_ptr) (")
			tmp_buffer.put_array (a_types)
			tmp_buffer.put_string (")")
			l_arg_types.put (tmp_buffer.as_string, 1)
				-- The name of the pointer is embedded in its type
			l_arg_names.put ("", 1)

			l_arg_types.put ("EIF_TYPED_ELEMENT *", 2)
			l_arg_names.put ("closed", 2)

			if a_oargs_encapsulated then
				l_arg_types.put ("EIF_TYPED_ELEMENT *", 3)
				l_arg_names.put ("open", 3)
			else
				from
					a_omap.start
					i := 3
				until
					a_omap.after
				loop
					o := a_omap.item
					l_arg_types.put (a_types.item (o), i)
					l_arg_names.put ("op_" + o.out, i)

					i := i + 1
					a_omap.forth
				end
			end
			a_buf.generate_pure_function_signature (a_return_type, a_name, True, a_buf, l_arg_names, l_arg_types)
		end

	tmp_buffer: GENERATION_BUFFER is
			-- helper buffer for feature generation
		once
			create Result.make (1024)
		end

feature

	make_reordering (a_is_target_closed: BOOLEAN; a_open_map: ARRAYED_LIST [INTEGER]): FEATURE_REORDERING is
			-- Creates a reordering with the given parameters
		local
			l_open_map: like empty_omap
		do
			if a_open_map = Void then
				l_open_map := empty_omap
			else
				l_open_map := a_open_map
			end
			if reordering = Void then
				create reordering.make (a_is_target_closed, l_open_map, new_frozen_age)
			else
				reordering.set_attributes (a_is_target_closed, l_open_map)
				reordering.set_frozen_age (new_frozen_age)
			end
			Result := reordering
		end

feature {NONE}	--implementation

	reordering: FEATURE_REORDERING;

	empty_omap: ARRAYED_LIST [INTEGER] is
		once
			create Result.make (0)
		end

	dollar_id_counter: COUNTER

	new_frozen_age: INTEGER;

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
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
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end -- class ADDRESS_TABLE
