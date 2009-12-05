<cfcomponent extends="algid.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Error ID --->
		<cfset addAttribute(
				attribute = 'errorID'
			) />
		
		<!--- Code --->
		<cfset addAttribute(
				attribute = 'code'
			) />
		
		<!--- Column --->
		<cfset addAttribute(
				attribute = 'column'
			) />
		
		<!--- Line --->
		<cfset addAttribute(
				attribute = 'line'
			) />
		
		<!--- ID --->
		<cfset addAttribute(
				attribute = 'id'
			) />
		
		<!--- Order --->
		<cfset addAttribute(
				attribute = 'order'
			) />
		
		<!--- Raw --->
		<cfset addAttribute(
				attribute = 'raw'
			) />
		
		<!--- Template --->
		<cfset addAttribute(
				attribute = 'template'
			) />
		
		<!--- Type --->
		<cfset addAttribute(
				attribute = 'type'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/error/i18n/inc/model', 'modTrace') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="load" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#arguments.datasource.name#">
			SELECT "errorID", "orderBy", "raw", "template", "type", "line", "column", "id", "code"
			FROM "#arguments.datasource.prefix#error".trace
			WHERE errorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.errorID#" />
				AND orderBy = <cfqueryparam cfsqltype="cf_sql_smallint" value="#arguments.filter.order#" />
		</cfquery>
		
		<cfif results.recordCount>
			<cfset this.setErrorID(results.errorID) />
			<cfset this.setOrder(results.orderBy) />
			<cfset this.setRaw(results.raw) />
			<cfset this.setTemplate(results.template) />
			<cfset this.setType(results.type) />
			<cfset this.setLine(results.line) />
			<cfset this.setColumn(results.column) />
			<cfset this.setID(results.id) />
			<cfset this.setCode(results.code) />
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		
		<!--- For insert only! --->
		<cfquery datasource="#arguments.datasource.name#">
			INSERT INTO "#arguments.datasource.prefix#error".trace
			(
				"errorID",
				"orderBy",
				"raw",
				"template",
				"type",
				"line",
				"column",
				"id",
				"code"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getErrorID()#" />,
				<cfqueryparam cfsqltype="cf_sql_smallint" value="#this.getOrder()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getRaw()#" maxlength="350" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getTemplate()#" maxlength="350" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getType()#" maxlength="15" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getLine()#" />,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getColumn()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getID()#" maxlength="25" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCode()#" maxlength="500" />
			)
		</cfquery>
	</cffunction>
</cfcomponent>