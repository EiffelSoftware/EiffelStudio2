indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.DirectoryServices.PropertyValueCollection"

external class
	SYSTEM_DIRECTORYSERVICES_PROPERTYVALUECOLLECTION

inherit
	SYSTEM_COLLECTIONS_ILIST
		rename
			insert as system_collections_ilist_insert,
			index_of as system_collections_ilist_index_of,
			remove as system_collections_ilist_remove,
			add as system_collections_ilist_add,
			contains as system_collections_ilist_contains,
			set_item as system_collections_ilist_set_item,
			get_item as system_collections_ilist_get_item,
			copy_to as system_collections_icollection_copy_to,
			get_sync_root as system_collections_icollection_get_sync_root,
			get_is_synchronized as system_collections_icollection_get_is_synchronized,
			get_is_fixed_size as system_collections_ilist_get_is_fixed_size,
			get_is_read_only as system_collections_ilist_get_is_read_only
		end
	SYSTEM_COLLECTIONS_COLLECTIONBASE
		redefine
			on_remove_complete,
			on_clear_complete,
			on_insert_complete,
			on_set_complete
		end
	SYSTEM_COLLECTIONS_IENUMERABLE
	SYSTEM_COLLECTIONS_ICOLLECTION
		rename
			copy_to as system_collections_icollection_copy_to,
			get_sync_root as system_collections_icollection_get_sync_root,
			get_is_synchronized as system_collections_icollection_get_is_synchronized
		end

create {NONE}

feature -- Access

	frozen get_item (index: INTEGER): ANY is
		external
			"IL signature (System.Int32): System.Object use System.DirectoryServices.PropertyValueCollection"
		alias
			"get_Item"
		end

feature -- Element Change

	frozen set_item (index: INTEGER; value: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"set_Item"
		end

feature -- Basic Operations

	frozen insert (index: INTEGER; value: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"Insert"
		end

	frozen copy_to (array: ARRAY [ANY]; index: INTEGER) is
		external
			"IL signature (System.Object[], System.Int32): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"CopyTo"
		end

	frozen index_of (value: ANY): INTEGER is
		external
			"IL signature (System.Object): System.Int32 use System.DirectoryServices.PropertyValueCollection"
		alias
			"IndexOf"
		end

	frozen remove (value: ANY) is
		external
			"IL signature (System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"Remove"
		end

	frozen contains (value: ANY): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use System.DirectoryServices.PropertyValueCollection"
		alias
			"Contains"
		end

	frozen add_range (value: SYSTEM_DIRECTORYSERVICES_PROPERTYVALUECOLLECTION) is
		external
			"IL signature (System.DirectoryServices.PropertyValueCollection): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"AddRange"
		end

	frozen add (value: ANY): INTEGER is
		external
			"IL signature (System.Object): System.Int32 use System.DirectoryServices.PropertyValueCollection"
		alias
			"Add"
		end

	frozen add_range_array_object (value: ARRAY [ANY]) is
		external
			"IL signature (System.Object[]): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"AddRange"
		end

feature {NONE} -- Implementation

	on_set_complete (index: INTEGER; old_value: ANY; new_value: ANY) is
		external
			"IL signature (System.Int32, System.Object, System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"OnSetComplete"
		end

	on_clear_complete is
		external
			"IL signature (): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"OnClearComplete"
		end

	on_remove_complete (index: INTEGER; value: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"OnRemoveComplete"
		end

	on_insert_complete (index: INTEGER; value: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.DirectoryServices.PropertyValueCollection"
		alias
			"OnInsertComplete"
		end

end -- class SYSTEM_DIRECTORYSERVICES_PROPERTYVALUECOLLECTION
