<cfcomponent extends="cf-compendium.inc.resource.base.service" output="false">
	<cffunction name="log" access="public" returntype="void" output="false">
		<cfargument name="exception" type="struct" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<!--- Log to the application error log --->
		<cflog application="true" file="errors" text="#arguments.exception.message#|#arguments.exception.detail#" type="error">
		
		<cftransaction>
			<!--- TODO Insert the error into the DB --->
			
			<!--- TODO Insert the trace context into the DB --->
			
			<!--- TODO Insert the SQL information into the DB --->
		</cftransaction>
	</cffunction>
</cfcomponent>