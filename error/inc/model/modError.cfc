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
				attribute = 'type'
			) />
		
		<!--- Set the bundle information for translation --->
		<cfset add__bundle('plugins/error/i18n/inc/model', 'modError') />
		
		<cfreturn this />
	</cffunction>
	
	<cffunction name="load" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		<cfargument name="filter" type="struct" required="true" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#arguments.datasource.name#">
			SELECT type, message, detail, code, errorCode, stackTrace
			FROM "#arguments.datasource.prefix#error".error
			WHERE errorID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter.errorID#" />::uuid
		</cfquery>
		
		<cfif results.recordCount>
			<cfset this.setErrorID(results.errorID.toString()) />
			<cfset this.setMessage(results.message) />
			<cfset this.setDetail(results.detail) />
			<cfset this.setCode(results.code) />
			<cfset this.setErrorCode(results.errorCode) />
			<cfset this.setStackTrace(results.stackTrace) />
		</cfif>
	</cffunction>
	
	<cffunction name="save" access="public" returntype="void" output="false">
		<cfargument name="datasource" type="struct" required="true" />
		
		<cfset var results = '' />
		
		<cfif this.getErrorID() eq ''>
			<!--- Create the new ID --->
			<cfset this.setErrorID( createUUID() ) />
			
			<cfquery datasource="#arguments.datasource.name#">
				INSERT INTO "#arguments.datasource.prefix#error".error
				(
					"errorID",
					type,
					message,
					detail,
					code,
					"errorCode",
					"stackTrace"
				) VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getErrorID()#" />::uuid,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getType()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getMessage()#" maxlength="300" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDetail()#" maxlength="300" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCode()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getErrorCode()#" maxlength="75" />,
					<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getStackTrace()#" />
				)
			</cfquery>
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
				WHERE errorID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getErrorID()#" />::uuid
			</cfquery>
		</cfif>
	</cffunction>
</cfcomponent>