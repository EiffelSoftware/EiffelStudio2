﻿note
	description: "Object that implements PROCESS on UNIX."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	PROCESS_IMP

inherit
	PROCESS
		redefine
			check_exit,
			launch,
			wait_for_exit_with_timeout
		select
			put_string
		end

	BASE_PROCESS_IMP
		rename
			parameter_initialized as base_parameter_initialized,
			put_string as blocking_put_string
		undefine
			cancel_error_redirection,
			cancel_output_redirection,
			initialize_parameter,
			is_error_redirection_valid,
			is_output_redirection_valid,
			redirect_error_to_file,
			redirect_error_to_same_as_output,
			redirect_output_to_file
		redefine
			check_exit,
			initialize_after_launch,
			initialize_child_process,
			launch,
			make,
			wait_for_exit,
			wait_for_exit_with_timeout
		end

	EXCEPTIONS
		rename
			ignore as exce_ignore,
			catch as exec_catch
		end

create
	make,
	make_with_command_line

feature {NONE} -- Initialization

	make (a_exec_name: READABLE_STRING_GENERAL; args: detachable LIST [READABLE_STRING_GENERAL]; a_working_directory: detachable READABLE_STRING_GENERAL)
		do
			create input_buffer.make_empty
			create input_mutex.make
			Precursor (a_exec_name, args, a_working_directory)
		end

feature  -- Control

	launch
			-- <Precursor>
		do
				-- For repeated launch, we must ensure all listening threads, if any have terminated.
			if timer.has_started then
				timer.wait (0).do_nothing
			end
			Precursor
		end

	wait_for_exit
			-- <Precursor>
		do
			timer.wait (0).do_nothing
		end

	wait_for_exit_with_timeout (a_timeout: INTEGER)
			-- <Precursor>
		do
			is_last_wait_timeout := not timer.wait (a_timeout)
		end

feature -- Status report

	is_last_wait_timeout: BOOLEAN
			-- Did the last `wait_for_exit_with_timeout' time out?

feature -- Interprocess data transmission

	put_string (s: READABLE_STRING_8)
		do
			input_mutex.lock
			input_buffer.append (s)
			input_mutex.unlock
		end

feature {PROCESS_TIMER}  -- Status update

	check_exit
			-- Check if process has exited.
		local
			l_in_thread: like in_thread
			l_out_thread: like out_thread
			l_err_thread: like err_thread
		do
			if not has_exited then
				l_in_thread := in_thread
				l_out_thread := out_thread
				l_err_thread := err_thread
				if not has_process_exited then
					child_process.wait_for_process (id, False)
					has_process_exited := not child_process.is_executing
						-- If launched process exited, send signal to all listenning threads.
					if has_process_exited then
						if is_launched_in_new_process_group and then is_terminal_control_enabled then
							attach_terminals (process_id)
						end
						if attached l_in_thread then
							l_in_thread.set_exit_signal
						end
						if attached l_out_thread then
							l_out_thread.set_exit_signal
						end
						if attached l_err_thread then
							l_err_thread.set_exit_signal
						end
					end
				elseif
					(attached l_in_thread implies l_in_thread.terminated) and
					(attached l_out_thread implies l_out_thread.terminated) and
					(attached l_err_thread implies l_err_thread.terminated)
				then
					  -- If all listenning threads exited, perform clean up.
					timer.destroy
					input_buffer.wipe_out
					Precursor
				end
			end
		end

feature {NONE} -- Interprocess IO

	input_buffer: STRING
			-- Buffer used to store input data of process
			-- This buffer is used temporarily to store data that can not be
			-- consumed by launched process.

feature {PROCESS_IO_LISTENER_THREAD} -- Interprocess IO

	last_output_bytes: INTEGER
			-- Number of bytes of data read from output of process

	last_error_bytes: INTEGER
			-- Number of bytes of data read from error of process

	last_input_bytes: INTEGER
			-- Number of bytes in `buffer_size' wrote to process the last time

	write_input_stream
			-- Write at most `buffer_size' bytes of data in `input_buffer' into launched process.
			--|Note: This feature will be used in input listening thread.
		require
			process_running: is_running
			input_redirected_to_stream: input_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream
		local
			l_cnt: INTEGER
			l_left: INTEGER
			l_str: detachable STRING
			l_retried: BOOLEAN
		do
			if not l_retried and then not is_read_pipe_broken then
				input_mutex.lock
				l_cnt := input_buffer.count
				if l_cnt > 0 then
					last_input_bytes := l_cnt.min (buffer_size)
					create l_str.make (last_input_bytes)
					l_left := l_cnt - last_input_bytes
					l_str.append (input_buffer.substring (1, last_input_bytes))
					input_buffer.keep_tail (l_left)
				else
					last_input_bytes := 0
				end
				input_mutex.unlock
				if l_str /= Void then
					child_process.put_string (l_str)
				end
			end
		rescue
			l_retried := True
			if is_signal and then signal = sigpipe then
				is_read_pipe_broken := True
				retry
			end
		end

	read_output_stream
			-- Read output stream from launched process and dispatch data to `output_handler'.
			--|Note: This feature will be used in output listening thread.			
		require
			process_running: is_running
			output_redirected_to_stream: output_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream
		do
			last_output_bytes := 0
			if attached output_handler as l_output_handler then
				child_process.read_output_stream (buffer_size)
				if attached child_process.last_output as l_last_output then
					last_output_bytes := l_last_output.count
					l_output_handler.call ([l_last_output])
				end
			end
		end

	read_error_stream
			-- Read output stream from launched process and dispatch data to `output_handler'.
			--|Note: This feature will be used in error listening thread.
		require
			process_running: is_running
			error_redirected_to_stream: error_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream
		do
			last_error_bytes := 0
			if attached error_handler as l_error_handler then
				child_process.read_error_stream (buffer_size)
				if attached child_process.last_error as l_last_error then
					last_error_bytes := l_last_error.count
					l_error_handler.call ([l_last_error])
				end
			end
		end

feature {NONE}  -- Implementation

	initialize_child_process
			-- <Precursor>
		do
			Precursor
			is_read_pipe_broken := False
		end

	initialize_after_launch
			-- <Precursor>
		do
			Precursor
			start_listening_threads
		end

	start_listening_threads
			-- Setup listeners for process output/error and for process status acquiring.
		local
			l_in_thread: like in_thread
			l_out_thread: like out_thread
			l_err_thread: like err_thread
		do
			if input_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream then
				create input_buffer.make (initial_buffer_size)
				create input_mutex.make
				create l_in_thread.make (Current)
				l_in_thread.launch
				in_thread := l_in_thread
			end
				-- Start  output listening thread is necessory
			if output_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream then
				create l_out_thread.make (Current)
			   	l_out_thread.launch
			   	out_thread := l_out_thread
			end
				-- Start a error listening thread is necessory	
			if error_direction /= {PROCESS_REDIRECTION_CONSTANTS}.to_same_as_output then
				if error_direction = {PROCESS_REDIRECTION_CONSTANTS}.to_stream then
					create l_err_thread.make (Current)
					l_err_thread.launch
					err_thread := l_err_thread
				end
			end
					-- Start a timer for process status acquiring.
			timer.start
		end

feature {NONE} -- Implementation

	in_thread: detachable PROCESS_INPUT_LISTENER_THREAD
	out_thread: detachable PROCESS_OUTPUT_LISTENER_THREAD
	err_thread: detachable PROCESS_ERROR_LISTENER_THREAD
			-- Threads to listen to output and error from process

	input_mutex: MUTEX
		-- Mutex used to synchorinze listening threads		

feature{NONE} -- Error recovery

	is_read_pipe_broken: BOOLEAN
			-- Is pipe used for reading broken?

;note
	copyright: "Copyright (c) 1984-2017, Eiffel Software and others"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
