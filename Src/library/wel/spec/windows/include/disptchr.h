/*
 * DISPATCH.H
 */

#ifndef __WEL_DISPATCHER__
#define __WEL_DISPATCHER__

#ifndef __WEL__
#	include <wel.h>
#endif

typedef EIF_INTEGER (* EIF_WNDPROC)
	(EIF_OBJ,     /* WEL_DISPATCHER Eiffel object */
	 EIF_POINTER, /* hwnd */
	 EIF_INTEGER, /* message */
	 EIF_INTEGER, /* wparam */
	 EIF_INTEGER  /* lparam */
	 );
/* Eiffel routine signature for `window_procedure' */

typedef EIF_BOOLEAN (* EIF_DLGPROC)
	(EIF_OBJ,     /* WEL_DISPATCHER Eiffel object */
	 EIF_POINTER, /* hwnd */
	 EIF_INTEGER, /* message */
	 EIF_INTEGER, /* wparam */
	 EIF_INTEGER  /* lparam */
	 );
/* Eiffel routine signature for `dialog_procedure' */

LRESULT CALLBACK cwel_window_procedure (HWND, UINT, WPARAM, LPARAM);
BOOL CALLBACK cwel_dialog_procedure (HWND, UINT, WPARAM, LPARAM);

extern EIF_WNDPROC wel_wndproc;
/* Address of the Eiffel routine `window_procedure' (class WEL_DISPATCHER) */

extern EIF_DLGPROC wel_dlgproc;
/* Address of the Eiffel routine `dialog_procedure' (class WEL_DISPATCHER) */

extern EIF_OBJ dispatcher;
/* Address of the Eiffel object WEL_DISPATCHER created for each application */

#define cwel_window_procedure_address ((EIF_POINTER) cwel_window_procedure)
/* Address of `cwel_window_procedure' */

#define cwel_dialog_procedure_address ((EIF_POINTER) cwel_dialog_procedure)
/* Address of `cwel_dialog_procedure' */

#define cwel_set_window_procedure_address(_addr_) (wel_wndproc = (EIF_WNDPROC) _addr_)
/* Set `wel_wndproc' with `addr' */

#define cwel_set_dialog_procedure_address(_addr_) (wel_dlgproc = (EIF_DLGPROC) _addr_)
/* Set `wel_dlgproc' with `addr' */

#define cwel_set_dispatcher_object(_addr_) (dispatcher = (EIF_OBJ) _addr_)
/* Set `dispather' with `addr' */

#endif /* __WEL_DISPATCHER__ */

/*
--|-------------------------------------------------------------------------
--| Windows Eiffel Library: library of reusable components for ISE Eiffel 3.
--| Copyright (C) 1995, Interactive Software Engineering, Inc.
--| All rights reserved. Duplication and distribution prohibited.
--|
--| 270 Storke Road, Suite 7, Goleta, CA 93117 USA
--| Telephone 805-685-1006
--| Fax 805-685-6869
--| Information e-mail <info@eiffel.com>
--| Customer support e-mail <support@eiffel.com>
--|-------------------------------------------------------------------------
*/
