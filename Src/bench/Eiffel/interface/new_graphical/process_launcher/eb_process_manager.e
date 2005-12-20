indexing
	description: "Object that manages freezing and finalizing c compilation"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EB_PROCESS_MANAGER

inherit
	EB_SHARED_PREFERENCES

	EB_CONSTANTS

create
	make

feature{NONE} -- Initialization

	make (a_freezor, a_finalizor: EB_C_COMPILER_LAUNCHER; a_external: EB_EXTERNAL_LAUNCHER) is
			-- Initialize using freezing launcher `freezor',
			-- finalizing launcher `finalizor' and external command launcher `a_external'.
		require
			a_freezor_not_void: a_freezor /= Void
			a_finalizor_not_void: a_finalizor /= Void
			a_external_not_void: a_external /= Void
		do
			freezor := a_freezor
			finalizor := a_finalizor
			externalor := a_external
		ensure
			freezor_set: freezor = a_freezor
			finalizor_set: finalizor = a_finalizor
			externalor_set: externalor = a_external
		end

feature -- Status reporting

	is_c_compilation_running: BOOLEAN is
			-- Is either `freezor' or `finalizor' running, or both?
		do
			Result := freezor.is_running or finalizor.is_running
		end

	is_external_command_running: BOOLEAN is
			-- Is external command running?
		do
			Result := externalor.is_running
		end

	is_process_running: BOOLEAN is
			-- Is either `freezor', `finalizor' or `externalor' running, or all?
		do
			Result := is_c_compilation_running or is_external_command_running
		end

	is_freezing_running: BOOLEAN is
			-- Is freezor running?
		do
			Result := freezor.is_running
		end

	is_finalizing_running: BOOLEAN is
			-- Is finalizor running?
		do
			Result := finalizor.is_running
		end

feature -- Execution

	terminate_c_compilation is
			-- Terminate running freezing or fianlizing.
		do
			if is_freezing_running then
				freezor.terminate
			end
			if is_finalizing_running then
				finalizor.terminate
			end
		ensure
			freezor_not_running: not is_freezing_running
			finalizor_not_running: not is_finalizing_running
		end

	terminate_finalizing is
			-- Terminate running finalizing if any.
		do
			if is_finalizing_running then
				finalizor.terminate
			end
		ensure
			freezing_not_running: not is_freezing_running
		end

	terminate_freezing is
			-- Terminate running freezing is any.
		do
			if is_freezing_running then
				freezor.terminate
			end
		ensure
			finalizing_not_running: not is_finalizing_running
		end

	terminate_external_command is
			-- Terminate running external command if any.
		do
			if is_external_command_running then
				externalor.terminate
			end
		ensure
			externalor_terminated: not is_external_command_running
		end


	terminate_process is
			-- Terminate running freezing, finalizing and external command if any.
		do
			terminate_c_compilation
			terminate_external_command
		end



	confirm_process_termination (ok_agent, no_agent: PROCEDURE [ANY, TUPLE]; a_window: EV_WINDOW) is
			-- Confirm if user want to terminate running c compilation.
		require
			a_window_not_void: a_window /= Void
		local
			cd: STANDARD_DISCARDABLE_CONFIRMATION_DIALOG
		do
			if is_c_compilation_running then
				if is_freezing_running then
					create cd.make_initialized (
						3, preferences.dialog_data.confirm_on_terminate_freezing_string,
						Warning_messages.w_Freezing_running, Interface_names.l_Discard_terminate_freezing,
						preferences.preferences)
				elseif is_finalizing_running then
					create cd.make_initialized (
						3, preferences.dialog_data.confirm_on_terminate_finalizing_string,
						Warning_messages.w_Finalizing_running, Interface_names.l_Discard_terminate_finalizing,
						preferences.preferences)
				end
				if cd /= Void then
					cd.set_ok_action (ok_agent)
					cd.set_no_action (no_agent)
					cd.show_modal_to_window (a_window)
				end
			end
		end

	confirm_process_termination_for_quiting (ok_agent, no_agent: PROCEDURE [ANY, TUPLE]; a_window: EV_WINDOW) is
			-- Confirm if user want to exit EiffelStudio when c compilation or external command is running.
		require
			a_window_not_void: a_window /= Void
		local
			cd: STANDARD_DISCARDABLE_CONFIRMATION_DIALOG
			head, msg: STRING
			prc_count: INTEGER
			discard_msg: STRING
		do
			head := "The following "
			msg := "running:%N"
			if is_freezing_running then
				msg := msg + " - freezing%N"
				prc_count := prc_count + 1
			end
			if is_finalizing_running then
				msg := msg + " - finalizing%N"
				prc_count := prc_count + 1
			end
			if is_external_command_running then
				msg := msg + " - external command"
				prc_count := prc_count + 1
			end
			msg := msg + "%N%NDo you want to terminate "
			discard_msg := "Do not ask again, and always terminate "
			if prc_count > 1 then
				head.append ("are ")
				msg := msg + "them"
				discard_msg := discard_msg + "them"
			else
				head.append ("is ")
				msg := msg + "it"
				discard_msg := discard_msg + "it"
			end

			msg := msg +" before exit?"
			msg.prepend (head)
			if prc_count > 0 then
				create cd.make_initialized (
					3, preferences.dialog_data.confirm_on_terminate_process_string,
					msg, discard_msg,
					preferences.preferences)
				cd.set_ok_action (ok_agent)
				cd.set_no_action (no_agent)
				cd.show_modal_to_window (a_window)
			end
		end

	confirm_external_command_termination (ok_agent, no_agent: PROCEDURE [ANY, TUPLE]; a_window: EV_WINDOW) is
			-- Confirm running external command termination before destroy a development window.
		require
			a_window_not_void: a_window /= Void
		local
			cd: STANDARD_DISCARDABLE_CONFIRMATION_DIALOG
		do
			if is_external_command_running then
				create cd.make_initialized (
					3, preferences.dialog_data.confirm_on_terminate_external_command_string,
					Warning_messages.w_external_command_running_in_development_window,
					Interface_names.l_Discard_terminate_external_command,
					preferences.preferences)
					cd.set_ok_action (ok_agent)
					cd.set_no_action (no_agent)
					cd.show_modal_to_window (a_window)
			end
		end


feature{NONE} -- Implementation

	freezor: EB_C_COMPILER_LAUNCHER
			-- Freezing launcher

	finalizor: EB_C_COMPILER_LAUNCHER
			-- Finalizing launcher

	externalor: EB_EXTERNAL_LAUNCHER

invariant

	freezor_not_void: freezor /= Void
	finalizor_not_void: finalizor /= Void
	externalor_not_void: externalor /= Void

end
