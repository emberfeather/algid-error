<!--- Adds logging for applications --->
<cfcomponent output="false">
	<cffunction name="onError" access="public" returntype="void" output="false">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<cfset var errorLogger = '' />
		
		<!--- Check if we have got far enough for the singletons --->
		<cfif structKeyExists(application, 'singletons') AND NOT variables.isDebugMode>
			<cftry>
				<cfset errorLogger = application.managers.singleton.getErrorLog() />
				
				<cfset errorLogger.log(argumentCollection = arguments) />
				
				<cfcatch type="any">
					<!--- Failed to log error, send report of unlogged error --->
					<!--- TODO Send Unlogged Error --->
				</cfcatch>
			</cftry>
		<cfelse>
			<!--- TODO Remove -- only here to test out error conversations --->
			<cfset errorLogger = application.managers.singleton.getErrorLog() />
			<cfset errorLogger.log(argumentCollection = arguments) />
			
			<!--- Dump out the error --->
			<cfdump var="#arguments.exception#" /><cfabort />
		</cfif>
	</cffunction>
</cfcomponent>