indexing

	description:	
		"Command to display class attributes.";
	date: "$Date$";
	revision: "$Revision$"

class SHOW_ATTRIBUTES 

inherit

	FILTERABLE
		redefine
			dark_symbol, display_temp_header, post_fix
		end

creation

	make
	
feature -- Properties

	symbol: PIXMAP is 
			-- Pixmap for the button.
		once 
			Result := Pixmaps.bm_Showattributes 
		end;
 
	dark_symbol: PIXMAP is 
			-- Dark version of `symbol'.
		once 
			Result := Pixmaps.bm_Dark_showattributes 
		end;
 
	
feature {NONE} -- Properties

	name: STRING is
			-- Name of the command.
		do
			Result := Interface_names.f_Showattributes
		end;

	menu_name: STRING is
			-- Name used in menu entry
		do
			Result := Interface_names.m_Showattributes
		end;

	accelerator: STRING is
			-- Accelerator action for menu entry
		do
		end;

	title_part: STRING is
		do
			Result := Interface_names.t_Attributes_of
		end;

	post_fix: STRING is "att";

	create_structured_text (c: CLASSC_STONE): STRUCTURED_TEXT is
		local
			cmd: E_SHOW_ATTRIBUTES
		do
			!! cmd.make (c.e_class);
			cmd.execute;
			Result := cmd.structured_text
		end;

feature {NONE} -- Implementation

	display_temp_header (stone: STONE) is
			-- Display a temporary header during the format processing.
		do
			tool.set_title ("Finding attributes...")
		end;

end -- SHOW_ATTRIBUTES
