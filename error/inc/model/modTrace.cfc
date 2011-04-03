<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Error ID --->
		<cfset add__attribute(
			attribute = 'errorID'
		) />
		
		<!--- Code --->
		<cfset add__attribute(
			attribute = 'code'
		) />
		
		<!--- Column --->
		<cfset add__attribute(
			attribute = 'column'
		) />
		
		<!--- Line --->
		<cfset add__attribute(
			attribute = 'line'
		) />
		
		<!--- ID --->
		<cfset add__attribute(
			attribute = 'id'
		) />
		
		<!--- Order --->
		<cfset add__attribute(
			attribute = 'order'
		) />
		
		<!--- Raw --->
		<cfset add__attribute(
			attribute = 'raw'
		) />
		
		<!--- Template --->
		<cfset add__attribute(
			attribute = 'template'
		) />
		
		<!--- Type --->
		<cfset add__attribute(
			attribute = 'type'
		) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/error/i18n/inc/model', 'modTrace') />
		
		<cfreturn this />
	</cffunction>
</cfcomponent>
