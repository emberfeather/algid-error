<cfset viewConversation = views.get('error', 'conversation') />

<cfoutput>
	#viewConversation.detailSide( conversation )#
</cfoutput>
