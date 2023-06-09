@RestResource(
  urlMapping='/WebApiRestEntryPoint'
) // Best practice: don't push to org
global class WebApiRestEntryPoint {
  @HttpPost
  global static void handle() {
    // http request handling
    RestRequest req = RestContext.request;
    String requestBody = req.requestBody.toString();
    WebHttpRequest parsedRequest = (WebHttpRequest) Json.deserialize(
      requestBody,
      WebHttpRequest.class
    );

    // request processing pipeline
    WebRoutes webRequestHandler = new WebRoutes();
    WebHttpResponse handledResult = webRequestHandler.handle(parsedRequest);

    // http response handling
    RestResponse res = RestContext.response;
    res.responseBody = Blob.valueOf(Json.serialize(handledResult));
  }
}
