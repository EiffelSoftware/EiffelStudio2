note
	description: "Summary description for {ES_CLOUD_MODULE_ADMINISTRATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_CLOUD_MODULE_ADMINISTRATION

inherit
	CMS_MODULE_ADMINISTRATION [ES_CLOUD_MODULE]
		redefine
			setup_hooks,
			permissions
		end

	CMS_HOOK_AUTO_REGISTER

	CMS_HOOK_MENU_SYSTEM_ALTER

	CMS_HOOK_FORM_ALTER

	CMS_HOOK_RESPONSE_ALTER

create
	make

feature -- Security

	permissions: LIST [READABLE_STRING_8]
			-- List of permission ids, used by this module, and declared.
		do
			Result := Precursor
			Result.force ("admin es subscriptions")
			Result.force ("admin es plans")
			Result.force ("admin es organizations")
		end

feature {NONE} -- Router/administration

	setup_administration_router (a_router: WSF_ROUTER; a_api: CMS_API)
			-- <Precursor>
		local
			org_hlr: ES_CLOUD_ORGANIZATIONS_ADMIN_HANDLER
		do
			if attached module.es_cloud_api as l_es_cloud_api then
				create org_hlr.make (l_es_cloud_api)
				org_hlr.setup_router (a_router, "/cloud/organizations/")
				a_router.handle ("/cloud/subscriptions/", create {ES_CLOUD_SUBSCRIPTIONS_ADMIN_HANDLER}.make (l_es_cloud_api), a_router.methods_get_post)
				a_router.handle ("/cloud/installations/", create {ES_CLOUD_INSTALLATIONS_ADMIN_HANDLER}.make (l_es_cloud_api), a_router.methods_get_post)
				a_router.handle ("/cloud/plans/", create {ES_CLOUD_PLANS_ADMIN_HANDLER}.make (l_es_cloud_api), a_router.methods_get_post)
				a_router.handle ("/cloud/plans/{pid}", create {ES_CLOUD_PLANS_ADMIN_HANDLER}.make (l_es_cloud_api), a_router.methods_get_post)
			end
		end

feature -- Hooks configuration

	setup_hooks (a_hooks: CMS_HOOK_CORE_MANAGER)
			-- Module hooks configuration.
		do
			a_hooks.subscribe_to_menu_system_alter_hook (Current)
			a_hooks.subscribe_to_response_alter_hook (Current)
		end

	response_alter (a_response: CMS_RESPONSE)
		do
			module.response_alter (a_response)
			a_response.add_style (a_response.module_resource_url (Current, "/files/css/es_cloud-admin.css", Void), Void)
		end

	menu_system_alter (a_menu_system: CMS_MENU_SYSTEM; a_response: CMS_RESPONSE)
			-- Hook execution on collection of menu contained by `a_menu_system'
			-- for related response `a_response'.
		local
			lnk: CMS_LOCAL_LINK
		do
				 -- Add the link to the taxonomy to the main menu
			if a_response.has_permission ("admin subscriptions") then
				lnk := a_response.api.administration_link ("ES Subscriptions", "cloud/subscriptions/")
				a_menu_system.management_menu.extend_into (lnk, "Admin", a_response.api.administration_path_location (""))
				lnk := a_response.api.administration_link ("ES Plans", "cloud/plans/")
				a_menu_system.management_menu.extend_into (lnk, "Admin", a_response.api.administration_path_location (""))
				lnk := a_response.api.administration_link ("ES organizations", "cloud/organizations/")
				a_menu_system.management_menu.extend_into (lnk, "Admin", a_response.api.administration_path_location (""))

			end
		end

	form_alter (a_form: CMS_FORM; a_form_data: detachable WSF_FORM_DATA; a_response: CMS_RESPONSE)
			-- Hook execution on form `a_form' and its associated data `a_form_data',
			-- for related response `a_response'.
		local
			fset: WSF_FORM_FIELD_SET
			r: WSF_FORM_RADIO_INPUT
			num: WSF_FORM_NUMBER_INPUT
			exp: WSF_FORM_DATE_INPUT
			s: STRING
			l_submit: WSF_FORM_SUBMIT_INPUT
			l_user: detachable ES_CLOUD_USER
			l_sub: detachable ES_CLOUD_PLAN_SUBSCRIPTION
			l_plan: detachable ES_CLOUD_PLAN
		do
			if
				attached module.es_cloud_api as l_cloud_api and then
				attached a_form.id as l_form_id and then l_form_id.same_string ("edit-user")
			then
				if
					a_response.has_permission ("admin es subscriptions")
				then
					if
						attached a_form.fields_by_name ("user-id") as lst and then
						attached {WSF_FORM_HIDDEN_INPUT} lst.first as l_field and then
						attached l_field.default_value as l_user_id and then
						attached a_response.api.user_api.user_by_id_or_name (l_user_id) as u
					then
						create l_user.make (u)
						if a_form_data = Void then
							create fset.make
							fset.set_legend ("Subscription plan")
							l_sub := l_cloud_api.user_direct_subscription (l_user)
							if l_sub /= Void then
								l_plan := l_sub.plan
								create s.make_empty
								s.append ("<p>Current plan: <strong>" + html_encoded (l_plan.title_or_name) + "</strong>")
								if attached l_sub.expiration_date as dt then
									s.append (" until ")
									s.append (date_time_to_string (dt))
								end
								s.append ("</p>")
								fset.extend_html_text (s)
							end
							across
								l_cloud_api.plans as ic
							loop
								create r.make_with_value ("es-plan", ic.item.name.as_string_32)
								r.set_title (ic.item.title_or_name)
								if ic.item.same_plan (l_plan) then
									r.set_checked (True)
								end
								fset.extend (r)
							end
							create num.make ("es-plan-duration-in-month")
							num.set_min (0)
							num.set_max (5*12)
							num.set_step (0.5)
							num.set_label ("Additional time")
							num.set_size (3)
							num.set_description ("number of additional months.")
							fset.extend (num)


							create exp.make ("es-plan-expiration")
							exp.set_label ("Expiration date")
							exp.set_description ("Expiration date")
							if l_sub /= Void and then attached l_sub.expiration_date as l_exp_date then
								exp.set_description ("Current expiration date: " + l_exp_date.out + "%N")
							end
							fset.extend (exp)

							create l_submit.make_with_text ("op", "Save plan")
							fset.extend (l_submit)
							a_form.extend (fset)
							a_form.validation_actions.extend (agent (i_fd: WSF_FORM_DATA; i_user: ES_CLOUD_USER; i_sub: detachable ES_CLOUD_PLAN_SUBSCRIPTION; i_cloud_api: ES_CLOUD_API)
									local
										n: INTEGER
										orig: DATE_TIME
										dt: DATE_TIME
										y,mo: INTEGER
										nb_months: INTEGER
										nb_days: INTEGER
									do
											-- Only update plan, if validated via the [Save plan] button!
										if
											attached i_fd.string_item ("op") as l_op and then
											l_op.same_string ("Save plan") and then
											attached i_fd.string_item ("es-plan") as l_plan_name and then
											attached i_cloud_api.plan_by_name (l_plan_name) as l_new_plan
										then
											if attached i_fd.string_item ("es-plan-expiration") as s_exp and then attached yyyy_mm_dd_to_date (s_exp) as l_exp_date then
												i_cloud_api.subscribe_user_to_plan_until_date (i_user, l_new_plan, l_exp_date)
											else
												if
													attached i_fd.string_item ("es-plan-duration-in-month") as s_nb
												then
													if s_nb.is_integer then
														nb_months := s_nb.to_integer --months
													elseif s_nb.is_real then
														nb_days := (31 * s_nb.to_real).truncated_to_integer --days
													end
												end
												if i_sub /= Void and then i_sub.plan.same_plan (l_new_plan) then
													orig := i_sub.creation_date
													nb_days := nb_days + i_sub.days_remaining
												else
													create orig.make_now_utc
												end
												if nb_months > 0 then
													n := nb_months
													y := orig.year
													mo := orig.month + n
													if mo <= 12 then
													else
														y := y + mo // 12
														mo := mo \\ 12
													end
													create dt.make_by_date_time (create {DATE}.make (y, mo, orig.day), orig.time)
													n := (dt.relative_duration (orig).seconds_count // 3600 // 24).to_integer
													nb_days := nb_days + n
												end

												i_cloud_api.subscribe_user_to_plan (i_user, l_new_plan, nb_days)
											end
										end
									end(?, l_user, l_sub, l_cloud_api)
								)
						end
					end
				end
			end
		end


	yyyy_mm_dd_to_date (s: READABLE_STRING_GENERAL): detachable DATE
			-- YYYY-mm-dd to DATE object.
		local
			i,j: INTEGER
		do
			i := s.index_of ('-', 1)
			if i = 5 then
				j := s.index_of ('-', i + 1)
				if j > 0 then
					create Result.make (s.substring (1, i - 1).to_integer, s.substring (i + 1, j - 1).to_integer, s.substring (j + 1, s.count).to_integer)
				end
			end
		end

end
