/*

 #####   #       #    #   ####           #    #
 #    #  #       #    #  #    #          #    #
 #    #  #       #    #  #               ######
 #####   #       #    #  #  ###   ###    #    #
 #       #       #    #  #    #   ###    #    #
 #       ######   ####    ####    ###    #    #

	Declarations for plugging routines and structures.
*/

#ifndef _plug_h_
#define _plug_h_

#include "config.h"
#include "portable.h"

/* Structure used to represent bits in the object. The first long integer
 * is the length of the bit field. It is then followed by enough long integers
 * to store the value of the bits.
 * The declaration of the structure is tricky: the value field is declared as
 * a pointer on an array of one time, but as C does no range checking, this
 * perfectly suits our needs--RAM.
 */

struct bit {
	uint32 b_length;				/* Length of the bit field */
	uint32 b_value[1];				/* Array long integers holding value */
};

/*
 * Run time functions used by generated C code.
 */

extern char *makestr();				/* Build an Eiffel string object */
extern int str_dtype;				/* Dynamic type for string */
extern int bit_dtype;				/* Dynamic type for bit */
extern void (*strmake)();			/* STRING creation feature */
extern void (*strset)();			/* STRING `set_count' feature */

#ifdef WORKBENCH
extern void wstdinit();				/* Composite objects initialization */
#endif

/*
 * Run time declarations (tables produced by the compiler).
 */

#ifndef WORKBENCH
extern long esize[];				/* Size of object given Dynamic Type */
extern long nbref[];				/* Gives # of references given DT */
extern void (**edispose)();			/* Records pointers to dispose routines */
extern char *(**ecreate)();			/* Initialization routines */
#endif

#define System(type)		esystem[type]	/* Object description */

#ifndef WORKBENCH
#define References(type)	nbref[type]	 	/* # of references */
#define Size(type)			esize[type]	 	/* Object's size */
#define Dispose(type)		edispose[type]	/* Dispose routine */
#define Create(type)		ecreate[type]	/* Initialization routine */
#else
#define References(type)	esystem[type].nb_ref
#define Size(type)			esystem[type].size
#define Dispose(type)		esystem[type].dispose
#define Create(type)		\
	(esystem[type].cn_composite ? (char *(*)()) wstdinit : (char *(*)()) 0)
#endif

/* Type used in the "dynamic type" field of special objects holding an array
 * of simple type, e.g. ARRAY[REAL]. They are used by all the object "viewing"
 * routines.
 */

extern int sp_bool;			/* Dynamic type of SPECIAL[BOOLEAN] */
extern int sp_char;			/* Dynamic type of SPECIAL[CHARACTER] */
extern int sp_int;			/* Dynamic type of SPECIAL[INTEGER] */
extern int sp_real;			/* Dynamic type of SPECIAL[REAL] */
extern int sp_double;			/* Dynamic type of SPECIAL[DOUBLE] */

/*
 * Miscellaneous routines.
 */

extern char econfg();			/* Conformance query in class GENERAL */
extern int econfm();			/* Conformance query for assignment attempt */
extern long sp_count();			/* Count of a special object */
extern void chkinv();			/* Invariant control call in final mode */

#endif

