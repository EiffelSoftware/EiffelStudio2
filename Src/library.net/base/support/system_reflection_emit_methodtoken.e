indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.Reflection.Emit.MethodToken"

frozen expanded external class
	SYSTEM_REFLECTION_EMIT_METHODTOKEN

inherit
	VALUE_TYPE
		redefine
			get_hash_code,
			is_equal
		end

feature -- Access

	frozen empty: SYSTEM_REFLECTION_EMIT_METHODTOKEN is
		external
			"IL static_field signature :System.Reflection.Emit.MethodToken use System.Reflection.Emit.MethodToken"
		alias
			"Empty"
		end

	frozen get_token: INTEGER is
		external
			"IL signature (): System.Int32 use System.Reflection.Emit.MethodToken"
		alias
			"get_Token"
		end

feature -- Basic Operations

	get_hash_code: INTEGER is
		external
			"IL signature (): System.Int32 use System.Reflection.Emit.MethodToken"
		alias
			"GetHashCode"
		end

	is_equal (obj: ANY): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use System.Reflection.Emit.MethodToken"
		alias
			"Equals"
		end

end -- class SYSTEM_REFLECTION_EMIT_METHODTOKEN
