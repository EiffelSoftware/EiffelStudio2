note
	description: "Summary description for {CMS_USER_STORAGE_SQL_I}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CMS_USER_STORAGE_SQL_I

inherit
	CMS_USER_STORAGE_I

	CMS_STORAGE_SQL_I

	REFACTORING_HELPER

	SHARED_LOGGER

feature -- Access: user

	has_user: BOOLEAN
			-- Has any user?
		do
			Result := users_count > 0
		end

	users_count: INTEGER
			-- Number of items users.
		do
			error_handler.reset
			write_information_log (generator + ".user_count")

			sql_query (select_users_count, Void)
			if not has_error and then not sql_after then
				Result := sql_read_integer_64 (1).to_integer_32
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	users: LIST [CMS_USER]
		do
			create {ARRAYED_LIST [CMS_USER]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".all_users")

			from
				sql_query (select_users, Void)
				sql_start
			until
				sql_after or has_error
			loop
				if attached fetch_user as l_user then
					Result.force (l_user)
				end
				sql_forth
			end
			sql_finalize
		end

	user_by_id (a_id: like {CMS_USER}.id): detachable CMS_USER
			-- User for the given id `a_id', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_id, "uid")
			sql_query (select_user_by_id, l_parameters)
			if not has_error and not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_name (a_name: READABLE_STRING_GENERAL): detachable CMS_USER
			-- User for the given name `a_name', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_name")
			create l_parameters.make (1)
			l_parameters.put (a_name, "name")
			sql_query (select_user_by_name, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_email (a_email: READABLE_STRING_GENERAL): detachable CMS_USER
			-- User for the given email `a_email', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_email")
			create l_parameters.make (1)
			l_parameters.put (a_email, "email")
			sql_query (select_user_by_email, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User for the given activation token `a_token', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_activation_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (select_user_by_activation_token, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_by_password_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User for the given password token `a_token', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_by_password_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (select_user_by_password_token, l_parameters)
			if not sql_after then
				Result := fetch_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	is_valid_credential (l_auth_login, l_auth_password: READABLE_STRING_32): BOOLEAN
		local
			l_security: SECURITY_PROVIDER
		do
			if attached user_salt (l_auth_login) as l_hash then
				if attached user_by_name (l_auth_login) as l_user then
					create l_security
					if
						attached l_user.hashed_password as l_hashed_password and then
					   	l_security.password_hash (l_auth_password, l_hash).is_case_insensitive_equal (l_hashed_password)
					then
						Result := True
					else
						write_information_log (generator + ".is_valid_credential User: wrong username or password" )
					end
				else
					write_information_log (generator + ".is_valid_credential User:" + l_auth_login + "does not exist" )
				end
			end
		end

	recent_users (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_USER]
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create {ARRAYED_LIST [CMS_USER]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".recent_users")

			from
				create l_parameters.make (2)
				l_parameters.put (a_count, "rows")
				l_parameters.put (a_lower, "offset")
				sql_query (sql_select_recent_users, l_parameters)
				sql_start
			until
				sql_after
			loop
				if attached fetch_user as l_user then
					Result.force (l_user)
				end
				sql_forth
			end
			sql_finalize
		end

feature -- Change: user

	new_user (a_user: CMS_USER)
			-- Add a new user `a_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_password_salt, l_password_hash: STRING
			l_security: SECURITY_PROVIDER
		do
			error_handler.reset
			if
				attached a_user.password as l_password and then
				attached a_user.email as l_email
			then
				sql_begin_transaction
				create l_security
				l_password_salt := l_security.salt
				l_password_hash := l_security.password_hash (l_password, l_password_salt)

				write_information_log (generator + ".new_user")
				create l_parameters.make (7)
				l_parameters.put (a_user.name, "name")
				l_parameters.put (l_password_hash, "password")
				l_parameters.put (l_password_salt, "salt")
				l_parameters.put (l_email, "email")
				l_parameters.put (create {DATE_TIME}.make_now_utc, "created")
				l_parameters.put (a_user.status, "status")
  				l_parameters.put (a_user.profile_name, "profile_name")

				sql_insert (sql_insert_user, l_parameters)
				if not error_handler.has_error then
					a_user.set_id (last_inserted_user_id)
					update_user_roles (a_user)
				end
				if not error_handler.has_error then
					sql_commit_transaction
				else
					sql_rollback_transaction
				end
				sql_finalize
			else
				-- set error
				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
			end
		end

	update_username (a_user: CMS_USER; a_new_username: READABLE_STRING_32)
			-- Update username of `a_user' to `a_new_username`.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_password_salt, l_password_hash: detachable READABLE_STRING_8
			l_security: SECURITY_PROVIDER
		do
			error_handler.reset
			if attached a_user.password as l_password then
					-- New password!
				create l_security
				l_password_salt := l_security.salt
				l_password_hash := l_security.password_hash (l_password, l_password_salt)
			else
					-- Existing hashed password
				l_password_hash := a_user.hashed_password
				l_password_salt := user_salt (a_user.name)
			end
			if
				l_password_hash /= Void and l_password_salt /= Void
			then
				sql_begin_transaction

				write_information_log (generator + ".update_username")
				create l_parameters.make (4)
				l_parameters.put (a_user.id, "uid")
				l_parameters.put (a_new_username, "name")
				l_parameters.put (l_password_hash, "password")
				l_parameters.put (l_password_salt, "salt")

				sql_modify (sql_update_user_name, l_parameters)
				sql_finalize
				if not error_handler.has_error then
					a_user.set_name (a_new_username)
					update_user_roles (a_user)
				end
				if not error_handler.has_error then
					sql_commit_transaction
				else
					sql_rollback_transaction
				end
				sql_finalize
			else
					-- set error
				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
			end
		end

	update_user (a_user: CMS_USER)
			-- Save user `a_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_password_salt, l_password_hash: detachable READABLE_STRING_8
			l_security: SECURITY_PROVIDER
		do
			error_handler.reset
			if attached a_user.password as l_password then
					-- New password!
				create l_security
				l_password_salt := l_security.salt
				l_password_hash := l_security.password_hash (l_password, l_password_salt)
			else
					-- Existing hashed password
				l_password_hash := a_user.hashed_password
				l_password_salt := user_salt (a_user.name)
			end
			if
				l_password_hash /= Void and l_password_salt /= Void and
				attached a_user.email as l_email
			then
				sql_begin_transaction

				write_information_log (generator + ".update_user")
				create l_parameters.make (8)
				l_parameters.put (a_user.id, "uid")
				l_parameters.put (a_user.name, "name")
				l_parameters.put (l_password_hash, "password")
				l_parameters.put (l_password_salt, "salt")
				l_parameters.put (l_email, "email")
				l_parameters.put (a_user.status, "status")
				l_parameters.put (a_user.last_login_date, "signed")
				l_parameters.put (a_user.profile_name, "profile_name")

				sql_modify (sql_update_user, l_parameters)
				sql_finalize
				if not error_handler.has_error then
					update_user_roles (a_user)
				end
				if not error_handler.has_error then
					sql_commit_transaction
				else
					sql_rollback_transaction
				end
				sql_finalize
			else
					-- set error
				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
			end
		end

	delete_user (a_user: CMS_USER)
			-- Delete user `a_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".delete_user")
			create l_parameters.make (1)
			l_parameters.put (a_user.id, "uid")
			sql_modify (sql_delete_user, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

feature -- Change: roles

	update_user_roles (a_user: CMS_USER)
			-- Update roles of `a_user'
		require
			a_user.has_id
		local
			l_roles, l_existing_roles: detachable LIST [CMS_USER_ROLE]
			l_has_role: BOOLEAN
		do
			l_roles := a_user.roles
			if l_roles = Void then
				create {ARRAYED_LIST [CMS_USER_ROLE]} l_roles.make (0)
			end

			sql_begin_transaction

			l_existing_roles := user_roles_for (a_user)
			across
				l_existing_roles as ic
			until
				error_handler.has_error
			loop
				from
					l_has_role := False
					l_roles.start
				until
					l_has_role or l_roles.after
				loop
					if l_roles.item.id = ic.item.id then
						l_has_role := True
						l_roles.remove -- Already stored.
					else
						l_roles.forth
					end
				end
				if l_has_role then
						-- Existing role has to be removed!
					unassign_role_from_user (ic.item, a_user)
				end
			end
			across
				l_roles as ic
			until
				error_handler.has_error
			loop
					-- New role.
				assign_role_to_user (ic.item, a_user)
			end

			if not error_handler.has_error then
				sql_commit_transaction
			else
				sql_rollback_transaction
			end
			sql_finalize
		end

	assign_role_to_user (a_role: CMS_USER_ROLE; a_user: CMS_USER)
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create l_parameters.make (2)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_role.id, "rid")
			sql_insert (sql_insert_role_to_user, l_parameters)
			sql_finalize
		end

	unassign_role_from_user (a_role: CMS_USER_ROLE; a_user: CMS_USER)
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create l_parameters.make (2)
			l_parameters.put (a_user.id, "uid")
			l_parameters.put (a_role.id, "rid")
			sql_modify (sql_delete_role_from_user, l_parameters)
			sql_finalize
		end

feature -- Access: roles and permissions

	user_role_by_id (a_id: like {CMS_USER_ROLE}.id): detachable CMS_USER_ROLE
		local
			l_parameters: STRING_TABLE [ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_role_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_id, "rid")
			sql_query (select_user_role_by_id, l_parameters)
			if not sql_after then
				Result := fetch_user_role
				sql_forth
				check one_row: sql_after end
				sql_finalize
				if Result /= Void and not has_error then
					fill_user_role (Result)
				end
			end
			sql_finalize
		end

	user_role_by_name (a_name: READABLE_STRING_GENERAL): detachable CMS_USER_ROLE
			-- User role by name `a_name', if any.
		local
			l_parameters: STRING_TABLE [ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_role_by_name")
			create l_parameters.make (1)
			l_parameters.put (a_name, "name")
			sql_query (select_user_role_by_name, l_parameters)
			if not sql_after then
				Result := fetch_user_role
				sql_forth
				check one_row: sql_after end
				sql_finalize
				if Result /= Void and not has_error then
					fill_user_role (Result)
				end
			end
			sql_finalize
		end

	user_roles_for (a_user: CMS_USER): LIST [CMS_USER_ROLE]
		local
			l_parameters: STRING_TABLE [ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_roles_for")

			create {ARRAYED_LIST [CMS_USER_ROLE]} Result.make (0)
			from
				create l_parameters.make (1)
				l_parameters.put (a_user.id, "uid")
				sql_query (select_user_roles_by_user_id, l_parameters)
				sql_start
			until
				sql_after
			loop
				if attached fetch_user_role as l_role then
					Result.force (l_role)
				end
				sql_forth
			end
			sql_finalize
			if not has_error then
				across Result as ic loop
					fill_user_role (ic.item)
				end
			end
		end

	user_roles: LIST [CMS_USER_ROLE]
		local
			l_role: detachable CMS_USER_ROLE
		do
			error_handler.reset
			write_information_log (generator + ".user_roles")

			create {ARRAYED_LIST [CMS_USER_ROLE]} Result.make (0)
			from
				sql_query (select_user_roles, Void)
				sql_start
			until
				sql_after
			loop
				l_role := fetch_user_role
				if l_role /= Void then
					Result.force (l_role)
				end
				sql_forth
			end
			sql_finalize
			if not has_error then
				across Result as ic loop
					fill_user_role (ic.item)
				end
			end
		end

	fill_user_role (a_role: CMS_USER_ROLE)
		require
			a_role_has_id: a_role.has_id
		do
			if attached role_permissions_by_id (a_role.id) as l_permissions then
				across
					l_permissions as p_ic
				loop
					a_role.add_permission (p_ic.item)
				end
			end
		end

	role_permissions_by_id (a_role_id: INTEGER_32): LIST [READABLE_STRING_8]
		local
			l_parameters: STRING_TABLE [ANY]
		do
			error_handler.reset
			write_information_log (generator + ".role_permissions_by_id")

			create {ARRAYED_LIST [READABLE_STRING_8]} Result.make (0)
			from
				create l_parameters.make (1)
				l_parameters.put (a_role_id, "rid")
				sql_query (select_role_permissions_by_role_id, l_parameters)
				sql_start
			until
				sql_after or has_error
			loop
				if attached sql_read_string (1) as l_permission then
					Result.force (l_permission)
				end
--				if attached sql_read_string_32 (2) as l_module then
--				end
				sql_forth
			end
			sql_finalize
		end

	role_permissions: LIST [READABLE_STRING_8]
			-- Possible known permissions.
		do
			error_handler.reset
			write_information_log (generator + ".role_permissions")

			create {ARRAYED_LIST [READABLE_STRING_8]} Result.make (0)
			Result.compare_objects
			from
				sql_query (select_role_permissions, Void)
				sql_start
			until
				sql_after or has_error
			loop
				if attached sql_read_string (1) as l_permission then
					Result.force (l_permission)
				end
				sql_forth
			end
			sql_finalize
		end

feature -- Change: roles and permissions		

	save_user_role (a_user_role: CMS_USER_ROLE)
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_existing_role: detachable CMS_USER_ROLE
			l_permissions: detachable LIST [READABLE_STRING_8]
			p: READABLE_STRING_8
			l_found: BOOLEAN
		do
			error_handler.reset
			write_information_log (generator + ".save_user_role")


			if a_user_role.has_id then
				l_existing_role := user_role_by_id (a_user_role.id)
				check l_existing_role /= Void and then l_existing_role.id = a_user_role.id end
				if
					l_existing_role /= Void and then
					l_existing_role.name.same_string (a_user_role.name)
				then
						-- No update needed
				else
					create l_parameters.make (2)
					l_parameters.put (a_user_role.id, "rid")
					l_parameters.put (a_user_role.name, "name")
					sql_modify (sql_update_user_role, l_parameters)
					sql_finalize
				end
				if not a_user_role.permissions.is_empty then
					-- FIXME: check if this is non set permissions,or none ...
					if l_existing_role /= Void then
						l_permissions := l_existing_role.permissions
--						fill_user_role (l_existing_role)
					end
					if l_permissions = Void or else l_permissions.is_empty then
						l_permissions := role_permissions_by_id (a_user_role.id)
					end

					a_user_role.permissions.compare_objects
					across l_permissions as ic
					loop
						if not a_user_role.permissions.has (ic.item) then
							unset_permission_for_role_id (ic.item, a_user_role.id)
						end
					end

					across
						a_user_role.permissions as ic
					loop
						p := ic.item
						l_found := across l_permissions as p_ic some p.is_case_insensitive_equal_general (p_ic.item) end
						if l_found then
								-- Already there, skip							
						else
								-- Add permission
							set_permission_for_role_id (p, a_user_role.id)
						end
					end
				else
						-- The user role does not have permissions, unset permissions
						-- if any in the storage.
					if l_existing_role /= Void then
						l_permissions := l_existing_role.permissions
						across l_permissions as ic
						loop
							unset_permission_for_role_id (ic.item, a_user_role.id)
						end
					end
				end
			else
				create l_parameters.make (1)
				l_parameters.put (a_user_role.name, "name")
				sql_insert (sql_insert_user_role, l_parameters)
				sql_finalize
				if not error_handler.has_error then
					a_user_role.set_id (last_inserted_user_role_id)
					across
						a_user_role.permissions as ic
					loop
						set_permission_for_role_id (ic.item, a_user_role.id)
					end
				end
			end
		end

	set_permission_for_role_id (a_permission: READABLE_STRING_8; a_role_id: INTEGER)
		require
			a_role_id > 0
			not a_permission.is_whitespace
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create l_parameters.make (3)
			l_parameters.put (a_role_id, "rid")
			l_parameters.put (a_permission, "permission")
			l_parameters.put (Void, "module") -- FIXME: unsupported for now!
			sql_insert (sql_insert_user_role_permission, l_parameters)
			sql_finalize
		end

	unset_permission_for_role_id (a_permission: READABLE_STRING_8; a_role_id: INTEGER)
		require
			a_role_id > 0
			not a_permission.is_whitespace

		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create l_parameters.make (2)
			l_parameters.put (a_role_id, "rid")
			l_parameters.put (a_permission, "permission")
			sql_modify (sql_delete_user_role_permission, l_parameters)
			sql_finalize
		end

	last_inserted_user_role_id: INTEGER_32
			-- Last inserted user role id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_user_role_id")
			sql_query (sql_last_insert_user_role_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1).to_integer_32
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end


	delete_role (a_role: CMS_USER_ROLE)
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".delete_role")
			create l_parameters.make (1)
			l_parameters.put (a_role.id, "rid")
			sql_modify (sql_delete_role_permissions_by_role_id, l_parameters)
			sql_finalize
			sql_modify (sql_delete_role_by_id, l_parameters)
			sql_commit_transaction
			sql_finalize
		end


feature -- Access: User activation

	activation_elapsed_time (a_token: READABLE_STRING_32): INTEGER_32
			-- amount of time that has passed in days since the token `a_token' was saved.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".activation_elapsed_time")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (sql_select_activation_expiration, l_parameters)
			if not sql_after then
				Result := sql_read_integer_32 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	user_id_by_activation (a_token: READABLE_STRING_32): INTEGER_64
			-- User id associatied with a token `a_token', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_id_by_actication")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (sql_select_userid_activation, l_parameters)
			if not sql_after then
				Result := sql_read_integer_32 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature -- Change: User activation

	save_activation (a_token: READABLE_STRING_32; a_id: INTEGER_64)
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_utc_date: DATE_TIME
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".save_activation")
			create l_utc_date.make_now_utc
			create l_parameters.make (3)
			l_parameters.put (a_token, "token")
			l_parameters.put (a_id, "uid")
			l_parameters.put (l_utc_date, "utc_date")
			sql_insert (sql_insert_activation, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

feature -- Change: User password recovery

	save_password (a_token: READABLE_STRING_32; a_id: INTEGER_64)
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_utc_date: DATE_TIME
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".save_password")
			create l_utc_date.make_now_utc
			create l_parameters.make (2)
			l_parameters.put (a_token, "token")
			l_parameters.put (a_id, "uid")
			l_parameters.put (l_utc_date, "utc_date")
			sql_insert (sql_insert_password, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

	remove_password (a_token: READABLE_STRING_32)
			-- <Precursor>.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".remove_password")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_modify (sql_remove_password, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

feature {NONE} -- Implementation: User

	user_salt (a_username: READABLE_STRING_32): detachable READABLE_STRING_8
			-- User salt for the given user `a_username', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".user_salt")
			create l_parameters.make (1)
			l_parameters.put (a_username, "name")
			sql_query (select_salt_by_username, l_parameters)
			if not sql_after then
				if attached sql_read_string (1) as l_salt then
					Result := l_salt
				end
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	fetch_user: detachable CMS_USER
			-- Fetch user from fields: 1:uid, 2:name, 3:password, 4:salt, 5:email, 6:status, 7:created, 8:signed, 9:profile_name.
		local
			l_id: INTEGER_64
			l_name: detachable READABLE_STRING_32
		do
			if attached sql_read_integer_32 (1) as i then
				l_id := i
			end
			if attached sql_read_string_32 (2) as s and then not s.is_whitespace then
				l_name := s
			end

			if l_name /= Void then
				create Result.make (l_name)
				if l_id > 0 then
					Result.set_id (l_id)
				end
			elseif l_id > 0 then
				create Result.make_with_id (l_id)
			end

			if Result /= Void then
				if attached sql_read_string (3) as l_password then
						-- FIXME: should we return the password here ???
					Result.set_hashed_password (l_password)
				end
				if attached sql_read_string (5) as l_email then
					Result.set_email (l_email)
				end
				if attached sql_read_integer_32 (6) as l_status then
					Result.set_status (l_status)
				end
				if attached sql_read_date_time (7) as l_creation_date then
					Result.set_creation_date (l_creation_date)
				end
				if attached sql_read_date_time (8) as l_signed_date then
					Result.set_last_login_date (l_signed_date)
				end
				if attached sql_read_string_32 (9) as l_prof_name then
					Result.set_profile_name (l_prof_name)
				end
			else
				check expected_valid_user: False end
			end
		end


feature {NONE} -- Implementation: User role		

	fetch_user_role: detachable CMS_USER_ROLE
		local
			l_id: INTEGER_32
			l_name: detachable READABLE_STRING_32
		do
			if attached sql_read_integer_32 (1) as rid then
				l_id := rid
			end
			if attached sql_read_string_32 (2) as s and then not s.is_whitespace then
				l_name := s
			end

			if l_name /= Void then
				create Result.make (l_name)
				if l_id > 0 then
					Result.set_id (l_id)
				end
			elseif l_id > 0 then
				create Result.make_with_id (l_id)
			end
		end

feature {NONE} -- Sql Queries: USER

	select_users_count: STRING = "SELECT count(*) FROM users;"
			-- Number of users.

	select_users: STRING = "SELECT uid, name, password, salt, email, status, created, signed, profile_name FROM users;"
			-- List of users.

	select_user_by_id: STRING = "SELECT uid, name, password, salt, email, status, created, signed, profile_name FROM users WHERE uid =:uid;"
			-- Retrieve user by id if exists.

	select_user_by_name: STRING = "SELECT uid, name, password, salt, email, status, created, signed, profile_name FROM users WHERE name =:name;"
			-- Retrieve user by name if exists.

	sql_select_recent_users: STRING = "SELECT uid, name, password, salt, email, status, created, signed, profile_name FROM users ORDER BY uid DESC, created DESC LIMIT :rows OFFSET :offset;"
			-- Retrieve recent users

	select_user_by_email: STRING = "SELECT uid, name, password, salt, email, status, created, signed, profile_name FROM users WHERE email =:email;"
			-- Retrieve user by email if exists.

	select_salt_by_username: STRING = "SELECT salt FROM users WHERE name =:name;"
			-- Retrieve salt by username if exists.

	sql_insert_user: STRING = "INSERT INTO users (name, password, salt, email, created, status, profile_name) VALUES (:name, :password, :salt, :email, :created, :status, :profile_name);"
			-- SQL Insert to add a new user.

	sql_update_user: STRING = "UPDATE users SET name=:name, password=:password, salt=:salt, email=:email, status=:status, signed=:signed, profile_name=:profile_name WHERE uid=:uid;"
			-- SQL update to update an existing user.

	sql_update_user_name: STRING = "UPDATE users SET name=:name, password=:password, salt=:salt WHERE uid=:uid;"
			-- SQL update to update `name` for an existing user.

	sql_delete_user: STRING = "DELETE FROM users WHERE uid=:uid;"

feature {NONE} -- Sql Queries: USER ROLE

	sql_last_insert_user_role_id: STRING = "SELECT MAX(rid) FROM roles;"

	sql_last_insert_user_id: STRING = "SELECT MAX(uid) FROM users;"

	select_user_roles: STRING = "SELECT rid, name FROM roles;"
			-- List of user roles.	

	sql_insert_user_role: STRING = "INSERT INTO roles (name) VALUES (:name);"
			-- SQL Insert to add a new user role with name :name.		

	sql_update_user_role : STRING = "UPDATE roles SET name=:name WHERE rid=:rid;"
			-- Update user role with id :rid.	

	select_user_roles_by_user_id: STRING = "SELECT users_roles.rid, roles.name FROM roles INNER JOIN users_roles ON users_roles.rid=roles.rid WHERE users_roles.uid=:uid;"
			-- List of user roles for user id :uid.	

	sql_insert_role_to_user: STRING = "INSERT INTO users_roles (uid, rid) VALUES (:uid, :rid);"

	sql_delete_role_from_user: STRING = "DELETE FROM users_roles WHERE uid=:uid AND rid=:rid;"

	sql_select_roles_ids_for_user: STRING = "SELECT rid FROM users_roles WHERE uid=:uid;"

	select_user_role_by_id: STRING = "SELECT rid, name FROM roles WHERE rid=:rid;"
			-- User role for role id :rid;

	select_user_role_by_name: STRING = "SELECT rid, name FROM roles WHERE name=:name;"
			-- User role for role name :name;

	sql_insert_user_role_permission: STRING = "INSERT INTO role_permissions (rid, permission, module) VALUES (:rid, :permission, :module);"
			-- SQL Insert a new permission :permission for user role :rid.

	sql_delete_user_role_permission: STRING = "DELETE FROM role_permissions WHERE rid=:rid AND permission=:permission;"
			-- SQL Delete permission :permission from user role :rid.

	select_role_permissions_by_role_id: STRING = "SELECT permission, module FROM role_permissions WHERE rid=:rid;"
			-- User role permissions for role id :rid;

	select_role_permissions: STRING = "SELECT DISTINCT permission FROM role_permissions;"
			-- Used user role permissions

	sql_delete_role_permissions_by_role_id: STRING = "DELETE FROM role_permissions WHERE rid=:rid;"

	sql_delete_role_by_id: STRING = "DELETE FROM roles WHERE rid=:rid;"

feature {NONE} -- Sql Queries: USER ACTIVATION

	sql_insert_activation: STRING = "INSERT INTO users_activations (token, uid, created) VALUES (:token, :uid, :utc_date);"
			-- SQL insert a new activation :token.

	sql_select_activation_expiration: STRING = "SELECT DATEDIFF(day,created,UTC_DATE()) FROM users_activations WHERE token = :token;"
			-- elapsed time that has passed in days since the token `a_token' was saved.

	sql_select_userid_activation: STRING = "SELECT uid FROM users_activations WHERE token = :token;"
			-- Retrieve userid given the activation token.

	select_user_by_activation_token: STRING = "SELECT u.uid, u.name, u.password, u.salt, u.email, u.status, u.created, u.signed, u.profile_name FROM users as u JOIN users_activations as ua ON ua.uid = u.uid and ua.token = :token;"
			-- Retrieve user by activation token if exist.

	sql_remove_activation: STRING = "DELETE FROM users_activations WHERE token = :token;"
			-- Remove activation token.

feature {NONE} -- User Password Recovery

	sql_insert_password: STRING = "INSERT INTO users_password_recovery (token, uid, created) VALUES (:token, :uid, :utc_date);"
			-- SQL insert a new password recovery :token.

	sql_remove_password: STRING = "DELETE FROM users_password_recovery WHERE token = :token;"
			-- Retrieve password if exist.

	select_user_by_password_token: STRING = "SELECT u.uid, u.name, u.password, u.salt, u.email, u.status, u.created, u.signed, u.profile_name FROM users as u JOIN users_password_recovery as ua ON ua.uid = u.uid and ua.token = :token;"
			-- Retrieve user by password token if exist.

feature -- Acess: Temp users

	temp_users_count: INTEGER
			-- Number of items users.
		do
			error_handler.reset
			write_information_log (generator + ".temp_users_count")

			sql_query (select_temp_users_count, Void)
			if not has_error and then not sql_after then
				Result := sql_read_integer_64 (1).to_integer_32
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	temp_user_by_id (a_uid: like {CMS_USER}.id; a_consumer: READABLE_STRING_GENERAL): detachable CMS_USER
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_string: STRING
		do
			error_handler.reset
			write_information_log (generator + ".temp_user_by_id")
			create l_parameters.make (1)
			l_parameters.put (a_uid, "uid")
			create l_string.make_from_string (select_user_auth_temp_by_id)
			sql_query (l_string, l_parameters)
			if not has_error and not sql_after then
				Result := fetch_temp_user
				sql_forth
				if not sql_after then
					check no_more_than_one: False end
					Result := Void
				end
			end
			sql_finalize
		end

	temp_user_by_name (a_name: like {CMS_USER}.name): detachable CMS_USER
			-- User for the given name `a_name', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".temp_user_by_name")
			create l_parameters.make (1)
			l_parameters.put (a_name, "name")
			sql_query (select_temp_user_by_name, l_parameters)
			if not sql_after then
				Result := fetch_temp_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	temp_user_by_email (a_email: like {CMS_USER}.email): detachable CMS_USER
			-- User for the given email `a_email', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".temp_user_by_name")
			create l_parameters.make (1)
			l_parameters.put (a_email, "email")
			sql_query (select_temp_user_by_email, l_parameters)
			if not sql_after then
				Result := fetch_temp_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	temp_user_by_activation_token (a_token: READABLE_STRING_32): detachable CMS_USER
			-- User for the given activation token `a_token', if any.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".temp_user_by_activation_token")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_query (select_temp_user_by_activation_token, l_parameters)
			if not sql_after then
				Result := fetch_temp_user
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	temp_recent_users (a_lower: INTEGER; a_count: INTEGER): LIST [CMS_TEMP_USER]
			-- <Precursor>
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			create {ARRAYED_LIST [CMS_TEMP_USER]} Result.make (0)

			error_handler.reset
			write_information_log (generator + ".temp_recent_users")

			from
				create l_parameters.make (2)
				l_parameters.put (a_count, "rows")
				l_parameters.put (a_lower, "offset")
				sql_query (sql_select_temp_recent_users, l_parameters)
				sql_start
			until
				sql_after or has_error
			loop
				if attached fetch_temp_user as l_user then
					Result.force (l_user)
				end
				sql_forth
			end
			sql_finalize
		end

	token_by_temp_user_id (a_id: like {CMS_USER}.id): detachable STRING
			-- Number of items users.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			write_information_log (generator + ".token_by_temp_user_id")
			create l_parameters.make (1)
			l_parameters.put (a_id, "uid")


			sql_query (select_token_activation_by_user_id, l_parameters)
			if not has_error and then not sql_after then
				Result := sql_read_string (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature {NONE} -- Implementation: User

	fetch_temp_user: detachable CMS_TEMP_USER
		local
			l_id: INTEGER_64
			l_name: detachable READABLE_STRING_32
		do
			if attached sql_read_integer_64 (1) as i then
				l_id := i
			end
			if attached sql_read_string_32 (2) as s and then not s.is_whitespace then
				l_name := s
			end

			if l_name /= Void then
				create Result.make (l_name)
				if l_id > 0 then
					Result.set_id (l_id)
				end
			elseif l_id > 0 then
				create Result.make_with_id (l_id)
			end

			if Result /= Void then
				if attached sql_read_string (3) as l_password then
					Result.set_hashed_password (l_password)
				end
				if attached sql_read_string (4) as l_salt then
					Result.set_salt (l_salt)
				end
				if attached sql_read_string (5) as l_email then
					Result.set_email (l_email)
				end
				if attached sql_read_string (6) as l_application then
					Result.set_personal_information (l_application)
				end
			else
				check expected_valid_user: False end
			end
		end


feature -- New Temp User

	new_user_from_temp_user (a_temp_user: CMS_TEMP_USER)
			-- <Precursor>
  		local
  			l_parameters: STRING_TABLE [detachable ANY]
  		do
  			error_handler.reset
  			if
  				attached a_temp_user.hashed_password as l_password_hash and then
  				attached a_temp_user.email as l_email and then
  				attached a_temp_user.salt as l_password_salt
  			then
  					-- FIXME: store the personal_information in profile!
  				sql_begin_transaction

  				write_information_log (generator  + ".new_user_from_temp_user")
  				create l_parameters.make (7)
  				l_parameters.put (a_temp_user.name, "name")
  				l_parameters.put (l_password_hash, "password")
  				l_parameters.put (l_password_salt, "salt")
  				l_parameters.put (l_email, "email")
  				l_parameters.put (create {DATE_TIME}.make_now_utc, "created")
  				l_parameters.put (a_temp_user.status, "status")
  				l_parameters.put (a_temp_user.profile_name, "profile_name")

  				sql_insert (sql_insert_user, l_parameters)
  				if not error_handler.has_error then
  					sql_commit_transaction
  				else
  					sql_rollback_transaction
  				end
  				sql_finalize
  			else
  				-- set error
  				error_handler.add_custom_error (-1, "bad request" , "Missing password or email")
  			end
  		end

	new_temp_user (a_temp_user: CMS_TEMP_USER)
			-- Add a new temp_user `a_temp_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
			l_password_salt, l_password_hash: STRING
			l_security: SECURITY_PROVIDER
		do
			error_handler.reset
			if
				attached a_temp_user.password as l_password and then
				attached a_temp_user.email as l_email and then
				attached a_temp_user.personal_information as l_personal_information
			then

				create l_security
				l_password_salt := l_security.salt
				l_password_hash := l_security.password_hash (l_password, l_password_salt)

				write_information_log (generator + ".new_temp_user")
				create l_parameters.make (4)
				l_parameters.put (a_temp_user.name, "name")
				l_parameters.put (l_password_hash, "password")
				l_parameters.put (l_password_salt, "salt")
				l_parameters.put (l_email, "email")
				l_parameters.put (l_personal_information, "application")

				sql_begin_transaction
				sql_insert (sql_insert_temp_user, l_parameters)
				if not error_handler.has_error then
					a_temp_user.set_id (last_inserted_temp_user_id)
					sql_commit_transaction
				else
					sql_rollback_transaction
				end
				sql_finalize
			else
					-- set error
				error_handler.add_custom_error (-1, "bad request" , "Missing password or email or personal information")
			end
		end

feature -- Remove Activation

	remove_activation (a_token: READABLE_STRING_GENERAL)
			-- <Precursor>.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".remove_activation")
			create l_parameters.make (1)
			l_parameters.put (a_token, "token")
			sql_modify (sql_remove_activation, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

	delete_temp_user (a_temp_user: CMS_TEMP_USER)
			-- Delete user `a_temp_user'.
		local
			l_parameters: STRING_TABLE [detachable ANY]
		do
			error_handler.reset
			sql_begin_transaction
			write_information_log (generator + ".delete_temp_user")
			create l_parameters.make (1)
			l_parameters.put (a_temp_user.id, "uid")
			sql_modify (sql_delete_temp_user, l_parameters)
			sql_commit_transaction
			sql_finalize
		end

feature {NONE} -- Implementation

	last_inserted_temp_user_id: INTEGER_64
			-- Last insert user id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_temp_user_id")
			sql_query (sql_last_insert_temp_user_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

	last_inserted_user_id: INTEGER_64
			-- Last insert user id.
		do
			error_handler.reset
			write_information_log (generator + ".last_inserted_user_id")
			sql_query (sql_last_insert_user_id, Void)
			if not sql_after then
				Result := sql_read_integer_64 (1)
				sql_forth
				check one_row: sql_after end
			end
			sql_finalize
		end

feature {NONE} -- SQL select

	sql_last_insert_temp_user_id: STRING = "SELECT MAX(uid) FROM auth_temp_users;"


	select_user_auth_temp_by_id: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users as u WHERE uid=:uid;"


	sql_insert_temp_user: STRING = "INSERT INTO auth_temp_users (name, password, salt, email, application) VALUES (:name, :password, :salt, :email, :application);"
			-- SQL Insert to add a new user.

	select_temp_user_by_name: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users WHERE name =:name;"
			-- Retrieve user by name if exists.

	select_temp_user_by_email: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users WHERE email =:email;"
			-- Retrieve user by email if exists.

	select_temp_user_by_activation_token: STRING = "SELECT u.uid, u.name, u.password, u.salt, u.email, u.application FROM auth_temp_users as u JOIN users_activations as ua ON ua.uid = u.uid and ua.token = :token;"
			-- Retrieve user by activation token if exist.

	sql_delete_temp_user: STRING = "DELETE FROM auth_temp_users WHERE uid=:uid;"

	select_temp_users_count: STRING = "SELECT count(*) FROM auth_temp_users;"
			-- Number of temporal users.			

	sql_select_temp_recent_users: STRING = "SELECT uid, name, password, salt, email, application FROM auth_temp_users ORDER BY uid DESC LIMIT :rows OFFSET :offset ;"
			-- Retrieve recent users

	select_token_activation_by_user_id: STRING = "SELECT token FROM users_activations WHERE uid = :uid;"


note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
