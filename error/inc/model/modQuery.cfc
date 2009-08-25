<cfcomponent extends="algid.inc.resource.base.model" output="false">
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
		
		<!--- Datasource --->
		<cfset attr = {
				attribute = 'datasource'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- SQL --->
		<cfset attr = {
				attribute = 'sql'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/error/i18n/inc/model', 'objQuery') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="load" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#arguments.datasource.name#">
			SELECT "errorID", "datasource", "sql"
			FROM "#arguments.datasource.prefix#error".query
			WHERE errorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.errorID#" />
		</cfquery>
		
		<cfif results.recordCount>
			<cfset this.setErrorID(results.errorID) />
			<cfset this.setDatasource(results.datasource) />
			<cfset this.setSql(results.sql) />
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		
		<!--- For insert only! --->
		<cfquery datasource="#arguments.datasource.name#">
			INSERT INTO "#arguments.datasource.prefix#error".query
			(
				"errorID",
				"datasource",
				"sql"
			) VALUES (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getErrorID()#" />,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDatasource()#" maxlength="50" />,
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getSQL()#" />
			)
		</cfquery>
	</cffunction>
</cfcomponent>