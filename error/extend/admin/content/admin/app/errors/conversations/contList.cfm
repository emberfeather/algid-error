<cfset conversations = servConversation.getConversations( filter ) />

<cfset paginate = variables.transport.theApplication.factories.transient.getPaginate(conversations.recordcount, session.numPerPage, theURL.searchID('onPage')) />

<cfoutput>#viewMaster.datagrid(transport, conversations, viewConversation, paginate, filter)#</cfoutput>
