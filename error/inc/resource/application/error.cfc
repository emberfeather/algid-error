// Adds logging for applications
component {
	public void function onError(required any exception, required string eventName) {
		writeOutput('<h1>Server Error</h1><div>A <strong>rogue ninja monkey</strong> invaded the server.</div>');
		
		// Check if we have got far enough for the singletons
		if(structKeyExists(session, 'managers') and structKeyExists(session.managers, 'singleton')) {
			try {
				local.errorLogger = session.managers.singleton.getErrorLog();
				
				local.errorLogger.log(argumentCollection = arguments);
			} catch( any e ) {
				writeOutput('<div>The <strong>bad news</strong> is that we <strong><em>cannot find him</em></strong>.</div>');
				
				return;
			}
			
			writeOutput('<div>The <strong>good news</strong> is that <strong><em>we are tracking him and will catch him soon</em></strong>.</div>');
		} else if(isDebugMode()) {
			writeOutput('<div>The <strong>really good news</strong> is that we <strong><em>are better ninjas than him</em></strong>:</div>');
			
			writeDump(arguments.exception);
		} else {
			writeOutput('<div>The <strong>bad news</strong> is that we <strong><em>cannot find him</em></strong>.</div>');
		}
	}
}
