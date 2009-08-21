<cfset viewConversation = createObject('component', 'plugins.error.inc.view.viewConversation').init(theURL) />

<cfset filter = {
		
	} />

<cfset conversations = servConversation.getConversations( filter ) />

<cfoutput>#viewConversation.listConversations( conversations )#</cfoutput>

<p>
	List the conversations starting with the most recent. Separate the
	ones that have not been sent out as part of the normal notification
	yet.
</p>