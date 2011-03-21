component extends="algid.inc.resource.base.service" {
	public void function log(required any exception, string eventName = '') {
		if(variables.transport.theApplication.managers.singleton.getApplication().isDevelopment()) {
			writeDump(arguments.exception);
			abort;
		}
		
		// Log to the application error log
		writeLog(application="true", file="errors", text="#arguments.exception.message#|#arguments.exception.detail#", type="error");
		
		local.i18n = variables.transport.theApplication.managers.singleton.getI18N();
		
		transaction {
			local.error = variables.transport.theApplication.factories.transient.getModErrorForError(local.i18n);
			
			local.error.setDetail(arguments.exception.detail);
			local.error.setErrorCode(arguments.exception.errorCode);
			local.error.setMessage(arguments.exception.message);
			local.error.setType(arguments.exception.type);
			local.error.setStackTrace(arguments.exception.stackTrace);
			
			if (structKeyExists(arguments.exception, 'code')) {
				local.error.setCode(arguments.exception.code);
			}
			
			// Save to the DB
			local.error.save(variables.datasource);
			
			for(i = 1; i <= arrayLen(arguments.exception.tagContext); i++) {
				context = arguments.exception.tagContext[i];
				
				local.trace = variables.transport.theApplication.factories.transient.getModTraceForError(local.i18n);
				
				local.trace.setErrorID( local.error.getErrorID() );
				local.trace.setOrder( i );
				
				local.trace.setColumn( context.column );
				local.trace.setLine( context.line );
				local.trace.setId( context.id );
				local.trace.setRaw( context.raw_trace );
				local.trace.setTemplate( context.template );
				local.trace.setType( context.type );
				
				if (structKeyExists(context, 'codePrintPlain')) {
					local.trace.setCode( context.codePrintPlain );
				}
				
				// Save to the DB
				local.trace.save(variables.datasource);
			}
			
			// Test if this is an exception with query info
			if (structKeyExists(arguments.exception, 'sql')) {
				local.query = variables.transport.theApplication.factories.transient.getModQueryForError(local.i18n);
				
				local.query.setErrorID( local.error.getErrorID() );
				local.query.setDatasource( arguments.exception.datasource );
				local.query.setSql( arguments.exception.sql );
				
				// Save to the DB
				local.query.save(variables.datasource);
			}
		}
	}
}