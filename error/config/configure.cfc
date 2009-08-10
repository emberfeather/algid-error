<cfcomponent extends="cf-compendium.inc.resource.application.configure" output="false">
	<cffunction name="configure" access="public" returntype="void" output="false">
		<cfargument name="newApplication" type="struct" required="true" />
		
		<cfset var datasource = '' />
		<cfset var temp = '' />
		
		<!--- Add an error logging singleton --->
		<cfset temp = createObject('component', 'plugins.error.inc.service.servErrorLog').init(variables.datasource) />
		
		<cfset arguments.newapplication.managers.singleton.setErrorLog(temp) />
	</cffunction>
	
	<cffunction name="update" access="public" returntype="void" output="false">
		<cfargument name="plugin" type="struct" required="true" />
		<cfargument name="installedVersion" type="string" default="" />
		
		<!--- fresh => 0.1.0 --->
		<cfif arguments.installedVersion EQ ''>
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
			
			<!--- Note Sequence --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE SEQUENCE "#variables.datasource.prefix#error"."notes_noteID_seq"
					INCREMENT 1
					MINVALUE 1
					MAXVALUE 9223372036854775807
					START 1
					CACHE 1;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error"."notes_noteID_seq" OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<!---	Sequence --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE SEQUENCE "#variables.datasource.prefix#error"."resolution_resolutionID_seq"
					INCREMENT 1
					MINVALUE 1
					MAXVALUE 9223372036854775807
					START 1
					CACHE 1;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error"."resolution_resolutionID_seq" OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<!--- Status Sequence --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE SEQUENCE "#variables.datasource.prefix#error"."status_statusID_seq"
					INCREMENT 1
					MINVALUE 1
					MAXVALUE 9223372036854775807
					START 1
					CACHE 1;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error"."status_statusID_seq" OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<!---
				TABLES
			--->
			
			<!--- Status Table --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE TABLE "#variables.datasource.prefix#error".status
				(
					"statusID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#error"."status_statusID_seq"'::regclass),
					"status" character varying(50) NOT NULL,
					"isClosed" bit(1) NOT NULL DEFAULT B'0'::"bit",
					CONSTRAINT "status_PK" PRIMARY KEY ("statusID")
				)
				WITH (OIDS=FALSE);
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error".status OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				COMMENT ON TABLE "#variables.datasource.prefix#error".status IS 'Error Resolution Status';
			</cfquery>
			
			<!--- Resolution Table --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE TABLE "#variables.datasource.prefix#error".resolution
				(
					"resolutionID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#error"."resolution_resolutionID_seq"'::regclass),
					"statusID" integer NOT NULL,
					CONSTRAINT "resolution_PK" PRIMARY KEY ("resolutionID"),
					CONSTRAINT "resolution_statusID_FK" FOREIGN KEY ("resolutionID")
						REFERENCES "#variables.datasource.prefix#error".resolution ("resolutionID") MATCH SIMPLE
						ON UPDATE NO ACTION ON DELETE NO ACTION
				)
				WITH (OIDS=FALSE);
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error".resolution OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				COMMENT ON TABLE "#variables.datasource.prefix#error".resolution IS 'Error Resolutions.';
			</cfquery>
			
			<!--- Error Table --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE TABLE "#variables.datasource.prefix#error".error
				(
					"errorID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#error"."error_errorID_seq"'::regclass),
					"resolutionID" integer,
					"type" character varying(300),
					message character varying(300),
					detail character varying(500),
					code character varying(75),
					"errorCode" character varying(75),
					CONSTRAINT "error_PK" PRIMARY KEY ("errorID"),
					CONSTRAINT "error_resolutionID_FK" FOREIGN KEY ("resolutionID")
						REFERENCES "#variables.datasource.prefix#error".resolution ("resolutionID") MATCH SIMPLE
						ON UPDATE NO ACTION ON DELETE NO ACTION
				)
				WITH (OIDS=FALSE);
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error".error OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				COMMENT ON TABLE "#variables.datasource.prefix#error".error IS 'Error logging for the application.';
			</cfquery>
			
			<!--- Notes Table --->
			<cfquery datasource="#variables.datasource.name#">
				CREATE TABLE "#variables.datasource.prefix#error".notes
				(
					"noteID" integer NOT NULL DEFAULT nextval('"#variables.datasource.prefix#error"."notes_noteID_seq"'::regclass),
					"resolutionID" integer NOT NULL,
					"userID" integer NOT NULL,
					"statusID" integer NOT NULL,
					"createdOn" timestamp without time zone,
					note text,
					CONSTRAINT "note_PK" PRIMARY KEY ("noteID"),
					CONSTRAINT "note_resolutionID_FK" FOREIGN KEY ("resolutionID")
						REFERENCES "#variables.datasource.prefix#error".resolution ("resolutionID") MATCH SIMPLE
						ON UPDATE CASCADE ON DELETE CASCADE,
					CONSTRAINT "note_userID_FK" FOREIGN KEY ("userID")
						REFERENCES "#variables.datasource.prefix#user"."user" ("userID") MATCH SIMPLE
						ON UPDATE NO ACTION ON DELETE NO ACTION,
					CONSTRAINT "notes_statusID_FK" FOREIGN KEY ("statusID")
						REFERENCES "#variables.datasource.prefix#error".status ("statusID") MATCH SIMPLE
						ON UPDATE NO ACTION ON DELETE NO ACTION
				)
				WITH (OIDS=FALSE);
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				ALTER TABLE "#variables.datasource.prefix#error".notes OWNER TO #variables.datasource.owner#;
			</cfquery>
			
			<cfquery datasource="#variables.datasource.name#">
				COMMENT ON TABLE "#variables.datasource.prefix#error".notes IS 'Error Resolution Notes';
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
		</cfif>
	</cffunction>
</cfcomponent>