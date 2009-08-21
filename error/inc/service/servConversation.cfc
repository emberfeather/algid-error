<cfcomponent extends="cf-compendium.inc.resource.base.service" output="false">
	<cffunction name="getConversations" access="public" returntype="query" output="false">
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
				AND e."isReported" = <cfif arguments.filter.isReported>B'1'<cfelse>B'0'</cfif>
			</cfif>
			
			GROUP BY e.message, e.detail, e.type, e.code, e."errorCode", e."isReported", t.template, t.line, t.column
			ORDER BY lastLogged DESC
		</cfquery>
		
		<cfreturn results />
	</cffunction>
</cfcomponent>