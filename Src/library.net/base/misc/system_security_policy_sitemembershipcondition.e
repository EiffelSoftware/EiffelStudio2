indexing
	Generator: "Eiffel Emitter 2.5b2"
	external_name: "System.Security.Policy.SiteMembershipCondition"

frozen external class
	SYSTEM_SECURITY_POLICY_SITEMEMBERSHIPCONDITION

inherit
	ANY
		rename
			to_string as to_string_with_format_and_provider
		redefine
			finalize,
			get_hash_code,
			is_equal,
			to_string_with_format_and_provider
		end
	SYSTEM_SECURITY_POLICY_IMEMBERSHIPCONDITION
		rename
			to_string as to_string_with_format_and_provider
		end
	SYSTEM_SECURITY_ISECURITYENCODABLE
		rename
			to_string as to_string_with_format_and_provider
		end
	SYSTEM_SECURITY_ISECURITYPOLICYENCODABLE
		rename
			from_xml as from_xml_security_element_policy_level,
			to_xml as to_xml_policy_level,
			to_string as to_string_with_format_and_provider
		end

create
	make

feature {NONE} -- Initialization

	frozen make (site: STRING) is
		external
			"IL creator signature (System.String) use System.Security.Policy.SiteMembershipCondition"
		end

feature -- Access

	frozen get_site: STRING is
		external
			"IL signature (): System.String use System.Security.Policy.SiteMembershipCondition"
		alias
			"get_Site"
		end

feature -- Element Change

	frozen set_site (value: STRING) is
		external
			"IL signature (System.String): System.Void use System.Security.Policy.SiteMembershipCondition"
		alias
			"set_Site"
		end

feature -- Basic Operations

	frozen from_xml_security_element_policy_level (e: SYSTEM_SECURITY_SECURITYELEMENT; level: SYSTEM_SECURITY_POLICY_POLICYLEVEL) is
		external
			"IL signature (System.Security.SecurityElement, System.Security.Policy.PolicyLevel): System.Void use System.Security.Policy.SiteMembershipCondition"
		alias
			"FromXml"
		end

	frozen from_xml (e: SYSTEM_SECURITY_SECURITYELEMENT) is
		external
			"IL signature (System.Security.SecurityElement): System.Void use System.Security.Policy.SiteMembershipCondition"
		alias
			"FromXml"
		end

	frozen copy: SYSTEM_SECURITY_POLICY_IMEMBERSHIPCONDITION is
		external
			"IL signature (): System.Security.Policy.IMembershipCondition use System.Security.Policy.SiteMembershipCondition"
		alias
			"Copy"
		end

	frozen to_xml: SYSTEM_SECURITY_SECURITYELEMENT is
		external
			"IL signature (): System.Security.SecurityElement use System.Security.Policy.SiteMembershipCondition"
		alias
			"ToXml"
		end

	is_equal (o: ANY): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use System.Security.Policy.SiteMembershipCondition"
		alias
			"Equals"
		end

	frozen Check_ (evidence: SYSTEM_SECURITY_POLICY_EVIDENCE): BOOLEAN is
		external
			"IL signature (System.Security.Policy.Evidence): System.Boolean use System.Security.Policy.SiteMembershipCondition"
		alias
			"Check"
		end

	to_string_with_format_and_provider: STRING is
		external
			"IL signature (): System.String use System.Security.Policy.SiteMembershipCondition"
		alias
			"ToString"
		end

	frozen to_xml_policy_level (level: SYSTEM_SECURITY_POLICY_POLICYLEVEL): SYSTEM_SECURITY_SECURITYELEMENT is
		external
			"IL signature (System.Security.Policy.PolicyLevel): System.Security.SecurityElement use System.Security.Policy.SiteMembershipCondition"
		alias
			"ToXml"
		end

	get_hash_code: INTEGER is
		external
			"IL signature (): System.Int32 use System.Security.Policy.SiteMembershipCondition"
		alias
			"GetHashCode"
		end

feature {NONE} -- Implementation

	finalize is
		external
			"IL signature (): System.Void use System.Security.Policy.SiteMembershipCondition"
		alias
			"Finalize"
		end

end -- class SYSTEM_SECURITY_POLICY_SITEMEMBERSHIPCONDITION
