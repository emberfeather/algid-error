<cfset viewConversation = createObject('component', 'plugins.error.inc.view.viewConversation').init(theURL) />

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.readConversations( filter ) />

<cfoutput>#viewConversation.list( conversations, filter )#</cfoutput>