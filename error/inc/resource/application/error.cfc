<!--- Adds logging for applications --->
<cfcomponent output="false">
	<cffunction name="onError" access="public" returntype="void" output="false">
		<cfargument name="exception" type="struct" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<cfset var errorLog = '' />
		
		<!--- Check if we have got far enough for the singletons --->
		<cfif structKeyExists(application, 'singletons') AND NOT variables.isDebugMode>
			<cfset errorLog = application.managers.singleton.getErrorLog() />
			
			<cfset errorLog.log(argumentCollection = arguments) />
		<cfelse>
			<!--- Dump out the error --->
			<cfdump var="#arguments.exception#" /><cfabort />
		</cfif>
	</cffunction>
</cfcomponent>