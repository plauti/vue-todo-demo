public without sharing class TodoController implements Callable {
  /**
   * Get all items from the todo list sobject.
   */
  public List<TodoDTO> getAllTodoItems() {
    List<todoListItem__c> items = [
      SELECT Id, isDone__c, value__c, createdAt__c
      FROM todoListItem__c
      ORDER BY createdAt__c DESC
    ];
    List<TodoDTO> dtoList = new List<TodoDTO>();
    for (todoListItem__c item : items) {
      TodoDTO dto = new TodoDTO();
      dto.id = item.Id;
      dto.task = item.value__c;
      dto.completed = item.isDone__c;
      dtoList.add(dto);
    }

    return dtoList;
  }

  public Object addTodoItem(String body) {
    TodoDTO todoDTO = (TodoDTO) JSON.deserialize(body, TodoDTO.class);
    todoListItem__c todoItem = new todoListItem__c(
      isDone__c = todoDTO.completed,
      value__c = todoDTO.task,
      createdAt__c = Datetime.now()
    );
    insert todoItem;
    return true;
  }

  public Object updateTodoItem(String body) {
    TodoDTO todoDTO = (TodoDTO) JSON.deserialize(body, TodoDTO.class);
    todoListItem__c item = [
      SELECT Id, isDone__c, value__c
      FROM todoListItem__c
      WHERE Id = :todoDTO.id
      LIMIT 1
    ];

    if (item == null) {
      return false;
    }

    item.isDone__c = todoDTO.completed;
    item.value__c = todoDTO.task;

    update item;
    return true;
  }

  public Object deleteTodoItem(String body) {
    Map<String, String> parsedBody = (Map<String, String>) JSON.deserialize(
      body,
      Map<String, String>.class
    );

    Id deleteId = (Id) parsedBody.get('id');
    todoListItem__c item = [
      SELECT Id, isDone__c, value__c
      FROM todoListItem__c
      WHERE Id = :deleteId
      LIMIT 1
    ];

    if (item == null) {
      return false;
    }

    delete item;
    return true;
  }

  public Object call(String action, Map<String, Object> args) {
    switch on action {
      when 'getAllTodoItems' {
        return getAllTodoItems();
      }
      when 'addTodoItem' {
        return addTodoItem((String) args.get('body'));
      }
      when 'updateTodoItem' {
        return updateTodoItem((String) args.get('body'));
      }
      when 'deleteTodoItem' {
        return deleteTodoItem((String) args.get('body'));
      }
    }

    return null;
  }

  public class TodoDTO {
    Id id;
    String task;
    Boolean completed;
  }
}
