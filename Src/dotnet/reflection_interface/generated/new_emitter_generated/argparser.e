indexing
	Generator: "Eiffel Emitter 2.3b"
	external_name: "ArgParser"

deferred external class
	ARGPARSER

feature {NONE} -- Implementation

	OnNonSwitch (value: STRING): INTEGER is
		external
			"IL signature (System.String): enum NewArgParser+SwitchStatus use ArgParser"
		alias
			"OnNonSwitch"
			--
		end

	OnSwitch (switchSymbol: STRING; switchValue: STRING): INTEGER is
		external
			"IL signature (System.String, System.String): enum NewArgParser+SwitchStatus use ArgParser"
		alias
			"OnSwitch"
			--
		end

	OnDoneParse: INTEGER is
		external
			"IL signature (): enum NewArgParser+SwitchStatus use ArgParser"
		alias
			"OnDoneParse"
			--
		end

end -- class ARGPARSER
