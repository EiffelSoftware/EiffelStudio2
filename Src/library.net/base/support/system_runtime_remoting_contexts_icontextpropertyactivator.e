indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.Runtime.Remoting.Contexts.IContextPropertyActivator"

deferred external class
	SYSTEM_RUNTIME_REMOTING_CONTEXTS_ICONTEXTPROPERTYACTIVATOR

inherit
	ANY
		undefine
			finalize,
			get_hash_code,
			is_equal,
			to_string
		end

feature -- Basic Operations

	collect_from_client_context (msg: SYSTEM_RUNTIME_REMOTING_ACTIVATION_ICONSTRUCTIONCALLMESSAGE) is
		external
			"IL deferred signature (System.Runtime.Remoting.Activation.IConstructionCallMessage): System.Void use System.Runtime.Remoting.Contexts.IContextPropertyActivator"
		alias
			"CollectFromClientContext"
		end

	collect_from_server_context (msg: SYSTEM_RUNTIME_REMOTING_ACTIVATION_ICONSTRUCTIONRETURNMESSAGE) is
		external
			"IL deferred signature (System.Runtime.Remoting.Activation.IConstructionReturnMessage): System.Void use System.Runtime.Remoting.Contexts.IContextPropertyActivator"
		alias
			"CollectFromServerContext"
		end

	deliver_client_context_to_server_context (msg: SYSTEM_RUNTIME_REMOTING_ACTIVATION_ICONSTRUCTIONCALLMESSAGE): BOOLEAN is
		external
			"IL deferred signature (System.Runtime.Remoting.Activation.IConstructionCallMessage): System.Boolean use System.Runtime.Remoting.Contexts.IContextPropertyActivator"
		alias
			"DeliverClientContextToServerContext"
		end

	deliver_server_context_to_client_context (msg: SYSTEM_RUNTIME_REMOTING_ACTIVATION_ICONSTRUCTIONRETURNMESSAGE): BOOLEAN is
		external
			"IL deferred signature (System.Runtime.Remoting.Activation.IConstructionReturnMessage): System.Boolean use System.Runtime.Remoting.Contexts.IContextPropertyActivator"
		alias
			"DeliverServerContextToClientContext"
		end

	is_okto_activate (msg: SYSTEM_RUNTIME_REMOTING_ACTIVATION_ICONSTRUCTIONCALLMESSAGE): BOOLEAN is
		external
			"IL deferred signature (System.Runtime.Remoting.Activation.IConstructionCallMessage): System.Boolean use System.Runtime.Remoting.Contexts.IContextPropertyActivator"
		alias
			"IsOKToActivate"
		end

end -- class SYSTEM_RUNTIME_REMOTING_CONTEXTS_ICONTEXTPROPERTYACTIVATOR
