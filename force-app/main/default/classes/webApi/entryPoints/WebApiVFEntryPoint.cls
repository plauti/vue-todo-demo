global with sharing class WebApiVFEntryPoint {

    @RemoteAction
    global static Object handle(WebHttpRequest req) {
        WebRoutes webHandler = new WebRoutes();
        return webHandler.handle(req);
    }
}
