indexing
	description: "Form containing a set of query properties used to generate %
				% the corresponding object editor. Used when the returned %
				% is not BOOLEAN."
	date: "$Date$"
	id: "$Id$"
	revision: "$Revision$"

class
	ANY_QUERY_EDITOR_FORM

inherit

	QUERY_EDITOR_FORM

	COMMAND

creation

	make

feature {NONE} -- GUI

   create_interface is
			-- Create interface.
		do
			!! procedure_opt_pull.make ("", Current)
			!! bottom_form.make ("", Current)
			!! query_label.make ("", Current)
			!! procedure_label.make ("Procedure:", Current)
			!! separator.make ("", Current)

			!! test_toggle_b.make ("Precondition test", Current)
			!! test_label.make("Error message:", Current)
			!! test_text_field.make ("", Current)

			!! select_label.make ("Select through:", bottom_form)
			!! select_radio_box.make ("", bottom_form)
			!! field_toggle_b.make ("Field", select_radio_box)
			!! menu_toggle_b.make ("Menu", select_radio_box)
			!! field_and_menu_toggle_b.make ("Field + menu", select_radio_box)
			!! menu_choice_label.make ("Menu choices:", bottom_form)
			!! menu_choice_sc_l.make ("", bottom_form)
			!! add_menu_label.make ("Menu entry:", bottom_form)
			!! menu_text_field.make ("", bottom_form)
			!! delete_button.make ("Delete", bottom_form)
			set_values
			attach_all
			set_callbacks
		end

	set_values is
			-- Set values for GUI elements.
		local
			set_colors: SET_WINDOW_ATTRIBUTES_COM
		do
			set_size (475, 165)
			!! set_colors
			set_colors.execute (Current)
			select_radio_box.set_always_one (True)
			field_toggle_b.set_toggle_on
			menu_choice_sc_l.set_visible_item_count (4)
			deactivate_menu_fields
			if object_tool_generator.precondition_test.state then
				test_toggle_b.arm
			else	
				test_text_field.set_insensitive
			end
		end

	attach_all is
			-- Perform attachments.
		do
 			attach_top (procedure_label, 8)
 			attach_top (procedure_opt_pull, 5)
			attach_top (query_label, 5)
 			attach_left (query_label, 0)
  			attach_right (procedure_opt_pull, 0)
  			attach_right_widget (procedure_opt_pull, procedure_label, 5)

 			
			attach_left (test_toggle_b, 5)
	   		attach_top_widget (query_label, test_toggle_b, 5)
			attach_top_widget (procedure_label, test_text_field, 0)
			attach_top_widget (procedure_label, test_label, 10) 
			attach_left_widget (test_toggle_b, test_label, 0)
			attach_left_widget (test_label, test_text_field, 10)
			attach_right (test_text_field, 0)
			attach_top_widget (procedure_opt_pull, test_text_field, 0) 

			attach_top_widget (test_toggle_b, bottom_form, 10)
			attach_top_widget (test_text_field, bottom_form, 10)						
			attach_left (bottom_form, 0)
			attach_right (bottom_form, 0)

 			attach_top_widget (bottom_form, separator, 0)
 			attach_left (separator, 0)
 			attach_right (separator, 0)
 			attach_bottom (separator, 0)
			
			bottom_form.attach_left (select_label, 10)
			bottom_form.attach_top (select_label, 5)
			bottom_form.attach_top (add_menu_label, 5)
			bottom_form.attach_left_widget (select_label, add_menu_label, 50)
			bottom_form.attach_top_widget (select_label, select_radio_box, 0)		
			bottom_form.attach_left (select_radio_box, 20)
			bottom_form.attach_top (menu_text_field, 5)
			bottom_form.attach_top_widget (add_menu_label, menu_choice_label, 10)
			bottom_form.attach_top_widget (add_menu_label, menu_choice_sc_l, 10)
			bottom_form.attach_top_widget (menu_text_field, menu_choice_sc_l, 10)
			bottom_form.attach_top_widget (menu_text_field, menu_choice_label, 10)
			bottom_form.attach_top_widget (menu_choice_label, delete_button, 10)
			bottom_form.attach_left_widget (select_radio_box, menu_choice_label, 10)
			bottom_form.attach_left_widget (select_radio_box, delete_button, 20)
			bottom_form.attach_left_widget (add_menu_label, menu_text_field, 24)
			bottom_form.attach_left_widget (menu_choice_label, menu_choice_sc_l, 3)
			bottom_form.attach_left_widget (delete_button, menu_choice_sc_l, 18)
			bottom_form.attach_right (menu_choice_sc_l, 0)
			bottom_form.attach_right (menu_text_field, 0)
		end	

	update_interface is
			-- Update the interface after setting `query'.
		local
			error_message: STRING
		do
			query_label.set_text (query.value)
			!! error_message.make (0)
			error_message.append ("Incorrect `")
			error_message.append (query.query_name)
			error_message.append ("' field.")
			test_text_field.set_text(error_message)
			update_procedure_opt_pull
		end

	set_callbacks is
			-- Add callbacks on GUI elements
		do
			test_toggle_b.add_activate_action (Current, Void)
			menu_toggle_b.add_activate_action (Current, Void)
			field_toggle_b.add_activate_action (Current, Void)
			field_and_menu_toggle_b.add_activate_action (Current, Void)
			menu_text_field.set_action ("<Key>Return", Current, menu_text_field)
			delete_button.add_activate_action (Current, delete_button)
			menu_choice_sc_l.add_default_action (Current, menu_choice_sc_l)
		end

feature {NONE} -- GUI attributes

	bottom_form: FORM
			-- Form at the bottom including the radio_box and 
			-- the  scrollable list.

	query_label,
			-- Query label

	procedure_label,
			-- Procedure label

	test_label,
			-- Precondition test label
	
	menu_choice_label,
			-- Menu choice when selecting `menu_toggle_b'

	add_menu_label,
			-- 'Add menu' label

	select_label: LABEL
			-- "Select through" label

	test_text_field,
			-- Text field used to add the precondition test

	menu_text_field: TEXT_FIELD
			-- Text field used to add a new menu

	select_radio_box: RADIO_BOX
			-- Radio box used to select the kind of widget used
			-- to edit the query

	test_toggle_b,
			-- Precondition test field

	field_toggle_b,
			-- 'Field' field

	menu_toggle_b,
			-- 'Menu' field

	field_and_menu_toggle_b: TOGGLE_B
			-- 'Field+Menu' field

	menu_choice_sc_l: SCROLLABLE_LIST
			-- List of choice when selecting `menu_toggle_b'

	separator: THREE_D_SEPARATOR
			-- Separator used between different query editor forms

	delete_button: PUSH_B
			-- Delete button

feature -- GUI attributes

	procedure_opt_pull: OPT_PULL
			-- Option pull used to select the procedure used
			-- to set `query'.

feature {NONE} -- Heuristic

	update_procedure_opt_pull is
			-- Display a list of compatible procedure in
			-- `procedure_opt_pull'.
		require
			current_application_class_not_void: current_application_class /= Void
		local
			menu_entry: APPLICATION_METHOD_PUSH_B
		do
			if not query.possible_commands.empty then
				from 
					query.possible_commands.start
				until
					query.possible_commands.after
				loop
					!! menu_entry.make (query.possible_commands.item, procedure_opt_pull)
					query.possible_commands.forth
				end
				procedure_opt_pull.set_selected_button (menu_entry)
			end
		end

feature -- Execution

	execute (arg: ANY) is
			-- Activate or deactivate the menu fields.
		local
			a_menu_choice: STRING_SCROLLABLE_ELEMENT
			selected_items: LINKED_LIST [SCROLLABLE_LIST_ELEMENT]
			removed: BOOLEAN
			temp_string: STRING
		do
			if arg = menu_text_field then
				if not (menu_text_field.count = 0) then
					!! a_menu_choice.make (0)
					a_menu_choice.append (menu_text_field.text)
					menu_choice_sc_l.extend (a_menu_choice)
					menu_text_field.clear
				end
			elseif (arg = delete_button) and (menu_choice_sc_l.selected_count > 0) 
			then
				selected_items := menu_choice_sc_l.selected_items
				if not selected_items.empty then
					from
						selected_items.start
					until
						selected_items.after
					loop
						from
							menu_choice_sc_l.start
							removed := False
						until
							removed or menu_choice_sc_l.after
						loop
							if selected_items.item.value.is_equal (menu_choice_sc_l.item.value) then
								removed := True
								menu_choice_sc_l.remove
							else
								menu_choice_sc_l.forth
							end
						end
						selected_items.forth
					end
				end
			elseif arg = menu_choice_sc_l and menu_choice_sc_l.selected_count > 0 then
				if default_choice /= Void then
					temp_string := default_choice.substring (1, default_choice.count - 10)
					default_choice.wipe_out
					default_choice.append (temp_string)
				end
				default_choice ?= menu_choice_sc_l.selected_item
				check
					default_choice_not_void: default_choice /= Void
				end
				default_choice.append (" <Default>")
			else
				if menu_toggle_b.state or field_and_menu_toggle_b.state then
					activate_menu_fields
				else
					deactivate_menu_fields
				end
				
				if test_toggle_b.state then
					test_text_field.set_sensitive
				else
					test_text_field.set_insensitive
				end
			end
		end

	deactivate_menu_fields is
			-- Deactivate every field related to the notion of Menu.
		do
			menu_choice_label.set_insensitive
			menu_choice_sc_l.set_insensitive
			add_menu_label.set_insensitive
			menu_text_field.set_insensitive
			delete_button.set_insensitive
		end

	activate_menu_fields is
			-- Activate every field related to the notion of Menu.
		do
			menu_choice_label.set_sensitive
			menu_choice_sc_l.set_sensitive
			add_menu_label.set_sensitive
			menu_text_field.set_sensitive
			delete_button.set_sensitive
		end

feature {NONE} -- Attribute

	default_choice: STRING_SCROLLABLE_ELEMENT
			-- Default choice in the menu entries

feature {NONE} -- Generated interface attributes

	new_text_field_c: TEXT_FIELD_C
			-- Text field holding the value used to set `query'
	new_opt_pull_c: OPT_PULL_C
			-- Option pull holding the value used to set `query' 

feature -- Interface generation

	generate_interface_elements (base_x, base_y: INTEGER; a_perm_wind_c: PERM_WIND_C) is
			-- Generate the interface elements in `a_perm_wind_c'
			-- starting at position (`base_x', `base_y').
		local
			new_label_c: LABEL_C
		do
			!! new_label_c
			new_label_c := new_label_c.create_context (a_perm_wind_c)
			new_label_c.set_visual_name (query.query_name)
			new_label_c.set_x_y (base_x, base_y)
			new_label_c.set_size (130, new_label_c.height)
			if field_toggle_b.state then
				!! new_text_field_c
				new_text_field_c := new_text_field_c.create_context (a_perm_wind_c)
				new_text_field_c.set_x_y (base_x + 130, base_y)
				new_text_field_c.set_size (130, new_text_field_c.height)
				display_new_context (new_text_field_c)
				text_field_name := new_text_field_c.entity_name
			elseif menu_toggle_b.state then
				!! new_opt_pull_c
				new_opt_pull_c := new_opt_pull_c.create_context (a_perm_wind_c)
				new_opt_pull_c.set_x_y (base_x + 130, base_y)
				new_opt_pull_c.set_size (130, new_opt_pull_c.height)
				fill_menu (new_opt_pull_c)
				display_new_context (new_opt_pull_c)
				opt_pull_name := new_opt_pull_c.entity_name
			elseif field_and_menu_toggle_b.state then
				!! new_text_field_c
				!! new_opt_pull_c
				new_text_field_c := new_text_field_c.create_context (a_perm_wind_c)
				new_opt_pull_c := new_opt_pull_c.create_context (a_perm_wind_c)
				new_text_field_c.set_x_y (base_x + 130, base_y)
				new_text_field_c.set_size (45, new_text_field_c.height)
				new_opt_pull_c.set_x_y (base_x + 180, base_y)
				new_opt_pull_c.set_size (50, new_opt_pull_c.height)
				fill_menu (new_opt_pull_c)
				display_new_context (new_text_field_c)
				display_new_context (new_opt_pull_c)
				is_both := True
				text_field_name := new_text_field_c.entity_name
				opt_pull_name := new_opt_pull_c.entity_name
			end
		end

	fill_menu (an_opt_pull_c: OPT_PULL_C) is
			-- Fill menus for `an_opt_pull_c'.
		local
			new_push_b_c: PUSH_B_C
		do
			!! new_push_b_c
			from
				menu_choice_sc_l.start
			until
				menu_choice_sc_l.after
			loop
				new_push_b_c := new_push_b_c.create_context (an_opt_pull_c)
				new_push_b_c.set_visual_name (menu_choice_sc_l.item.value)
				menu_choice_sc_l.forth
			end
		end

feature -- Interface generation

	minimum_height: INTEGER is 25
			-- Height needed to fit the generated elements
			-- on the permanent window.

	minimum_width: INTEGER is 150
			-- Width for needed to fit the generated elements
			-- on the permanent window.

feature -- Command generation

	arguments: EB_LINKED_LIST [ARG] is
		   -- Generated widgets holding the value to set `query'.
		local
			arg: ARG
		do
			!! Result.make
			if is_both then
				!! arg.session_init (new_text_field_c.type)
				Result.extend (arg)
				!! arg.session_init (new_opt_pull_c.type)
				Result.extend (arg)
			elseif new_text_field_c /= Void then
				!! arg.session_init (new_text_field_c.type)
				Result.extend (arg)
			else
				!! arg.session_init (new_opt_pull_c.type)
				Result.extend (arg)
			end	
		end

	argument_instances: EB_LINKED_LIST [ARG_INSTANCE] is
		   -- Generated widgets holding the value to set `query'.
		local
			arg: ARG_INSTANCE
		do
			!! Result.make
			if is_both then
				!! arg.storage_init (new_text_field_c.type, new_text_field_c)
				Result.extend (arg)
				!! arg.storage_init (new_opt_pull_c.type, new_opt_pull_c)
				Result.extend (arg)
			elseif new_text_field_c /= Void then
				!! arg.storage_init (new_text_field_c.type, new_text_field_c)
				Result.extend (arg)
			else
				!! arg.storage_init (new_opt_pull_c.type, new_opt_pull_c)
				Result.extend (arg)
			end	
		end

	generate_eiffel_text (counter: INT_GENERATOR): STRING is
			-- Generate Eiffel text corresponding to the setting
			-- of the query correpsonding to `query'.
		local
			actual_argument: STRING
		do
			!! Result.make (0)
			Result.append ("%T%T%T")
			if is_both then
				Result.append ("if not argument")
				Result.append_integer (counter.value)
				Result.append (".text.empty then%N%T%T%T")
				!! actual_argument.make (0)
				actual_argument.append ("argument")
				actual_argument.append_integer (counter.value)
				actual_argument.append (".text")
				actual_argument.append (extension_to_add)
				Result.append (eiffel_setting (actual_argument))
				if test_toggle_b.state and not procedure.precondition_list.empty then
					Result.append ("%N%T%T%T%Telse%N%T%T%T%T%Tdisplay_error_message (%"")
					Result.append (test_text_field.text)
					Result.append ("%", argument")
					Result.append_integer (counter.value)
					Result.append (".parent)%N%T%T%T%Tend%N")
				end	
				Result.append ("%T%T%Telse%N%T%T%T%T")
				counter.next
				!! actual_argument.make (0)
				actual_argument.append ("argument")
				actual_argument.append_integer (counter.value)
				actual_argument.append (".selected_button.text")
				actual_argument.append (extension_to_add)
				Result.append (eiffel_setting (actual_argument))
				if test_toggle_b.state and not procedure.precondition_list.empty then
					Result.append ("%N%T%T%T%Telse%N%T%T%T%T%Tdisplay_error_message (%"")
					Result.append (test_text_field.text)
					Result.append ("%", argument")
					Result.append_integer (counter.value)
					Result.append (".parent)%N%T%T%T%Tend%N")
				end	
				Result.append ("%T%T%Tend%N")
			elseif text_field_name /= Void then
				!! actual_argument.make (0)
				actual_argument.append ("argument")
				actual_argument.append_integer (counter.value)
				actual_argument.append (".text")
				actual_argument.append (extension_to_add)
				Result.append (eiffel_setting (actual_argument))
			else
				!! actual_argument.make (0)
				actual_argument.append ("argument")
				actual_argument.append_integer (counter.value)
				actual_argument.append (".selected_button.text")
				actual_argument.append (extension_to_add)
				Result.append (eiffel_setting (actual_argument))
			end
			if test_toggle_b.state and not procedure.precondition_list.empty and not is_both then
				Result.append ("%T%T%Telse%N%T%T%T%Tdisplay_error_message (%"")
				Result.append (test_text_field.text)
				Result.append ("%", argument")
				Result.append_integer (counter.value)
				Result.append (".parent)%N%T%T%Tend%N")
			end		
		end

	eiffel_setting (actual_argument: STRING): STRING is
			-- Generate the setting of the query using `argument'.
		local
			preconditions: LINKED_LIST [APPLICATION_PRECONDITION]
		do
			!! Result.make (0)
			if test_toggle_b.state and not procedure.precondition_list.empty then 
				Result.append ("precondition := True%N")

				preconditions := procedure.precondition_list
				from
					preconditions.start
				until
					preconditions.after
				loop
					Result.append ("%T%T%Tprecondition := precondition and then ")
					Result.append (preconditions.item.generated_text_for_command (procedure.argument_name, actual_argument))
					Result.append ("%N")
					preconditions.forth
				end		
				Result.append ("%N%T%T%Tif precondition then%N%T%T%T%T")
			end
			Result.append ("target.")
			Result.append (procedure.command_name)
			Result.append (" (")
			Result.append (actual_argument)
			Result.append (")%N")
		end

	procedure: APPLICATION_COMMAND is
			-- Procedure chosen to set `query'
		require
			item_selected: procedure_opt_pull.selected_button /= Void
		local
			application_method_button: APPLICATION_METHOD_PUSH_B
		do
			application_method_button ?= procedure_opt_pull.selected_button
			Result ?= application_method_button.application_method
		end

	text_field_name: STRING 
			-- Internal name of the text field holding the value
			-- used to set `query'.

	opt_pull_name: STRING 
			-- Internal name of the option pull holding the value
			-- used to set `query'.

	is_both: BOOLEAN 
			-- Does the interface use both a text field and 
			-- an option pull.

end -- class ANY_QUERY_EDITOR_FORM
