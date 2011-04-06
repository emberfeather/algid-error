<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/error/i18n/inc/model', 'modOccurrence') />
		
		<!--- Error ID --->
		<cfset add__attribute(
			attribute = 'errorID'
		) />
		
		<!--- Is Reported ? --->
		<cfset add__attribute(
			attribute = 'isReported'
		) />
		
		<!--- Logged On --->
		<cfset add__attribute(
			attribute = 'loggedOn'
		) />
		
		<!--- Occurrence ID --->
		<cfset add__attribute(
			attribute = 'occurrenceID'
		) />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
