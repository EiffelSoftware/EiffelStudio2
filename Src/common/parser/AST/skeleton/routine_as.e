indexing

	description: "Abstract description of the content of a standard feature.";
	date: "$Date$";
	revision: "$Revision$"

class ROUTINE_AS

inherit

	CONTENT_AS
		redefine
			is_require_else, is_ensure_then, has_rescue,
			has_precondition, has_postcondition
		end;

feature -- Properties

	body_start_position: INTEGER;
			-- Position at the start of the main body (after the comments)

	obsolete_message: STRING_AS;
			-- Obsolete clause message
			-- (Void if was not present)

	precondition: REQUIRE_AS;
			-- Precondition list

	locals: EIFFEL_LIST [TYPE_DEC_AS];
			-- Local declarations

	routine_body: ROUT_BODY_AS;
			-- Routine body

	postcondition: ENSURE_AS;
			-- Routine postconditions

	rescue_clause: EIFFEL_LIST [INSTRUCTION_AS];
			-- Rescue compound

feature -- Initialization

	set is
			-- Yacc initialization
		do
			obsolete_message ?= yacc_arg (0);
			precondition ?= yacc_arg (1);
			locals ?= yacc_arg (2);
			routine_body ?= yacc_arg (3);
			postcondition ?= yacc_arg (4);
			rescue_clause ?= yacc_arg (5);
			body_start_position := yacc_int_arg (0);
		ensure then
			routine_body /= Void
		end;

feature -- Conveniences

	is_require_else: BOOLEAN is
			-- Is the precondition block of the content preceeded by
			-- `require else' ?
			--|Note: It is valid to not include a precondition in 
			--|a redefined feature (it is equivalent to "require else False")
		do
			Result := precondition = Void or else precondition.is_else;
		end;

	is_ensure_then: BOOLEAN is
			-- Is the postcondition block of the content preceeded by
			-- `ensure then' ?
			--|Note: It is valid to not include a postcondition in 
			--|a redefined feature (it is equivalent to "ensure then True"
		do
			Result := postcondition = Void or else postcondition.is_then;
		end;

	has_precondition: BOOLEAN is
			-- Has the routine content a preconditions ?
		do
			Result := not (	precondition = Void
							or else
							precondition.assertions = Void)
		end;

	has_postcondition: BOOLEAN is
			-- Has the routine content postconditions ?
		do
			Result := not (	postcondition = Void
							or else
							postcondition.assertions = Void)
		end;

	has_rescue: BOOLEAN is
			-- Has the routine a rescue clause ?
		do
			Result := rescue_clause /= Void;
		end;

	is_deferred: BOOLEAN is
			-- Is the routine body a deferred one ?
		do
			Result := routine_body.is_deferred;
		end;

	is_once: BOOLEAN is
			-- Is the routine body a once one ?
		do
			Result := routine_body.is_once;
		end;

	is_external: BOOLEAN is
			-- Is the routine body an external one ?
		do
			Result := routine_body.is_external;
		end;

	has_instruction (i: INSTRUCTION_AS): BOOLEAN is
			-- Does this routine has instruction `i'?
		do
			Result := routine_body.has_instruction (i)
		end;

	index_of_instruction (i: INSTRUCTION_AS): INTEGER is
			-- Index of `i' in this routine.
		do	
			Result := routine_body.index_of_instruction (i)
		end;

feature -- Equivalent

	is_body_equiv (other: like Current): BOOLEAN is
			-- Is the current feature equivalent to `other' ?
		require else
			valid_other: other /= Void
		do
			reset_locals;
			other.reset_locals;
			Result :=	deep_equal (routine_body, other.routine_body) and then
						deep_equal (locals, other.locals) and then
						deep_equal (rescue_clause, other.rescue_clause) and then
						deep_equal (obsolete_message, other.obsolete_message)
		end;
 
	is_assertion_equiv (other: like Current): BOOLEAN is
			-- Is the current feature equivalent to `other' ?
		require else
			valid_other: other /= Void
		do
			reset_assertions;
			other.reset_assertions;
			Result :=   deep_equal (precondition, other.precondition) and then
				deep_equal (postcondition, other.postcondition)
		end;

	reset_locals is
			-- Reset the positions in the list
		do
			if locals /= Void then
				from
					locals.start
				until
					locals.after
				loop
					locals.item.reset;
					locals.forth
				end;
				locals.start;
			end;
		end;

	reset_assertions is
		do
			if precondition /= Void then
				precondition.reset;
			end;
			if postcondition /= Void then
				postcondition.reset;
			end;
		end;

feature -- Simple formatting

	simple_format (ctxt: FORMAT_CONTEXT) is
			-- Reconstitute text.
		local
			comments: EIFFEL_COMMENTS
		do
			ctxt.put_space
			ctxt.put_text_item_without_tabs (ti_Is_keyword)
			ctxt.new_line

			if obsolete_message /= Void then
				ctxt.indent
				ctxt.put_text_item (ti_Obsolete_keyword)
				ctxt.put_space
				obsolete_message.simple_format (ctxt)
				ctxt.new_line
				ctxt.exdent
			end

			comments := ctxt.feature_comments;
            if comments /= Void then
                ctxt.indent
                ctxt.indent
                ctxt.put_comments (comments)
                ctxt.exdent
                ctxt.exdent
            end;

			ctxt.indent;
			if precondition /= Void then
				precondition.simple_format (ctxt);
			end
			if locals /= Void then
				ctxt.put_text_item (ti_Local_keyword)
				ctxt.set_separator (ti_Semi_colon)
				ctxt.indent
				ctxt.set_new_line_between_tokens
				ctxt.new_line
				locals.simple_format (ctxt)
				ctxt.new_line;
				ctxt.exdent
			end
			if routine_body /= Void then
				routine_body.simple_format (ctxt)
			end
			if postcondition /= Void then
				postcondition.simple_format (ctxt);
			end
			if rescue_clause /= Void then
				ctxt.put_text_item (ti_Rescue_keyword)
				ctxt.indent
				ctxt.new_line
				rescue_clause.simple_format (ctxt)
				ctxt.new_line
				ctxt.exdent
			end;
			ctxt.put_text_item (ti_End_keyword)
			ctxt.exdent
		end;

feature	{ROUTINE_AS, FEATURE_AS, ROUTINE_MERGER, USER_CMD, CMD}  -- Replication and for flattening of a routine

	set_precondition (p: like precondition) is
		do
			precondition := p
		end;

	set_locals (l: like locals) is
		do
			locals := l
		end;

	set_routine_body (r: like routine_body) is
		require
			valid_arg: r /= Void
		do
			routine_body := r
		end;

	set_postcondition (p: like postcondition) is
		do
			postcondition := p
		end;

	set_rescue_clause (r: like rescue_clause) is
		do	
			rescue_clause := r
		end;

	set_obsolete_message (m: like obsolete_message) is
		do	
			obsolete_message := m
		end;

end -- class ROUTINE_AS
