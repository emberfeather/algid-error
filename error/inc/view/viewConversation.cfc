<cfcomponent extends="cf-compendium.inc.resource.base.view" output="false">
	<cffunction name="listConversations" access="public" returntype="string" output="false">
		<cfargument name="conversations" type="query" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var html = '' />
		
		<!--- TODO Use the datagrid --->
		
		<!--- TODO Remove --->
		<cfsavecontent variable="html">
			<cfdump var="#arguments.conversations#" />
		</cfsavecontent>
		
		<cfreturn html />
	</cffunction>
</cfcomponent>