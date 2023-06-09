global class WebHttpResponse {
    public WebHttpResponse(WebHttpRequest request) {
        this.endpoint = request.endpoint;
    }

    public void setBody(Object body) {
        this.body = Json.serialize(body);
    }

    global String endpoint;
    global String body;
}
