// Adds logging for applications
component {
	public void function onError(required any exception, required string eventName) {
		// Check if we have got far enough for the singletons
		if(structKeyExists(application, 'managers') and structKeyExists(application.managers, 'singleton')) {
			try {
				local.errorLogger = application.managers.singleton.getErrorLog();
				
				local.errorLogger.log(argumentCollection = arguments);
				
				writeOutput('<h1>500 Server Error</h1><div>A <strong>rogue monkey ninja</strong> invaded the server. The <strong>good news</strong> is that <em>we are tracking him and will catch him soon</em>.</div>');
			} catch( any exception ) {
				// Failed to log error, send report of unlogged error
				// TODO Send Unlogged Error
			}
		} else if(isDebugMode()) {
			writeOutput('<h1>500 Server Error</h1><div>A <strong>rogue monkey ninja</strong> invaded the server. The <strong>really good news</strong> is that we <strong><em>are better ninjas than him</em></strong>:</div>');
			
			writeDump(arguments.exception);
		} else {
			writeOutput('<h1>500 Server Error</h1><div>A <strong>rogue monkey ninja</strong> invaded the server. The <strong>bad news</strong> is that we <em>cannot find him</em>.</div>');
		}
	}
}
