<cfset viewConversation = application.factories.transient.getviewConversationForError( transport ) />

<cfset filter = {
		'isReported' = theURL.search('isReported'),
		'search' = theURL.search('search'),
		'timeframe' = theURL.search('timeframe')
	} />

<cfoutput>
	#viewConversation.filter( filter )#
</cfoutput>