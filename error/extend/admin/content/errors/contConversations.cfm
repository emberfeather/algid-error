<cfset viewConversation = createObject('component', 'plugins.error.inc.view.viewConversation').init(theURL) />

<h3>Unreported Errors</h3>

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.getConversations( filter ) />

<cfoutput>#viewConversation.list( conversations, filter )#</cfoutput>