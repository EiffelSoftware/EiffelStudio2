/*
	description:

		"Part of ISE Eiffel runtime. Needed to compile the EiffelCOM library."

	system: "Gobo Eiffel Compiler"
	copyright: "Copyright (c) 2010-2016, Eric Bezault and others"
	license: "MIT License"
	date: "$Date$"
	revision: "$Revision$"
*/

#ifndef EIF_GLOBALS_H
#define EIF_GLOBALS_H
#if defined(_MSC_VER) && (_MSC_VER >= 1020)
#pragma once
#endif

#ifndef EIF_THREADS_H
#include "eif_threads.h"
#endif

#ifdef __cplusplus
extern "C" {
#endif

#define EIF_GET_CONTEXT
#define GTCX EIF_GET_CONTEXT

#ifdef __cplusplus
}
#endif

#endif
