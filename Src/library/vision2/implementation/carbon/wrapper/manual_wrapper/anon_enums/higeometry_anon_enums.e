indexing
	description: "wrapper for anynymous enums from file HIGeometry.h"

class
	HIGEOMETRY_ANON_ENUMS

feature -- Carbon constants

	frozen kHICoordSpace72DPIGlobal: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kHICoordSpace72DPIGlobal"
	end

	frozen kHICoordSpaceScreenPixel: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kHICoordSpaceScreenPixel"
	end

	frozen kHICoordSpaceWindow: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kHICoordSpaceWindow"
	end

	frozen kHICoordSpaceView: INTEGER is
	external
		"C inline use <Carbon/Carbon.h>"
	alias
		"kHICoordSpaceView"
	end

end
