/*

 #    #    ##       #    #    #           ####
 ##  ##   #  #      #    ##   #          #    #
 # ## #  #    #     #    # #  #          #
 #    #  ######     #    #  # #   ###    #
 #    #  #    #     #    #   ##   ###    #    #
 #    #  #    #     #    #    #   ###     ####

	Therein lie paths I would not have dared treading alone.
*/

/*
doc:<file name="main.c" header="eif_main.h" version="$Id$" summary="Initialization of runtime">
*/

#include "eif_portable.h"

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include "rt_assert.h"

#include "eif_project.h"
#include <string.h>
#include "rt_urgent.h"
#include "rt_except.h"
#include "rt_sig.h"
#include "rt_gen_conf.h"

#ifdef WORKBENCH
#include "eif_wbench.h"		/* %%ss added for create_desc */
#include "rt_interp.h"
#include "rt_update.h"
#include "server.h"						/* ../ipc/app */
#endif /* WORKBENCH */

#include "rt_err_msg.h"

#if !defined CUSTOM || defined NEED_UMAIN_H
#include "eif_umain.h"
#endif

#if !defined CUSTOM || defined NEED_ARGV_H
#include "rt_argv.h"
#endif

#include "rt_lmalloc.h"
#include "rt_malloc.h"
#include "rt_garcol.h"
#include "rt_main.h"

#ifdef BOEHM_GC
#include "rt_boehm.h"
#endif

#ifdef EIF_ASSERTIONS
#include <stdarg.h>
#endif

#ifdef WORKBENCH
extern void dbreak_create_table(void); /* defined in debug.c */
#else
// NON_COMMERCIAL is defined when compiling a non-commercial version of the run-time
#ifdef NON_COMMERCIAL
#ifdef EIF_WIN32
#include "splashcom.x"
#endif
rt_private void display_non_commercial(void);
#endif
#endif

/*
doc:	<attribute name="eif_no_reclaim" return_type="int" export="public">
doc:		<summary>Tell if runtime should reclaim all objects at the very end of execution.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized once in `eif_alloc_init'.</synchronization>
doc:	</attribute>
*/
rt_public int eif_no_reclaim = 0;

/*
doc:	<attribute name="cc_for_speed" return_type="int" export="public">
doc:		<summary>Is runtime memory allocation optimized for speed or for memory. Default value is `1' (speed), except on some platforms where it is not supported or if scavenging is disabled.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Use `eif_memory_mutex' when updating its value.</synchronization>
doc:		<eiffel_classes>MEMORY</eiffel_classes>
doc:	</attribute>
*/
#if defined VXWORKS
	/* when eif_malloc() fails, the system dies otherwise !!! */
	/* FIXME?? */
rt_public int cc_for_speed = 0;			/* Save memory. */
#else	/* VXWORKS */
#ifdef EIF_NO_SCAVENGING
rt_public int cc_for_speed = 0;			/* No scavenging. */
#else	/* EIF_NO_SCAVENGING */
rt_public int cc_for_speed = 1;			/* Fast memory allocation */
#endif	/* EIF_NO_SCAVENGING */
#endif	/* VXWORKS */

#ifndef VXWORKS  /* In the case of VxWorks, the declaration and 
					initialization of scount is added by finish_freezing
					to the file E1/ececil.c (paulv) */
/*
doc:	<attribute name="scount" return_type="int" export="public">
doc:		<summary>Number of dynamic types in system.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `eplug.c' from generated C code.</synchronization>
doc:	</attribute>
*/
rt_public int scount;						/* Number of dynamic types */
#endif

/*
doc:	<attribute name="esystem" return_type="struct cnode *" export="public">
doc:		<summary>Description of types in current system.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Dynamic type.</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized here in `main.c' and updated once in `update' from `update.c'.</synchronization>
doc:	</attribute>
*/
rt_public struct cnode *esystem;			/* Eiffel system */

#ifdef WORKBENCH
/*
doc:	<attribute name="ccount" return_type="int" export="public">
doc:		<summary>Number of classes.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in compiler generated `einit.c'.</synchronization>
doc:	</attribute>
*/
rt_public int ccount;

/*
doc:	<attribute name="fcount" return_type="int" export="public">
doc:		<summary>Number of frozen dynamic types. Same as `scount' when system is completely frozen.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c'.</synchronization>
doc:	</attribute>
*/
rt_public int fcount;

/*
doc:	<attribute name="ecall" return_type="int32 **" export="shared">
doc:		<summary>Routine ID arrays. Used for workbench mode only. Array of routine IDs per class indexed by their feature_id.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>First index is by class_id, second by feature_id</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c', updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_shared int32 **ecall;

/*
doc:	<attribute name="eorg_table" return_type="struct rout_info *" export="shared">
doc:		<summary>Routine origin/offset table.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c', updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_shared struct rout_info *eorg_table;

/*
doc:	<attribute name="melt" return_type="unsigned char **" export="shared">
doc:		<summary>Byte code array. For each body_id, we store address in melted code array.</summary>
doc:		<access>Read/Write once</access>\
doc:		<indexing>Body_id</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_shared unsigned char **melt;

/*
doc:	<attribute name="eif_nb_features" return_type="uint32" export="public">
doc:		<summary>Number of features in frozen system. Correspond to count of generated `egc_frozen_init'.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in compiler generated `einit.c'.</synchronization>
doc:	</attribute>
*/
rt_public uint32 eif_nb_features;

/*
doc:	<attribute name="eoption" return_type="struct eif_opt *" export="public">
doc:		<summary>Option table. Store assertion and profiling option per dynamic type.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>Dtype</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c' and updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_public struct eif_opt *eoption;

/*
doc:	<attribute name="mpatidtab" return_type="int *" export="shared">
doc:		<summary>Table of pattern ID for a given body_id.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Body_id</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_shared int *mpatidtab;

/*
doc:	<attribute name="pattern" return_type="struct p_interface *" export="public">
doc:		<summary>Pattern table indexed by pattern ID. It is a vtable of `toi' (from C to melted code) and `toc' (from melted code to C code) routines</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Pattern_id</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c'.</synchronization>
doc:	</attribute>
*/
rt_public struct p_interface *pattern;		/* Pattern table */
#else
/*
doc:	<attribute name="esize" return_type="long *" export="public">
doc:		<summary>Size of objects indexed by dynamic type for finalized mode only. Done this way to avoid page fault by loading large `esystem' table.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Dtype</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c'.</synchronization>
doc:	</attribute>
*/
rt_public long *esize;						/* Size of objects */

/*
doc:	<attribute name="nbref" return_type="long *" export="shared">
doc:		<summary>Number of references per dynamic type for finalized mode only. Done this way to avoid page fault by loading large `esystem' table.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Dtype</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in `main.c'.</synchronization>
doc:	</attribute>
*/
rt_shared long *nbref;						/* Gives # of references */
#endif

#if defined(WORKBENCH) || defined (EIF_THREADS)
/*
doc:	<attribute name="eif_nb_org_routines" return_type="uint32" export="public">
doc:		<summary>Number of original routine bodies. Additional routine bodies generated for derivations with expanded parameters are not counted.</summary>
doc:		<access>Read/Write once</access>
doc:		<indexing>Body_id</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized in compiler generated `einit.c' and updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_public uint32 eif_nb_org_routines;
#endif

#define exvec() exset(NULL, 0, NULL)	/* How to get an execution vector */

rt_public void failure(void);					/* The Eiffel exectution failed */
rt_private Signal_t emergency(int sig);			/* Emergency exit */
rt_public unsigned TIMEOUT;     /* Time out for interprocess communications */

/*
doc:	<attribute name="EIF_once_count" return_type="long" export="public">
doc:		<summary>Total number of once routines (computed by compiler).</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized at beginning with EIF_Minitxxx routines in generated code.</synchronization>
doc:	</attribute>
*/
rt_public long EIF_once_count = 0;

/*
doc:	<attribute name="EIF_bonce_count" return_type="long" export="shared">
doc:		<summary>Number of once routines in bytecode.</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized either to 0 or updated in `update.c'.</synchronization>
doc:	</attribute>
*/
rt_shared long EIF_bonce_count = 0;

#ifndef EIF_THREADS
/*
doc:	<attribute name="in_assertion" return_type="int" export="public">
doc:		<summary>Is an assertion being evaluated? Used to avoid recursive calls on assertions.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Per thread data.</synchronization>
doc:	</attribute>
*/
rt_public int in_assertion = 0;

/*
doc:	<attribute name="EIF_once_values" return_type="EIF_REFERENCE *" export="public">
doc:		<summary>Array to save value of each computed once. It is used to store once per thread values.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>By once key.</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Per thread data.</synchronization>
doc:	</attribute>
*/
rt_public EIF_REFERENCE *EIF_once_values = NULL;

/*
doc:	<attribute name="EIF_oms" return_type="EIF_REFERENCE **" export="public">
doc:		<summary>Array of pointers to arrays to save once manifest strings
doc:            for every routine. It is used to store once per thread values.</summary>
doc:		<access>Read/Write</access>
doc:		<indexing>By original routine body index.</indexing>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Per thread data.</synchronization>
doc:	</attribute>
*/
rt_public EIF_REFERENCE **EIF_oms = NULL;

#endif /* EIF_THREADS */

/*
doc:	<attribute name="debug_mode" return_type="int" export="public">
doc:		<summary>This variable records whether the workbench application was launched via the ised wrapper (i.e. in debug mode) or not.</summary>
doc:		<access>Read/Write</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>Done by `winit' at the beginning and only one thread can modify `debug_mode' while debugging.</synchronization>
doc:	</attribute>
*/
rt_public int debug_mode = 0;	/* Assume not in debug mode */

/*
doc:	<attribute name="starting_working_directory" return_type="char *" export="public">
doc:		<summary>Store working directory during session, ie where to put output files from runtime</summary>
doc:		<access>Read/Write once</access>
doc:		<thread_safety>Safe</thread_safety>
doc:		<synchronization>None since initialized once in `eif_rtinit'.</synchronization>
doc:		<fixme>Memory is allocated, we do chdir, but we never fill its content?</fixme>
doc:	</attribute>
*/
rt_public char *starting_working_directory;

rt_private void display_reminder (void);	/* display reminder of license */

#ifdef EIF_ASSERTIONS
rt_shared int ise_printf (char *StrFmt, ...)
	/* To put a breakpoint when an assertion violation occurs. */
{
	va_list ap;
	int r;

	va_start (ap, StrFmt);
	r = vprintf (StrFmt, ap);
	va_end (ap);

	return r;
}
#endif

rt_public void once_init (void)
{
	EIF_GET_CONTEXT

	/* At this point 'EIF_bonce_count' has already been
	   computed (by update) */

	/* Run through all modules and count once routines
	   This also assigns an offset to each module. The
	   sum of the module offset and a once routines own
	   key index gives the index in 'once_keys' */
	/* Addition: we also the previous value of EIF_once_count to
	 * EIF_once_count, since some once routines could have been
	 * supermelted */

	EIF_once_count = EIF_once_count + EIF_bonce_count;

	egc_system_mod_init ();

	/* Allocate room for once manifest strings array. */
	ALLOC_OMS (EIF_oms);

	/* Allocate room for once values */

	EIF_once_values = (EIF_REFERENCE *) eif_realloc (EIF_once_values, EIF_once_count * REFSIZ);
			/* needs malloc; crashes otherwise on some pure C-ansi compiler (SGI)*/
	if (EIF_once_values == (EIF_REFERENCE *) 0) /* Out of memory */
		enomem();

	memset (EIF_once_values, 0, EIF_once_count * sizeof (char *));

}

rt_public void eif_alloc_init(void)
{
	/*
	 * This function initializes the global variables holding the values
	 * for memory allocation parameters (chunk and scavenge zone size) to
	 * their default values (env. variable or macro).
	 * The constant CHUNK has been replaced with eif_chunk_size everywhere.
	 * The constant GS_ZONE_SZ has been replaced with eif_scavenge_size.
	 * The constant TENURE_MAX is replaced by eif_tenure_max.
	 * The constant GS_LIMIT is replaced by eif_gs_limit. 
	 * The constant STACK_CHUNK is replaced by eif_stack_chunk. 
	 * The constant PLSC_PER is replaced by plsc_per.
	 * The constant CLSC_PER is replaced by clsc_per.
	 * The constants TH_ALLOC is replaced by th_alloc. 
	 */

	char *env_var;						/* Environment variable recipient. */
	static int chunk_size = 0;
	static int stack_chunk = 0;
	static int scavenge_size = 0;		/* Generational scavenge zone size. */
	static int tenure_max	= 0;		/* Maximum age of tenuring. */
	static int gs_limit	= 0;			/* Maximum size (bytes) of 
										 * objects in GSZ.*/
	static int c_per = 0;				/* Full coalesc period.*/
	static int p_per = 0;				/* full collection period.*/
	static int thd	= 0;				/* Threshold of allocation.*/
	static uint32 stk_limit = 0;			/* Stack size limit for GC */
	int mod;							/* Value to ensure that some runtime values are properly
										   rounded to ALIGNMAX */

	/* Special options. */
	env_var = getenv ("EIF_NO_RECLAIM");
	if (env_var != NULL)
		eif_no_reclaim = atoi (env_var);
		
	/* Set chunk size. */
	if (!chunk_size) {
		env_var = getenv ("EIF_MEMORY_CHUNK");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {
			chunk_size = atoi (env_var);
			mod = chunk_size % ALIGNMAX;
			if (mod != 0)
				chunk_size += ALIGNMAX - mod;
		} else {
			chunk_size = CHUNK_DEFAULT;
		}
	}
	eif_chunk_size = chunk_size >= CHUNK_SZ_MIN ? chunk_size : CHUNK_SZ_MIN;
								/* Reasonable chunk size. */

#ifdef ISE_GC
	/* Set scavenge size. */
	if (!scavenge_size) {
		env_var = getenv ("EIF_MEMORY_SCAVENGE");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {
			scavenge_size = atoi (env_var);
			mod = scavenge_size % ALIGNMAX;
			if (mod != 0)
				scavenge_size += ALIGNMAX - mod;
		} else {
			scavenge_size = GS_ZONE_SZ_DEFAULT;
		}
	}
	eif_scavenge_size = scavenge_size >= GS_SZ_MIN ? scavenge_size : GS_SZ_MIN;
								/* Reasonable GSZ size. */	

	/* Set maximum tenuring age. */
	if (!tenure_max)	/* Is maximum tenuring age not set yet? */
	{
		env_var = getenv ("EIF_TENURE_MAX");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {	/* Has user specified it? */
			tenure_max = atoi (env_var);

			/* Must be in bounds. */
			if (tenure_max < 0)		
				tenure_max = 0;		/* Mimimun is 0. */
			else if (tenure_max > TENURE_MAX)
				tenure_max = TENURE_MAX;	/* Maximum is TENURE_MAX. */
		} else {
			tenure_max = TENURE_MAX;	/* RT default setting. */
		}
	}
	eif_tenure_max = tenure_max;	

	/* Set maximum size of objects in GSZ. */
	if (!gs_limit)	/* Is maximum size of objects in GSZ not set yet? */
	{
		env_var = getenv ("EIF_GS_LIMIT");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {	/* Has user specified it? */
			gs_limit = atoi (env_var);
			/* Must be in bounds. */
			if (gs_limit < 0)		
				gs_limit = 0;		/* Mimimun is 0. */
			else if (gs_limit > GS_FLOATMARK)
				gs_limit = GS_FLOATMARK;	/* Maximum we allow, may crash 
											 * otherwise. */
		} else {
			gs_limit = GS_LIMIT;	/* RT default setting. */
		}
	}
	eif_gs_limit = gs_limit;	
								/* Reasonable gs_limit. */
#endif /* ISE GC */

	/* Set Size of local stack chunk. */
	if (!stack_chunk) {	/* Is maximum size of objects in GSZ not set yet? */
		env_var = getenv ("EIF_STACK_CHUNK");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {	/* Has user specified it? */
			stack_chunk = atoi (env_var);
			mod = stack_chunk % ALIGNMAX;
			if (mod != 0)
				stack_chunk += ALIGNMAX - mod;
		} else {
			stack_chunk = STACK_CHUNK;	/* RT default setting. */
		}
	}
	eif_stack_chunk = stack_chunk;	

#ifdef ISE_GC
	/* Set full coalesce period. */
	if (!c_per) {	/* Is full coalesce period not set yet? */
		env_var = getenv ("EIF_FULL_COALESCE_PERIOD");
		if ((env_var != NULL) && (strlen(env_var) > 0))	/* Has user specified it? */
			c_per = atoi (env_var);
		else
			c_per = CLSC_PER;	/* RT default setting. */
	}
	clsc_per = c_per >= 0 ? c_per : 0;	

	/* Set full collection period. */
	if (!p_per) {	/* Is full collection period not set yet? */
		env_var = getenv ("EIF_FULL_COLLECTION_PERIOD");
		if ((env_var != NULL) && (strlen(env_var) > 0))	/* Has user specified it? */
			p_per = atoi (env_var);
		else
			p_per = PLSC_PER;	/* RT default setting. */
	}
	plsc_per = p_per >= 0 ? p_per : 0;	

	/* Set memory threshold. */
	if (!thd) {	/* Is memory threshold not set yet? */
		env_var = getenv ("EIF_MEMORY_THRESHOLD");
		if ((env_var != NULL) && (strlen(env_var) > 0))	/* Has user specified it? */
			thd = atoi (env_var);
		else
			thd = TH_ALLOC;	/* RT default setting. */
	}
	th_alloc = thd >= TH_ALLOC_MIN ? thd : TH_ALLOC_MIN;

	/* Set stack overflow depth to a certain threshold */
	if (!stk_limit) {	/* Is it set yet? */
		env_var = getenv ("EIF_STACK_LIMIT");
		if ((env_var != NULL) && (strlen(env_var) > 0)) {
			stk_limit = (uint32) atoi (env_var);
		} else {
			stk_limit = OVERFLOW_STACK_LIMIT;
		}
	}
	overflow_stack_limit = (stk_limit < 2 ? 2 : stk_limit);

#ifndef EIF_THREADS
		/* Try to allocate scavenge zone if possible in non-MT compilation. For MT compilation
		 * this is taken care of in `eif_thr_init_root'. */
	create_scavenge_zones ();
#endif

	/******************* Postconditions *******************/
	ENSURE ("Chunk size must be over that", eif_chunk_size >= CHUNK_SZ_MIN);
	ENSURE ("GSZ size must be over that", eif_scavenge_size >= GS_SZ_MIN);
	ENSURE ("Max tenure age in bounds", eif_tenure_max >= 0 && eif_tenure_max <= TENURE_MAX);
	ENSURE ("Reasonable max size of objects in GSZ.", eif_gs_limit >= 0 && eif_gs_limit <= GS_FLOATMARK);
	ENSURE ("Full coelesc period must be positive.", clsc_per >= 0);
	ENSURE ("Full collection period must be postive.", plsc_per >= 0);
	ENSURE ("Threshold of allocation must be positive", th_alloc >= TH_ALLOC_MIN);
	/*************** End of Postconditions. ******************/
#endif /* ISE_GC */
}

rt_public void eif_rtinit(int argc, char **argv, char **envp)
{
	char *eif_timeout;

	/* Compute the program name, so that all the error messages can be tagged
	 * with that name (with the notable exception of the stack trace, for
	 * formatting purpose).
	 */

#ifdef EIF_WIN32
	static char module_name [255] = {0};
#endif

#ifdef EIF_WIN32
	set_windows_exception_filter();
#endif

#ifdef BOEHM_GC
	GC_register_displacement (OVERHEAD);
#endif

	starting_working_directory = (char *) eif_malloc (PATH_MAX + 1);

	ufill();							/* Get urgent memory chunks */

#if defined (DEBUG) && ! defined (VXWORKS)
	/* The following install signal handlers for signals USR1 and USR2. Both
	 * raise an immediate scanning of memory and dumping of the free list usage
	 * and other statistics. The difference is that USR1 also performrs a full
	 * GC cycle before runnning the diagnosis. If memck() is programmed to
	 * panic when inconsistencies are detected, this may raise a system failure
	 * due to race condition. There is nothing the user can do about it, except
	 * pray--RAM.
	 */

	esignal(SIGUSR1, mem_diagnose);
	esignal(SIGUSR2, mem_diagnose);
#endif

	/* Check if the user wants to override the default timeout value
	 * for interprocess communications. This new value is specified in
	 * the ISE_TIMEOUT environment variable
	 */
	eif_timeout = getenv("ISE_TIMEOUT");
	if ((eif_timeout != NULL) && (strlen(eif_timeout) > 0)) {		/* Environment variable set */
		TIMEOUT = (unsigned) atoi(eif_timeout);
	} else {
		TIMEOUT = 30;
	}

#ifdef WORKBENCH
	xinitint();							/* Interpreter initialization */
	esystem = egc_fsystem;
	ecall = egc_fcall;
	eoption = egc_foption;
	eif_par_table = egc_partab;
	eif_par_table_size = egc_partab_size;
	eorg_table = egc_forg_table;
	pattern = egc_fpattern;

	dbreak_create_table();		/* create the structure used to store breakpoints information */

	/* In workbench mode, we have a slight problem: when we link ewb in
	 * workbench mode, since ewb is a child from ised, the run-time will
	 * assume, wrongly, that the executable is started in debug mode. Therefore,
	 * we need a special run-time, with no debugging hooks involved.
	 */
#ifndef NOHOOK
	winit();					/* Did we start under ewb control? */
#endif

	/* Initialize dynamically computed variables (i.e. system dependent)
	 * Then we may call update. Eventually, when debugging the
	 * application, the values loaded from the update file will be overridden
	 * by the workbench (via winit).
	 */

	egc_einit();							/* Various static initializations */
	fcount = scount;

	{
		char temp = 0;
		int i;

		for (i=1;i<argc;i++) {
			if (0 == strcmp (argv[i], "-ignore_updt")) {
				temp = (char) 1;	
				break;
			}
		}
		update(temp);					
	}									/* Read melted information
										 * Note: the `update' function takes
										 * care of the initialization of the 
										 * temporary descriptor structures
										 */

	create_desc();						/* Create descriptor (call) tables */
	
#else

	/*
	 * Initialize the finalized system with the static data structures.
	 */
	esystem = egc_fsystem;
	eif_par_table = egc_partab;
	eif_par_table_size = egc_partab_size;
	eif_gen_conf_init (eif_par_table_size);
	nbref = egc_fnbref;
	esize = egc_fsize;

#endif

#if !defined CUSTOM || defined NEED_UMAIN_H
	umain(argc, argv, envp);			/* User's initializations */
#endif
#if !defined CUSTOM || defined NEED_ARGV_H
	arg_init(argc, argv);				/* Save copy for class ARGUMENTS */
#endif
	once_init();

	/* Check for the license code and if it does not match displays the
	 * dialog */
	{
		int value;
		value = 0x00000025 * egc_platform_level;
		value = value + egc_compiler_tag;
#ifndef WORKBENCH
#ifdef NON_COMMERCIAL
		display_non_commercial();
#else
		if (value != egc_type_of_gc)
			display_reminder();
#endif // NON_COMMERCIAL
#endif // WORKBENCH
	}
}

rt_public void failure(void)
{
	/* A fatal Eiffel exception has occurred. The stack of exceptions is dumped
	 * and the memory is cleaned up, if possible.
	 */

  	GTCX
  		/* When we arrive at this location, the Eiffel call stack is theoratically
		 * empty, but `loc_set' still points to the location where the last Eiffel
		 * call has been made. Since now `loc_set' records address of C local variable
		 * which are usually located on the C call stack. Any addition to the C call
		 * stack (like the call to `trapsig' below) will corrupt the information
		 * stored in `loc_set' since it will replace a location by another.
		 *
		 * To prevent this, we have to manually empty `loc_set'. It does not matter
		 * at this point that the GC forgets about all objects referenced through
		 * a local variable since all Eiffel calls have been executed.
		 * Doing so, enables a safe `reclaim' that will not traverse `loc_set'
		 * objects.
		 */
#ifdef ISE_GC
	st_reset (&loc_set);
#endif

	trapsig(emergency);					/* Weird signals are trapped */
	esfail(MTC_NOARG);							/* Dump the execution stack trace */

	reclaim();							/* Reclaim all the objects */
	exit(1);							/* Abnormal termination */

	/* NOTREACHED */
}

rt_private Signal_t emergency(int sig)
{
	/* A signal has been trapped while we were failing peacefully. The memory
	 * must really be in a desastrous state, so print out a give-up message
	 * and exit.
	 */
	
	print_err_msg(stderr, "\n\n%s: PANIC: caught signal #%d (%s) -- Giving up...\n",
		egc_system_name, sig, signame(sig));

	exit(2);							/* Really abnormal termination */

	/* NOTREACHED */
}

#ifdef NOHOOK

/* When no debugging is allowed, the file network.o is not part of the
 * archive. However, we need to define dummy dserver() and dinterrupt() entries.
 */

rt_public void dserver(void) {}
rt_public char dinterrupt(void) { return 0; }
#endif

rt_public void dexit(int code)
{
	/* This routine is called by functions from libipc.a to raise immediate
	 * termination with a chance to trap the action and perform some clean-up.
	 * Here we call esdie() which will collect all the Eiffel objects and
	 * eventually call dispose() on some of them.
	 */

	esdie(code);						/* Propagate dying request */
}

rt_private void display_reminder(void)
{
	char *msg;

	msg = "This program has been produced with a demo or non-commercial version\nof ISE EiffelStudio, the full lifecycle object-oriented development\nenvironment from Eiffel Software.\nThis version is reserved for non-production use of Eiffel. Any other\nuse requires purchase of a license.\n\nEiffel Software offers commercial and academic licenses and\nsupport/maintenance contracts covering diverse needs.\n\nFor more information please contact\nEiffel Software at the address below or consult the Eiffel products page\nat http://www.eiffel.com/products/.\n\n\tEiffel Software\n\t356 Storke Road\n\tGoleta CA 93117 USA \n\tTelephone 805-685-1006, Fax 805-685-6869\n\tE-mail sales@eiffel.com\n\thttp://www.eiffel.com\n";

#ifdef EIF_WIN32
	MessageBox (NULL, msg, 
			"Generated by unregistered version of ISE EIffel", MB_OK); 
#else
	printf ("%s", msg);
#endif
}

#if !defined( WORKBENCH ) && defined( NON_COMMERCIAL)
rt_private void display_non_commercial(void)
{
#ifdef EIF_WIN32
	HDC dc, MemDC;
	HBITMAP Bitmap, OldBitmap;
	BITMAP bm;
	RECT sr;
	BITMAPINFO* pbmi;
	int non_commercial_splash_width;
	int non_commercial_splash_height;
	int non_commercial_splash_size;
	char * non_commercial_splash_array;

	dc = CreateDC ("DISPLAY", NULL, NULL, NULL);
	pbmi = (BITMAPINFO*) non_commercial_splash; // We initialize the BITMAPINFO with a raw copy of the splash.
	non_commercial_splash_width = pbmi -> bmiHeader.biWidth;
	non_commercial_splash_height = pbmi -> bmiHeader.biHeight;
	non_commercial_splash_size = pbmi -> bmiHeader.biSizeImage;
	non_commercial_splash_array = ((char*) pbmi) + 1024 + 40; // 1024: Palette; 40: BITMAPINFO (header)

	MemDC = CreateCompatibleDC (dc);
	Bitmap = CreateDIBitmap (dc, &(pbmi -> bmiHeader), CBM_INIT, non_commercial_splash_array, pbmi, DIB_RGB_COLORS);
	OldBitmap = (HBITMAP) SelectObject (MemDC, Bitmap);
	GetObject (Bitmap, sizeof (BITMAP), &bm);
	sr.left = (GetSystemMetrics (SM_CXSCREEN) - bm.bmWidth) / 2;
	sr.top = (GetSystemMetrics (SM_CYSCREEN) - bm.bmHeight) / 2;
	sr.right = sr.left + bm.bmWidth;
	sr.bottom = sr.top + bm.bmHeight;
		/* If someone feels like it, they can realize the current palette depending on the palette of the splash... */
	BitBlt (dc, sr.left, sr.top, bm.bmWidth, bm.bmHeight, MemDC, 0, 0, SRCCOPY);
	DeleteObject (SelectObject (MemDC, OldBitmap));
	DeleteDC (MemDC);
	DeleteDC (dc);
	Sleep (2000);
	InvalidateRect (NULL, NULL, TRUE); // Wipe the splash out.

#else
	display_reminder ();
#endif // EIF_WIN32
}
#endif // NON_COMMERCIAL && WORKBENCH

/*
doc:</file>
*/
