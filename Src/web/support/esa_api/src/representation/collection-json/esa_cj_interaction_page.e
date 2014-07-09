note
	description: "Summary description for {ESA_CJ_INTERACTION_PAGE}."
	date: "$Date$"
	revision: "$Revision$"

class
	ESA_CJ_INTERACTION_PAGE


inherit

	ESA_TEMPLATE_PAGE

	SHARED_TEMPLATE_CONTEXT

create
	make

feature {NONE} --Initialization

	make (a_host: READABLE_STRING_GENERAL; a_form: ESA_INTERACTION_FORM_VIEW; a_user: detachable ANY;)
			-- Initialize `Current'.
		do
			log.write_information (generator + ".make render template: cj_interaction_form.tpl")
			set_template_folder (cj_path)
			set_template_file_name ("cj_interaction_form.tpl")
			template.add_value (a_host, "host")
			template.add_value (a_form.categories, "categories")
			template.add_value (a_form.status, "status")
			template.add_value (a_form, "form")
			template.add_value (a_form.report, "report")
			template.add_value (a_form.temporary_files,"uploaded_files")

			if a_form.id > 0 then
				template.add_value (a_form.id, "id")
			end

			if attached a_user then
				template.add_value (a_user, "user")
			end

			template_context.enable_verbose
			template.analyze
			template.get_output

				-- Workaround
			if attached template.output as l_output then
				l_output.replace_substring_all ("<", "{")
				l_output.replace_substring_all (">", "}")
				l_output.replace_substring_all ("},]", "}]")
				l_output.replace_substring_all (",]", "]")


				representation := l_output
				debug
					log.write_information (generator + ".make " + l_output)
				end
			end

		end
end
