<cfcomponent extends="algid.inc.resource.base.view" output="false">
	<cffunction name="filterActive" access="public" returntype="string" output="false">
		<cfargument name="filter" type="struct" default="#{}#" />
		
		<cfset var filterActive = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filterActive = variables.transport.theApplication.factories.transient.getFilterActive(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filterActive.addBundle('plugins/error/i18n/inc/view', 'viewConversation') />
		
		<cfreturn filterActive.toHTML(arguments.filter, variables.transport.theRequest.managers.singleton.getURL()) />
	</cffunction>
	
	<cffunction name="filter" access="public" returntype="string" output="false">
		<cfargument name="values" type="struct" default="#{}#" />
		
		<cfset var filter = '' />
		<cfset var options = '' />
		<cfset var results = '' />
		
		<cfset filter = variables.transport.theApplication.factories.transient.getFilterVertical(variables.transport.theApplication.managers.singleton.getI18N()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset filter.addBundle('plugins/error/i18n/inc/view', 'viewConversation') />
		
		<!--- Search --->
		<cfset filter.addFilter('search') />
		
		<!--- Timeframes --->
		<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
		
		<cfset options.addOption('All Available', '') />
		<cfset options.addOption('Past Day', 'day') />
		<cfset options.addOption('Past Week', 'week') />
		<cfset options.addOption('Past Month', 'month') />
		<cfset options.addOption('Past Quarter', 'quarter') />
		<cfset options.addOption('Past Year', 'year') />
		
		<cfset filter.addFilter('timeframe', options) />
		
		<!--- Is Reported --->
		<cfset options = variables.transport.theApplication.factories.transient.getOptions() />
		
		<cfset options.addOption('All', '') />
		<cfset options.addOption('Reported', 'true') />
		<cfset options.addOption('Not Reported', 'false') />
		
		<cfset filter.addFilter('isReported', options) />
		
		<cfreturn filter.toHTML(variables.transport.theRequest.managers.singleton.getURL(), arguments.values) />
	</cffunction>
	
	<cffunction name="datagrid" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset var datagrid = '' />
		<cfset var i18n = '' />
		
		<cfset arguments.options.theURL = variables.transport.theRequest.managers.singleton.getURL() />
		<cfset i18n = variables.transport.theApplication.managers.singleton.getI18N() />
		<cfset datagrid = variables.transport.theApplication.factories.transient.getDatagrid(i18n, variables.transport.theSession.managers.singleton.getSession().getLocale()) />
		
		<!--- Add the resource bundle for the view --->
		<cfset datagrid.addBundle('plugins/error/i18n/inc/view', 'viewConversation') />
		
		<cfset datagrid.addColumn({
			key = 'lastLogged',
			label = 'lastLogged',
			format = {
				datetime: {
					mask: {
						date: 'd mmm yyyy',
						time: 'HH:mm'
					}
				}
			}
		}) />
		
		<cfset datagrid.addColumn({
			key = 'numErrors',
			label = 'count'
		}) />
		
		<cfset datagrid.addColumn({
			key = 'message',
			label = 'message'
		}) />
		
		<cfset datagrid.addColumn({
			key = 'detail',
			label = 'details'
		}) />
		
		<cfset datagrid.addColumn({
			key = 'type',
			label = 'type'
		}) />
		
		<cfreturn datagrid.toHTML( arguments.data, arguments.options ) />
	</cffunction>
	
	<cffunction name="report" access="public" returntype="string" output="false">
		<cfargument name="data" type="any" required="true" />
		<cfargument name="options" type="struct" default="#{}#" />
		
		<cfset local.stats = {
			totalErrors = 0
		} />
		
		<cfloop query="arguments.data">
			<cfset local.stats.totalErrors += arguments.data.numErrors />
		</cfloop>
		
		<cfsavecontent variable="local.html">
			<cfoutput>
				<dl>
					<dt>Error Statistics</dt>
					<dd><strong>#local.stats.totalErrors#</strong> total errors</dd>
					<dd><strong>#arguments.data.recordCount#</strong> distinct errors</dd>
				</dl>
			</cfoutput>
		</cfsavecontent>
		
		<cfreturn local.html />
	</cffunction>
</cfcomponent>