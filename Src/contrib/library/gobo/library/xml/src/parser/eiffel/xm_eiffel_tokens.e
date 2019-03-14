note

	description: "Parser token codes"
	generator: "geyacc version 4.3"

deferred class XM_EIFFEL_TOKENS

inherit

	YY_PARSER_TOKENS

feature -- Last values

	last_detachable_any_value: detachable ANY
	last_string_value: STRING

feature -- Access

	token_name (a_token: INTEGER): STRING
			-- Name of token `a_token'
		do
			inspect a_token
			when 0 then
				Result := "EOF token"
			when -1 then
				Result := "Error token"
			when NAME then
				Result := "NAME"
			when NAME_UTF8 then
				Result := "NAME_UTF8"
			when NMTOKEN then
				Result := "NMTOKEN"
			when NMTOKEN_UTF8 then
				Result := "NMTOKEN_UTF8"
			when EQ then
				Result := "EQ"
			when SPACE then
				Result := "SPACE"
			when APOS then
				Result := "APOS"
			when QUOT then
				Result := "QUOT"
			when CHARDATA then
				Result := "CHARDATA"
			when CHARDATA_UTF8 then
				Result := "CHARDATA_UTF8"
			when COMMENT_START then
				Result := "COMMENT_START"
			when COMMENT_END then
				Result := "COMMENT_END"
			when COMMENT_DASHDASH then
				Result := "COMMENT_DASHDASH"
			when PI_START then
				Result := "PI_START"
			when PI_TARGET then
				Result := "PI_TARGET"
			when PI_TARGET_UTF8 then
				Result := "PI_TARGET_UTF8"
			when PI_END then
				Result := "PI_END"
			when PI_RESERVED then
				Result := "PI_RESERVED"
			when XMLDECLARATION_START then
				Result := "XMLDECLARATION_START"
			when XMLDECLARATION_END then
				Result := "XMLDECLARATION_END"
			when XMLDECLARATION_VERSION then
				Result := "XMLDECLARATION_VERSION"
			when XMLDECLARATION_VERSION_10 then
				Result := "XMLDECLARATION_VERSION_10"
			when XMLDECLARATION_STANDALONE then
				Result := "XMLDECLARATION_STANDALONE"
			when XMLDECLARATION_STANDALONE_YES then
				Result := "XMLDECLARATION_STANDALONE_YES"
			when XMLDECLARATION_STANDALONE_NO then
				Result := "XMLDECLARATION_STANDALONE_NO"
			when XMLDECLARATION_ENCODING then
				Result := "XMLDECLARATION_ENCODING"
			when XMLDECLARATION_ENCODING_VALUE then
				Result := "XMLDECLARATION_ENCODING_VALUE"
			when CDATA_START then
				Result := "CDATA_START"
			when CDATA_END then
				Result := "CDATA_END"
			when DOCTYPE_START then
				Result := "DOCTYPE_START"
			when DOCTYPE_END then
				Result := "DOCTYPE_END"
			when DOCTYPE_DECLARATION_START then
				Result := "DOCTYPE_DECLARATION_START"
			when DOCTYPE_DECLARATION_END then
				Result := "DOCTYPE_DECLARATION_END"
			when DOCTYPE_ELEMENT_EMPTY then
				Result := "DOCTYPE_ELEMENT_EMPTY"
			when DOCTYPE_ELEMENT_ANY then
				Result := "DOCTYPE_ELEMENT_ANY"
			when DOCTYPE_ELEMENT then
				Result := "DOCTYPE_ELEMENT"
			when DOCTYPE_ATTLIST then
				Result := "DOCTYPE_ATTLIST"
			when DOCTYPE_ENTITY then
				Result := "DOCTYPE_ENTITY"
			when DOCTYPE_NOTATION then
				Result := "DOCTYPE_NOTATION"
			when DOCTYPE_GROUP_START then
				Result := "DOCTYPE_GROUP_START"
			when DOCTYPE_GROUP_END then
				Result := "DOCTYPE_GROUP_END"
			when DOCTYPE_GROUP_OR then
				Result := "DOCTYPE_GROUP_OR"
			when DOCTYPE_GROUP_SEQ then
				Result := "DOCTYPE_GROUP_SEQ"
			when DOCTYPE_GROUP_ZEROONE then
				Result := "DOCTYPE_GROUP_ZEROONE"
			when DOCTYPE_GROUP_ANY then
				Result := "DOCTYPE_GROUP_ANY"
			when DOCTYPE_GROUP_ONEMORE then
				Result := "DOCTYPE_GROUP_ONEMORE"
			when DOCTYPE_PCDATA then
				Result := "DOCTYPE_PCDATA"
			when DOCTYPE_PUBLIC then
				Result := "DOCTYPE_PUBLIC"
			when DOCTYPE_SYSTEM then
				Result := "DOCTYPE_SYSTEM"
			when DOCTYPE_SYSTEM_UTF8 then
				Result := "DOCTYPE_SYSTEM_UTF8"
			when DOCTYPE_REQUIRED then
				Result := "DOCTYPE_REQUIRED"
			when DOCTYPE_IMPLIED then
				Result := "DOCTYPE_IMPLIED"
			when DOCTYPE_FIXED then
				Result := "DOCTYPE_FIXED"
			when DOCTYPE_ATT_CDATA then
				Result := "DOCTYPE_ATT_CDATA"
			when DOCTYPE_ATT_ID then
				Result := "DOCTYPE_ATT_ID"
			when DOCTYPE_ATT_IDREF then
				Result := "DOCTYPE_ATT_IDREF"
			when DOCTYPE_ATT_IDREFS then
				Result := "DOCTYPE_ATT_IDREFS"
			when DOCTYPE_ATT_ENTITY then
				Result := "DOCTYPE_ATT_ENTITY"
			when DOCTYPE_ATT_ENTITIES then
				Result := "DOCTYPE_ATT_ENTITIES"
			when DOCTYPE_ATT_NMTOKEN then
				Result := "DOCTYPE_ATT_NMTOKEN"
			when DOCTYPE_ATT_NMTOKENS then
				Result := "DOCTYPE_ATT_NMTOKENS"
			when DOCTYPE_ATT_NOTATION then
				Result := "DOCTYPE_ATT_NOTATION"
			when DOCTYPE_PERCENT then
				Result := "DOCTYPE_PERCENT"
			when DOCTYPE_PEREFERENCE then
				Result := "DOCTYPE_PEREFERENCE"
			when DOCTYPE_PEREFERENCE_UTF8 then
				Result := "DOCTYPE_PEREFERENCE_UTF8"
			when ENTITYVALUE_PEREFERENCE then
				Result := "ENTITYVALUE_PEREFERENCE"
			when ENTITYVALUE_PEREFERENCE_UTF8 then
				Result := "ENTITYVALUE_PEREFERENCE_UTF8"
			when DOCTYPE_IGNORE then
				Result := "DOCTYPE_IGNORE"
			when DOCTYPE_INCLUDE then
				Result := "DOCTYPE_INCLUDE"
			when DOCTYPE_NDATA then
				Result := "DOCTYPE_NDATA"
			when DOCTYPE_CONDITIONAL_START then
				Result := "DOCTYPE_CONDITIONAL_START"
			when DOCTYPE_CONDITIONAL_END then
				Result := "DOCTYPE_CONDITIONAL_END"
			when DOCTYPE_CONDITIONAL_IGNORE then
				Result := "DOCTYPE_CONDITIONAL_IGNORE"
			when VALUE_START then
				Result := "VALUE_START"
			when VALUE_END then
				Result := "VALUE_END"
			when TAG_START then
				Result := "TAG_START"
			when TAG_START_END then
				Result := "TAG_START_END"
			when TAG_END_EMPTY then
				Result := "TAG_END_EMPTY"
			when TAG_END then
				Result := "TAG_END"
			when TAG_NAME_FIRST then
				Result := "TAG_NAME_FIRST"
			when TAG_NAME_FIRST_UTF8 then
				Result := "TAG_NAME_FIRST_UTF8"
			when TAG_NAME_ATOM then
				Result := "TAG_NAME_ATOM"
			when TAG_NAME_ATOM_UTF8 then
				Result := "TAG_NAME_ATOM_UTF8"
			when TAG_NAME_COLON then
				Result := "TAG_NAME_COLON"
			when CONTENT_ENTITY then
				Result := "CONTENT_ENTITY"
			when CONTENT_ENTITY_UTF8 then
				Result := "CONTENT_ENTITY_UTF8"
			when CONTENT_CONDITIONAL_END then
				Result := "CONTENT_CONDITIONAL_END"
			when ATTRIBUTE_ENTITY then
				Result := "ATTRIBUTE_ENTITY"
			when ATTRIBUTE_ENTITY_UTF8 then
				Result := "ATTRIBUTE_ENTITY_UTF8"
			when ATTRIBUTE_LT then
				Result := "ATTRIBUTE_LT"
			when ENTITY_INVALID then
				Result := "ENTITY_INVALID"
			when INPUT_INVALID then
				Result := "INPUT_INVALID"
			else
				Result := yy_character_token_name (a_token)
			end
		end

feature -- Token codes

	NAME: INTEGER = 258
	NAME_UTF8: INTEGER = 259
	NMTOKEN: INTEGER = 260
	NMTOKEN_UTF8: INTEGER = 261
	EQ: INTEGER = 262
	SPACE: INTEGER = 263
	APOS: INTEGER = 264
	QUOT: INTEGER = 265
	CHARDATA: INTEGER = 266
	CHARDATA_UTF8: INTEGER = 267
	COMMENT_START: INTEGER = 268
	COMMENT_END: INTEGER = 269
	COMMENT_DASHDASH: INTEGER = 270
	PI_START: INTEGER = 271
	PI_TARGET: INTEGER = 272
	PI_TARGET_UTF8: INTEGER = 273
	PI_END: INTEGER = 274
	PI_RESERVED: INTEGER = 275
	XMLDECLARATION_START: INTEGER = 276
	XMLDECLARATION_END: INTEGER = 277
	XMLDECLARATION_VERSION: INTEGER = 278
	XMLDECLARATION_VERSION_10: INTEGER = 279
	XMLDECLARATION_STANDALONE: INTEGER = 280
	XMLDECLARATION_STANDALONE_YES: INTEGER = 281
	XMLDECLARATION_STANDALONE_NO: INTEGER = 282
	XMLDECLARATION_ENCODING: INTEGER = 283
	XMLDECLARATION_ENCODING_VALUE: INTEGER = 284
	CDATA_START: INTEGER = 285
	CDATA_END: INTEGER = 286
	DOCTYPE_START: INTEGER = 287
	DOCTYPE_END: INTEGER = 288
	DOCTYPE_DECLARATION_START: INTEGER = 289
	DOCTYPE_DECLARATION_END: INTEGER = 290
	DOCTYPE_ELEMENT_EMPTY: INTEGER = 291
	DOCTYPE_ELEMENT_ANY: INTEGER = 292
	DOCTYPE_ELEMENT: INTEGER = 293
	DOCTYPE_ATTLIST: INTEGER = 294
	DOCTYPE_ENTITY: INTEGER = 295
	DOCTYPE_NOTATION: INTEGER = 296
	DOCTYPE_GROUP_START: INTEGER = 297
	DOCTYPE_GROUP_END: INTEGER = 298
	DOCTYPE_GROUP_OR: INTEGER = 299
	DOCTYPE_GROUP_SEQ: INTEGER = 300
	DOCTYPE_GROUP_ZEROONE: INTEGER = 301
	DOCTYPE_GROUP_ANY: INTEGER = 302
	DOCTYPE_GROUP_ONEMORE: INTEGER = 303
	DOCTYPE_PCDATA: INTEGER = 304
	DOCTYPE_PUBLIC: INTEGER = 305
	DOCTYPE_SYSTEM: INTEGER = 306
	DOCTYPE_SYSTEM_UTF8: INTEGER = 307
	DOCTYPE_REQUIRED: INTEGER = 308
	DOCTYPE_IMPLIED: INTEGER = 309
	DOCTYPE_FIXED: INTEGER = 310
	DOCTYPE_ATT_CDATA: INTEGER = 311
	DOCTYPE_ATT_ID: INTEGER = 312
	DOCTYPE_ATT_IDREF: INTEGER = 313
	DOCTYPE_ATT_IDREFS: INTEGER = 314
	DOCTYPE_ATT_ENTITY: INTEGER = 315
	DOCTYPE_ATT_ENTITIES: INTEGER = 316
	DOCTYPE_ATT_NMTOKEN: INTEGER = 317
	DOCTYPE_ATT_NMTOKENS: INTEGER = 318
	DOCTYPE_ATT_NOTATION: INTEGER = 319
	DOCTYPE_PERCENT: INTEGER = 320
	DOCTYPE_PEREFERENCE: INTEGER = 321
	DOCTYPE_PEREFERENCE_UTF8: INTEGER = 322
	ENTITYVALUE_PEREFERENCE: INTEGER = 323
	ENTITYVALUE_PEREFERENCE_UTF8: INTEGER = 324
	DOCTYPE_IGNORE: INTEGER = 325
	DOCTYPE_INCLUDE: INTEGER = 326
	DOCTYPE_NDATA: INTEGER = 327
	DOCTYPE_CONDITIONAL_START: INTEGER = 328
	DOCTYPE_CONDITIONAL_END: INTEGER = 329
	DOCTYPE_CONDITIONAL_IGNORE: INTEGER = 330
	VALUE_START: INTEGER = 331
	VALUE_END: INTEGER = 332
	TAG_START: INTEGER = 333
	TAG_START_END: INTEGER = 334
	TAG_END_EMPTY: INTEGER = 335
	TAG_END: INTEGER = 336
	TAG_NAME_FIRST: INTEGER = 337
	TAG_NAME_FIRST_UTF8: INTEGER = 338
	TAG_NAME_ATOM: INTEGER = 339
	TAG_NAME_ATOM_UTF8: INTEGER = 340
	TAG_NAME_COLON: INTEGER = 341
	CONTENT_ENTITY: INTEGER = 342
	CONTENT_ENTITY_UTF8: INTEGER = 343
	CONTENT_CONDITIONAL_END: INTEGER = 344
	ATTRIBUTE_ENTITY: INTEGER = 345
	ATTRIBUTE_ENTITY_UTF8: INTEGER = 346
	ATTRIBUTE_LT: INTEGER = 347
	ENTITY_INVALID: INTEGER = 348
	INPUT_INVALID: INTEGER = 349

end
