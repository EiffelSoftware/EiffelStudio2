indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.Web.UI.WebControls.RangeValidator"

external class
	SYSTEM_WEB_UI_WEBCONTROLS_RANGEVALIDATOR

inherit
	SYSTEM_WEB_UI_IATTRIBUTEACCESSOR
		rename
			set_attribute as system_web_ui_iattribute_accessor_set_attribute,
			get_attribute as system_web_ui_iattribute_accessor_get_attribute
		end
	SYSTEM_COMPONENTMODEL_ICOMPONENT
	SYSTEM_WEB_UI_IPARSERACCESSOR
		rename
			add_parsed_sub_object as system_web_ui_iparser_accessor_add_parsed_sub_object
		end
	SYSTEM_WEB_UI_WEBCONTROLS_BASECOMPAREVALIDATOR
		redefine
			control_properties_valid,
			add_attributes_to_render
		end
	SYSTEM_IDISPOSABLE
	SYSTEM_WEB_UI_IVALIDATOR
	SYSTEM_WEB_UI_IDATABINDINGSACCESSOR
		rename
			get_data_bindings as system_web_ui_idata_bindings_accessor_get_data_bindings,
			get_has_data_bindings as system_web_ui_idata_bindings_accessor_get_has_data_bindings
		end

create
	make_rangevalidator

feature {NONE} -- Initialization

	frozen make_rangevalidator is
		external
			"IL creator use System.Web.UI.WebControls.RangeValidator"
		end

feature -- Access

	frozen get_minimum_value: STRING is
		external
			"IL signature (): System.String use System.Web.UI.WebControls.RangeValidator"
		alias
			"get_MinimumValue"
		end

	frozen get_maximum_value: STRING is
		external
			"IL signature (): System.String use System.Web.UI.WebControls.RangeValidator"
		alias
			"get_MaximumValue"
		end

feature -- Element Change

	frozen set_minimum_value (value: STRING) is
		external
			"IL signature (System.String): System.Void use System.Web.UI.WebControls.RangeValidator"
		alias
			"set_MinimumValue"
		end

	frozen set_maximum_value (value: STRING) is
		external
			"IL signature (System.String): System.Void use System.Web.UI.WebControls.RangeValidator"
		alias
			"set_MaximumValue"
		end

feature {NONE} -- Implementation

	evaluate_is_valid: BOOLEAN is
		external
			"IL signature (): System.Boolean use System.Web.UI.WebControls.RangeValidator"
		alias
			"EvaluateIsValid"
		end

	add_attributes_to_render (writer: SYSTEM_WEB_UI_HTMLTEXTWRITER) is
		external
			"IL signature (System.Web.UI.HtmlTextWriter): System.Void use System.Web.UI.WebControls.RangeValidator"
		alias
			"AddAttributesToRender"
		end

	control_properties_valid: BOOLEAN is
		external
			"IL signature (): System.Boolean use System.Web.UI.WebControls.RangeValidator"
		alias
			"ControlPropertiesValid"
		end

end -- class SYSTEM_WEB_UI_WEBCONTROLS_RANGEVALIDATOR
