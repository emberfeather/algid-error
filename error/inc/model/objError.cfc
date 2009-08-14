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
		
		<!--- Detail --->
		<cfset attr = {
				attribute = 'detail'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Error Code --->
		<cfset attr = {
				attribute = 'errorCode'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Message --->
		<cfset attr = {
				attribute = 'message'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Stack Trace --->
		<cfset attr = {
				attribute = 'stackTrace'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Type --->
		<cfset attr = {
				attribute = 'type'
			} />
		
		<cfset addAttribute(argumentCollection = attr) />
		
		<!--- Set the bundle information for translation --->
		<cfset setI18NBundle('plugins/error/i18n/inc/model', 'objError') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="load" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#arguments.datasource.name#">
			SELECT type, message, detail, code, errorCode, stackTrace
			FROM "#arguments.datasource.prefix#error".error
			WHERE errorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.filter.errorID#" />
		</cfquery>
		
		<cfif results.recordCount>
			<cfset this.setErrorID(results.errorID) />
			<cfset this.setMessage(results.message) />
			<cfset this.setDetail(results.detail) />
			<cfset this.setCode(results.code) />
			<cfset this.setErrorCode(results.errorCode) />
			<cfset this.setStackTrace(results.stackTrace) />
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		
		<cfif this.getErrorID() EQ ''>
			<cfquery datasource="#arguments.datasource.name#">
				INSERT INTO "#arguments.datasource.prefix#error".error
				(
					type,
					message,
					detail,
					code,
					"errorCode",
					"stackTrace"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getType()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#" maxlength="300" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDetail()#" maxlength="300" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCode()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getErrorCode()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getStackTrace()#" />
				)
			</cfquery>
			
			<cfquery name="results" datasource="#arguments.datasource.name#">
				SELECT MAX("errorID") AS newID
				FROM "#arguments.datasource.prefix#error".error
				WHERE message = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#" maxlength="300" />
			</cfquery>
			
			<cfset this.setErrorID(results.newID) />
		<cfelse>
			<cfquery datasource="#arguments.datasource.name#">
				UPDATE "#arguments.datasource.prefix#error".error
				SET
					type = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getType()#" maxlength="75" />,
					message = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#" maxlength="300" />,
					detail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDetail()#" maxlength="300" />,
					code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCode()#" maxlength="75" />,
					errorCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getErrorCode()#" maxlength="75" />,
					stackTrace = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getStackTrace()#" />
				WHERE errorID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getErrorID()#" />
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>