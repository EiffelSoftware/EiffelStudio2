indexing
	Generator: "Eiffel Emitter 2.7b2"
	external_name: "System.Windows.Forms.ToolBar+ToolBarButtonCollection"

external class
	TOOLBARBUTTONCOLLECTION_IN_SYSTEM_WINDOWS_FORMS_TOOLBAR

inherit
	ANY
		redefine
			finalize,
			get_hash_code,
			is_equal,
			to_string
		end
	SYSTEM_COLLECTIONS_ILIST
		rename
			remove as system_collections_ilist_remove,
			insert as system_collections_ilist_insert,
			index_of as system_collections_ilist_index_of,
			copy_to as system_collections_icollection_copy_to,
			has as system_collections_ilist_contains,
			extend as system_collections_ilist_add,
			get_is_fixed_size as system_collections_ilist_get_is_fixed_size,
			get_is_synchronized as system_collections_icollection_get_is_synchronized,
			get_sync_root as system_collections_icollection_get_sync_root,
			put_i_th as system_collections_ilist_set_item,
			get_item as system_collections_ilist_get_item
		end
	SYSTEM_COLLECTIONS_IENUMERABLE
	SYSTEM_COLLECTIONS_ICOLLECTION
		rename
			copy_to as system_collections_icollection_copy_to,
			get_is_synchronized as system_collections_icollection_get_is_synchronized,
			get_sync_root as system_collections_icollection_get_sync_root
		end

create
	make

feature {NONE} -- Initialization

	frozen make (owner: SYSTEM_WINDOWS_FORMS_TOOLBAR) is
		external
			"IL creator signature (System.Windows.Forms.ToolBar) use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		end

feature -- Access

	get_item (index: INTEGER): SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON is
		external
			"IL signature (System.Int32): System.Windows.Forms.ToolBarButton use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"get_Item"
		end

	frozen get_count: INTEGER is
		external
			"IL signature (): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"get_Count"
		end

	frozen get_is_read_only: BOOLEAN is
		external
			"IL signature (): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"get_IsReadOnly"
		end

feature -- Element Change

	set_item (index: INTEGER; value: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON) is
		external
			"IL signature (System.Int32, System.Windows.Forms.ToolBarButton): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"set_Item"
		end

feature -- Basic Operations

	to_string: STRING is
		external
			"IL signature (): System.String use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"ToString"
		end

	frozen add (text: STRING): INTEGER is
		external
			"IL signature (System.String): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Add"
		end

	get_hash_code: INTEGER is
		external
			"IL signature (): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"GetHashCode"
		end

	frozen insert (index: INTEGER; button: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON) is
		external
			"IL signature (System.Int32, System.Windows.Forms.ToolBarButton): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Insert"
		end

	frozen get_enumerator: SYSTEM_COLLECTIONS_IENUMERATOR is
		external
			"IL signature (): System.Collections.IEnumerator use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"GetEnumerator"
		end

	frozen clear is
		external
			"IL signature (): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Clear"
		end

	frozen contains (button: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON): BOOLEAN is
		external
			"IL signature (System.Windows.Forms.ToolBarButton): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Contains"
		end

	frozen add_range (buttons: ARRAY [SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON]) is
		external
			"IL signature (System.Windows.Forms.ToolBarButton[]): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"AddRange"
		end

	is_equal (obj: ANY): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Equals"
		end

	frozen add_tool_bar_button (button: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON): INTEGER is
		external
			"IL signature (System.Windows.Forms.ToolBarButton): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Add"
		end

	frozen index_of (button: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON): INTEGER is
		external
			"IL signature (System.Windows.Forms.ToolBarButton): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"IndexOf"
		end

	frozen remove (button: SYSTEM_WINDOWS_FORMS_TOOLBARBUTTON) is
		external
			"IL signature (System.Windows.Forms.ToolBarButton): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Remove"
		end

	frozen remove_at (index: INTEGER) is
		external
			"IL signature (System.Int32): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"RemoveAt"
		end

feature {NONE} -- Implementation

	frozen system_collections_ilist_index_of (button: ANY): INTEGER is
		external
			"IL signature (System.Object): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.IndexOf"
		end

	frozen system_collections_ilist_set_item (index: INTEGER; value: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.set_Item"
		end

	frozen system_collections_icollection_get_sync_root: ANY is
		external
			"IL signature (): System.Object use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.ICollection.get_SyncRoot"
		end

	frozen system_collections_icollection_copy_to (dest: SYSTEM_ARRAY; index: INTEGER) is
		external
			"IL signature (System.Array, System.Int32): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.ICollection.CopyTo"
		end

	frozen system_collections_ilist_remove (button: ANY) is
		external
			"IL signature (System.Object): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.Remove"
		end

	frozen system_collections_ilist_add (button: ANY): INTEGER is
		external
			"IL signature (System.Object): System.Int32 use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.Add"
		end

	frozen system_collections_ilist_get_item (index: INTEGER): ANY is
		external
			"IL signature (System.Int32): System.Object use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.get_Item"
		end

	frozen system_collections_icollection_get_is_synchronized: BOOLEAN is
		external
			"IL signature (): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.ICollection.get_IsSynchronized"
		end

	frozen system_collections_ilist_contains (button: ANY): BOOLEAN is
		external
			"IL signature (System.Object): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.Contains"
		end

	frozen system_collections_ilist_get_is_fixed_size: BOOLEAN is
		external
			"IL signature (): System.Boolean use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.get_IsFixedSize"
		end

	finalize is
		external
			"IL signature (): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"Finalize"
		end

	frozen system_collections_ilist_insert (index: INTEGER; button: ANY) is
		external
			"IL signature (System.Int32, System.Object): System.Void use System.Windows.Forms.ToolBar+ToolBarButtonCollection"
		alias
			"System.Collections.IList.Insert"
		end

end -- class TOOLBARBUTTONCOLLECTION_IN_SYSTEM_WINDOWS_FORMS_TOOLBAR
