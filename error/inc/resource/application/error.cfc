// Adds logging for applications
component {
	public void function onError(required any exception, required string eventName) {
		// Check if we have got far enough for the singletons
		if(structKeyExists(application, 'managers') and structKeyExists(application.managers, 'singletons')) {
			try {
				local.errorLogger = application.managers.singleton.getErrorLog();
				
				local.errorLogger.log(argumentCollection = arguments);
			} catch( any exception ) {
				// Failed to log error, send report of unlogged error
				// TODO Send Unlogged Error
			}
		} else if(isDebugMode()) {
			// Dump out the error
			writeDump(arguments.exception);
			abort;
		} else {
			writeOutput('<h1>Server Error</h1><div>A rogue monkey ninja invaded the server and is causing issues. We are currently unable to catch what damage he is causing.</div>');
			abort;
		}
	}
}
