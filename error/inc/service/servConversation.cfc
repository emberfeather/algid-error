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
			
			<cfif structKeyExists(arguments.filter, 'isReported')>
				AND e."isReported" = B'#(arguments.filter.isReported ? 1 : 0)#'
			</cfif>
			
			GROUP BY e.message, e.detail, e.type, e.code, e."errorCode", e."isReported", t.template, t.line, t.column
			ORDER BY lastLogged DESC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>