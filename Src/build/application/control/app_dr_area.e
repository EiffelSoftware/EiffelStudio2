indexing
	description: "Application drawing area."
	Id: "$Id $"
	date: "$Date$"
	revision: "$Revision$"

class APP_DR_AREA

inherit
	EV_PIXMAP

	EV_COMMAND

	WINDOWS

	CONSTANTS

creation
	make

feature {NONE} -- Initialization

	make (par: EV_CONTAINER) is
			-- Create the drawing area.
		local
			update_trans_cmd: APP_UPDATE_TRANS
			cmd: EV_ROUTINE_COMMAND
		do
			create active_area.make (par)

			make_with_size (Resources.app_dr_area_width, Resources.app_dr_area_height)
			active_area.set_pixmap (Current)

			create cmd.make (~select_command)
			active_area.add_button_press_command (1, cmd, Void)
			active_area.add_button_press_command (3, Current, Void)
			active_area.activate_pick_and_drop (Void, Void)
			create update_trans_cmd
			active_area.add_pnd_command (Pnd_types.label_type, update_trans_cmd, Void)
			create cmd.make (~process_state)
			active_area.add_pnd_command (Pnd_types.state_type, cmd, Void)
			create cmd.make (~process_new_state)
			active_area.add_pnd_command (Pnd_types.new_state_type, cmd, Void)
		end

feature -- Access

	active_area: EV_DRAWING_AREA
			-- Active area that receive the events

feature {APP_DR_AREA} -- Commands

	select_command (arg: EV_ARGUMENT; ev_data: EV_BUTTON_EVENT_DATA) is
		do
			if ev_data.control_key_pressed then
				figures.find (ev_data.x, ev_data.y)
				if figures.found then
					app_editor.set_selected (figures.figure)
					app_editor.display_states
					app_editor.display_transitions
				end
			end
		end

feature {APP_DR_AREA} -- Pick and drop

	execute (arg: EV_ARGUMENT; ev_data: EV_BUTTON_EVENT_DATA) is
		local
			cmd: PND_ACCELERATOR
			arg1: EV_ARGUMENT1 [ANY]
		do
			app_editor.find_pointed_figure (ev_data.x, ev_data.y)
			if app_editor.pointed_figure /= Void then
				create cmd
				create arg1.make (app_editor.pointed_figure.data)
				cmd.execute (arg1, ev_data)
				active_area.set_data_type (app_editor.pointed_figure.data_type)
				if active_area.transported_data = Void then
					active_area.set_transported_data (app_editor.pointed_figure)
				end
			end
		end

	process_state (arg: EV_ARGUMENT; ev_data: EV_PND_EVENT_DATA) is
			-- Update the drawing area appropriately 
			-- using the dropped state. 
			-- Either 
			--	. add a transition between figures
			--	. update the state
			--	. copy a state
			--	. add a line between two circles
		local
			circle: STATE_CIRCLE
			add_line_command: APP_ADD_LINE
			args: EV_ARGUMENT2 [STATE_CIRCLE, APP_FIGURE]
			new_state: BUILD_STATE
			add_state_cmd: APP_ADD_FIGURE
			arg2: EV_ARGUMENT2 [EV_POINT, BUILD_STATE]
		do
			circle ?= ev_data.data
			if circle /= Void then
				figures.find (ev_data.x, ev_data.y)
				if figures.found then
						-- State circle dropped on another circle
						-- (create a transition)
					create add_line_command
					create args.make (circle, figures.figure)
					add_line_command.execute (args, Void)
				else
						-- Create a `new_state' and
						-- copy lists from the dropped state to `new_state'
					create new_state.make
					new_state.set_internal_name ("")
					create add_state_cmd
					create arg2.make (figures.previous_point, new_state)
					add_state_cmd.execute (arg2, Void)
					new_state.copy_contents (circle.data)
				end
			end
			active_area.set_transported_data (Void)
		end

	process_new_state (arg: EV_ARGUMENT; ev_data: EV_PND_EVENT_DATA) is
			-- Search for a figure in Current according
			-- to the mouse position. If found, then graphically
			-- override found figure with stone dropped.
			-- Otherwise, add a new figure at current mouse position.
		local
			new_state: BUILD_STATE
			add_state_cmd: APP_ADD_FIGURE
			arg2: EV_ARGUMENT2 [EV_POINT, BUILD_STATE]
		do
			new_state ?= ev_data.data
			new_state.set_internal_name ("")
			figures.find (ev_data.x, ev_data.y)
			create add_state_cmd
			create arg2.make (figures.previous_point, new_state)
			add_state_cmd.execute (arg2, Void)
			active_area.set_transported_data (Void)
		end

feature {NONE} -- Implementation

	figures: APP_FIGURES is
			-- List of figures.
		do
			Result := app_editor.figures
		end

	lines: APP_LINES is
			-- List of lines.
		do
			Result := app_editor.lines
		end

	remove_yourself is
			-- Remove source_figure.
		do
			app_editor.remove_pointed_figure
		end

end -- class APP_DR_AREA

