indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.Runtime.Remoting.RemotingConfiguration"

external class
	SYSTEM_RUNTIME_REMOTING_REMOTINGCONFIGURATION

create {NONE}

feature -- Access

	frozen get_application_name: STRING is
		external
			"IL static signature (): System.String use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"get_ApplicationName"
		end

feature -- Element Change

	frozen set_application_name (value: STRING) is
		external
			"IL static signature (System.String): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"set_ApplicationName"
		end

feature -- Basic Operations

	frozen get_registered_activated_service_types: ARRAY [SYSTEM_RUNTIME_REMOTING_ACTIVATEDSERVICETYPEENTRY] is
		external
			"IL static signature (): System.Runtime.Remoting.ActivatedServiceTypeEntry[] use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"GetRegisteredActivatedServiceTypes"
		end

	frozen get_registered_well_known_client_types: ARRAY [SYSTEM_RUNTIME_REMOTING_WELLKNOWNCLIENTTYPEENTRY] is
		external
			"IL static signature (): System.Runtime.Remoting.WellKnownClientTypeEntry[] use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"GetRegisteredWellKnownClientTypes"
		end

	frozen register_well_known_client_type (entry: SYSTEM_RUNTIME_REMOTING_WELLKNOWNCLIENTTYPEENTRY) is
		external
			"IL static signature (System.Runtime.Remoting.WellKnownClientTypeEntry): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterWellKnownClientType"
		end

	frozen is_remotely_activated_client_type (svr_type: SYSTEM_TYPE): SYSTEM_RUNTIME_REMOTING_ACTIVATEDCLIENTTYPEENTRY is
		external
			"IL static signature (System.Type): System.Runtime.Remoting.ActivatedClientTypeEntry use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"IsRemotelyActivatedClientType"
		end

	frozen register_well_known_client_type_type (type: SYSTEM_TYPE; object_url: STRING) is
		external
			"IL static signature (System.Type, System.String): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterWellKnownClientType"
		end

	frozen is_well_known_client_type_string (type_name: STRING; assembly_name: STRING): SYSTEM_RUNTIME_REMOTING_WELLKNOWNCLIENTTYPEENTRY is
		external
			"IL static signature (System.String, System.String): System.Runtime.Remoting.WellKnownClientTypeEntry use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"IsWellKnownClientType"
		end

	frozen register_activated_service_type_type (type: SYSTEM_TYPE) is
		external
			"IL static signature (System.Type): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterActivatedServiceType"
		end

	frozen register_well_known_service_type_type (type: SYSTEM_TYPE; object_uri: STRING; mode: SYSTEM_RUNTIME_REMOTING_WELLKNOWNOBJECTMODE) is
		external
			"IL static signature (System.Type, System.String, System.Runtime.Remoting.WellKnownObjectMode): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterWellKnownServiceType"
		end

	frozen is_well_known_client_type (svr_type: SYSTEM_TYPE): SYSTEM_RUNTIME_REMOTING_WELLKNOWNCLIENTTYPEENTRY is
		external
			"IL static signature (System.Type): System.Runtime.Remoting.WellKnownClientTypeEntry use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"IsWellKnownClientType"
		end

	frozen get_registered_activated_client_types: ARRAY [SYSTEM_RUNTIME_REMOTING_ACTIVATEDCLIENTTYPEENTRY] is
		external
			"IL static signature (): System.Runtime.Remoting.ActivatedClientTypeEntry[] use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"GetRegisteredActivatedClientTypes"
		end

	frozen is_activation_allowed (svr_type: SYSTEM_TYPE): BOOLEAN is
		external
			"IL static signature (System.Type): System.Boolean use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"IsActivationAllowed"
		end

	frozen register_activated_client_type_type (type: SYSTEM_TYPE; app_url: STRING) is
		external
			"IL static signature (System.Type, System.String): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterActivatedClientType"
		end

	frozen configure (filename: STRING) is
		external
			"IL static signature (System.String): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"Configure"
		end

	frozen get_registered_well_known_service_types: ARRAY [SYSTEM_RUNTIME_REMOTING_WELLKNOWNSERVICETYPEENTRY] is
		external
			"IL static signature (): System.Runtime.Remoting.WellKnownServiceTypeEntry[] use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"GetRegisteredWellKnownServiceTypes"
		end

	frozen register_activated_service_type (entry: SYSTEM_RUNTIME_REMOTING_ACTIVATEDSERVICETYPEENTRY) is
		external
			"IL static signature (System.Runtime.Remoting.ActivatedServiceTypeEntry): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterActivatedServiceType"
		end

	frozen register_well_known_service_type (entry: SYSTEM_RUNTIME_REMOTING_WELLKNOWNSERVICETYPEENTRY) is
		external
			"IL static signature (System.Runtime.Remoting.WellKnownServiceTypeEntry): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterWellKnownServiceType"
		end

	frozen is_remotely_activated_client_type_string (type_name: STRING; assembly_name: STRING): SYSTEM_RUNTIME_REMOTING_ACTIVATEDCLIENTTYPEENTRY is
		external
			"IL static signature (System.String, System.String): System.Runtime.Remoting.ActivatedClientTypeEntry use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"IsRemotelyActivatedClientType"
		end

	frozen register_activated_client_type (entry: SYSTEM_RUNTIME_REMOTING_ACTIVATEDCLIENTTYPEENTRY) is
		external
			"IL static signature (System.Runtime.Remoting.ActivatedClientTypeEntry): System.Void use System.Runtime.Remoting.RemotingConfiguration"
		alias
			"RegisterActivatedClientType"
		end

end -- class SYSTEM_RUNTIME_REMOTING_REMOTINGCONFIGURATION
