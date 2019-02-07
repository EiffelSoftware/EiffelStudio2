note

	description:

		"Eiffel binary expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"

deferred class ET_BINARY_EXPRESSION

inherit

	ET_EXPRESSION
		redefine
			is_instance_free
		end

feature -- Access

	left: ET_EXPRESSION
			-- Left-hand-side

	right: ET_EXPRESSION
			-- Right-hand-side

	position: ET_POSITION
			-- Position of first character of
			-- current node in source code
		do
			Result := left.position
		end

	first_leaf: ET_AST_LEAF
			-- First leaf node in current node
		do
			Result := left.first_leaf
		end

	last_leaf: ET_AST_LEAF
			-- Last leaf node in current node
		do
			Result := right.last_leaf
		end

feature -- Status report

	is_instance_free: BOOLEAN
			-- Does current expression not depend on 'Current' or its attributes?
			-- Note that we do not consider unqualified calls and Precursors as
			-- instance-free because it's not always possible syntactically
			-- to determine whether the feature being called is a class feature
			-- or not.
		do
			Result := left.is_instance_free and right.is_instance_free
		end

feature -- Setting

	set_left (a_left: like left)
			-- Set `left' to `a_left'.
		require
			a_left_not_void: a_left /= Void
		do
			left := a_left
		ensure
			left_set: left = a_left
		end

	set_right (a_right: like right)
			-- Set `right' to `a_right'.
		require
			a_right_not_void: a_right /= Void
		do
			right := a_right
		ensure
			right_set: right = a_right
		end

invariant

	left_not_void: left /= Void
	right_not_void: right /= Void

end
