indexing

	description: 
		"Representation of an Eiffel system.";
	date: "$Date$";
	revision: "$Revision $"

class E_SYSTEM

inherit

	SHARED_WORKBENCH;
	COMPILER_EXPORTER;
	SHARED_INST_CONTEXT;
	SHARED_MELT_ONLY;
	PROJECT_CONTEXT

creation

	make

feature -- Initialization

	make is
			-- Create an eiffel system.
		do
			!! classes.make (1, System_chunk);
		end;

feature -- Properties

	classes: ARRAY [E_CLASS];
			-- Array of compiled eiffel classes indexed by their class `id's
			-- (Can have void entries)

	root_class_name: STRING is
			-- Root class name
		do
			Result := System.root_class_name
		end;

	name: STRING is
			-- System name specified in Lace file
		do
			Result := System.system_name
		end;

	root_cluster: CLUSTER_I is
			-- Root cluster of System
		do
			Result := System.root_cluster
		end

feature -- Access

	current_class: E_CLASS is
		obsolete "to be removed"
		local
			c: CLASS_C
		do
			c := System.current_class;
			if c /= Void then
				Result := c.e_class
			end
		end;

	cluster: CLUSTER_I is		
		obsolete "to be removed"
		do
			Result := Inst_context.cluster;
		end;

	Any_id: INTEGER is
			-- Identification for class ANY
		require
			compiled: Any_class.compiled
		once
			Result := System.any_id
		end;

	Any_class: CLASS_I is
			-- class ANY
		once
			Result := System.any_class
		end;

	Boolean_class: CLASS_I is
			-- Class BOOLEAN
		once
			Result := System.boolean_class
		end;

	Character_class: CLASS_I is
			-- Class CHARACTER
		once
			Result := System.character_class
		end;

	Integer_class: CLASS_I is
			-- Class INTEGER
		once
			Result := System.integer_class
		end;

	Real_class: CLASS_I is
			-- Class REAL
		once
			Result := System.real_class
		end;

	Double_class: CLASS_I is
			-- Class DOUBLE
		once
			Result := System.double_class
		end;

	Pointer_class: CLASS_I is
			-- Class POINTER
		once
			Result := System.pointer_class
		end;

	String_class: CLASS_I is
			-- Class STRING
		once
			Result := System.string_class
		end;

	Array_class: CLASS_I is
		once
			Result := System.array_class
		end;

	Special_class: CLASS_I is
			-- Class SPECIAL
		once
			Result := System.special_class
		end;

	To_special_class: CLASS_I is
			-- Class TO_SPECIAL
		once
			Result := System.to_special_class
		end;

	Bit_class: CLASS_I is
			-- Class BIT_REF
		once
			Result := System.bit_class
		end;

	number_of_classes: INTEGER is
			-- Number of compiled classes in the system
		require
			classes_not_void: classes /= Void
		local
			id_array: like classes;
			i: INTEGER
		do
			Result := System.nb_of_classes;
			--id_array := classes;
			--from
				--i := id_array.lower
			--until
				--i > id_array.upper
			--loop
				--if id_array.item (i) /= Void then
					--Result := Result + 1
				--end;
				--i := i + 1
			--end
		end;

	class_of_id (i: INTEGER): E_CLASS is
			-- Eiffel Class of id `i'
		require
			positive_i: i >= 0;
		local
			classc: CLASS_C
		do
			classc := System.class_of_id (i);
			if classc /= Void then
				Result := classc.e_class
			end
		end;

	root_class: CLASS_I is
			-- Root class of the system
		do
			Result := root_cluster.classes.item (root_class_name);
		end;

	application_name (compile_type: BOOLEAN): STRING is
			-- Get the full qualified name of the application
			-- For workbench-mode application `compile_type' is true
		local
			system_name: STRING;
			f_name: FILE_NAME;
			f: PLAIN_TEXT_FILE;
			make_f: PLAIN_TEXT_FILE
		do
			system_name := clone (name);
			if system_name = Void then
				io.putstring ("You must compile a project first.%N");
			else
				if melt_only then
					Result := (Precompilation_driver)
				else
					system_name.append (Executable_suffix);
					if compile_type then
						!! f_name.make_from_string (Workbench_generation_path);
					else
						!! f_name.make_from_string (Final_generation_path);
					end;
					f_name.set_file_name (system_name);
					Result := f_name
				end;
				!! f.make (Result);
				if not f.exists then
					io.putstring ("The system ");
					io.putstring (Result);
					io.putstring (" does not exist.%N");
					Result := Void;
				else
					if not melt_only then
						if compile_type then
							!! f_name.make_from_string (Workbench_generation_path);
						else
							!! f_name.make_from_string (Final_generation_path);
						end;
						f_name.set_file_name (Makefile_SH);
						!! make_f.make (f_name);
						if make_f.exists and then make_f.date > f.date then
							io.putstring (Makefile_SH);
							io.putstring (" is more recent than the system.%N");
							Result := Void
						end
					end
				end
			end
		end;

feature {CALL_STACK_ELEMENT, RUN_INFO, REFERENCE_VALUE, APPLICATION_STATUS}

	valid_dynamic_id (i: INTEGER): BOOLEAN is
			-- Is the class_type dynamic id `i' valid?
		do
			Result := System.class_types.valid_index (i)
		end;

	class_of_dynamic_id (i: INTEGER): E_CLASS is
			-- Eiffel Class of dynamic id `i'
		require
			positive_i: i >= 0;
			valid_i: valid_dynamic_id (i)
		local
			ct: CLASS_TYPE
		do
			ct := System.class_types.item (i);
			if ct /= Void then
				Result := ct.associated_eclass
			end
		end;

feature {NONE} -- Implementation

	System_chunk: INTEGER is 500

invariant

	non_void_classes: classes /= Void

end -- class E_SYSTEM
