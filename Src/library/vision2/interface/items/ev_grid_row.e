indexing
	description: "Representation of a row of an EV_GRID"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_GRID_ROW

inherit
	REFACTORING_HELPER
	
	EV_GRID_ROW_ACTION_SEQUENCES
	
-- EV_SELECTABLE

create {EV_GRID_I}
	make_with_grid_i

feature {NONE} -- Initialization

	make_with_grid_i (a_grid_i: EV_GRID_I) is
			-- Make `Current' associated with `a_grid_i'
		require
			a_grid_i_not_void: a_grid_i /= Void
		do
			parent_grid_i := a_grid_i
		ensure
			parent_grid_i = a_grid_i
		end

feature -- Access

	subrow (i: INTEGER): EV_GRID_ROW is
			-- `i'-th child of Current
		require
			is_parented: parent /= Void
			i_positive: i > 0
			i_less_than_subrow_count: i <= subrow_count
		do
			to_implement ("EV_GRID_ROW.subrow")
		ensure
			subrow_not_void: Result /= Void
			subrow_valid: (Result.parent /= Void) and then has_subrow (Result) and then Result.parent_row = Current
		end

	has_subrow (a_row: EV_GRID_ROW): BOOLEAN is
			-- Is `a_row' a child of Current?
		require
			a_row_not_void: a_row /= Void
		do
			to_implement ("EV_GRID_ROW.has_subrow")
		ensure
			has_subrow_same_parent: Result implies
				((a_row.parent /= Void and parent /= Void) and then a_row.parent = parent)
		end

	parent_row: EV_GRID_ROW is
			-- Parent of Current if any, Void otherwise
		do
			to_implement ("EV_GRID_ROW.parent_row")
		ensure
			has_parent: Result /= Void implies Result.has_subrow (Current)
		end

	parent: EV_GRID is
			-- Grid to which current row belongs
		do
			if parent_grid_i /= Void then
				Result := parent_grid_i.interface
			end
		end

	item (i: INTEGER): EV_GRID_ITEM is
			-- Item at `i'-th column
		require
			i_within_bounds: i > 0 and i <= count
		do
			to_implement ("EV_GRID_ROW.item")
		ensure
			item_not_void: Result /= Void
		end
		
	selected_items: ARRAYED_LIST [EV_GRID_ITEM] is
			-- All items selected in `Current'.
		do
			to_implement ("EV_GRID_ROW.selected_items")
		ensure
			result_not_void: Result /= Void
		end
		
	is_expanded: BOOLEAN is
			-- Are subrows of `Current' displayed?
		do
			to_implement ("EV_GRID_ROW.is_expanded")
		end
		
	height: INTEGER is
			-- Height of `Current'.
		do
			to_implement ("EV_GRID_ROW.height")
		ensure
			result_not_negative: Result >= 0
		end

feature -- Status report

	subrow_count: INTEGER is
			-- Number of children
		require
			is_parented: parent /= Void
		do
			to_implement ("EV_GRID_ROW.subrow_count")
		ensure
			subrow_count_non_negative: subrow_count >= 0
			subrow_count_in_range: subrow_count <= (parent.row_count - index)
		end

	index: INTEGER is
			-- Position of Current in `parent'
		require
			is_parented: parent /= Void
		do
			to_implement ("EV_GRID_ROW.index")
		ensure
			index_positive: Result > 0
			index_less_than_row_count: Result <= parent.row_count
		end

	count: INTEGER is
			-- Number of items in current
		do
			to_implement ("EV_GRID_ROW.count")
		ensure
			count_positive: count > 0
		end
		
feature -- Status setting

	expand is
			-- Display all subrows of `Current'.
		require
			has_subrows: subrow_count > 0
		do
			to_implement ("EV_GRID_ROW.expand")
		ensure
			is_expanded: is_expanded
		end
		
	collapse is
			-- Hide all subrows of `Current'.
		do
			to_implement ("EV_GRID_ROW.collapse")
		ensure
			not_is_expanded: not is_expanded
		end
		
	set_height (a_height: INTEGER) is
			-- Assign `a_height' to `height'.
		do
			to_implement ("EV_GRID_ROW.set_height")
		ensure
			height_set: height = a_height
		end

feature -- Element change

	set_item (i: INTEGER; a_item: EV_GRID_ITEM) is
			-- Set item at `i'-th column to be `a_item'
		require
			i_positive: i > 0
			a_item_not_void: a_item /= Void
		do
			to_implement ("EV_GRID_ROW.set_item")
		ensure
			item_set: item (i) = a_item
		end

	add_subrow (a_row: EV_GRID_ROW) is
			-- Make `a_row' a child of Current
		require
			a_row_not_void: a_row /= Void
			a_row_is_parented: a_row.parent /= Void
			a_row_is_not_current: a_row /= Current
			a_row_is_not_a_subrow: a_row.parent_row = Void
			current_is_parented: parent /= Void
			same_parent: a_row.parent = parent
			parent_enabled_as_tree: parent.is_tree_enabled
			a_row_is_below_current: a_row.index > index
			valid_parent: parent.row (a_row.index - 1) = Current or
				True -- for (i in index .. a_row.index - 1) there exists i where
				-- parent.row (i).parent_row = Current
		do
			to_implement ("EV_GRID_ROW.add_subrow")
		ensure
			added: a_row.parent_row = Current
			subrow (subrow_count) = a_row
		end

	set_background_color (a_color: EV_COLOR) is
			-- Set `a_color' to all items in Current
		require
			a_color_not_void: a_color /= Void
		do
			to_implement ("EV_GRID_ROW.set_background_color")
		ensure
			--color_set: forall (item(i).background_color  = a_color)
		end

feature {EV_GRID_I, EV_GRID_DRAWER_I} -- Implementation

	set_parent_grid_i (a_parent_grid_i: EV_GRID_I) is
			-- Set `parent_grid_i' to `a_parent_grid_i'
		require
			a_parent_grid_i_not_void: a_parent_grid_i /= Void
		do
			parent_grid_i := a_parent_grid_i
		ensure
			parent_grid_i_set: parent_grid_i = a_parent_grid_i
		end

	parent_grid_i: EV_GRID_I
		-- Grid that `Current' resides in.
		
invariant
	no_subrows_implies_not_expanded: subrow_count = 0 implies not is_expanded

end

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------
