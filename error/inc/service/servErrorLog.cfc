<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="log" access="public" returntype="void" output="false">
		<cfargument name="exception" type="any" required="true" />
		<cfargument name="eventName" type="string" required="true" />
		
		<cfset var error = '' />
		<cfset var context = '' />
		<cfset var i = '' />
		<cfset var i18n = '' />
		<cfset var locale = '' />
		<cfset var query = '' />
		<cfset var trace = '' />
		
		<!--- Log to the application error log --->
		<cflog application="true" file="errors" text="#arguments.exception.message#|#arguments.exception.detail#" type="error">
		
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset locale = variables.transport.theSession.managers.singleton.getSession().getLocale() />
		
		<cftransaction>
			<cfset error = variables.transport.theApplication.factories.transient.getModErrorForError(i18n, locale) />
			
			<cfset error.setDetail(arguments.exception.detail) />
			<cfset error.setErrorCode(arguments.exception.errorCode) />
			<cfset error.setMessage(arguments.exception.message) />
			<cfset error.setType(arguments.exception.type) />
			<cfset error.setStackTrace(arguments.exception.stackTrace) />
			
			<cfif structKeyExists(arguments.exception, 'code')>
				<cfset error.setCode(arguments.exception.code) />
			</cfif>
			
			<!--- Save to the DB --->
			<cfset error.save(variables.datasource) />
			
			<cfset i = 1 />
			
			<!--- Save the tag context --->
			<cfloop array="#arguments.exception.tagContext#" index="context">
				<cfset trace = variables.transport.theApplication.factories.transient.getModTraceForError(i18n, locale) />
				
				<cfset trace.setErrorID( error.getErrorID() ) />
				<cfset trace.setOrder( i ) />
				
				<cfset trace.setColumn( context.column ) />
				<cfset trace.setLine( context.line ) />
				<cfset trace.setId( context.id ) />
				<cfset trace.setRaw( context.raw_trace ) />
				<cfset trace.setTemplate( context.template ) />
				<cfset trace.setType( context.type ) />
				
				<cfif structKeyExists(context, 'codePrintPlain')>
					<cfset trace.setCode( context.codePrintPlain ) />
				</cfif>
				
				<!--- Save to the DB --->
				<cfset trace.save(variables.datasource) />
				
				<!--- Increment the counter --->
				<cfset i++ />
			</cfloop>
			
			<!--- Test if this is an exception with query info --->
			<cfif structKeyExists(arguments.exception, 'sql')>
				<cfset query = variables.transport.theApplication.factories.transient.getModQueryForError(i18n, locale) />
				
				<cfset query.setErrorID( error.getErrorID() ) />
				<cfset query.setDatasource( arguments.exception.datasource ) />
				<cfset query.setSql( arguments.exception.sql ) />
				
				<!--- Save to the DB --->
				<cfset query.save(variables.datasource) />
			</cfif>
		</cftransaction>
	</cffunction>
</cfcomponent>