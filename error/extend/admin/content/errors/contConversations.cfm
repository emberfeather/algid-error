<cfset viewConversation = application.factories.transient.getviewConversationForError( transport ) />

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.readConversations( filter ) />

<cfoutput>#viewConversation.list( conversations )#</cfoutput>