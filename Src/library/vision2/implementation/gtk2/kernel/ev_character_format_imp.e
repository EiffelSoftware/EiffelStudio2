indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EV_CHARACTER_FORMAT_IMP

inherit
	EV_CHARACTER_FORMAT_I
		undefine
			copy, is_equal
		end
	
	IDENTIFIED
		undefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (an_interface: like interface) is
			-- Create character format 
		do
			base_make (an_interface)
		end
	
	initialize is
			-- Do nothing
		do
			bcolor := 0xFFFFFF -- White
			fcolor := 0 -- Black
			
			set_font_attributes
				(
					app_implementation.default_font_name_internal,
					feature {EV_FONT_CONSTANTS}.family_sans,
					app_implementation.default_font_size_internal,
					app_implementation.default_font_weight_internal,
					feature {EV_FONT_CONSTANTS}.shape_regular,
					0
				)
			is_initialized := True
		end

feature -- Access

	font: EV_FONT is
			-- Font of the current format
		do
			create Result
			Result.set_family (family)
			Result.set_height (height)
			Result.set_weight (weight)
			Result.set_shape (shape)
			Result.preferred_families.extend (name)
		end
	
	color: EV_COLOR is
			-- Color of the current format
		local
			a_color: INTEGER
		do
			a_color := fcolor
			create Result
			Result.set_red_with_8_bit (a_color & 0x000000FF)
			Result.set_green_with_8_bit ((a_color & 0x0000FF00) |>> 8)
			Result.set_blue_with_8_bit (a_color |>> 16)
		end

	background_color: EV_COLOR is
			-- Background Color of the current format
		local
			a_color: INTEGER
		do
			a_color := bcolor
			create Result
			Result.set_red_with_8_bit (a_color & 0x000000FF)
			Result.set_green_with_8_bit ((a_color & 0x0000FF00) |>> 8)
			Result.set_blue_with_8_bit (a_color |>> 16)
		end
		
	effects: EV_CHARACTER_FORMAT_EFFECTS is
			-- Character format effects applicable to `font'
		do
			create Result
			if is_underlined then
				Result.enable_underlined
			end
			if is_striked_out then
				Result.enable_striked_out
			end
			Result.set_vertical_offset (vertical_offset)
		end

feature -- Status setting
		
	set_font (a_font: EV_FONT) is
			-- Make `value' the new font
		do
			set_font_attributes
				(
					a_font.name,
					a_font.family,
					a_font.height,
					a_font.weight,
					a_font.shape,
					0
				)
		end

	set_font_attributes (a_name: STRING; a_family, a_height, a_weight, a_shape, a_charset: INTEGER) is
			-- Set internal font attributes
		do
			name := a_name
			family := a_family
			height := a_height
			height_in_points := app_implementation.point_value_from_pixel_value (height)
			weight := a_weight
			shape := a_shape
			char_set := a_charset
		end

	set_color (a_color: EV_COLOR) is
			-- Make `value' the new color
		do
			set_fcolor (a_color.red_8_bit, a_color.green_8_bit, a_color.blue_8_bit)
		end

	set_fcolor (a_red, a_green, a_blue: INTEGER) is
			-- Pack `fcolor' with `a_red', `a_green' and `a_blue'
		do
			fcolor := a_blue;
			fcolor := fcolor |<< 8
			fcolor := fcolor + a_green
			fcolor := fcolor |<< 8
			fcolor := fcolor + a_red
		end

	set_bcolor (a_red, a_green, a_blue: INTEGER) is
			-- Pack `bcolor' with `a_red', `a_green' and `a_blue'
		do
			bcolor := a_blue;
			bcolor := bcolor |<< 8
			bcolor := bcolor + a_green
			bcolor := bcolor |<< 8
			bcolor := bcolor + a_red
		end

	set_background_color (a_color: EV_COLOR) is
			-- Make `value' the new color
		do
			set_bcolor (a_color.red_8_bit, a_color.green_8_bit, a_color.blue_8_bit)
		end
		
	set_effects (an_effect: EV_CHARACTER_FORMAT_EFFECTS) is
			-- Make `an_effect' the new `effects'
		do
			set_effects_internal (an_effect.is_underlined, an_effect.is_striked_out, an_effect.vertical_offset)
		end

	set_effects_internal (a_underlined, a_striked_out: BOOLEAN; a_vertical_offset: INTEGER) is
			-- 
		do
			is_underlined := a_underlined
			is_striked_out := a_striked_out
			vertical_offset := a_vertical_offset
		end

feature {EV_RICH_TEXT_IMP} -- Implementation
		
	dummy_character_format_range_information: EV_CHARACTER_FORMAT_RANGE_INFORMATION is
			-- Used for creating a fully set GtkTextTag
		once
			create Result.make_with_flags (
				feature {EV_CHARACTER_FORMAT_CONSTANTS}.font_family
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.font_weight
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.font_shape
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.font_height
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.color
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.background_color
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.effects_striked_out
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.effects_underlined
				| feature {EV_CHARACTER_FORMAT_CONSTANTS}.effects_vertical_offset
			)
		end

	apply_character_format_to_text_buffer (applicable_attributes: EV_CHARACTER_FORMAT_RANGE_INFORMATION; a_text_buffer, a_start_iter, a_end_iter: POINTER) is
			-- Apply `Current' to `a_text_buffer' to the region bounded by `a_start_iter' and `a_end_iter'
		local
			a_tag_table: POINTER
			a_text_tag: POINTER
			a_text_tag_name: EV_GTK_C_STRING
			prop_value_int: INTEGER
			prop_value_string: EV_GTK_C_STRING
			temp_string: STRING
			a_red, a_green, a_blue: INTEGER
		do
			a_tag_table := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_get_tag_table (a_text_buffer)
			
			if applicable_attributes.font_family then
				a_text_tag_name := name
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_string (a_text_tag, family_string.item, a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end

			if applicable_attributes.font_height then
				a_text_tag_name := "fh" + height.out
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (a_text_tag, size_string.item, height * feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_scale)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end
			
			if applicable_attributes.font_shape then
				if shape = feature {EV_FONT_CONSTANTS}.shape_italic then
					a_text_tag_name := "fsi"
					prop_value_int := 2
				else
					a_text_tag_name := "fsr"
					prop_value_int := 0
				end
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (a_text_tag, style_string.item, prop_value_int)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end


			if applicable_attributes.font_weight then
				inspect
					weight
				when
					feature {EV_FONT_CONSTANTS}.weight_bold
				then
					a_text_tag_name := "fwb"
					prop_value_int := feature {EV_FONT_IMP}.pango_weight_bold
				when
					feature {EV_FONT_CONSTANTS}.weight_regular
				then
					a_text_tag_name := "fwr"
					prop_value_int := feature {EV_FONT_IMP}.pango_weight_normal
				when
					feature {EV_FONT_CONSTANTS}.weight_thin
				then
					a_text_tag_name := "fwt"
					prop_value_int := feature {EV_FONT_IMP}.pango_weight_ultra_light
				when
					feature {EV_FONT_CONSTANTS}.weight_black
				then
					a_text_tag_name := "fwb"
					prop_value_int := feature {EV_FONT_IMP}.pango_weight_heavy
				end
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (a_text_tag, weight_string.item, prop_value_int)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end
			
			
			if applicable_attributes.color then
				a_text_tag_name := "fg" + fcolor.out
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)

					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_blue (App_implementation.reusable_color_struct, (fcolor |>> 16) * 257)
					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_green (App_implementation.reusable_color_struct, ((fcolor |<< 16) |>> 24) * 257)
					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_red (App_implementation.reusable_color_struct, ((fcolor |<< 24) |>> 24) * 257)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_pointer (a_text_tag, foreground_gdk_string.item, App_implementation.reusable_color_struct, default_pointer)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end

			if applicable_attributes.background_color then
				a_text_tag_name := "bg" + bcolor.out
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)

					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_blue (App_implementation.reusable_color_struct, (bcolor |>> 16) * 257)
					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_green (App_implementation.reusable_color_struct, ((bcolor |<< 16) |>> 24) * 257)
					feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_red (App_implementation.reusable_color_struct, ((bcolor |<< 24) |>> 24) * 257)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_pointer (a_text_tag, background_gdk_string.item, App_implementation.reusable_color_struct, default_pointer)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end

			if applicable_attributes.effects_striked_out then
				if is_striked_out then
					a_text_tag_name := "sot"
				else
					a_text_tag_name := "sof"
				end
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_boolean (a_text_tag, strikethrough_string.item, is_striked_out)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end

			if applicable_attributes.effects_underlined then
				if is_underlined then
					a_text_tag_name := "ut"
				else
					a_text_tag_name := "uf"
				end
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_boolean (a_text_tag, underline_string.item, is_underlined)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end
	
			if applicable_attributes.effects_vertical_offset then
				a_text_tag_name := "vo" + vertical_offset.out
				a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_lookup (a_tag_table, a_text_tag_name.item)
				if a_text_tag = default_pointer then
					a_text_tag := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (a_text_tag_name.item)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (a_text_tag, rise_string.item, vertical_offset)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_table_add (a_tag_table, a_text_tag)					
				end
				feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_buffer_apply_tag (a_text_buffer, a_text_tag, a_start_iter, a_end_iter)
			end
		end
		

	new_text_tag_from_applicable_attributes (applicable_attributes: EV_CHARACTER_FORMAT_RANGE_INFORMATION): POINTER is
			-- Create a new text tag based on state of `Current'
		local
			color_struct: POINTER
			propvalue: EV_GTK_C_STRING
			a_red, a_green, a_blue: INTEGER
			temp_string: STRING
		do
			
			Result := feature {EV_GTK_DEPENDENT_EXTERNALS}.gtk_text_tag_new (default_pointer)
			
			if (applicable_attributes.font_family or else applicable_attributes.font_height or else applicable_attributes.font_shape or else applicable_attributes.font_weight) then
				if applicable_attributes.font_family then
					create propvalue.make (name)
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_string (Result, family_string.item, propvalue.item)					
				end
				if applicable_attributes.font_height then
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, size_string.item, height * feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_scale)	
				end
				if applicable_attributes.font_shape then
					if shape = feature {EV_FONT_CONSTANTS}.shape_italic then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, style_string.item, 2)
					else
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, style_string.item, 0)
					end
				end
				if applicable_attributes.font_weight then
					inspect
						weight
					when
						feature {EV_FONT_CONSTANTS}.weight_bold
					then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, weight_string.item, feature {EV_FONT_IMP}.pango_weight_bold)
					when
						feature {EV_FONT_CONSTANTS}.weight_regular
					then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, weight_string.item, feature {EV_FONT_IMP}.pango_weight_normal)
					when
						feature {EV_FONT_CONSTANTS}.weight_thin
					then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, weight_string.item, feature {EV_FONT_IMP}.pango_weight_ultra_light)
					when
						feature {EV_FONT_CONSTANTS}.weight_black
					then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, weight_string.item, feature {EV_FONT_IMP}.pango_weight_heavy)
					end				
				end
			end

			color_struct := App_implementation.reusable_color_struct
			if applicable_attributes.color then
				a_red := (fcolor & 0x000000FF) |<< 16
				a_green := (fcolor & 0x0000FF00)
				a_blue := fcolor |>> 16
				temp_string := (a_red + a_green + a_blue).to_hex_string
				temp_string.keep_tail (6)
				propvalue := "#" +  temp_string
				feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_string (Result, foreground_string.item, propvalue.item)

				--feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_blue (color_struct, (fcolor |>> 16) * 257)
				--feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_green (color_struct, ((fcolor |<< 16) |>> 24) * 257)
				--feature {EV_GTK_EXTERNALS}.set_gdk_color_struct_red (color_struct, ((fcolor |<< 24) |>> 24) * 257)
				--feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_pointer (Result, foreground_gdk_string.item, color_struct, default_pointer)
							
			end

			if applicable_attributes.background_color then
				a_red := (bcolor & 0x000000FF) |<< 16
				a_green := (bcolor & 0x0000FF00)
				a_blue := bcolor |>> 16
				temp_string := (a_red + a_green + a_blue).to_hex_string
				temp_string.keep_tail (6)
				propvalue := "#" +  temp_string
				feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_string (Result, background_string.item, propvalue.item)		
			end	

			if (applicable_attributes.effects_striked_out or else applicable_attributes.effects_underlined or else applicable_attributes.effects_vertical_offset) then
				if applicable_attributes.effects_striked_out then
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_boolean (Result, strikethrough_string.item, is_striked_out)
				end
				if applicable_attributes.effects_underlined then 
					if is_underlined then
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, underline_string.item, feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_underline_single_enum)
					else
						feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, underline_string.item, feature {EV_GTK_DEPENDENT_EXTERNALS}.pango_underline_none_enum)
					end
				end
				if applicable_attributes.effects_vertical_offset then
					feature {EV_GTK_DEPENDENT_EXTERNALS}.g_object_set_integer (Result, rise_string.item, vertical_offset)
				end
			end
		end
		
	family_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("family")	
		end

	size_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("size")	
		end

	style_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("style")
		end

	weight_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("weight")	
		end

	foreground_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("foreground")	
		end

	background_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("background")	
		end

	foreground_gdk_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("foreground-gdk")	
		end

	background_gdk_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("background-gdk")	
		end

	underline_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("underline")	
		end

	strikethrough_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("strikethrough")	
		end

	rise_string: EV_GTK_C_STRING is
			-- String optimization
		once
			create Result.make ("rise")	
		end

feature {NONE} -- Implementation

	app_implementation: EV_APPLICATION_IMP is
			-- 
		once
			Result ?= (create {EV_ENVIRONMENT}).application.implementation
		end

	name: STRING
			-- Face name used by `Current'.
		
	family: INTEGER
			-- Family used by `Current'.
		
	height: INTEGER
			--  Height of `Current' in screen pixels.

	height_in_points: INTEGER
			-- Height of `Current' in points.
		
	weight: INTEGER
			-- Weight of `Current'.
		
	is_bold: BOOLEAN is
			-- Is `Current' bold?
		do
			Result := (weight = feature {EV_FONT_CONSTANTS}.weight_bold)
		end
		
	shape: INTEGER
			-- Shape of `Current'.

	char_set: INTEGER
			-- Char set used by `Current'.
		
	is_underlined: BOOLEAN
			-- Is `Current' underlined?
		
	is_striked_out: BOOLEAN
			-- Is `Current' striken out?
		
	vertical_offset: INTEGER
			-- Vertical offset of `Current'.

	fcolor: INTEGER
			-- foreground color BGR packed into 24 bit.
		
	bcolor: INTEGER
			-- background color BGR packed into 24 bit.

	destroy is
			-- Clean up
		do
			-- Do nothing
		end

end -- class EV_CHARACTER_FORMAT_IMP

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

