<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/error/i18n/inc/model', 'modError') />
		
		<!--- Error ID --->
		<cfset add__attribute(
			attribute = 'errorID'
		) />
		
		<!--- Code --->
		<cfset add__attribute(
			attribute = 'code'
		) />
		
		<!--- Detail --->
		<cfset add__attribute(
			attribute = 'detail'
		) />
		
		<!--- Error Code --->
		<cfset add__attribute(
			attribute = 'errorCode'
		) />
		
		<!--- Message --->
		<cfset add__attribute(
			attribute = 'message'
		) />
		
		<!--- Stack Trace --->
		<cfset add__attribute(
			attribute = 'stackTrace'
		) />
		
		<!--- Type --->
		<cfset add__attribute(
			attribute = 'traceHash'
		) />
		
		<!--- Type --->
		<cfset add__attribute(
			attribute = 'type'
		) />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
