-- Table of patterns

class PATTERN_TABLE 

inherit

	SEARCH_TABLE [PATTERN_INFO]
		rename
			make as search_table_make
		end;
	SHARED_CODE_FILES
		undefine
			copy, setup, consistent, is_equal
		end;
	SHARED_WORKBENCH
		undefine
			copy, setup, consistent, is_equal
		end

creation

	make

feature
	
	patterns: SEARCH_TABLE [PATTERN];
			-- Shared references on patterns

	info_array: HASH_TABLE [PATTERN_INFO, PATTERN_ID];
			-- Table of pattern information in order to reference them
			-- through an index.

	last_pattern_id: PATTERN_ID;
			-- Pattern id processed after last insertion

	
	c_patterns: SEARCH_TABLE [C_PATTERN_INFO];
			-- Non formal patterns present already in the system

	pattern_id_counter: PATTERN_ID_COUNTER
			-- Pattern id counter

	c_pattern_id_counter: COUNTER;
			-- Counter of C patterns

	make is
			-- Table creation
		do
			search_table_make (Chunk);
			!!patterns.make (Chunk);
			!!info_array.make (Chunk);
			!!c_pattern_id_counter;
			!! pattern_id_counter.make;
			!!c_patterns.make (Chunk);
		end;

	Chunk: INTEGER is 100;
			-- Table chunk

	process is
			-- Process the table of C patterns
		local
			c_pattern: C_PATTERN;
			types: LINKED_LIST [CLASS_TYPE];
			info: PATTERN_INFO;
			c_pattern_info: C_PATTERN_INFO;
			assoc_class: CLASS_C;
		do
			from
				info_array.start
			until
				info_array.after
			loop
				info := info_array.item_for_iteration;
				assoc_class := info.associated_class;
				if assoc_class /= Void then
						-- Classes could be removed
					from
						types := info.associated_class.types;
						types.start
					until
						types.after
					loop
						c_pattern := 
							info.instantiation_in (types.item.type).c_pattern;
						!!c_pattern_info;
						c_pattern_info.set_pattern (c_pattern);
						if not c_patterns.has (c_pattern_info) then
							c_pattern_info.set_c_pattern_id
												(c_pattern_id_counter.next);
							c_patterns.put (c_pattern_info);
						end;
						types.forth;
					end;
				end;
				info_array.forth
			end;
		end;
				
	insert (written_in: CLASS_ID; pattern: PATTERN) is
		require
			good_argument: pattern /= Void
		local
			other_pattern: PATTERN;
			info, other_info: PATTERN_INFO;
		do
			!!info.make (written_in, pattern);
			other_info := item (info);
			if other_info = Void then
				other_pattern := patterns.item (pattern);
				if other_pattern = Void then
					patterns.put (pattern);
				else
					info.set_pattern (other_pattern);
				end;
				put (info);

				last_pattern_id := pattern_id_counter.next_id;
				info.set_pattern_id (last_pattern_id);
				info_array.put (info, last_pattern_id);
			else
				last_pattern_id := other_info.pattern_id;
			end;
		end;

	pattern_of_id (i: PATTERN_ID; type: CL_TYPE_I): PATTERN is
			-- Pattern information of id `i'.
		require
			valid_id: info_array.has (i)
		do
			Result := info_array.item (i).instantiation_in (type);
		end;

	c_pattern_id (pattern_id: PATTERN_ID; cl_type: CL_TYPE_I): INTEGER is
			-- Pattern id of C pattern `p'
		require
			good_type: cl_type /= Void;
		local
			info: C_PATTERN_INFO;
		do
			Marker.set_pattern
				(pattern_of_id (pattern_id, cl_type).c_pattern);
			info := c_patterns.item (Marker);
			if info /= Void then
				Result := info.c_pattern_id;
			end;
		end;

	Marker: C_PATTERN_INFO is
			-- Marker for search in `c_patterns'
		once
			!!Result;
		end;

feature -- Merging

	append (other: like Current) is
			-- Append `other' to `Current'.
			-- Used when merging precompilations.
		require
			other_not_void: other /= Void
		local
			pattern, other_pattern: PATTERN;
			info, other_info: PATTERN_INFO;
			other_info_array: HASH_TABLE [PATTERN_INFO, PATTERN_ID]
		do
			pattern_id_counter.append (other.pattern_id_counter);
			other_info_array := other.info_array;
			from other_info_array.start until other_info_array.after loop
				info := other_info_array.item_for_iteration;
				other_info := item (info);
				if other_info = Void then
					pattern := info.pattern;
					other_pattern := patterns.item (pattern);
					if other_pattern = Void then
						patterns.put (pattern)
					else
						info.set_pattern (other_pattern)
					end;
					put (info);
					info.set_pattern_id (last_pattern_id);
					info_array.put (info, other_info_array.key_for_iteration)
				end;
				other_info_array.forth
			end;
			process
		end;

feature -- Generation

	generate is
			-- Generate patterns
		local
			id, i, nb: INTEGER;
		do
			Pattern_file.open_write;

			Pattern_file.putstring ("%
				%#include %"macros.h%"%N%
				%#include %"struct.h%"%N%
				%#include %"interp.h%"%N%N");

			generate_pattern;

				-- Generate pattern table
			Pattern_file.putstring ("struct p_interface fpattern[] = {%N")
			from
				i := 1;
				nb := c_pattern_id_counter.value;
			until
				i > nb
			loop
				Pattern_file.putstring ("{toc");
				Pattern_file.putint (i);
				Pattern_file.putstring (", (fnptr) toi");
				Pattern_file.putint (i);
				Pattern_file.putstring ("},%N");
				i := i + 1;
			end;
			Pattern_file.putstring ("};%N%N");

			Pattern_file.close;
		end;

	generate_pattern is
			-- Generate pattern for interfacing C generated code and
			-- the interpreter
		do
			from
				c_patterns.start
			until
				c_patterns.after
			loop
				c_patterns.item_for_iteration.generate_pattern;
				c_patterns.forth;
			end;
		end;

feature -- DLE

	dle_level: INTEGER;
			-- Last pattern id used in the static system

	init_dle is
			-- Keep track of the water-mark between the static
			-- and the dynamic systems.
		do
			dle_level := c_pattern_id_counter.value
		end;

	has_dle_patterns: BOOLEAN is
			-- Are there new patterns introduced in the DC-set?
		do
			Result := dle_level < c_pattern_id_counter.value
		end;

	generate_dle is
			-- Generate patterns
		require
			dynamic_system: System.is_dynamic
		local
			i, nb: INTEGER
		do
			Pattern_file.open_write;

			Pattern_file.putstring ("%
				%#include %"macros.h%"%N%
				%#include %"struct.h%"%N%
				%#include %"interp.h%"%N%N");

			generate_dle_pattern;
			nb := c_pattern_id_counter.value;

			Pattern_file.putstring ("void dle_epattern()");
			Pattern_file.new_line;
			Pattern_file.putchar ('{');
			Pattern_file.new_line;
			if has_dle_patterns then
				Pattern_file.indent;
				Pattern_file.putstring ("struct p_interface *interf;");
				Pattern_file.new_line;
				Pattern_file.new_line;
				Pattern_file.putstring 
						("pattern = (struct p_interface *)cmalloc(");
				Pattern_file.putint (nb);
				Pattern_file.putstring (" * sizeof(struct p_interface));");
				Pattern_file.new_line;
				Pattern_file.putstring 
						("if (pattern == (struct p_interface *) 0)");
				Pattern_file.new_line;
				Pattern_file.indent;
				Pattern_file.putstring ("enomem();");
				Pattern_file.new_line;
				Pattern_file.exdent;
				Pattern_file.putstring ("bcopy(fpattern, pattern, ");
				Pattern_file.putint (dle_level);
				Pattern_file.putstring (" * sizeof(struct p_interface));");
				Pattern_file.new_line;
				Pattern_file.new_line;

				from
					i := dle_level + 1
				until
					i > nb
				loop
					Pattern_file.putstring ("interf = &pattern[");
					Pattern_file.putint (i - 1);
					Pattern_file.putstring ("];");
					Pattern_file.new_line;
					Pattern_file.putstring ("interf->toc = toc");
					Pattern_file.putint (i);
					Pattern_file.putchar (';');
					Pattern_file.new_line;
					Pattern_file.putstring ("interf->toi = (fnptr) toi");
					Pattern_file.putint (i);
					Pattern_file.putchar (';');
					Pattern_file.new_line;
					i := i + 1
				end;
				Pattern_file.exdent
			end;
			Pattern_file.putstring ("}");
			Pattern_file.new_line;
			Pattern_file.new_line;

			Pattern_file.putstring ("void free_epattern()");
			Pattern_file.new_line;
			Pattern_file.putchar ('{');
			Pattern_file.new_line;
			if has_dle_patterns then
				Pattern_file.indent;
				Pattern_file.putstring ("xfree(pattern);");
				Pattern_file.new_line;
				Pattern_file.putstring ("pattern = fpattern;");
				Pattern_file.new_line;
				Pattern_file.exdent
			end;
			Pattern_file.putstring ("}");
			Pattern_file.new_line;

			Pattern_file.close
		end;

	generate_dle_pattern is
			-- Generate pattern for interfacing C generated code and
			-- the interpreter. Only the patterns which are not yet
			-- known by the static system are generated.
		require
			dynamic_system: System.is_dynamic
		local
			info: C_PATTERN_INFO
		do
			from
				c_patterns.start
			until
				c_patterns.after
			loop
				info := c_patterns.item_for_iteration;
				if info.c_pattern_id > dle_level then
					info.generate_pattern
				end;
				c_patterns.forth
			end
		end;

invariant

	patterns_exists: patterns /= Void;
	info_array_exists: info_array /= Void;

end
