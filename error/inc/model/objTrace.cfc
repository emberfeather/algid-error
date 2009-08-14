<cfcomponent extends="cf-compendium.inc.resource.base.model" output="false">
	<cffunction name="init" access="public" returntype="component" output="false">
		<cfargument name="i18n" type="component" required="true" />
		<cfargument name="locale" type="string" default="en_US" />
		
		<cfset var attr = '' />
		
		<cfset super.init(arguments.i18n, arguments.locale) />
		
		<!--- Error ID --->
		<cfset attr = {
				attribute = 'errorID'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Code --->
		<cfset attr = {
				attribute = 'code'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Column --->
		<cfset attr = {
				attribute = 'column'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Line --->
		<cfset attr = {
				attribute = 'line'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- ID --->
		<cfset attr = {
				attribute = 'id'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Order --->
		<cfset attr = {
				attribute = 'order'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Raw --->
		<cfset attr = {
				attribute = 'raw'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Template --->
		<cfset attr = {
				attribute = 'template'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Type --->
		<cfset attr = {
				attribute = 'type'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/error/i18n/inc/model', 'objTrace') />
		
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