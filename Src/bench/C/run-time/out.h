/*

  ####   #    #   #####          #    #
 #    #  #    #     #            #    #
 #    #  #    #     #            ######
 #    #  #    #     #     ###    #    #
 #    #  #    #     #     ###    #    #
  ####    ####      #     ###    #    #

			Include file for printing an Eiffel object
*/

#include "portable.h"

/*
 * Function declarations 
 */

extern char *c_generator();		/* Eiffel feature `generator' (GENERAL) */
extern char *c_tagged_out();	/* Eiffel feature `tagged_out' (GENERAL) */
shared char *build_out();		/* Build tagged out in C buffer */

/*
 * Building `out' string for simple types.
 */

extern char *c_outb();
extern char *c_outi();
extern char *c_outr();
extern char *c_outd();
extern char *c_outc();
extern char *c_outp();

#ifdef WORKBENCH

/* The following routine builds a tagged out string out of simple types.
 * The reason for this is that the debugger can request the value of, say,
 * local #2, and this might be an integer for instance... We cannot call
 * build_out, as it expects a true object, not a simple type...
 */

extern char *simple_out();		/* Tagged out form for simple types */

#endif
