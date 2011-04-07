<!--- Redirect until a good reason for this page exists --->
<cfif theUrl.search('conversation') eq ''>
	<cfset theURL.setRedirect('_base', '/admin/app/errors/conversation/list') />
	<cfset theURL.redirectRedirect() />
</cfif>

<cfset servConversation = services.get('error', 'conversation') />

<!--- Retrieve the object --->
<cfset conversation = servConversation.getConversation( theURL.search('conversation') ) />

<!--- Add to the current levels --->
<cfset template.addLevel(conversation.getMessage(), conversation.getMessage(), theUrl.get(), 0, true) />
