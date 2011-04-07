component extends="algid.inc.resource.base.event" {
	public void function generate(required struct transport, required component task, required struct options, required component report) {
		local.servConversation = getService(arguments.transport, 'error', 'conversation');
		
		local.filter = {
			loggedAfter: dateAdd('s', -1 * arguments.task.getInterval(), now()),
			loggedBefore: now()
		};
		
		local.recentConversations = local.servConversation.getConversations(local.filter);
		
		// Only need more if there are errors to report on
		if (local.recentConversations.recordCount) {
			local.viewConversation = getView(arguments.transport, 'error', 'conversation');
			
			local.section = local.servConversation.getModel('admin', 'reportSection');
			
			arguments.options.theUrl.cleanSection();
			arguments.options.theUrl.setSection('_base', '/admin/app/errors/conversations/list');
			arguments.options.theUrl.setSection('loggedBefore', local.filter.loggedBefore);
			arguments.options.theUrl.setSection('loggedAfter', local.filter.loggedAfter);
			
			local.link = '<p><a href="' & arguments.options.theUrl.getSection() & '">View error conversations &##8594;</a></p>';
			
			local.section.setTitle('Errors');
			local.section.setContent(local.viewConversation.report(local.recentConversations) & local.link);
			
			report.addSections(local.section);
			
			// Record the errors as reported
			local.servConversation.reportConversations(local.filter);
		}
	}
}
