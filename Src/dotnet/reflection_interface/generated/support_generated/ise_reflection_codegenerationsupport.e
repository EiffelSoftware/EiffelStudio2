indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "ISE.Reflection.CodeGenerationSupport"

external class
	ISE_REFLECTION_CODEGENERATIONSUPPORT

inherit
	ISE_REFLECTION_SUPPORT

create
	make_codegenerationsupport

feature {NONE} -- Initialization

	frozen make_codegenerationsupport is
		external
			"IL creator use ISE.Reflection.CodeGenerationSupport"
		end

feature -- Access

	frozen a_internal_eiffel_class: ISE_REFLECTION_EIFFELCLASS is
		external
			"IL field signature :ISE.Reflection.EiffelClass use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_EiffelClass"
		end

	frozen a_internal_error_messages: ISE_REFLECTION_CODEGENERATIONSUPPORTERRORMESSAGES is
		external
			"IL field signature :ISE.Reflection.CodeGenerationSupportErrorMessages use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_ErrorMessages"
		end

	frozen a_internal_generic_type_names: ARRAY [ANY] is
		external
			"IL field signature :System.Object[] use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_GenericTypeNames"
		end

	frozen a_internal_type_description: SYSTEM_XML_XMLTEXTREADER is
		external
			"IL field signature :System.Xml.XmlTextReader use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_TypeDescription"
		end

	get_xml_elements: ISE_REFLECTION_XMLELEMENTS is
		external
			"IL signature (): ISE.Reflection.XmlElements use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_XmlElements"
		end

	frozen a_internal_eiffel_feature: ISE_REFLECTION_EIFFELFEATURE is
		external
			"IL field signature :ISE.Reflection.EiffelFeature use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_EiffelFeature"
		end

	frozen a_internal_xml_elements: ISE_REFLECTION_XMLELEMENTS is
		external
			"IL field signature :ISE.Reflection.XmlElements use ISE.Reflection.CodeGenerationSupport"
		alias
			"_internal_XmlElements"
		end

	get_type_description: SYSTEM_XML_XMLTEXTREADER is
		external
			"IL signature (): System.Xml.XmlTextReader use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_TypeDescription"
		end

	get_eiffel_class: ISE_REFLECTION_EIFFELCLASS is
		external
			"IL signature (): ISE.Reflection.EiffelClass use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_EiffelClass"
		end

	get_error_messages: ISE_REFLECTION_CODEGENERATIONSUPPORTERRORMESSAGES is
		external
			"IL signature (): ISE.Reflection.CodeGenerationSupportErrorMessages use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_ErrorMessages"
		end

	get_generic_type_names: ARRAY [ANY] is
		external
			"IL signature (): System.Object[] use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_GenericTypeNames"
		end

	get_eiffel_feature: ISE_REFLECTION_EIFFELFEATURE is
		external
			"IL signature (): ISE.Reflection.EiffelFeature use ISE.Reflection.CodeGenerationSupport"
		alias
			"get_EiffelFeature"
		end

feature -- Basic Operations

	generate_feature_assertions (element_name: STRING) is
		external
			"IL signature (System.String): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateFeatureAssertions"
		end

	create_folder (a_path: STRING) is
		external
			"IL signature (System.String): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"CreateFolder"
		end

	generate_parents is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateParents"
		end

	has_write_lock (a_folder_name: STRING): BOOLEAN is
		external
			"IL signature (System.String): System.Boolean use ISE.Reflection.CodeGenerationSupport"
		alias
			"HasWriteLock"
		end

	generate_class_body is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateClassBody"
		end

	generate_comments is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateComments"
		end

	set_feature_info is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"SetFeatureInfo"
		end

	compute_generic_names (a_count: INTEGER) is
		external
			"IL signature (System.Int32): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"ComputeGenericNames"
		end

	generate_features (element_name: STRING) is
		external
			"IL signature (System.String): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateFeatures"
		end

	read_lock_filename: STRING is
		external
			"IL signature (): System.String use ISE.Reflection.CodeGenerationSupport"
		alias
			"ReadLockFilename"
		end

	generate_class_footer is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateClassFooter"
		end

	is_valid_directory_path (a_path: STRING): BOOLEAN is
		external
			"IL signature (System.String): System.Boolean use ISE.Reflection.CodeGenerationSupport"
		alias
			"IsValidDirectoryPath"
		end

	is_valid_filename (a_filename: STRING): BOOLEAN is
		external
			"IL signature (System.String): System.Boolean use ISE.Reflection.CodeGenerationSupport"
		alias
			"IsValidFilename"
		end
		
	generic_name_base: STRING is
		external
			"IL signature (): System.String use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenericNameBase"
		end

	make is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"Make"
		end

	write_lock_filename: STRING is
		external
			"IL signature (): System.String use ISE.Reflection.CodeGenerationSupport"
		alias
			"WriteLockFilename"
		end

	generic_names_table: ARRAY [ANY] is
		external
			"IL signature (): System.Object[] use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenericNamesTable"
		end

	generate_generic_derivations is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateGenericDerivations"
		end

	eiffel_class_from_xml (a_filename: STRING): ISE_REFLECTION_EIFFELCLASS is
		external
			"IL signature (System.String): ISE.Reflection.EiffelClass use ISE.Reflection.CodeGenerationSupport"
		alias
			"EiffelClassFromXml"
		end

	generate_class_header is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateClassHeader"
		end

	has_read_lock (a_folder_name: STRING): BOOLEAN is
		external
			"IL signature (System.String): System.Boolean use ISE.Reflection.CodeGenerationSupport"
		alias
			"HasReadLock"
		end

	generate_arguments is
		external
			"IL signature (): System.Void use ISE.Reflection.CodeGenerationSupport"
		alias
			"GenerateArguments"
		end

	eiffel_assembly_from_xml (a_filename: STRING): ISE_REFLECTION_EIFFELASSEMBLY is
		external
			"IL signature (System.String): ISE.Reflection.EiffelAssembly use ISE.Reflection.CodeGenerationSupport"
		alias
			"EiffelAssemblyFromXml"
		end

end -- class ISE_REFLECTION_CODEGENERATIONSUPPORT
