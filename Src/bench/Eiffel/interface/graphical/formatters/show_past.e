indexing

	description:	
		"Command to display the history of a feature.";
	date: "$Date$";
	revision: "$Revision$"

class SHOW_PAST

inherit

	FILTERABLE
		redefine
			dark_symbol, display_temp_header
		end;
	SHARED_SERVER

creation

	make
	
feature -- Properties

	symbol: PIXMAP is 
		once 
			Result := Pixmaps.bm_Showaversions 
		end;
 
	dark_symbol: PIXMAP is 
		once 
			Result := Pixmaps.bm_Dark_showaversions 
		end;
 
feature {NONE} -- Properties

	name: STRING is
		do
			Result := Interface_names.f_Showpast
		end;

	menu_name: STRING is
			-- Name used in menu entry
		do
			Result := Interface_names.m_Showpast
		end;

	accelerator: STRING is
			-- Accelerator action for menu entry
		do
		end;

	title_part: STRING is
		do
			Result := Interface_names.t_Past
		end;

	create_structured_text (f: FEATURE_STONE): STRUCTURED_TEXT is
			-- Display history of `f'.
		local
			cmd: E_SHOW_ROUTINE_ANCESTORS;
		do
			!! Result.make;
			!! cmd.make (f.e_feature, Result);
			if cmd.has_valid_feature then
				cmd.execute
			end
		end;

feature {NONE} -- Implementation

	display_temp_header (stone: STONE) is
			-- Display a temporary header during the format processing.
		do
			tool.set_title ("Searching system for ancestor versions...")
		end;

end -- class SHOW_PAST
