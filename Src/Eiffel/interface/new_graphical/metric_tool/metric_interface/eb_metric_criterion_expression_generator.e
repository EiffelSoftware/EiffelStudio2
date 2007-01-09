indexing
	description: "Criterion expression generator"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_METRIC_CRITERION_EXPRESSION_GENERATOR

inherit
	EB_METRIC_VISITOR
		export
			{NONE}all
		end

	EB_METRIC_EXPRESSION_GENERATOR

	EB_METRIC_INTERFACE_PROVIDER

create
	make

feature -- Process

	set_criterion (a_criterion: like criterion) is
			-- Set `criterion' with `a_criterion'.
		do
			criterion := a_criterion
		ensure
			criterion_set: criterion = a_criterion
		end

	generate_expression is
			-- Generate `text_list' and `format_list' for `criterion'.
		do
			reset
			if criterion /= Void then
				criterion.process (Current)
			end
		end

feature -- Access

	criterion: EB_METRIC_CRITERION
			-- Criterion whose expression is to be generated

feature{NONE} -- Process

	process_basic_metric (a_basic_metric: EB_METRIC_BASIC) is
			-- Process `a_basic_metric'.
		do
			check
				should_not_arrive_here: False
			end
		end

	process_linear_metric (a_linear_metric: EB_METRIC_LINEAR) is
			-- Process `a_linear_metric'.
		do
			check
				should_not_arrive_here: False
			end
		end

	process_ratio_metric (a_ratio_metric: EB_METRIC_RATIO) is
			-- Process `a_ratio_metric'.
		do
			check
				should_not_arrive_here: False
			end
		end

	process_criterion (a_criterion: EB_METRIC_CRITERION) is
			-- Process `a_criterion'.
		do
		end

	process_domain_criterion (a_criterion: EB_METRIC_DOMAIN_CRITERION) is
			-- Process `a_criterion'.
		local
			l_format: EV_CHARACTER_FORMAT
		do
			check a_criterion.is_name_valid end
			append_negation_start (a_criterion)
			text_list.extend (a_criterion.name)
			l_format := normal_format
			format_list.extend (criterion_name_format)
			text_list.extend (" (")
			format_list.extend (l_format)
			append_domain (a_criterion.domain)
			text_list.extend (")")
			format_list.extend (normal_format)
			append_negation_end (a_criterion)
		end

	process_caller_callee_criterion (a_criterion: EB_METRIC_CALLER_CALLEE_CRITERION) is
			-- Process `a_criterion'.
		do
			process_domain_criterion (a_criterion)
		end

	process_supplier_client_criterion (a_criterion: EB_METRIC_SUPPLIER_CLIENT_CRITERION) is
			-- Process `a_criterion'.
		do
			process_domain_criterion (a_criterion)
		end

	process_text_criterion (a_criterion: EB_METRIC_TEXT_CRITERION) is
			-- Process `a_criterion'.
		do
			check a_criterion.is_name_valid end
			append_negation_start (a_criterion)
			text_list.extend (a_criterion.name + " ")
			format_list.extend (criterion_name_format)
			text_list.extend ("%""+ a_criterion.text + "%"")
			format_list.extend (string_format)
			append_negation_end (a_criterion)
		end

	process_path_criterion (a_criterion: EB_METRIC_PATH_CRITERION) is
			-- Process `a_criterion'.
		do
			process_text_criterion (a_criterion)
		end

	process_normal_criterion (a_criterion: EB_METRIC_NORMAL_CRITERION) is
			-- Process `a_criterion'.
		do
			if a_criterion.is_name_valid then
				append_negation_start (a_criterion)
				text_list.extend (a_criterion.name)
				format_list.extend (criterion_name_format)
				append_negation_end (a_criterion)
			else
				text_list.extend (a_criterion.name)
				format_list.extend (error_format)
			end
		end

	process_value_criterion (a_criterion: EB_METRIC_VALUE_CRITERION) is
			-- Process `a_criterion'.
		do
			text_list.extend ("value of metric (")
			format_list.extend (normal_format)
			text_list.extend (a_criterion.metric_name)
			format_list.extend (normal_format)
			text_list.extend (") over (")
			format_list.extend (normal_format)
			append_domain (a_criterion.domain)
			text_list.extend (") ")
			text_list.extend (") is ")
			format_list.extend (normal_format)
			a_criterion.value_tester.process (Current)
		end

	process_nary_criterion (a_criterion: EB_METRIC_NARY_CRITERION) is
			-- Process `a_criterion'.
		local
			l_para_needed: BOOLEAN
			l_count: INTEGER
			l_operands: LIST [EB_METRIC_CRITERION]
		do
			check a_criterion.is_name_valid end
			l_para_needed := a_criterion.operands.count > 1
			append_negation_start (a_criterion)
			if l_para_needed then
				text_list.extend ("(")
				format_list.extend (normal_format)
			end
			from
				l_operands := a_criterion.operands
				l_count := l_operands.count
				l_operands.start
			until
				l_operands.after
			loop
				if
					l_para_needed and then
					(l_operands.item.is_and_criterion or l_operands.item.is_or_criterion)
				then
					text_list.extend ("(")
					format_list.extend (normal_format)
				end
				l_operands.item.process (Current)
				if
					l_para_needed and then
					(l_operands.item.is_and_criterion or l_operands.item.is_or_criterion)
				then
					text_list.extend (")")
					format_list.extend (normal_format)
				end
				if l_operands.index < l_count then
					text_list.extend (" " + a_criterion.name + " ")
					format_list.extend (criterion_name_format)
				end
				a_criterion.operands.forth
			end
			if l_para_needed then
				text_list.extend (")")
				format_list.extend (normal_format)
			end
			append_negation_end (a_criterion)
		end

	process_and_criterion (a_criterion: EB_METRIC_AND_CRITERION) is
			-- Process `a_criterion'.
		do
			process_nary_criterion (a_criterion)
		end

	process_or_criterion (a_criterion: EB_METRIC_OR_CRITERION) is
			-- Process `a_criterion'.
		do
			process_nary_criterion (a_criterion)
		end

	process_domain (a_domain: EB_METRIC_DOMAIN) is
			-- Process `a_domain'.
		do
		end

	process_domain_item (a_item: EB_METRIC_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			text_list.extend (a_item.string_representation)
			if not a_item.is_valid then
				format_list.extend (error_format)
			else
				if last_domain_item_format = Void then
					format_list.extend (normal_format)
				else
					format_list.extend (last_domain_item_format)
				end
			end
		end

	process_application_target_domain_item (a_item: EB_METRIC_TARGET_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			last_domain_item_format := normal_format
			process_domain_item (a_item)
		end

	process_group_domain_item (a_item: EB_METRIC_GROUP_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			last_domain_item_format := group_format
			process_domain_item (a_item)
		end

	process_folder_domain_item (a_item: EB_METRIC_FOLDER_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			last_domain_item_format := group_format
			process_domain_item (a_item)
		end

	process_class_domain_item (a_item: EB_METRIC_CLASS_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			last_domain_item_format := class_format
			process_domain_item (a_item)
		end

	process_feature_domain_item (a_item: EB_METRIC_FEATURE_DOMAIN_ITEM) is
			-- Process `a_item'.
		local
			l_class_domain_item: EB_METRIC_CLASS_DOMAIN_ITEM
		do
			if not a_item.is_valid then
				text_list.extend (a_item.string_representation)
				format_list.extend (error_format)
			else
				text_list.extend (ti_l_curly)
				format_list.extend (operator_format)
				process_class_domain_item (create {EB_METRIC_CLASS_DOMAIN_ITEM}.make (id_of_class (a_item.ql_feature.class_c.lace_class.config_class)))
				text_list.extend (ti_r_curly)
				format_list.extend (operator_format)
				text_list.extend (ti_dot)
				format_list.extend (operator_format)
				last_domain_item_format := feature_format
				process_domain_item (a_item)
			end
		end

	process_delayed_domain_item (a_item: EB_METRIC_DELAYED_DOMAIN_ITEM) is
			-- Process `a_item'.
		do
			last_domain_item_format := normal_format
			process_domain_item (a_item)
		end

	process_metric_archive_node (a_item: EB_METRIC_ARCHIVE_NODE) is
			-- Process `a_item'.
		do
		end

	process_value_tester (a_item: EB_METRIC_VALUE_TESTER) is
			-- Process `a_item'.
		local
			l_cri_list: LIST [TUPLE [l_value: DOUBLE; l_criterion_type: INTEGER]]
			l_count: INTEGER
			l_connector: STRING
		do
			text_list.extend ("(")
			format_list.extend (normal_format)
			if a_item.is_anded then
				l_connector := query_language_names.ql_cri_and
			else
				l_connector := query_language_names.ql_cri_or
			end
			from
				l_cri_list := a_item.criteria
				l_count := l_cri_list.count
				l_cri_list.start
			until
				l_cri_list.after
			loop
				text_list.extend (operator_table.item (l_cri_list.item.l_criterion_type))
				format_list.extend (operator_format)
				text_list.extend (l_cri_list.item.l_value.out)
				format_list.extend (number_format)
				if l_cri_list.index < l_count then
					text_list.extend (" ")
					format_list.extend (normal_format)
					text_list.extend (l_connector)
					format_list.extend (keyword_format)
					text_list.extend (" ")
					format_list.extend (normal_format)
				end
				l_cri_list.forth
			end
			text_list.extend (")")
			format_list.extend (normal_format)
		end

feature{NONE} -- Implementation

	append_negation_start (a_criterion: EB_METRIC_CRITERION) is
			-- Append negation for `a_criterion'.
		require
			a_criterion_attached: a_criterion /= Void
			name_of_a_criterion_is_valid: a_criterion.is_name_valid
		do
			if a_criterion.is_negation_used then
				text_list.extend ("(")
				format_list.extend (normal_format)
				text_list.extend ("not ")
				format_list.extend (keyword_format)
			end
		end

	append_negation_end (a_criterion: EB_METRIC_CRITERION) is
			-- Append negation end.
		require
			a_criterion_attached: a_criterion /= Void
			name_of_a_criterion_is_valid: a_criterion.is_name_valid
		do
			if a_criterion.is_negation_used then
				text_list.extend (")")
				format_list.extend (normal_format)
			end
		end

	last_domain_item_format: EV_CHARACTER_FORMAT
			-- Last domain item format

	criterion_name_format: EV_CHARACTER_FORMAT is
			-- Criterion name format
		do
			create Result.make_with_font_and_color (normal_font, normal_color, background_color)
		ensure
			result_attached: Result /= Void
		end

	append_domain (a_domain: EB_METRIC_DOMAIN) is
			-- Append `a_domain' into text.
		require
			a_domain_attached: a_domain /= Void
		local
			l_count: INTEGER
		do
			from
				l_count := a_domain.count
				a_domain.start
			until
				a_domain.after
			loop
				if a_domain.item /= Void then
					a_domain.item.process (Current)
				end
				if a_domain.index < l_count then
					text_list.extend (", ")
					format_list.extend (normal_format)
				end
				a_domain.forth
			end
		end

invariant
	text_list_attached: text_list /= Void
	format_list_attached: format_list /= Void

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


end
