<cfset viewConversation = views.get('error', 'conversation') />

<cfset filter = {
		'isReported' = theURL.search('isReported'),
		'loggedAfter' = theURL.search('loggedAfter'),
		'loggedBefore' = theURL.search('loggedBefore'),
		'search' = theURL.search('search'),
		'timeframe' = theURL.search('timeframe')
	} />

<cfoutput>
	#viewConversation.filter( filter )#
</cfoutput>