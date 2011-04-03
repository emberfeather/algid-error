component extends="algid.inc.resource.base.event" {
	public void function generate(required struct transport, required component task, required struct options, required component report) {
		local.servConversation = getService(arguments.transport, 'error', 'conversation');
		
		local.filter = {
			loggedAfter: dateAdd('s', -1 * arguments.task.getInterval(), now())
		};
		
		local.recentConversations = local.servConversation.getConversations(local.filter);
		
		// Only need more if there are errors to report on
		if (local.recentConversations.recordCount) {
			local.viewConversation = getView(arguments.transport, 'error', 'conversation');
			
			local.section = local.servConversation.getModel('admin', 'reportSection');
			
			local.section.setTitle('Errors');
			local.section.setContent(local.viewConversation.datagrid(local.recentConversations));
			
			report.addSections(local.section);
			
			// Record the errors as reported
			local.servConversation.reportConversations(local.filter);
		}
	}
}
