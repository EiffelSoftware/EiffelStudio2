note
	description:
		"Projection to Postscript files."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "projector, events, postscript"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_POSTSCRIPT_PROJECTOR

obsolete
	"Use EV_MODEL_POSTSCRIPT_PROJECTOR instead. [2017-05-31]"

inherit
	EV_PROJECTOR

	EV_FIGURE_POSTSCRIPT_DRAWER

	EV_PROJECTION_ROUTINES

create
	make_with_filename

feature {NONE} -- Initialization

	make_with_filename (a_world: EV_FIGURE_WORLD; a_filename: READABLE_STRING_GENERAL)
			-- Create with `a_world' and `a_filename'.
		require
			a_world_not_void: a_world /= Void
			a_filename_not_void: a_filename /= Void
		do
			make_with_filepath (a_world, create {PATH}.make_from_string (a_filename))
		end

	make_with_filepath (a_world: EV_FIGURE_WORLD; a_filename: PATH)
			-- Create with `a_world' and `a_filename'.
		require
			a_world_not_void: a_world /= Void
			a_filename_not_void: a_filename /= Void
		do
			create draw_routines.make_filled (Void, 0, 20)
			make_with_world (a_world)
			set_margins (Default_left_margin, Default_bottom_margin)
			set_page_size (Letter, False)
			register_basic_figures
			filename := a_filename
		end

feature {NONE} -- Implementation

	filename: detachable PATH

	file: detachable PLAIN_TEXT_FILE

	output_to_postscript
			-- Output standard projection to postscript.
		local
			rectangle: EV_RECTANGLE
		do
			create rectangle.make (0, 0, point_width - (2 * left_margin), point_height - (2 * bottom_margin))
			create postscript_result.make (0)
			add_ps_line ("%%!PS-Adobe-3.0 EPSF-3.0")
			add_ps_line("%%%%Creator: N/A")
			add_ps_line ("%%%%Title: N/A")
			add_ps_line ("%%%%CreationDate: N/A")
			add_ps_line ("%%%%DocumentData: N/A")
			add_ps_line ("%%%%Origin: 0 0")
			add_ps_line ("%%%%BoundingBox: 0 0 " + point_width.out + " " + point_height.out)
			add_ps_line ("%%%%LanguageLevel: 2")
			add_ps_line ("%%%%Pages: 1")
			add_ps_line ("%%%%Page: 1")
			add_eiffel_header
			add_ps_line ("%%Setting Clip Path and Origin")
			add_ps_line ("newpath%N" + left_margin.out + " " + bottom_margin.out + " moveto")
			add_ps_line (point_width.out + " 0 rlineto")
			add_ps_line ("0 " + point_height.out + " rlineto")
			add_ps_line ((-point_width).out + " 0 rlineto%Nclosepath%Nclip%Nclippath%N1 setgray fill")
			translate_to (left_margin, bottom_margin)
			if world.grid_enabled and world.grid_visible then
				draw_grid
			end
			if world.is_show_requested then
				project_figure_group (world, rectangle)
			end
			add_footer
		end

	add_eiffel_header
		do
			add_ps_line ("%N%%Generated by:%N%
			%%%EiffelVision2: library of reusable components for ISE Eiffel.%N%
			%%%Copyright (C) 1986-2003 Interactive Software Engineering Inc.%N%
			%%%All rights reserved. Duplication and distribution prohibited.%N%
			%%%May be used only with ISE Eiffel, under terms of user license.%N%
			%%%Contact ISE for any other use.%N%N%
			%%%Interactive Software Engineering Inc.%N%
			%%%ISE Building%N%
			%%%356 Storke Road, Goleta, CA 93117 USA%N%
			%%%Telephone 805-685-1006, Fax 805-685-6869%N%
			%%%Customer support: http://support.eiffel.com%N%
			%%%For latest info see award-winning pages: http://www.eiffel.com%N")
		end

	add_footer
		do
			add_ps_line ("%%%%EOF")
		end

	draw_grid
			-- Draw grid on canvas.
		do
			add_ps_line ("%%Drawing PS Grid")
			add_ps_line ("gsave")
			translate_to (0, 0)
			add_ps_line ("1 setlinewidth")
			add_ps_line ("[] 0 setdash")
			add_ps_line ("1 1 scale")
			add_ps_line (Default_colors.Grey.out + " setrgbcolor")
			add_ps_line ("/draw_grid_point")
			add_ps_line ("{moveto 1 0 rlineto stroke} def")
			add_ps_line ("/grid_x_increase")
			add_ps_line ("{grid_x_pos " + world.grid_x.out + " add /grid_x_pos exch def} def")
			add_ps_line ("/grid_y_decrease")
			add_ps_line ("{grid_y_pos " + world.grid_y.out + " sub /grid_y_pos exch def} def")
			add_ps_line ("/draw_grid_line")
			add_ps_line ("{/grid_x_pos 0 def")
			add_ps_line ("{grid_x_pos " + point_width.out + " le {grid_x_pos grid_y_pos draw_grid_point grid_x_increase}{exit} ifelse}loop} def")
			add_ps_line ("/draw_grid")
			add_ps_line ("{/grid_y_pos " + (point_height-1).out + " def")
			add_ps_line ("{grid_y_pos 0 ge {draw_grid_line grid_y_decrease}{exit} ifelse}loop} def")
			add_ps_line ("draw_grid")
			add_ps_line ("grestore")
		end

feature -- Basic operations

	project
			-- Make standard projection of world on device.
		local
			l_file: like file
			l_filename: like filename
			l_postscript_result: like postscript_result
		do
			if not is_projecting then
				is_projecting := True
				-- Full projection.
				output_to_postscript
				l_filename := filename
				check l_filename /= Void then end
				create l_file.make_with_path (l_filename)
				l_file.open_write
				file := l_file
				l_postscript_result := postscript_result
				check l_postscript_result /= Void then end
				l_file.put_string (l_postscript_result)
				l_file.close
				file := Void
				filename := Void
			end
			is_projecting := False
		end

note
	copyright:	"Copyright (c) 1984-2013, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end -- class EV_POSTSCRIPT_PROJECTOR





