indexing
	description:
		"Dynamically expandable tree items"
	status: "See notice at end of file"
	author: "Mark Howard"
	date: "11/4/1999"
	revision: "$Revision$"

class
	EV_DYNAMIC_TREE_ITEM [G]

inherit
	EV_TREE_ITEM
		redefine
			data
		end
		
creation
	default_create

feature -- Initialization

	set_dynamic (a_expand: like expand_agent; a_data: G) is
		require
			in_tree: parent_tree /= Void
		local
			t_item: EV_TREE_ITEM
		do
			expand_agent := a_expand
			if expand_agent /= Void then
				create t_item
				t_item.set_text ("to_be_expanded")
				extend (t_item)
				expand_actions.extend (~expand_node)
			end
			data := a_data
		end

feature -- Access

	data: G

feature {NONE} -- Implementation

	expand_agent: PROCEDURE [ANY, TUPLE [like Current]]
		-- Agent used to create create child items.

	expand_node is
		local
			a_counter: INTEGER
			temp_count: INTEGER
		do
			--| FIXME IEK Add wipe_out when bug is fixed.
			--wipe_out
			from
				start
			until
				count = 1 or off
			loop
				remove
			end
			expand_agent.call ([Current])
			start
			remove
		end

end -- class EV_DYNAMIC_TREE_ITEM
