note
	description: "Summary description for {DATA_THREAD_POOL_MANAGER}."
	legal: "See notice at end of class."
	status: "Pre-release"
	date: "$Date$"
	revision: "$Revision$"

class
	DATA_THREAD_POOL [G]

inherit
	THREAD_POOL [G]
		rename
			make as thread_pool_make
		redefine
			valid_action,
			initialize_threads
		end

create
	make

feature {NONE} -- Initialization

	make (n: NATURAL; a_target_spawner: FUNCTION [ANY, TUPLE, G])
			-- The targets are generated by the `a_target_spawner'.
			-- The maximal number of threads that can be spawned is stored in `n'.
			-- If this limit is reached, the requests are queued, until one of the threads is completed.
		require
			data_spawner_has_no_open_arguments: a_target_spawner.valid_operands (Void)
			n_positive: n > 0
			n_not_too_large: n < {INTEGER_32}.max_value.as_natural_32
		do
			target_spawner := a_target_spawner
			thread_pool_make (n)
		end

feature -- Status report

	valid_action (a_action: PROCEDURE [G, TUPLE]): BOOLEAN
			-- <Precursor>
		do
				-- We need at most one open operands of type G.
			Result := attached {PROCEDURE [G, TUPLE [G]]} a_action and then
				a_action.empty_operands.count = 1
		end

feature {NONE} -- Implementation: Access

	target_spawner: FUNCTION [ANY, TUPLE, G]
			-- Spawns new targets for work

	initialize_threads
			-- <Precursor>
			-- Added target set for reuse of target
		local
			i: NATURAL
			thread: POOLED_THREAD [G]
		do
			from
				i := 1
			until
				i > capacity
			loop
				create thread.make (Current, work_semaphore)
				thread.set_target (target_spawner.item (Void))
				thread.launch
				i := i + 1
			end
		end

end
