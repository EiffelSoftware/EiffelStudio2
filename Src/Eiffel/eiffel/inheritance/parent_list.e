indexing
	legal: "See notice at end of class."
	status: "See notice at end of class."
-- Eiffel class generated by the 2.3 to 3 translator.

class PARENT_LIST

inherit
	FIXED_LIST [PARENT_C]

create
	make, make_filled

feature -- Merging parents

	merge_and_check_renamings (inherit_table: INHERIT_TABLE) is
			-- Go through each parents and merge them into `inherit_table'
			-- Check also the renaming clause of the parents
		local
			i, nb: INTEGER
		do
			from
					-- Add non-conforming parents to the list first.
					-- This will leave any features from conforming
					-- branches as the first item in the list which is
					-- the version we wish to take should the features be the same.
					-- We can then check to see if the parent is non-conforming, this
					-- will mean that it needs to be replicated as a conforming version
					-- is not present (see {INHERIT_FEAT}.process_features)
				--| FIXME IEK The ordering should not have a difference on compilation
				--| but the validity of redefined features seems to be checked after selection.
--				i := count - 1
				nb := count
			until
--				i < 0
				i = nb
			loop
				inherit_table.merge_features_of_parent_c (area [i])
					-- Renaming is checked during the merge.
				i := i + 1
--				i := i - 1
			end
		end

feature -- Validity

	check_validity2 is
			-- Check the redefine and select clause
		local
			i, nb: INTEGER
		do
			from
				nb := count
			until
				i = nb
			loop
				area [i].check_validity2
				i := i + 1
			end
		end

	check_validity4 is
			-- Check useless selection
		local
			l_area: SPECIAL [PARENT_C]
			i, nb: INTEGER
			p: PARENT_C
		do
			from
				l_area := area
				nb := count
			until
				i = nb
			loop
				p := l_area.item(i)
				if not (p.selecting = Void) then
					p.check_validity4
				end
				i := i + 1
			end
		end

	are_features_renamed: BOOLEAN is
			-- Are features explicitly renamed in `Current' list?
		local
			i, nb: INTEGER
		do
			from
				nb := count
			until
				i = nb
			loop
				Result := area [i].has_renaming
				if Result then
					i := nb
				else
					i := i + 1
				end
			end
		end

	is_explicitly_selecting (a_feature_name_id: INTEGER): BOOLEAN is
			-- Are the parents explicitly selecting `a_feature_name_id'?
		require
			good_argument: a_feature_name_id > 0
		local
			i, nb: INTEGER
		do
			from
				nb := count
			until
				Result or else i >= nb
			loop
				if not area [i].is_non_conforming then
						-- If there is a non-conforming branch then return True
						-- as the feature is implicitly selected.
					Result := area [i].is_selecting (a_feature_name_id)
				end
				i := i + 1
			end
		end

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

end -- class PARENT_LIST
