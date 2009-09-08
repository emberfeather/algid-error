<cfset viewConversation = application.factories.transient.getviewConversationForError(theURL) />

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.readConversations( filter ) />

<cfoutput>#viewConversation.list( conversations, filter )#</cfoutput>