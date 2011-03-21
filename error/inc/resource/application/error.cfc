// Adds logging for applications
component {
	public void function onError(required any exception, required string eventName) {
		// Check if we have got far enough for the singletons
		if (structKeyExists(variables, 'isDebugMode') and not variables.isDebugMode and structKeyExists(application, 'managers') and structKeyExists(application.managers, 'singletons')) {
			try {
				local.errorLogger = application.managers.singleton.getErrorLog();
				
				local.errorLogger.log(argumentCollection = arguments);
			} catch( any exception ) {
				// Failed to log error, send report of unlogged error
				// TODO Send Unlogged Error
			}
		} else {
			// Dump out the error
			writeDump(#arguments.exception#);
			abort;
		}
	}
}
