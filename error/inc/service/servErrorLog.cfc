component extends="algid.inc.resource.base.service" {
	public void function log(required any exception, string eventName = '') {
		if(variables.transport.theApplication.managers.singleton.getApplication().isDevelopment()) {
			//writeDump(arguments.exception);
			//abort;
		}
		
		local.observer = getPluginObserver('error', 'errorLog');
		
		local.observer.beforeLog(argumentCollection = arguments);
		
		// Log to the application error log
		writeLog(application="true", file="errors", text="#arguments.exception.message#|#arguments.exception.detail#", type="error");
		
		local.traceHash = hash(arguments.exception.stackTrace, 'SHA');
		
		local.query = new Query(datasource = variables.datasource.name);
		
		local.query.setSql('
			SELECT "errorID"
			FROM "#variables.datasource.prefix#error".error
			WHERE "traceHash" = :tracehash');
		
		local.query.addParam(name = 'tracehash', value = local.traceHash, cfsqltype = 'cf_sql_varchar');
		
		local.previous = local.query.execute().getResult();
		
		transaction {
			// Determine if this is a new error or more of the same
			if(local.previous.recordCount) {
				local.errorID = local.previous.errorID;
			} else {
				// Insert as a new error
				local.errorID = createUUID();
				
				local.query = new Query(datasource = variables.datasource.name);
				
				local.query.setSql('
					INSERT INTO "#variables.datasource.prefix#error".error
					(
						"errorID",
						"type",
						"message",
						"detail",
						"code",
						"errorCode",
						"stackTrace",
						"traceHash"
					) VALUES (
						uuid( :errorID ),
						:type,
						:message,
						:detail,
						:code,
						:errorCode,
						:stackTrace,
						:traceHash
					) ');
				
				local.query.addParam(name = 'errorID', value = local.errorID, cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'type', value = arguments.exception.type, cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'message', value = arguments.exception.message, cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'detail', value = arguments.exception.detail, cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'code', value = (structKeyExists(arguments.exception, 'code') ? arguments.exception.code : ''), cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'errorCode', value = arguments.exception.errorCode, cfsqltype = 'cf_sql_varchar');
				local.query.addParam(name = 'stackTrace', value = arguments.exception.stackTrace, cfsqltype = 'cf_sql_longvarchar');
				local.query.addParam(name = 'tracehash', value = local.traceHash, cfsqltype = 'cf_sql_varchar');
				
				local.query.execute();
				
				for(local.i = 1; local.i <= arrayLen(arguments.exception.tagContext); local.i++) {
					local.context = arguments.exception.tagContext[local.i];
					
					local.query = new Query(datasource = variables.datasource.name);
					
					local.query.setSql('
						INSERT INTO "#variables.datasource.prefix#error".trace
						(
							"errorID",
							"orderBy",
							"raw",
							"template",
							"type",
							"line",
							"column",
							"id",
							"code"
						) VALUES (
							uuid( :errorID ),
							:orderBy,
							:raw,
							:template,
							:type,
							:line,
							:column,
							:id,
							:code
						)');
					
					local.query.addParam(name = 'errorID', value = local.errorID, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'orderBy', value = local.i, cfsqltype = 'cf_sql_smallint');
					local.query.addParam(name = 'raw', value = local.context.raw_trace, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'template', value = local.context.template, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'type', value = local.context.type, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'line', value = local.context.line, cfsqltype = 'cf_sql_integer');
					local.query.addParam(name = 'column', value = local.context.column, cfsqltype = 'cf_sql_integer');
					local.query.addParam(name = 'id', value = local.context.id, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'code', value = (structKeyExists(local.context, 'codePrintPlain') ? local.context.codePrintPlain : ''), cfsqltype = 'cf_sql_varchar');
					
					local.query.execute();
				}
				
				// Test if this is an exception with query info
				if (structKeyExists(arguments.exception, 'sql')) {
					local.query = new Query(datasource = variables.datasource.name);
					
					local.query.setSql('
						INSERT INTO "#variables.datasource.prefix#error".query
						(
							"errorID",
							"datasource",
							"sql"
						) VALUES (
							uuid( :errorID ),
							:datasource,
							:sql
						)');
					
					local.query.addParam(name = 'errorID', value = local.errorID, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'datasource', value = arguments.exception.datasource, cfsqltype = 'cf_sql_varchar');
					local.query.addParam(name = 'sql', value = arguments.exception.sql, cfsqltype = 'cf_sql_longvarchar');
					
					local.query.execute();
				}
			}
			
			// Add this occurrence to the error
			local.query = new Query(datasource = variables.datasource.name);
			
			local.query.setSql('
				INSERT INTO "#variables.datasource.prefix#error".occurrence
				(
					"occurrenceID",
					"errorID"
				) VALUES (
					uuid( :occurrenceID ),
					uuid( :errorID )
				)');
			
			local.query.addParam(name = 'occurrenceID', value = createUUID(), cfsqltype = 'cf_sql_varchar');
			local.query.addParam(name = 'errorID', value = local.errorID, cfsqltype = 'cf_sql_varchar');
			
			local.query.execute();
		}
		
		local.observer.afterLog(argumentCollection = arguments);
	}
}
