<cfset i18n = application.managers.singleton.getI18N() />

<cfset servConversation = createObject('component', 'plugins.error.inc.service.servConversation').init(application.settings.datasources.update, i18n, SESSION.locale) />