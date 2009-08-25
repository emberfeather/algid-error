<cfset viewConversation = application.managers.transient.getviewConversationForError(theURL) />

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.readConversations( filter ) />

<cfoutput>#viewConversation.list( conversations, filter )#</cfoutput>