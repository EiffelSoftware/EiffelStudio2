
class SET_PAGE 

inherit

	CONTEXT_CAT_PAGE

creation

	make
	
feature 

	bulletin_type: CONTEXT_TYPE;
	radio_box_type: CONTEXT_TYPE;
	check_box_type: CONTEXT_TYPE;

feature {NONE}

	build_interface is
		local
			toggle_b: TOGGLE_B;
			frame_radio_box: FRAME;
			frame_check_box: FRAME;
			radio_box: RADIO_BOX;
			check_box: CHECK_BOX;
			radio_box_c: RADIO_BOX_C;
			check_box_c: CHECK_BOX_C;
			bulletin_c: BULLETIN_C;
		do
			!!radio_box_c;
			!!frame_radio_box.make (radio_box_c.eiffel_type, Current);
			!!radio_box.make (radio_box_c.eiffel_type, frame_radio_box);
			!!toggle_b.make (Widget_names.toggle_b1_name, radio_box);
			!!toggle_b.make (Widget_names.toggle_b2_name, radio_box);
			!!radio_box_type.make (Widget_names.radio_box_name, radio_box_c);
			radio_box_type.initialize_callbacks (radio_box);

			!!check_box_c;
			!!frame_check_box.make (Widget_names.check_box, Current);
			!!check_box.make (Widget_names.check_box, frame_check_box);
			!!toggle_b.make (Widget_names.toggle_b1_name, check_box);
			!!toggle_b.make (Widget_names.toggle_b2_name, check_box);
			!!check_box_type.make (Widget_names.check_box_name, check_box_c);
			check_box_type.initialize_callbacks (check_box);

			!!bulletin_c;
			bulletin_type := create_type (Widget_names.bulletin_name, 
					bulletin_c, Pixmaps.cat_bulletin_pixmap);

			attach_left (frame_radio_box, 1);
			attach_left_widget (frame_radio_box, frame_check_box, 10);

			attach_left (bulletin_type.source, 1);

			attach_top (frame_radio_box, 1);
			attach_top (frame_check_box, 1);

			attach_top_widget (frame_radio_box, bulletin_type.source, 10);
		end;

	symbol: PIXMAP is
		do
			Result := Pixmaps.sets_pixmap
		end;

	selected_symbol: PIXMAP is
		do
			Result := Pixmaps.selected_sets_pixmap
		end;

	focus_string: STRING is
		do
			Result := Focus_labels.sets_label
		end;

end
