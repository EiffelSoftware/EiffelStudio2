indexing

	description:
		"Priority queues implemented as sorted lists";

	status: "See notice at end of class";
	names: priority_queue, queue;
	contents: generic;
	date: "$Date$";
	revision: "$Revision$"

class LINKED_PRIORITY_QUEUE [G -> COMPARABLE]

inherit
	PRIORITY_QUEUE [G]
		undefine
			consistent, copy, is_equal, setup,
			prune_all, append, readable, writable
		select
			put, remove, item
		end

	SORTED_TWO_WAY_LIST [G]
		rename
			make as sl_make,
			remove as sl_remove,
			put as sl_put,
			item as sl_item
		export
			{NONE}
				all
		end

creation
	make

feature -- Initialization

	make is
			-- Allocate heap space.
		do
			sl_make ;
		end;

feature -- Access

	item: G is
			-- Entry at top of heap.
		do
			Result := i_th (count)
		end;

feature -- Removal

	remove is
			-- Remove item of highest value.
		do
			go_i_th (count)
			sl_remove
			go_i_th (count)
		end;

feature -- Element change

	put (v: like item) is
			-- Insert item `v' at its proper position.
		do
			extend (v)
		end;


end -- class LINKED_PRIORITY_QUEUE

--|----------------------------------------------------------------
--| EiffelBase: library of reusable components for ISE Eiffel.
--| Copyright (C) 1986-1997 Interactive Software Engineering Inc.
--| All rights reserved. Duplication and distribution prohibited.
--| May be used only with ISE Eiffel, under terms of user license. 
--| Contact ISE for any other use.
--|
--| Interactive Software Engineering Inc.
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Electronic mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--| For latest info see award-winning pages: http://www.eiffel.com
--|----------------------------------------------------------------
