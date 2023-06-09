public class WebRoutes extends WebHttpPipeline {
    public Map<String, Callable> controllers = new Map<String, Callable>();

    public override Map<String, Callable> getControllers() {
        Map<String, Callable> controllers = new Map<String, Callable>();

        // Register controllers to expose them to Vue application
        controllers.put('HelloWorldController', new HelloWorldController());
        controllers.put('TodoController', new TodoController());

        return controllers;
    }
}
