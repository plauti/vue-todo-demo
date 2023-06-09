public class HelloWorldController implements Callable {
    public Object call(String action, Map<String, Object> args) {
        return 'hello';
      }
   

}