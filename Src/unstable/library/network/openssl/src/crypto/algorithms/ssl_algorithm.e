note
	description: "[
		Object representing cryptographic algorithms supported by OpenSSL like
		AES, Blowfish, Camellia, SEED, CAST-128, DES, IDEA, RC2, RC4, RC5, Triple DES, GOST 28147-89
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=OpenSSL algorithms", "src=https://en.wikipedia.org/wiki/OpenSSL#Algorithms", "protocol=uri"

deferred class
	SSL_ALGORITHM


feature -- Access

	key: STRING_8
			-- String representation.

	key_bytes: MANAGED_POINTER
			-- key represented as bytes.
		deferred
		end

	key_sizes: ARRAY [INTEGER]
			-- valid key sizes.
		deferred
		end

	key_size: INTEGER
		do
			Result := key_bytes.count * 8
		end

feature -- Status Report

	verify_key_size: BOOLEAN
		do
			if key_sizes.has (key_size) then
				Result := True
			end
		end

end
