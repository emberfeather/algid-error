component extends="algid.inc.resource.base.event" {
	public void function beforeLog(required struct transport, required any exception, string eventName = '') {
		if(arguments.transport.theApplication.managers.singleton.getApplication().isDevelopment()) {
			writeDump(arguments.exception);
			abort;
		}
	}
}
