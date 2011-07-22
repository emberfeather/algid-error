component extends="algid.inc.resource.base.event" {
	public void function beforeLog(required struct transport, required any exception, string eventName = '') {
		if(arguments.transport.theApplication.managers.singleton.getApplication().isDevelopment()) {
			writeDump(arguments.exception);
			abort;
		}
	}
	
	public void function failedLog(required struct transport, required any exception, required any loggingException, string eventName = '') {
		local.email = arguments.transport.theApplication.managers.plugin.getError().getEmail();
		
		// Failed to log error, send report of unlogged error
		if( local.email != '') {
			mail to=local.email from=local.email type="html" subject="Error: #arguments.exception.message#" {
				writeOutput('<h1>Unlogged Application Error</h1>');
				writeOutput('<h2>Original Error</h2>');
				writeDump(arguments.exception);
				writeOutput('<h2>Logging Error</h2>');
				writeDump(arguments.loggingException);
			}
		}
	}
}
