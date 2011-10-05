<cfscript>
	public void function onError(required any exception, required string eventName) {
		writeOutput('<h1>Server Error</h1><div>There has been a problem with the server.</div>');
		
		// Check if we have got far enough for the singletons
		if(structKeyExists(session, 'managers') and structKeyExists(session.managers, 'singleton')) {
			try {
				local.errorLogger = session.managers.singleton.getErrorLog();
				
				local.errorLogger.log(argumentCollection = arguments);
			} catch( any e ) {
				writeOutput('<div>The <strong>bad news</strong> is that <strong><em>we could not log the error</em></strong>.</div>');
				
				return;
			}
			
			writeOutput('<div>The <strong>good news</strong> is that <strong><em>we are tracking the problem</em></strong> and should fix it soon.</div>');
		} else if(isDebugMode()) {
			writeOutput('<div>Here is the error:</div>');
			
			writeDump(arguments.exception);
		} else {
			writeOutput('<div>The <strong>bad news</strong> is that we <strong><em>we could not log the error</em></strong>.</div>');
		}
	}
</cfscript>
