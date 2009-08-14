<cfcomponent extends="cf-compendium.inc.resource.application.configure" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var temp = '' />
		
		<!--- Add an error logging singleton --->
		<cfset temp = createObject('component', 'plugins.error.inc.service.servErrorLog').init(variables.datasource, arguments.newApplication.managers.singleton.getI18N()) />
		
		<cfset arguments.newApplication.managers.singleton.setErrorLog(temp) />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- fresh => 0.1.000 --->
		<cfif arguments.installedVersion EQ ''>
			<!--- Setup the Database --->
			<cfswitch expression="#variables.datasource.type#">
				<cfcase value="PostgreSQL">
					<cfset postgreSQL0_1_000() />
				</cfcase>
				<cfdefaultcase>
					<!--- TODO Remove this thow when a later version supports more database types  --->
					<cfthrow message="Database Type Not Supported" detail="The #variables.datasource.type# database type is not currently supported" />
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
	
	<!---
		Configures the database for v0.1.000
	--->
	<cffunction name="postgreSQL0_1_000" access="public" returntype="void" output="false">
		<!---
			SCHEMA
		--->
		
		<!--- Tagger schema --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SCHEMA "#variables.datasource.prefix#error"
				AUTHORIZATION #variables.datasource.owner#;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			COMMENT ON SCHEMA "#variables.datasource.prefix#error" IS 'Error Tracking and Reporting';
		</cfquery>
		
		<!---
			SEQUENCES
		--->
		
		<!--- Error Sequence --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE SEQUENCE "#variables.datasource.prefix#error"."error_errorID_seq"
				INCREMENT 1
				MINVALUE 1
				MAXVALUE 9223372036854775807
				START 1
				CACHE 1;
		</cfquery>
		
		<cfquery datasource="#variables.datasource.name#">
			ALTER TABLE "#variables.datasource.prefix#error"."error_errorID_seq" OWNER TO #variables.datasource.owner#;
		</cfquery>
		
		<!---
			TABLES
		--->
		
		<!--- Error Table --->
		<cfquery datasource="#variables.datasource.name#">
			CREATE TABLE "#variables.datasource.prefix#error".error
			(
				"errorID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#error"."error_errorID_seq"'::regclass),
				"type" character varying(75),
				message character varying(300),
				detail character varying(500),
				code character varying(75),
				"errorCode" character varying(75),
				"stackTrace" text,
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
				"errorID" integer NOT NULL,
				"orderBy" smallint NOT NULL,
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
				"errorID" integer NOT NULL,
				datasource character varying(50) NOT NULL,
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
</cfcomponent>