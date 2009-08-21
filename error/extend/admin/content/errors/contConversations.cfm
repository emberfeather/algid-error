<cfset viewConversation = createObject('component', 'plugins.error.inc.view.viewConversation').init(theURL) />

<h2>Unreported Errors</h2>

<cfset filter = {
		isReported = 0
	} />

<cfset conversations = servConversation.getConversations( filter ) />

<cfoutput>#viewConversation.listConversations( conversations )#</cfoutput>