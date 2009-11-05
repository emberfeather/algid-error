<cfcomponent extends="algid.inc.resource.base.service" output="false">
	<cffunction name="readConversations" access="public" returntype="query" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var results = '' />
		
		<cfquery name="results" datasource="#variables.datasource.name#">
			SELECT COUNT(e."errorID") AS numErrors, MAX(e."loggedOn") AS lastLogged, e.message, e.detail, e.type, e.code, e."errorCode", e."isReported", t.template, t.line, t.column
			FROM "#variables.datasource.prefix#error"."error" AS e
			LEFT JOIN "#variables.datasource.prefix#error"."trace" AS t
				ON e."errorID" = t."errorID"
					AND t."orderBy" = 1
			WHERE 1=1
			
			<cfif structKeyExists(arguments.filter, 'isReported') AND arguments.filter.isReported NEQ ''>
				AND e."isReported" = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.filter.isReported#" />
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'search') AND arguments.filter.search NEQ ''>
				AND (
					"message" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
					OR "detail" LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.filter.search#%" />
				)
			</cfif>
			
			<cfif structKeyExists(arguments.filter, 'timeframe') AND arguments.filter.timeframe NEQ ''>
				AND "loggedOn" >=
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
			
			GROUP BY e.message, e.detail, e.type, e.code, e."errorCode", e."isReported", t.template, t.line, t.column
			ORDER BY lastLogged DESC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>