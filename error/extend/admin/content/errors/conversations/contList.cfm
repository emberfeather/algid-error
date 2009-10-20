<cfset viewConversation = application.factories.transient.getViewConversationForError( transport ) />

<cfset filter = {
	} />

<cfset conversations = servConversation.readConversations( filter ) />

<cfoutput>#viewConversation.list( conversations )#</cfoutput>

<p>
	List the conversations starting with the most recent. Separate the
	ones that have not been sent out as part of the normal notification
	yet.
</p>