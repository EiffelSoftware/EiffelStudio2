indexing
	description: "Enlarged access to a C external"
	date: "$Date$"
	revision: "$Revision$"

class EXTERNAL_BL

inherit
	EXTERNAL_B
		redefine
			free_register,
			generate_parameters_list, generate_access_on_type,
			release_hector_protection, basic_register, has_hector_variables,
			has_call, current_needed_for_access, set_parent, parent,
			set_register, register, generate_access, generate_on,
			analyze_on, analyze, generate_end, allocates_memory,
			generate_metamorphose_end
		end;

	SHARED_TABLE;

	SHARED_DECLARATIONS;

	EXTERNAL_CONSTANTS;

feature

	parent: NESTED_BL;
			-- Parent of access

	register: REGISTRABLE;
			-- In which register the expression is stored

	basic_register: REGISTRABLE;
			-- Register used to store the metamorphosed simple type

	set_parent (p: NESTED_BL) is
			-- Assign `p' to `parent'
		do
			parent := p;
		end;

	set_register (r: REGISTRABLE) is
			-- Set current register to `r'
		do
			register := r;
		end;

	current_needed_for_access: BOOLEAN is False;
			-- Current is not needed to call an external

	free_register is
			-- Free registers
		do
			Precursor {EXTERNAL_B};
			if basic_register /= Void then
				basic_register.free_register;
			end;
		end;

	analyze is
			-- Build a proper context for code generation.
		do
			analyze_on (Current_register);
			get_register;
		end;

	analyze_on (reg: REGISTRABLE) is
			-- Analyze call on an entity held in `reg'.
		local
			tmp_register: REGISTER;
		do
			if context_type.is_basic then
					-- Get a register to store the metamorphosed basic type,
					-- on which the attribute access is made. The lifetime of
					-- this temporary is really short: just the time to make
					-- the call...
				create tmp_register.make (Reference_c_type);
				basic_register := tmp_register;
			end;
			if parameters /= Void then
				parameters.analyze;
					-- If No_register has been propagated, then this call will
					-- be expanded in line. It might be part of a more complex
					-- expression, hence temporary registers used by the
					-- parameters may not be released now.
				check_dt_current (reg);
				if not perused then
					free_param_registers;
				end;
			else
				check_dt_current (reg);
			end;
		end;

	check_dt_current (reg: REGISTRABLE) is
			-- Check whether we need to compute the dynamic type of current
			-- and call context.add_dt_current accordingly. The parameter
			-- `reg' is the entity on which the access is made.
		local
			type_i: TYPE_I;
			class_type: CL_TYPE_I;
			access: ACCESS_B;
			void_register: REGISTER;
			is_polymorphic_access: BOOLEAN;
		do
			type_i := context_type;
			class_type ?= type_i;
			is_polymorphic_access := not is_static_call and then
					not type_i.is_basic and then
					class_type /= Void and then
					Eiffel_table.is_polymorphic (routine_id, class_type.type_id, True) >= 0;
			if reg.is_current and is_polymorphic_access then
				context.add_dt_current;
				context.mark_current_used
			end;
			if not reg.is_predefined and is_polymorphic_access then
					-- BEWARE!! The function call is polymorphic hence we'll
					-- need to evaluate `reg' twice: once to get its dynamic
					-- type and once as a parameter for Current. Hence we
					-- must make sure it is not held in a No_register--RAM.
				access ?= reg;		-- Cannot fail
				if access.register = No_register then
					access.set_register (void_register);
					access.get_register;
				end;
			end;
		end;

	generate_access is
			-- Generate the external C call
		do
			do_generate (Current_register);
		end;

	generate_on (reg: REGISTRABLE) is
			-- Generate call of feature on `reg'
		do
			do_generate (reg);
		end;

	generate_access_on_type (reg: REGISTRABLE; typ: CL_TYPE_I) is
			-- Generate external call in a `typ' context
		local
			table_name: STRING;
			type_c: TYPE_C
			l_type_i: TYPE_I
			buf: GENERATION_BUFFER
			array_index: INTEGER
			local_argument_types: like argument_types
			rout_table: ROUT_TABLE
			internal_name: STRING
		do
			check
				final_mode: context.final_mode
			end

			l_type_i := real_type (type)
			type_c := l_type_i.c_type;
			buf := buffer

			if is_static_call then
					-- No polymorphic here, set `array_index' to not go to the
					-- polymorphic call handling.
				array_index := -1
			else
				array_index := Eiffel_table.is_polymorphic (routine_id, typ.type_id, True)
			end
			if array_index >= 0 then
					-- The call is polymorphic, so generate access to the
					-- routine table. The dereferenced function pointer has
					-- to be enclosed in parenthesis.
				table_name := Encoder.table_name (routine_id)

				buf.putchar ('(');
				type_c.generate_function_cast (buf, argument_types)

					-- Generate following dispatch:
					-- table [Actual_offset - base_offset]
				buf.putstring (table_name);
				buf.putchar ('[');
				if reg.is_current then
					context.generate_current_dtype;
				else
					buf.putstring (gc_upper_dtype_lparan);
					reg.print_register;
					buf.putchar (')');
				end;
				buf.putchar ('-');
				buf.putint (array_index);
				buf.putchar (']');
				
				buf.putchar (')');

					-- Mark routine table used.
				Eiffel_table.mark_used (routine_id);
					-- Remember external routine table declaration
				Extern_declarations.add_routine_table (table_name);
			else
					-- The call is not polymorphic in the given context,
					-- so the name can be hardwired. If we check assertions, we need
					-- to call associated encapsulation.
				if encapsulated or else system.keep_assertions then
						-- In the case of encapsulated externals, we call the associated
						-- encapsulation.
					rout_table ?= Eiffel_table.poly_table (routine_id)
					if is_static_call then
						rout_table.goto_implemented (static_class_type.type_id)
					else
						rout_table.goto_implemented (typ.type_id)
					end
					check
						is_valid_routine: rout_table.is_implemented
					end
					internal_name := rout_table.feature_name

					local_argument_types := argument_types
					if
						not (rout_table.item.written_type_id = Context.original_class_type.type_id)
					then
							-- Remember extern routine declaration
						Extern_declarations.add_routine_with_signature (type_c,
								internal_name, local_argument_types)
					end

					buf.putchar ('(')
					type_c.generate_function_cast (buf, local_argument_types)
					buf.putstring (internal_name)
					buf.putchar (')')
				else
					if not l_type_i.is_void then
						type_c.generate_cast (buf);
					end
						-- Nothing to be done now. Remaining of code generation will be done
						-- in `generate_end'.
				end
			end
		end

	generate_end (gen_reg: REGISTRABLE; class_type: CL_TYPE_I; is_class_separate: BOOLEAN) is
			-- Generate final portion of C code.
		local
			cpp_ext: CPP_EXTENSION_I
			macro_ext: MACRO_EXTENSION_I
			struct_ext: STRUCT_EXTENSION_I
			inline_ext: INLINE_EXTENSION_I
			c_ext: C_EXTENSION_I
			buf: GENERATION_BUFFER
			l_type: TYPE_I
			l_args: like argument_types
		do
			generate_access_on_type (gen_reg, class_type)
				-- Now generate the parameters of the call, if needed.
			buf := buffer
			if context.final_mode then
				if
					not (encapsulated or else system.keep_assertions) and (is_static_call or
					Eiffel_table.is_polymorphic (routine_id, class_type.type_id, True) < 0)
				then
					check
						not_dll: not extension.is_dll
					end
					l_type := real_type (type)
					if extension.is_macro then
						macro_ext ?= extension
						macro_ext.generate_access (external_name, parameters, l_type)
					elseif extension.is_struct then
						struct_ext ?= extension
						struct_ext.generate_access (external_name, parameters, l_type)
					elseif extension.is_inline then
						inline_ext ?= extension
						inline_ext.generate_access (parameters, l_type)
					elseif extension.is_cpp then
						cpp_ext ?= extension
						cpp_ext.generate_access (external_name, parameters, l_type)
					else
						c_ext ?= extension
						check
							is_c_extension: c_ext /= Void
						end
							-- Remove `Current' from argument types.
						l_args := argument_types
						if argument_types.count > 1 then
							l_args := l_args.subarray (l_args.lower + 1, l_args.upper)
						else
							create l_args.make (1, 0)
						end
						c_ext.generate_access (external_name, parameters, l_args, l_type)
					end
				else
						-- Call is done like a normal Eiffel routine call.
					buf.putchar ('(')
					gen_reg.print_register
					generate_parameters_list
					buf.putchar (')')
				end
			else
					-- Call is done like a normal Eiffel routine call.
				buf.putchar ('(')
				gen_reg.print_register
				generate_parameters_list
				buf.putchar (')')
			end
		end

	generate_metamorphose_end (gen_reg, meta_reg: REGISTRABLE; class_type: CL_TYPE_I;
		basic_type: BASIC_I; buf: GENERATION_BUFFER) is
			-- Generate final portion of C code.
		local
			is_class_separate: BOOLEAN
		do
			is_class_separate := class_type.is_separate

			generate_end (gen_reg, class_type, is_class_separate)

				-- Now generate the parameters of the call, if needed.
			if not is_class_separate then
				buf.putchar (')');
				basic_type.end_of_metamorphose (basic_register, meta_reg, buf)
			end

			if type.is_boolean then
					-- macro EIF_TEST was generated
				buf.putchar (')');
			end
		end

	generate_parameters_list is
			-- Generate the parameters list for C function call
		local
			buf: GENERATION_BUFFER
		do
			if parameters /= Void then
				from
					buf := buffer
					parameters.start
				until
					parameters.after
				loop
					buf.putstring (gc_comma)
					parameters.item.print_register
					parameters.forth
				end
			end
		end

	release_hector_protection is
			-- Release all the hector variables
		local
			protect_b: PROTECT_B;
			nb_hector: INTEGER;
			buf: GENERATION_BUFFER
		do
			if parameters /= Void then
				from
					parameters.start;
				until
					parameters.after
				loop
					protect_b ?= parameters.item;
					if protect_b /= Void then
						nb_hector := nb_hector + 1;
					end;
					parameters.forth;
				end;
					-- Here is the trick: we have to release hector-protected
					-- variables. Hence the 'has_hector_variables' predicate
					-- is true, and no No_register propagation could occur.
					-- That means the generate part HAS to be a C expression,
					-- which make it possible to generate a ';' at the end
					-- followed by the hector removal instructions--RAM.
				if nb_hector > 0 then
					buf := buffer
					buf.putchar (';');
					buf.new_line;
					buf.putstring ("RTHF(");
					buf.putint (nb_hector);
					buf.putchar (')');
				end;
			end;
		end;

	fill_from (e: EXTERNAL_B) is
			-- Fill current from `e'
		local
			expr_b: PARAMETER_B;
			protect_b: PROTECT_B;
		do
			is_static_call := e.is_static_call
			static_class_type := e.static_class_type
			written_in := e.written_in
			external_name_id := e.external_name_id;
			type := e.type;
			parameters := e.parameters;
			encapsulated := e.encapsulated;
			extension := e.extension;
			feature_id := e.feature_id;
			feature_name_id := e.feature_name_id;
			routine_id := e.routine_id
			if parameters /= Void then
				from parameters.start;
				until parameters.after
				loop
					expr_b ?= parameters.item;	-- Cannot fail
						-- Ensure run-time protection for references which are
						-- not to be passed as 'raw', but protected via Hector.
						-- Unfortunately, the class which represents the '$'
						-- operator is named hector_b, hence the confusion.
					if expr_b.is_hector or not
						real_type (expr_b.type).c_type.is_pointer
					then
						parameters.replace (expr_b.enlarged);
					else
						create protect_b;
						protect_b.set_expr (expr_b.enlarged);
						parameters.replace (protect_b);
					end;
					parameters.forth;
				end;
			end;
		end;

	has_call: BOOLEAN is True;
			-- The expression has at least one call

	allocates_memory: BOOLEAN is True;

	has_hector_variables: BOOLEAN is
			-- Does the current external call make use of Hector ?
		local
			protect_b: PROTECT_B;
		do
			if parameters /= Void then
				from
					parameters.start;
				until
					Result or parameters.after
				loop
					protect_b ?= parameters.item;
					Result := protect_b /= Void;
					parameters.forth;
				end;
			end;
		end;

end
