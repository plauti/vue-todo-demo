public abstract class WebHttpPipeline {
    public virtual Map<String, Callable> getControllers() {
        throw new WebGetControllersNotImplementedException();
    }

    /**
     * Simple pipeline that maps the unified request to a controller and returns the result in a unified format.
     */
    public WebHttpResponse handle(WebHttpRequest request) {
        List<string> endpoint = request.endpoint.split('\\.');
        if (2 != endpoint.size())
            throw new WebInvalidEndpointFormatException();

        String controllerName = endpoint[0];
        String method = endpoint[1];

        Callable controller = this.getControllers().get(controllerName);
        if (null == controller)
            throw new WebControllerNotFoundException();

        Map<string, object> args = new Map<string, object>{ 'body' => request.body };

        Object pipelineResult = controller.call(method, args);

        WebHttpResponse response = new WebHttpResponse(request);
        response.setBody(pipelineResult);

        return response;
    }

    public class WebControllerNotFoundException extends Exception {
    }
    public class WebGetControllersNotImplementedException extends Exception {
    }
    public class WebInvalidEndpointFormatException extends Exception {
    }
    public class WebMethodNotFoundException extends Exception {
    }
}
