<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="getConversations" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT COUNT(o."occurrenceID") AS numErrors, MAX(o."loggedOn") AS lastLogged, e.message, e.detail, e.type, e.code, e."errorCode", o."isReported", t.template, t.line, t.column
			FROM "#variables.datasource.prefix#error"."error" e
			JOIN "#variables.datasource.prefix#error"."occurrence" o
				ON e."errorID" = o."errorID"
			JOIN "#variables.datasource.prefix#error"."trace" t
				ON e."errorID" = t."errorID"
					AND t."orderBy" = 1
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'isReported') and arguments.filter.isReported neq ''>
				AND o."isReported" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.filter.isReported#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') and arguments.filter.search neq ''>
				AND (
					"message" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					or "detail" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'timeframe') and arguments.filter.timeframe neq ''>
				AND o."loggedOn" >=
				<cfswitch expression="#arguments.filter.timeframe#">
					<cfcase value="day">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('d', -1, now())#" />
					</cfcase>
					<cfcase value="week">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('ww', -1, now())#" />
					</cfcase>
					<cfcase value="month">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m', -1, now())#" />
					</cfcase>
					<cfcase value="quarter">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('m', -3, now())#" />
					</cfcase>
					<cfcase value="year">
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateAdd('yyyy', -1, now())#" />
					</cfcase>
				</cfswitch>
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'loggedAfter') and isDate(arguments.filter.loggedAfter)>
				AND o."loggedOn" >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.loggedAfter#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'loggedBefore') and isDate(arguments.filter.loggedBefore)>
				AND o."loggedOn" <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.loggedBefore#" />
			</cfif>
			
			GROUP BY e.message, e.detail, e.type, e.code, e."errorCode", o."isReported", t.template, t.line, t.column
			ORDER BY lastLogged DESC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
	
	<cffunction name="reportConversations" access="public" returntype="void" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfquery datasource="#variables.datasource.name#">
			UPDATE "#variables.datasource.prefix#error"."occurrence"
			SET "isReported" = <cfqueryparam cfsqltype="cf_sql_bit" value="true" />
			
			WHERE "isReported" = <cfqueryparam cfsqltype="cf_sql_bit" value="false" />
			
			<cfif structKeyExists(arguments.filter, 'loggedAfter') and arguments.filter.loggedAfter neq ''>
				AND "loggedOn" >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.loggedAfter#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'loggedBefore') and arguments.filter.loggedBefore neq ''>
				AND "loggedOn" <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.filter.loggedBefore#" />
			</cfif>
		</cfquery>
	</cffunction>
</cfcomponent>