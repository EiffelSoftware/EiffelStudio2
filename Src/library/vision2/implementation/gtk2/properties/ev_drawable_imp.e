indexing
	description: "EiffelVision drawable. GTK implementation."
	status: "See notice at end of class"
	keywords: "figures, primitives, drawing, line, point, ellipse" 
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EV_DRAWABLE_IMP

inherit
	EV_DRAWABLE_I
		redefine
			interface
		end

	EV_DRAWABLE_CONSTANTS

	DISPOSABLE
		undefine
			copy,
			default_create
		end

feature {NONE} -- Initialization

	init_default_values is
			-- Set default values. Call during initialization.
		do
			line_style := feature {EV_GTK_EXTERNALS}.Gdk_line_solid_enum
			set_drawing_mode (drawing_mode_copy)
			set_line_width (1)
		end

feature {EV_DRAWABLE_IMP} -- Implementation

	gc: POINTER
			-- Pointer to GdkGC struct.
			-- The graphics context applied to the primitives.
			-- Line style, width, colors, etc. are defined in here.
	
	gcvalues: POINTER
			-- Pointer to GdkGCValues struct.
			-- Is allocated during creation but has to be updated
			-- every time it is accessed.

	drawable: POINTER is
			-- Pointer to the GdkWindow of `c_object'.
		deferred
		end

	line_style: INTEGER
			-- Dash-style used when drawing lines.

	cap_style: INTEGER is
			-- Style used for drawing end of lines.
		do
			Result := feature {EV_GTK_EXTERNALS}.Gdk_cap_butt_enum
		end

	join_style: INTEGER is
			-- Way in which lines are joined together.				
		do
			Result := feature {EV_GTK_EXTERNALS}.Gdk_join_bevel_enum
		end

	gc_clip_area: EV_RECTANGLE
			-- Clip area currently used by `gc'.

	height: INTEGER is
			-- Needed by `draw_straight_line'.
		deferred
		end

	width: INTEGER is
			-- Needed by `draw_straight_line'.
		deferred
		end

feature -- Access

	font: EV_FONT is
			-- Font used for drawing text.
		do
			if internal_font_imp /= Void then
				Result := internal_font_imp.interface.twin
			else
				create Result
			end
		end

	foreground_color: EV_COLOR is
			-- Color used to draw primitives.
		do
			if internal_foreground_color /= Void then
				Result := internal_foreground_color
			else
				create Result.make_with_rgb (0, 0, 0)
			end
		end
		
	background_color: EV_COLOR is
			-- Color used for erasing of canvas.
			-- Default: white.
		do
			if internal_background_color /= Void then
				Result := internal_background_color
			else
				create Result.make_with_rgb (1.0, 1.0, 1.0)
			end
		end

	line_width: INTEGER is
			-- Line thickness.
		do
			gcvalues := feature {EV_GTK_EXTERNALS}.c_gdk_gcvalues_struct_allocate
			feature {EV_GTK_EXTERNALS}.gdk_gc_get_values (gc, gcvalues)
			Result := feature {EV_GTK_EXTERNALS}.gdk_gcvalues_struct_line_width (gcvalues)
			gcvalues.memory_free
		end

	drawing_mode: INTEGER is
			-- Logical operation on pixels when drawing.
		local
			gdk_drawing_mode: INTEGER
		do
			gcvalues := feature {EV_GTK_EXTERNALS}.c_gdk_gcvalues_struct_allocate
			feature {EV_GTK_EXTERNALS}.gdk_gc_get_values (gc, gcvalues)
			gdk_drawing_mode := feature {EV_GTK_EXTERNALS}.gdk_gcvalues_struct_function (gcvalues)
			gcvalues.memory_free

			if gdk_drawing_mode = feature {EV_GTK_EXTERNALS}.Gdk_copy_enum then
				Result := drawing_mode_copy
			elseif gdk_drawing_mode = feature {EV_GTK_EXTERNALS}.Gdk_xor_enum then
				Result := drawing_mode_xor
			elseif gdk_drawing_mode = feature {EV_GTK_EXTERNALS}.Gdk_invert_enum then
				Result := drawing_mode_invert
			elseif gdk_drawing_mode = feature {EV_GTK_EXTERNALS}.Gdk_and_enum then
				Result := drawing_mode_and
			elseif gdk_drawing_mode = feature {EV_GTK_EXTERNALS}.Gdk_or_enum then
				Result := drawing_mode_or
			else
				check
					drawing_mode_existent: False
				end
			end
		end

	clip_area: EV_RECTANGLE is
			-- Clip area used to clip drawing.
			-- If set to Void, no clipping is applied.
		do
			if gc_clip_area /= Void then
				Result := gc_clip_area.twin
			end
		end

	tile: EV_PIXMAP
			-- Pixmap that is used to fill instead of background_color.
			-- If set to Void, `background_color' is used to fill.

	dashed_line_style: BOOLEAN is
			-- Are lines drawn dashed?
		local
			style: INTEGER
		do
			gcvalues := feature {EV_GTK_EXTERNALS}.c_gdk_gcvalues_struct_allocate
			feature {EV_GTK_EXTERNALS}.gdk_gc_get_values (gc, gcvalues)
			style := feature {EV_GTK_EXTERNALS}.gdk_gcvalues_struct_line_style (gcvalues)
			gcvalues.memory_free
			Result := style = feature {EV_GTK_EXTERNALS}.Gdk_line_on_off_dash_enum
		end

feature -- Status report

	is_drawable: BOOLEAN is
			-- Is the device drawable?
		do
			Result := drawable /= default_pointer
		end

feature -- Element change

	set_font (a_font: EV_FONT) is
			-- Set `font' to `a_font'.
		do
			internal_font_imp ?= a_font.implementation
		end

	set_background_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `background_color'.
		local
			color_struct: POINTER
		do
			internal_background_color := a_color
			color_struct := App_implementation.reusable_color_struct
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_red (color_struct, a_color.red_16_bit)
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_green (color_struct, a_color.green_16_bit)
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_blue (color_struct, a_color.blue_16_bit)
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_rgb_bg_color (gc, color_struct)
		end

	set_foreground_color (a_color: EV_COLOR) is
			-- Assign `a_color' to `foreground_color'
		local
			color_struct: POINTER
		do
			internal_foreground_color := a_color
			color_struct := App_implementation.reusable_color_struct
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_red (color_struct, a_color.red_16_bit)
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_green (color_struct, a_color.green_16_bit)
			feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_blue (color_struct, a_color.blue_16_bit)
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_rgb_fg_color (gc, color_struct)
		end

	set_line_width (a_width: INTEGER) is
			-- Assign `a_width' to `line_width'.
		do
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_line_attributes (gc, a_width,
				line_style, cap_style, join_style)				
		end

	set_drawing_mode (a_mode: INTEGER) is
			-- Set drawing mode to `a_mode'.
		do
			check valid_drawing_mode (a_mode) end
			inspect
				a_mode
			when drawing_mode_copy then
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_function (gc, feature {EV_GTK_EXTERNALS}.Gdk_copy_enum)
			when drawing_mode_xor then
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_function (gc, feature {EV_GTK_EXTERNALS}.Gdk_xor_enum)
			when drawing_mode_invert then
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_function (gc, feature {EV_GTK_EXTERNALS}.Gdk_invert_enum)
			when drawing_mode_and then
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_function (gc, feature {EV_GTK_EXTERNALS}.Gdk_and_enum)
			when drawing_mode_or then
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_function (gc, feature {EV_GTK_EXTERNALS}.Gdk_or_enum)
			else
				check
					drawing_mode_existent: False
				end
			end
		end

	set_clip_area (an_area: EV_RECTANGLE) is
			-- Set an area to clip to.
		local
			rectangle_struct: POINTER
		do
			gc_clip_area := an_area.twin
			rectangle_struct := feature {EV_GTK_EXTERNALS}.c_gdk_rectangle_struct_allocate
			feature {EV_GTK_DEPENDENT_EXTERNALS}.set_gdk_rectangle_struct_x (rectangle_struct, an_area.x)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.set_gdk_rectangle_struct_y (rectangle_struct, an_area.y)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.set_gdk_rectangle_struct_width (rectangle_struct, an_area.width)
			feature {EV_GTK_DEPENDENT_EXTERNALS}.set_gdk_rectangle_struct_height (rectangle_struct, an_area.height)
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_rectangle (gc, rectangle_struct)
			rectangle_struct.memory_free
		end

	remove_clip_area is
			-- Do not apply any clipping.
		do
			gc_clip_area := Void
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_rectangle (gc, default_pointer)
		end

	set_tile (a_pixmap: EV_PIXMAP) is
			-- Set tile used to fill figures.
			-- Set to Void to use `background_color' to fill.
		local
			tile_imp: EV_PIXMAP_IMP
		do
			create tile
			tile.copy (a_pixmap)
			tile_imp ?= tile.implementation
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_tile (gc, tile_imp.drawable)
		end

	remove_tile is
			-- Do not apply a tile when filling.
		do
			tile := Void
		end

	enable_dashed_line_style is
			-- Draw lines dashed.
		do
			line_style := feature {EV_GTK_EXTERNALS}.Gdk_line_on_off_dash_enum
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_line_attributes (gc, line_width,
				line_style, cap_style, join_style)
		end

	disable_dashed_line_style is
			-- Draw lines solid.
		do
			line_style := feature {EV_GTK_EXTERNALS}.Gdk_line_solid_enum
			feature {EV_GTK_EXTERNALS}.gdk_gc_set_line_attributes (gc, line_width,
				line_style, cap_style, join_style)
		end

feature -- Clearing operations

	clear is
			-- Erase `Current' with `background_color'.
		do
			clear_rectangle (0, 0, width, height)
		end

	clear_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Erase rectangle specified with `background_color'.
		local
			tmp_fg_color: EV_COLOR
		do
			if drawable /= default_pointer then
				create tmp_fg_color
				tmp_fg_color.copy (foreground_color)
				set_foreground_color (background_color)
				feature {EV_GTK_EXTERNALS}.gdk_draw_rectangle (drawable, gc, 1,
					x,
					y,
					a_width,
					a_height)
				set_foreground_color (tmp_fg_color)
				flush
			end
		end

feature -- Drawing operations

	draw_point (x, y: INTEGER) is
			-- Draw point at (`x', `y').
		do
			if drawable /= default_pointer then
	 			feature {EV_GTK_EXTERNALS}.gdk_draw_point (drawable, gc, x, y)
	 			flush
			end
		end

	draw_text (x, y: INTEGER; a_text: STRING) is
			-- Draw `a_text' with left of baseline at (`x', `y') using `font'.
		do
			draw_text_internal (x, y, a_text, True)
		end
		
	draw_text_internal (x, y: INTEGER; a_text: STRING; draw_from_baseline: BOOLEAN) is
			-- Draw `a_text' at (`x', `y') using `font'.
		local
			--a_cs: EV_GTK_C_STRING
			a_pango_layout, a_pango_iter: POINTER
			a_text_count, a_baseline: INTEGER
			a_y: INTEGER
			temp_any: ANY
		do
			if drawable /= default_pointer then
				--create a_cs.make (a_text)
				--a_cs := a_text
				
					-- Replace when we have UTF16 support
				a_pango_layout := App_implementation.pango_layout
				a_text_count := a_text.count
				temp_any ?= a_text.to_c
				feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_layout_set_text (a_pango_layout, $temp_any, a_text_count)
				if internal_font_imp /= Void then
					feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_layout_set_font_description (a_pango_layout, internal_font_imp.font_description)
				end
				if draw_from_baseline then
					a_pango_iter := App_implementation.pango_iter
					a_baseline := feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_layout_iter_get_baseline (a_pango_iter) // feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_scale
					feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_layout_iter_free (a_pango_iter)
					a_y := y - a_baseline
				else
					a_y := y - 2
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gdk_draw_layout (drawable, gc, x, a_y, a_pango_layout)
			end
		end		

	draw_text_top_left (x, y: INTEGER; a_text: STRING) is
			-- Draw `a_text' with top left corner at (`x', `y') using `font'.
		do
			draw_text_internal (x, y, a_text, False)
		end

	draw_segment (x1, y1, x2, y2: INTEGER) is
			-- Draw line segment from (`x1', 'y1') to (`x2', 'y2').
		do
			if drawable /= default_pointer then
				feature {EV_GTK_EXTERNALS}.gdk_draw_line (drawable, gc, x1, y1, x2, y2)
				flush
			end
		end

	draw_arc (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- Angles are measured in radians.
		local
			corrected_start, corrected_aperture: REAL
			pi_nb: INTEGER
		do
			if drawable /= default_pointer then
				if a_height /= 0 then
					pi_nb := ((a_start_angle + Pi / 2) / Pi).floor
					corrected_start := a_start_angle - pi_nb * Pi
					if (math.modulo (a_start_angle, Pi)) /= Pi/2 then
						corrected_start := arc_tangent ((a_width * tangent (corrected_start))/a_height)
					end
					corrected_start := corrected_start + pi_nb * Pi
					corrected_aperture := an_aperture + a_start_angle
					pi_nb := ((corrected_aperture + Pi / 2) / Pi).floor
					corrected_aperture := corrected_aperture - pi_nb * Pi
					if (math.modulo (corrected_aperture, Pi)) /= Pi/2 then
						corrected_aperture := arc_tangent ((a_width * tangent (corrected_aperture))/a_height)
					end
					corrected_aperture := corrected_aperture - corrected_start + pi_nb * Pi
				end

				feature {EV_GTK_EXTERNALS}.gdk_draw_arc (drawable, gc, 0, x,
					y, a_width,
					a_height, (radians_to_gdk_angle * corrected_start).truncated_to_integer,
					(radians_to_gdk_angle * corrected_aperture).truncated_to_integer)
				flush
			end
		end

	draw_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP) is
			-- Draw `a_pixmap' with upper-left corner on (`x', `y').
		do
			draw_full_pixmap (x, y, a_pixmap, 0, 0, -1, -1)
		end

	draw_full_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; x_src, y_src, src_width, src_height: INTEGER) is
		local
			pixmap_imp: EV_PIXMAP_IMP
		do
			if drawable /= default_pointer then
				pixmap_imp ?= a_pixmap.implementation
				if pixmap_imp.mask /= default_pointer then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_mask (gc, pixmap_imp.mask)
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_origin (gc, x, y)
				end
				feature {EV_GTK_EXTERNALS}.gdk_draw_pixmap (drawable, gc,
					pixmap_imp.drawable,
					x_src, y_src, x, y, src_width, src_height)
				flush
				if pixmap_imp.mask /= default_pointer then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_mask (gc, default_pointer)
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_clip_origin (gc, 0, 0)
				end
			end
		end

	draw_sub_pixmap (x, y: INTEGER; a_pixmap: EV_PIXMAP; area: EV_RECTANGLE) is
			-- Draw `area' of `a_pixmap' with upper-left corner on (`x', `y').
		do
			draw_full_pixmap (x, y, a_pixmap, area.x, area.y, area.width, area.height)	
		end

	draw_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'.
		do
			if drawable /= default_pointer then
				feature {EV_GTK_EXTERNALS}.gdk_draw_rectangle (drawable, gc, 0, x, y, a_width - 1, a_height - 1)
				flush
			end
		end

	draw_ellipse (x, y, a_width, a_height: INTEGER) is
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
		do
			if drawable /= default_pointer then 
				if (a_width > 0 and a_height > 0 ) then
					feature {EV_GTK_EXTERNALS}.gdk_draw_arc (drawable, gc, 0, x,
						y, (a_width - 1),
						(a_height - 1), 0, whole_circle)
					flush
				end
			end
		end

	draw_polyline (points: ARRAY [EV_COORDINATE]; is_closed: BOOLEAN) is
			-- Draw line segments between subsequent points in
			-- `points'. If `is_closed' draw line segment between first
			-- and last point in `points'.
		local
			tmp: SPECIAL [INTEGER]
		do
			if drawable /= default_pointer then
				tmp := coord_array_to_gdkpoint_array (points).area
				if is_closed then
					feature {EV_GTK_EXTERNALS}.gdk_draw_polygon (drawable, gc, 0, $tmp, points.count)
					flush
				else
					feature {EV_GTK_EXTERNALS}.gdk_draw_lines (drawable, gc, $tmp, points.count)
					flush
				end
			end
		end

	draw_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians
		local
			left, top, right, bottom: INTEGER
			x_start_arc, y_start_arc, x_end_arc, y_end_arc: INTEGER
			semi_width, semi_height: DOUBLE
			tang_start, tang_end: DOUBLE
			x_tmp, y_tmp: DOUBLE
		do
			left := x
			top := y
			right := left + a_width
			bottom := top + a_height
			                     
			semi_width := a_width / 2
			semi_height := a_height / 2
			tang_start := tangent (a_start_angle)
			tang_end := tangent (a_start_angle + an_aperture)
			                        
			x_tmp := semi_height / (sqrt (tang_start^2 + semi_height^2 / semi_width^2))
			y_tmp := semi_height / (sqrt (1 + semi_height^2 / (semi_width^2 * tang_start^2)))
			if sine (a_start_angle) > 0 then
				y_tmp := -y_tmp
			end
			if cosine (a_start_angle) < 0 then
				x_tmp := -x_tmp
			end
			x_start_arc := (x_tmp + left + semi_width).rounded
			y_start_arc := (y_tmp + top + semi_height).rounded
			
			x_tmp := semi_height / (sqrt (tang_end^2 + semi_height^2 / semi_width^2))
			y_tmp := semi_height / (sqrt (1 + semi_height^2 / (semi_width^2 * tang_end^2)))
			if sine (a_start_angle + an_aperture) > 0 then
				y_tmp := -y_tmp
			end
			if cosine (a_start_angle + an_aperture) < 0 then
				x_tmp := -x_tmp
			end
			x_end_arc := (x_tmp + left + semi_width).rounded
			y_end_arc := (y_tmp + top + semi_height).rounded
                        		
			draw_arc (x, y, a_width, a_height, a_start_angle, an_aperture)
			draw_segment (x + (a_width // 2), y + (a_height // 2), x_start_arc, y_start_arc)
			draw_segment (x + (a_width // 2), y + (a_height // 2), x_end_arc, y_end_arc)
		end

feature -- filling operations

	fill_rectangle (x, y, a_width, a_height: INTEGER) is
			-- Draw rectangle with upper-left corner on (`x', `y')
			-- with size `a_width' and `a_height'. Fill with `background_color'.
		do
			if drawable /= default_pointer then
				if tile /= Void then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_tiled_enum)
				end
				feature {EV_GTK_EXTERNALS}.gdk_draw_rectangle (drawable, gc, 1, x, y, a_width, a_height)
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_solid_enum)
				flush
			end
		end

	fill_ellipse (x, y, a_width, a_height: INTEGER) is
			-- Draw an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Fill with `background_color'.
		do
			if drawable /= default_pointer then
				if tile /= Void then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_tiled_enum)
				end
				feature {EV_GTK_EXTERNALS}.gdk_draw_arc (drawable, gc, 1, x,
					y, a_width,
					a_height, 0, whole_circle)
				flush
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_solid_enum)
			end
		end

	fill_polygon (points: ARRAY [EV_COORDINATE]) is
			-- Draw line segments between subsequent points in `points'.
			-- Fill all enclosed area's with `background_color'.
		local
			tmp: SPECIAL [INTEGER]
		do
			if drawable /= default_pointer then
				tmp := coord_array_to_gdkpoint_array (points).area
				if tile /= Void then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_tiled_enum)
				end
				feature {EV_GTK_EXTERNALS}.gdk_draw_polygon (drawable, gc, 1, $tmp, points.count)
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_solid_enum)
				flush
			end
		end

	fill_pie_slice (x, y, a_width, a_height: INTEGER; a_start_angle, an_aperture: REAL) is
			-- Draw a part of an ellipse bounded by top left (`x', `y') with
			-- size `a_width' and `a_height'.
			-- Start at `a_start_angle' and stop at `a_start_angle' + `an_aperture'.
			-- The arc is then closed by two segments through (`x', `y').
			-- Angles are measured in radians.
		local
			corrected_start, corrected_aperture: REAL
			pi_nb: INTEGER
		do
			if drawable /= default_pointer then
				if height /= 0 then
					pi_nb := ((a_start_angle + Pi / 2) / Pi).floor
					corrected_start := a_start_angle - pi_nb * Pi
					if (math.modulo (a_start_angle, Pi)) /= Pi/2 then
						corrected_start := arc_tangent ((a_width * tangent (corrected_start))/a_height)
					end
					corrected_start := corrected_start + pi_nb * Pi
					corrected_aperture := an_aperture + a_start_angle
					pi_nb := ((corrected_aperture + Pi / 2) / Pi).floor
					corrected_aperture := corrected_aperture - pi_nb * Pi
					if (math.modulo (corrected_aperture, Pi)) /= Pi/2 then
						corrected_aperture := arc_tangent ((a_width * tangent (corrected_aperture))/a_height)
					end
					corrected_aperture := corrected_aperture - corrected_start + pi_nb * Pi
				end
				if tile /= Void then
					feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_tiled_enum)
				end
				feature {EV_GTK_EXTERNALS}.gdk_draw_arc (drawable, gc, 1, x,
					y, a_width,
					a_height, (corrected_start * radians_to_gdk_angle).rounded,
					(corrected_aperture * radians_to_gdk_angle).rounded)
				feature {EV_GTK_EXTERNALS}.gdk_gc_set_fill (gc, feature {EV_GTK_EXTERNALS}.Gdk_solid_enum)
				flush
			end
		end

feature {NONE} -- Implemention

	coord_array_to_gdkpoint_array (pts: ARRAY [EV_COORDINATE]): ARRAY [INTEGER] is
			-- Low-level conversion.
		require
			pts_exists: pts /= Void
		local
			i, array_count: INTEGER
			a_pts: ARRAY [EV_COORDINATE]
			a_coord: EV_COORDINATE
		do
			from
				a_pts := pts
				array_count := a_pts.count * 2 
				create Result.make (1, array_count)
				i := 2				
			until
				i > array_count + 1
			loop
				a_coord := a_pts.item (i // 2)
				Result.force (a_coord.x, i - 1)
				Result.force (a_coord.y, i)			
				i := i + 2
			end
		ensure
			Result_exists: Result /= Void
			same_size: pts.count = Result.count / 2
		end

	radians_to_gdk (ang: REAL): INTEGER is
			-- Converts `ang' (radians) to degrees * 64.
		do
			Result := ((ang / Pi) * 180 * 64).rounded
		end

feature {NONE} -- Implementation

	app_implementation: EV_APPLICATION_IMP is
			-- Return the instance of EV_APPLICATION_IMP.
		deferred
		end	

	internal_foreground_color: EV_COLOR
			-- Color used to draw primitives.
		
	internal_background_color: EV_COLOR
			-- Color used for erasing of canvas.
			-- Default: white.

	flush is
			-- Force all queued expose events to be called.
		deferred
		end

	whole_circle: INTEGER is 23040
		-- Number of 1/64 th degrees in a full circle (360 * 64)
		
	radians_to_gdk_angle: INTEGER is 3667 -- 
			-- Multiply radian by this to get no of (1/64) degree segments.

	internal_font_imp: EV_FONT_IMP
	
	interface: EV_DRAWABLE
	
	math: EV_FIGURE_MATH is
		once
			create Result
		end
		
	system_colormap: POINTER is
			-- Default system color map used for allocating colors.
		once
			Result := feature {EV_GTK_EXTERNALS}.gdk_rgb_get_cmap
		end
		
	gdk_gc_unref (a_gc: POINTER) is 
			-- void   gdk_gc_unref		  (GdkGC	    *gc);
		external
			"C (GdkGC*) | <gtk/gtk.h>"
		end

invariant
	gc_not_void: is_usable implies gc /= default_pointer

end -- class EV_DRAWABLE_IMP

--|----------------------------------------------------------------
--| EiffelVision2: library of reusable components for ISE Eiffel.
--| Copyright (C) 1985-2004 Eiffel Software. All rights reserved.
--| Duplication and distribution prohibited.  May be used only with
--| ISE Eiffel, under terms of user license.
--| Contact Eiffel Software for any other use.
--|
--| Interactive Software Engineering Inc.
--| dba Eiffel Software
--| 356 Storke Road, Goleta, CA 93117 USA
--| Telephone 805-685-1006, Fax 805-685-6869
--| Contact us at: http://www.eiffel.com/general/email.html
--| Customer support: http://support.eiffel.com
--| For latest info on our award winning products, visit:
--|	http://www.eiffel.com
--|----------------------------------------------------------------

