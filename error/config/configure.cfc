<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="onApplicationStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Add an error logging singleton --->
		<cfset temp = arguments.theApplication.factories.transient.getServErrorLogForError({ theApplication = arguments.theApplication }) />
		
		<cfset arguments.theApplication.managers.singleton.setErrorLog(temp) />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<cfset var versions = createObject('component', 'algid.inc.resource.utility.version').init() />
		
		<!--- fresh => 0.1.0 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.0') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_0() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
		
		<!--- => 0.1.5 --->
		<cfif versions.compareVersions(arguments.installedVersion, '0.1.5') lt 0>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_5() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Error schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#error"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#error" IS 'Error Tracking and Reporting';
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Error Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".error
			(
				"errorID" uuid NOT NULL,
				"loggedOn" timestamp without time zone DEFAULT now(),
				"type" character varying(75),
				message character varying(300),
				detail character varying(500),
				code character varying(75),
				"errorCode" character varying(75),
				"stackTrace" text,
				"isReported" boolean not NULL DEFAULT false,
				CONSTRAINT "error_PK" PRIMARY KEY ("errorID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#error".error OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".error IS 'Error logging for the application.';
		</cfquery>
		
		<!--- Trace Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".trace
			(
				"errorID" uuid NOT NULL,
				"orderBy" smallint not NULL,
				"raw" character varying(350),
				"template" character varying(350),
				"type" character varying(15),
				line integer,
				"column" integer,
				"id" character varying(25),
				code character varying(500),
				CONSTRAINT "trace_PK" PRIMARY KEY ("errorID", "orderBy"),
				CONSTRAINT "trace_errorID_FK" FOREIGN KEY ("errorID")
					REFERENCES "#variables.datasource.prefix#error".error ("errorID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#error".trace OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".trace IS 'Error Trace Information';
		</cfquery>
		
		<!--- Query Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".query
			(
				"errorID" uuid NOT NULL,
				datasource character varying(50) not NULL,
				sql text,
				CONSTRAINT "query_errorID_PK" PRIMARY KEY ("errorID"),
				CONSTRAINT "query_errorID_FK" FOREIGN KEY ("errorID")
					REFERENCES "#variables.datasource.prefix#error".error ("errorID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#error".query OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".query IS 'Query meta data from Errors.';
		</cfquery>
	</cffunction>
	
	<!---
		Configures the database for v0.1.5
	--->
	<cffunction name="postgreSQL0_1_5" access="public" returntype="void" output="false">
		<!---
			TABLES
		--->
		
		<!--- Error table --->
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#error".error
				ADD COLUMN "traceHash" character varying(40);
		</cfquery>
		
		<!---
			INDEXES
		--->
		
		<!--- Error table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE INDEX "error_traceHash_index"
				ON "#variables.datasource.prefix#error".error ("traceHash" ASC NULLS LAST);
		</cfquery>
	</cffunction>
</cfcomponent>
