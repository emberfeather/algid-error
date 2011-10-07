component extends="plugins.widget.inc.resource.base.widget" {
	public component function init(required struct transport, required string path) {
		super.init(arguments.transport, arguments.path);
		
		preventCaching();
		
		return this;
	}
	
	public string function process( required string content, required struct args ) {
		throw(message = 'Testing a error!', detail = 'Congratulations a test error was thrown!')
	}
}
