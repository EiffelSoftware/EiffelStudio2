-- System level real body id counter.

class REAL_BODY_ID_COUNTER

inherit
	COMPILER_COUNTER
		redefine
			append
		end

creation
	make

feature -- Initialization

	append (other: like Current) is
			-- Append ids generated by `other' to `Current' and
			-- renumber the resulting set of ids.
		do
			{COMPILER_COUNTER} Precursor (other);
			nb_frozen_features := count;
		end

feature -- Levels

	nb_frozen_features: INTEGER;
			-- Melted/Frozen limit

feature -- Setting

	set_nb_frozen_features (i: INTEGER) is
			-- Set `nb_frozen_features' to `i'.
		do
			nb_frozen_features := i
		end

end -- class REAL_BODY_ID_COUNTER
