note
	description: "[
				This represents a package on the iron node (i.e server)
			]"
	date: "$Date$"
	revision: "$Revision$"

class
	IRON_NODE_VERSION_PACKAGE

inherit
	DEBUG_OUTPUT
		redefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_package: IRON_NODE_PACKAGE; a_version: IRON_NODE_VERSION)
			-- Initialize `Current' with package `a_package'.
		do
			package := a_package
			version := a_version
		end

feature -- Status

	has_id: BOOLEAN
		do
			Result := package.has_id
		end

feature -- Access

	package: IRON_NODE_PACKAGE
			-- Associated package.

	version: IRON_NODE_VERSION
			-- Associated version.

	download_count: INTEGER assign set_download_count
			-- Download count.

feature -- Comparison		

	is_equal (other: IRON_NODE_VERSION_PACKAGE): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
			-- (from ANY)
		do
			Result := (package ~ other.package) and then (version ~ other.version)
		end

	is_named (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Is package named `a_name' ?
		local
			s: detachable READABLE_STRING_32
		do
			if a_name /= Void then
				s := name
				if s /= Void then
					Result := a_name.is_case_insensitive_equal (s)
				end
			end
		end

feature -- Status report

	debug_output: READABLE_STRING_GENERAL
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := package.human_identifier + " (version:" + version.value + ")"
		end

feature -- Access

	identifier: READABLE_STRING_32
		do
			Result := package.identifier
		end

	human_identifier: READABLE_STRING_32
		do
			Result := package.human_identifier
		end

	id: IMMUTABLE_STRING_8
		do
			Result := package.id
		end

	owner: detachable IRON_NODE_USER
		do
			Result := package.owner
		end

	name: detachable READABLE_STRING_32
		do
			Result := package.name
		end

	title: detachable READABLE_STRING_32
		do
			Result := package.title
		end

	description: detachable READABLE_STRING_32
		do
			Result := package.description
		end

	last_modified: detachable DATE_TIME
		do
			Result := package.last_modified
		end

feature -- Tags

	tags: detachable LIST [READABLE_STRING_32]
		do
			Result := package.tags
		end

	links: detachable STRING_TABLE [IRON_NODE_LINK]
		do
			Result := package.links
		end

feature -- Access: archive

	archive: detachable IRON_NODE_ARCHIVE

	archive_revision: NATURAL
			-- Associated archive revision for this version.

	has_archive: BOOLEAN
		do
			Result := archive /= Void
		end

	archive_path: detachable PATH
		do
			if attached archive as a then
				Result := a.path
			end
		end

	archive_file_size: INTEGER
		do
			if attached archive as a then
				Result := a.file_size
			end
		end

	archive_last_modified: detachable DATE_TIME
		do
			if attached archive as a then
				Result := a.last_modified
			end
		end

	archive_md5: detachable STRING
			-- MD5 hash for associated archive file, if any.
		do
			if attached archive as a then
				Result := a.hash_md5
			end
		end

	archive_sha1: detachable STRING
			-- SHA1 hash for associated archive file, if any.
		do
			if attached archive as a then
				Result := a.hash_sha1
			end
		end

	archive_hash: detachable STRING
			-- Default hash for associated archive file, if any.
		do
			if attached archive as a then
				Result := a.hash
			end
		end

feature -- Access: items	

	items: detachable STRING_TABLE [detachable READABLE_STRING_32]
			-- Optional info

	item (n: READABLE_STRING_GENERAL): detachable READABLE_STRING_32
		do
			if attached items as tb then
				Result := tb.item (n)
			end
			if Result = Void then
				Result := package.item (n)
			end
		end

feature -- Change

	put (v: detachable READABLE_STRING_32; k: READABLE_STRING_GENERAL)
		local
			tb: like items
		do
			tb := items
			if tb = Void then
				create tb.make (1)
				items := tb
			end
			tb.force (v, k)
		end

	remove (k: READABLE_STRING_GENERAL)
		local
			tb: like items
		do
			tb := items
			if tb /= Void then
				tb.remove (k)
			end
		end

	set_download_count (a_count: INTEGER)
		do
			download_count := a_count
		end
		
	set_archive (a_archive: detachable IRON_NODE_ARCHIVE)
		do
			archive := a_archive
		end

	set_archive_revision (a_rev: NATURAL)
		do
			archive_revision := a_rev
		end

	get_new_archive_revision
		do
			package.increment_last_archive_revision
			archive_revision := package.last_archive_revision
		end

feature -- Visitor

	accept (vis: IRON_NODE_VISITOR)
		do
			vis.visit_package_version (Current)
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
