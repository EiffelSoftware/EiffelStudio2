﻿note
	description: "[
			RULE #03: Undesirable comment content
			
			Under some circumstances it might be desirable
			to keep a certain language level. Imaginable cases
			include source code that will be visible to people
			outside the company or that will even be released
			publicly.
		]"
	author: "Samuel Schmid"
	date: "$Date$"
	revision: "$Revision$"

class
	CA_UNDESIRABLE_COMMENT_CONTENT_RULE

inherit
	CA_STANDARD_RULE

create
	make

feature {NONE} -- Initialization

	make (a_pref_manager: attached PREFERENCE_MANAGER)
		do
			make_with_defaults
			initialize_options (a_pref_manager)
		end

	initialize_options (a_pref_manager: attached PREFERENCE_MANAGER)
			-- Initializes the rule's preferences.
		local
			l_factory: BASIC_PREFERENCE_FACTORY
		do
			create l_factory

			bad_words_list := l_factory.new_string_list_preference_value (a_pref_manager,
				preference_namespace + ca_names.bad_words_list_option,
				default_bad_words_list)
			bad_words_list.set_default_value (default_bad_words_value)
			bad_words_list.set_description (ca_names.bad_words_list_option_description)
			bad_words_list.change_actions.extend (agent initialize_regex)

			case_sensitivity := l_factory.new_boolean_preference_value (a_pref_manager,
				preference_namespace + ca_names.case_sensitivity_option,
				default_case_sensitivity)
			case_sensitivity.set_default_value (default_case_sensitivity.out)
			case_sensitivity.set_description (ca_names.case_sensitivity_option_description)
			case_sensitivity.change_actions.extend (agent initialize_regex)

		end

	initialize_regex
			-- Initializes the regular expression for checking the comments.
		local
			l_regex_string: STRING
		do
			create l_regex_string.make_empty

			across bad_words_list.value_as_list_of_text as c loop
				if attached c.item as word then
					l_regex_string.append (word)
					l_regex_string.append_character ('|')
				end
			end

			l_regex_string.prune_all_trailing ('|')

			create r.make
			r.set_case_insensitive (not case_sensitivity.value)
			r.compile (l_regex_string)
		end

feature {NONE} -- Activation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
		do
			a_checker.add_class_pre_action (agent check_comments)
		end

feature {NONE} -- Rule checking

	check_comments (a_class: attached CLASS_AS)
		-- Checks for bad language in all the comments of `a_class'.
		local
			l_violation: CA_RULE_VIOLATION
			l_fix: CA_UNDESIRABLE_COMMENT_CONTENT_FIX
			l_comments: EIFFEL_COMMENTS
		do
			if not attached r then
				initialize_regex
			end

			if attached current_context.matchlist as l_matchlist then

				l_comments := l_matchlist.extract_comment (a_class.token_region (l_matchlist))

				across
					l_comments as l_comment
				loop
					if (r.matches (l_comment.item.content_32)) then
						create l_violation.make_with_rule (Current)
						l_violation.set_location (create {LOCATION_AS}.make (l_comment.item.line, l_comment.item.column, 0, 0, 0, 0, 0))
						l_violation.long_description_info.extend (l_comment.item.content_32)

						if attached {BREAK_AS} current_context.matchlist.item_by_position (l_comment.item.position) as l_break then
							create l_fix.make_with_break_and_regex (current_context.checking_class, l_break, r)
							l_violation.fixes.extend (l_fix)
						end

						violations.extend (l_violation)
					end
				end
			end
		end

feature -- Options

	bad_words_list: STRING_LIST_PREFERENCE

	default_bad_words_list: LIST[STRING_32]
		do
			Result := default_bad_words_value.split (';')
		end

	default_bad_words_value: STRING_32 = "fuck;shit"

	case_sensitivity: BOOLEAN_PREFERENCE

	default_case_sensitivity: BOOLEAN = False

feature -- Properties

	r: RX_PCRE_REGULAR_EXPRESSION

	name: STRING = "comment_content"
			-- <Precursor>

	title: STRING_32
		do
			Result := ca_names.undesirable_comment_content_title
		end

	id: STRING_32 = "CA037"

	description: STRING_32
		do
			Result := ca_names.undesirable_comment_content_description
		end

	format_violation_description (a_violation: attached CA_RULE_VIOLATION; a_formatter: attached TEXT_FORMATTER)
		do
			if attached {STRING_32} a_violation.long_description_info.first as l_comment_text then
				a_formatter.add_quoted_text (l_comment_text)
			end
		end
end
