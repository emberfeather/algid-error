<cfcomponent extends="cf-compendium.inc.resource.base.service" output="false">
	<cffunction name="log" access="public" returntype="void" output="false">
		<cfargument name="exception" type="struct" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<cflog application="true" file="errors" text="#arguments.exception.message#|#arguments.exception.detail#" type="error">
	</cffunction>
</cfcomponent>