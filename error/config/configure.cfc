<cfcomponent extends="algid.inc.resource.plugin.configure" output="false">
	<cffunction name="onApplicationStart" access="public" returntype="void" output="false">
		<cfargument name="theApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Add an error logging singleton --->
		<cfset temp = arguments.theApplication.factories.transient.getServErrorLogForError(variables.datasource, arguments.theApplication.managers.singleton.getI18N()) />
		
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
	</cffunction>
	
	<!---
		Configures the database for v0.1.0
	--->
	<cffunction name="postgreSQL0_1_0" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Tagger schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#error"
				AUTHorIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#error" IS 'Error Tracking and Reporting';
		</cfquery>
		
		<!---
			SeqUENCES
		--->
		
		<!--- Error Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SeqUENCE "#variables.datasource.prefix#error"."error_errorID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#error"."error_errorID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Error Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".error
			(
				"errorID" integer not NULL DEFAUlt nextval('"#variables.datasource.prefix#error"."error_errorID_seq"'::regclass),
				"loggedOn" timestamp without time zone DEFAUlt now(),
				"type" character varying(75),
				message character varying(300),
				detail character varying(500),
				code character varying(75),
				"errorCode" character varying(75),
				"stackTrace" text,
				"isReported" boolean not NULL DEFAUlt false,
				CONSTRAINT "error_PK" PRIMARY KEY ("errorID")
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#error".error OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".error IS 'Error logging for the application.';
		</cfquery>
		
		<!--- Trace Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".trace
			(
				"errorID" integer not NULL,
				"orderBy" smallint not NULL,
				"raw" character varying(350),
				"template" character varying(350),
				"type" character varying(15),
				line integer,
				"column" integer,
				"id" character varying(25),
				code character varying(500),
				CONSTRAINT "trace_PK" PRIMARY KEY ("errorID", "orderBy"),
				CONSTRAINT "trace_errorID_FK" ForEIGN KEY ("errorID")
					REFERENCES "#variables.datasource.prefix#error".error ("errorID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#error".trace OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".trace IS 'Error Trace Information';
		</cfquery>
		
		<!--- Query Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".query
			(
				"errorID" integer not NULL,
				datasource character varying(50) not NULL,
				sql text,
				CONSTRAINT "query_errorID_PK" PRIMARY KEY ("errorID"),
				CONSTRAINT "query_errorID_FK" ForEIGN KEY ("errorID")
					REFERENCES "#variables.datasource.prefix#error".error ("errorID") MATCH SIMPLE
					ON UPDATE CASCADE ON DELETE CASCADE
			)
			WITH (OIDS=FALSE);
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			AlteR TABLE "#variables.datasource.prefix#error".query OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON TABLE "#variables.datasource.prefix#error".query IS 'Query meta data from Errors.';
		</cfquery>
	</cffunction>
</cfcomponent>