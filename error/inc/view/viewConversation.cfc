<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="list" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset i18n = variables.transport.applicationSingletons.getI18N() />
		<cfset datagrid = variables.transport.applicationTransients.getDatagrid(i18n, variables.transport.locale) />
		
		<cfset datagrid.addColumn({
				key = 'lastLogged',
				label = 'Last Logged'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'numErrors',
				label = 'Count'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'message',
				label = 'Message'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'detail',
				label = 'Details'
			}) />
		
		<cfset datagrid.addColumn({
				key = 'type',
				label = 'Type'
			}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
</cfcomponent>