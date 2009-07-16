<cfcomponent extends="cf-compendium.inc.resource.application.configure" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var datasource = '' />
		<cfset var temp = '' />
		
		<!--- Find the datasource --->
		<cfset datasource = arguments.newapplication.managers.singleton.getDatasource() />
		
		<!--- Add an error logging singleton --->
		<cfset temp = createObject('component', 'plugins.error.inc.service.servErrorLog').init(datasource) />
		
		<cfset arguments.newapplication.managers.singleton.setErrorLog(temp) />
	</cffunction>
</cfcomponent>