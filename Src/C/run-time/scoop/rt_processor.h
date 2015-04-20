/*
	description:	"SCOOP support."
	date:		"$Date$"
	revision:	"$Revision: 96304 $"
	copyright:	"Copyright (c) 2010-2012, Eiffel Software.",
				"Copyright (c) 2014 Scott West <scott.gregory.west@gmail.com>"
	license:	"GPL version 2 see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"Commercial license is available at http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Runtime.

			Eiffel Software's Runtime is free software; you can
			redistribute it and/or modify it under the terms of the
			GNU General Public License as published by the Free
			Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).

			Eiffel Software's Runtime is distributed in the hope
			that it will be useful,	but WITHOUT ANY WARRANTY;
			without even the implied warranty of MERCHANTABILITY
			or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.

			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Runtime; if not,
			write to the Free Software Foundation, Inc.,
			51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
*/

#ifndef _rt_processor_h_
#define _rt_processor_h_

#include "rt_private_queue.h"
#include "rt_request_group.h"
#include "rt_queue_cache.h"

#include "rt_vector.h"

/* Define the struct to be used for the group stack. */
RT_DECLARE_VECTOR_BASE (request_group_stack_t, struct rt_request_group)

/* Define the vector to be used for wait condition subscribers. */
RT_DECLARE_VECTOR_BASE (subscriber_list_t, struct rt_processor*)

/* Define the vector to be used for keeping track of private queues of this processor. */
RT_DECLARE_VECTOR_BASE (private_queue_list_t, struct rt_private_queue*)

/*
doc:	<struct name="rt_processor" export="shared">
doc:		<summary> The SCOOP logical unit of processing.
doc:
doc:			The processor is responsible for receiving calls, executing them,
doc: 			and notifying clients of possible changes to wait conditions.
doc:		</summary>
doc:		<field name="cache" type="struct queue_cache"> A cache of private queues to other processors. These are used to log calls when the current processor is a client. </field>
doc:		<field name="queue_of_queues" type="struct rt_message_channel"> The queue of queues of this processors.
doc:			This will be used by client processors to add new private queues for this processor to work on.
doc:			Clients can only send SCOOP_MESSAGE_ADD_QUEUE on this channel, and the GC can only send SCOOP_MESSAGE_SHUTDOWN.
doc:			NOTE: Clients must synchronize access to this field with the queue_of_queues_mutex, as the message channel struct is not safe to be used by multiple senders. </field>
doc:		<field name="queue_of_queues_mutex", type="EIF_MUTEX_TYPE*"> The mutex used to protect the queue_of_queues field. </field>
doc:		<field name="result_notify" type="struct rt_message_channel"> A notification channel for the processor to wait on when it waits for the result of a synchronous call. </field>
doc:		<field name="startup_notify" type="struct rt_message_channel"> A notification channel to inform the constructing thread that the new processor has successfully spawned. </field>

doc:		<field name="wait_condition" type="EIF_COND_TYPE*"> A condition variable for wait condition change signalling.
doc:			The client (the current processor) will wait on this CV, whereas any suppliers will send signals to it. </field>
doc:		<field name="wait_condition_mutex" type="EIF_MUTEX_TYPE*"> The mutex used in conjunction with the wait_condition CV. </field>
doc:		<field name="wait_condition_subscribers" type="struct subscriber_list_t (a vector of struct rt_processor*)"> The list of clients that registered for a wait condition change signal. </field>

doc:		<field name="request_group_stack" type="struct request_group_stack_t (a vector of struct rt_request_group)">
doc:			A stack of request groups for this processor. The stack mirrors the processors locked in the real call stack. </field>
doc:		<field name="generated_private_queues" type="struct private_queue_list_t (a vector of struct rt_private_queue*)">
doc:			The queues generated by this processor (i.e. with the current processor as the queue's supplier). Each processor is responsible for 'his' queues during GC and cleanup. </field>
doc:		<field name="generated_private_queues_mutex" type="EIF_MUTEX_TYPE*"> The mutex used to protect the generated_private_queues vector. This is necessary because many clients may access the vector to create new queues. </field>

doc:		<field name="current_msg" type="struct rt_message"> The call that this processor is currently working on. This will be traced during GC marking. </field>
doc:		<field name="pid" type="EIF_SCP_PID"> The unique logical ID of the current processor. </field>
doc:		<field name="has_client" type="EIF_BOOLEAN"> Stores whether the processor has a client. This is used to prevent that an active processor, that may not have any references to it, is collected during GC. </field>
doc:		<field name="is_creation_procedure_logged" type="EIF_BOOLEAN"> Stores whether the creation procedure of the root object has already been logged. </field>
doc:		<field name="is_dirty" type="EIF_BOOLEAN">  Stores whether the current processor is marked as dirty (i.e. if it has encountered an exception). </field>

doc:		<fixme> There are several items to be fixed:
doc:			* For passive processors, it would make sense to split rt_processor into two structs for regions and processors.
doc:			* One could think about finding a way to replace startup_notify with something more lightweight, as it's only used once in a processor's lifecycle.
doc:			* The features used for wait condition notification could be moved into their own C file.
doc:			* It would be nice if the processor struct could be moved from the header to the source file, to enable true information hiding.
doc:		</fixme>
doc:	</struct>
*/
struct rt_processor {
	struct queue_cache cache;

	struct rt_message_channel queue_of_queues;
	EIF_MUTEX_TYPE* queue_of_queues_mutex;

	struct rt_message_channel result_notify;
	struct rt_message_channel startup_notify;

	EIF_MUTEX_TYPE* wait_condition_mutex;
	EIF_COND_TYPE* wait_condition;
	struct subscriber_list_t wait_condition_subscribers;

	struct request_group_stack_t request_group_stack;
	struct private_queue_list_t generated_private_queues;
	EIF_MUTEX_TYPE* generated_private_queues_mutex;

	struct rt_message current_msg;
	EIF_SCP_PID pid;
	EIF_BOOLEAN has_client;
	volatile EIF_BOOLEAN is_creation_procedure_logged;
	EIF_BOOLEAN is_dirty;
};

typedef struct rt_processor processor; /* TODO: Get rid of this typedef. */

/* Creation and destruction. */
rt_shared int rt_processor_create (EIF_SCP_PID a_pid, EIF_BOOLEAN is_root_processor, processor** result);
rt_shared void rt_processor_destroy (processor* self);
rt_shared void rt_processor_mark (processor* self, MARKER marking);

/* Thread spawning and teardown. */
rt_shared void rt_processor_shutdown (processor* self);

/* Wait condition subscription management. */
rt_shared void rt_processor_subscribe_wait_condition (processor* self, processor* client);
rt_shared void rt_processor_unsubscribe_wait_condition (processor* self, processor* dead_processor);

/* Declarations for group stack manipulation. */
rt_shared void rt_processor_request_group_stack_extend (processor* self);
rt_shared struct rt_request_group* rt_processor_request_group_stack_last (processor* self);
rt_shared void rt_processor_request_group_stack_remove_last (processor* self);

/* Features executed by the processor itself. */
rt_shared void rt_processor_execute_call (processor* self, processor* client, struct call_data* call);
rt_shared void rt_processor_application_loop (processor* self);

/* Utility functions. */
int rt_processor_new_private_queue (processor* self, struct rt_private_queue** result);

#endif /* _rt_processor_h_ */
