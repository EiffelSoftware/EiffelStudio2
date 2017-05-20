note
	description: "Pattern matchers"
	copyright: "Copyright (c) 2002-2017, Eric Bezault, Eiffel Software and others"
	license: "MIT License"

deferred class
	PATTERN_MATCHER

feature -- Compilation

	compile (a_pattern: READABLE_STRING_8)
			-- Compile `a_pattern'. Set `is_compiled'
			-- to True after successful compilation.
		deferred
		ensure
			not_matched: not has_matched
			not_matching: not is_matching
		end

feature -- Resetting

	reset
			-- Reset the pattern.
		deferred
		ensure
			not_compiled: not is_compiled
			not_matched: not has_matched
			not_matching: not is_matching
		end

	wipe_out
			-- Get rid of last match.
		do
			match_count := 0
			subject_start := 1
			subject_end := 0
			subject := no_subject
		ensure
			not_matched: not has_matched
			not_matching: not is_matching
		end

feature -- Status report

	is_compiled: BOOLEAN
			-- Has pattern been sucessfully compiled?
		deferred
		end

	is_matching: BOOLEAN
			-- Have matching routines already been called?
			-- (i.e. is there a subject available?)
		do
			Result := subject /= no_subject
		end

	has_matched: BOOLEAN
			-- Was the last match attempt successful?
		do
			Result := match_count > 0
		ensure
			definition: Result = (match_count > 0)
		end

	is_captured_substring_defined (n: NATURAL): BOOLEAN
			-- Is the `n'-th captured substring defined?
			-- 'n = 0' represents the whole matched string.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		do
			Result := captured_start_position (n) > 0
		ensure
			captured_substring_empty: not Result implies is_captured_substring_empty (n)
		end

	is_captured_substring_empty (n: NATURAL): BOOLEAN
			-- Is the `n'-th captured substring empty?
			-- 'n = 0' represents the whole matched string.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		do
			Result := captured_start_position (n) > captured_end_position (n).as_natural_32
		end

	matches (a_subject: READABLE_STRING_8): BOOLEAN
			-- Does `a_subject' include a token of the language
			-- described by current pattern?
		require
			compiled: is_compiled
		do
			match (a_subject)
			Result := has_matched
		ensure
			is_matching: is_matching
			subject_set: subject = a_subject
			subject_start_set: subject_start = 1
			subject_end_set: subject_end = a_subject.count.as_natural_32
		end

	recognizes (a_subject: READABLE_STRING_8): BOOLEAN
			-- Is `a_subject' a token of the language
			-- described by current pattern?
		require
			compiled: is_compiled
		do
			match (a_subject)
			if has_matched then
				Result := captured_start_position (0) = {NATURAL_32} 1 and captured_end_position (0) = a_subject.count
			end
		ensure
			is_matching: is_matching
			subject_set: subject = a_subject
			subject_start_set: subject_start = 1
			subject_end_set: subject_end = a_subject.count.as_natural_32
			definition: Result = (has_matched and then (captured_start_position (0) = 1 and captured_end_position (0) = a_subject.count))
		end

feature -- Access

	subject: STRING
			-- Last input string passed to the matcher

	subject_start: NATURAL
			-- Index of first character in `subject' to be read by the matcher
			-- (Anchored expressions only matches at this point even on
			-- repeated matches.)

	subject_end: NATURAL
			-- Index of last character in `subject' to be read by the matcher

	match_count: NATURAL
			-- Number of matched pattern and subpatterns;
			-- Result > 1 implies that captured substrings have been matched

	captured_start_position (n: NATURAL): NATURAL
			-- Start position of the `n'-th captured substring;
			-- 'n = 0' represents the whole matched string.
			-- Return 0 if undefined captured substring.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		deferred
		ensure
			position_large_enough: Result /= 0 implies Result >= subject_start
				-- The or-branch is the consequence of empty matches at the end of a subject:
			position_small_enough: (Result <= subject_end) or (Result = subject_end + 1 and
						(
							captured_end_position (n) /= -1) and then
							(captured_end_position (n).as_natural_32 = subject_end)
						)
		end

	captured_end_position (n: NATURAL): INTEGER_32
			-- End position of the `n'-th captured substring;
			-- 'n = 0' represents the whole matched string.
			-- Return -1 if undefined captured substring.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		deferred
		ensure
			position_large_enough: Result >= -1
			position_small_enough: Result <= subject_end.as_integer_32
		end

	captured_substring_count (n: NATURAL): NATURAL
			-- Size of `n'-th captured substring;
			-- 'n = 0' represents the whole matched string.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		local
			i: NATURAL
			nb: INTEGER_32
		do
			i := captured_start_position (n)
			nb := captured_end_position (n)
			if i >= 1 and nb <= subject.count then
				Result := nb.as_natural_32 - i + 1
			else
				Result := 0
			end
		ensure
			count_not_negative: Result >= 0
		end

	captured_substring (n: NATURAL): STRING
			-- `n'-th captured substring;
			-- 'n = 0' represents the whole matched string.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		local
			i: NATURAL
			nb: INTEGER_32
		do
			i := captured_start_position (n)
			nb := captured_end_position (n)
			if i >= 1 and nb <= subject.count then
				Result := subject.substring (i.as_integer_32, nb)
			else
				Result := subject.substring (1, 0)
			end
		ensure
			captured_substring_not_void: Result /= Void
		end

feature -- Element change

	append_captured_substring_to_string (a_string: STRING; n: NATURAL)
			-- Append `n'-th captured substring to `a_string';
			-- 'n = 0' represents the whole matched string.
		require
			has_matched: has_matched
			n_large_enough: n >= 0
			n_small_enough: n < match_count
		local
			i: NATURAL
			nb: INTEGER_32
		do
			i := captured_start_position (n)
			nb := captured_end_position (n)
			if i >= 1 and nb <= subject.count then
				a_string.append_string (subject.substring (i.as_integer_32, nb))
			end
		end

feature -- Matching

	match (a_subject: READABLE_STRING_8)
			-- Try to match `a_subject' with the current pattern.
			-- Make result available in `has_matched' and the various
			-- `*_captured_*' features.
		require
			compiled: is_compiled
		do
			match_substring (a_subject, 1, a_subject.count.as_natural_32)
		ensure
			is_matching: is_matching
			subject_set: subject.same_string (a_subject)
			subject_start_set: subject_start = 1
			subject_end_set: subject_end = a_subject.count.as_natural_32
		end

	match_substring (a_subject: READABLE_STRING_8; a_from, a_to: NATURAL)
			-- Try to match the substring of `a_subject' between
			-- positions `a_from' and `a_to' with the current pattern.
			-- Make result available in `has_matched' and the various
			-- `*_captured_*' features.
		require
			compiled: is_compiled
			a_from_large_enough: a_from >= 1
			a_to_small_enough: a_to <= a_subject.count.as_natural_32
			valid_bounds: a_from <= a_to + 1
		deferred
		ensure
			is_matching: is_matching
			subject_set: subject.same_string (a_subject)
			subject_start_set: subject_start = a_from
			subject_end_set: subject_end = a_to
		end

	match_unbounded_substring (a_subject: READABLE_STRING_8; a_from, a_to: NATURAL)
			-- Try to match the substring of `a_subject' between
			-- positions `a_from' and `a_to' with the current pattern.
			-- Make result available in `has_matched' and the various
			-- `*_captured_*' features.
			--
			-- Note that if `a_from' is not 1, then ^ will not match at position `a_from'.
			-- And if `a_to' is not `a_subject.count' then $ will not match at position `a_to'.
		require
			compiled: is_compiled
			a_from_large_enough: a_from >= 1
			a_to_small_enough: a_to <= a_subject.count.as_natural_32
			valid_bounds: a_from <= a_to + 1
		deferred
		ensure
			is_matching: is_matching
			subject_set: subject.same_string (a_subject)
			subject_start_set: subject_start = a_from
			subject_end_set: subject_end = a_to
		end

feature {NONE} -- Implementation

	no_subject: STRING = ""
			-- No subject marker

invariant
	is_matching_constraint: is_matching implies is_compiled
	has_matched_constraint: has_matched implies is_matching
	subject_not_void: subject /= Void
	subject_start_large_enough: subject_start >= 1
	subject_end_small_enough: subject_end <= subject.count.as_natural_32
	valid_subject_bounds: subject_start <= subject_end + 1
	match_count_positive: match_count >= 0

end
