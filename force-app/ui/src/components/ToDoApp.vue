<template>
  <div class="slds-card slds-m-around_medium slds-p-around_small">
    <h2 class="slds-page-header__title slds-truncate">Todo List</h2>
    <div class="slds-grid slds-m-top_small slds-m-bottom_small">
      <div class="slds-form-element__control">
        <input class="slds-input" v-model="todoItem" placeholder="What to do?" />
      </div>
      <button class="slds-m-left_small slds-button slds-button_brand" @click="addItem">Add Item</button>
    </div>
    <div v-if="loading" class="slds-spinner_container">
      <div
        role="status"
        class="slds-spinner slds-spinner_medium slds-spinner_brand"
      >
        <span class="slds-assistive-text">Loading</span>
        <div class="slds-spinner__dot-a"></div>
        <div class="slds-spinner__dot-b"></div>
      </div>
    </div>
    <div class="slds-grid slds-border_top">
      <ul class="slds-has-dividers_around slds-m-top_small">
        <li
          class="slds-item slds-p-around_small"
          v-for="(item, index) in todoItems"
          :key="index"
        >
          <div class="slds-grid slds-wrap">
            <div class="slds-m-right_none">
              <div class="slds-form-element">
                <div class="slds-form-element__control">
                  <div class="slds-checkbox">
                    <input
                      type="checkbox"
                      v-model="item.completed"
                      @change="updateItem(item.completed, item.id)"
                      :id="`${index}`"
                    />
                    <label class="slds-checkbox__label" :for="`${index}`">
                      <span class="slds-checkbox_faux"></span>
                    </label>
                  </div>
                </div>
              </div>
            </div>
            <div class="slds-col" style="min-width: 200px" :class="{done: item.completed}">
              <span>{{ item.task }}</span>
            </div>
            <span
              style="cursor: pointer"
              class="slds-col_bump-left slds-icon_container slds-icon-utility-delete slds-m-left_small"
              @click="deleteItem(item.id)"
            >
              <svg class="slds-icon slds-icon_x-small slds-icon-text-default">
                <use xlink:href="../assets/svg/symbols.svg#delete"></use>
              </svg>
            </span>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>
<script setup lang="ts">
import { ref, onMounted } from "vue";
import salesforceClient from "../salesforce/SalesforceClient.js";

const client = new salesforceClient();

interface ToDoItem {
  id: string;
  task: string;
  completed: boolean;
}

const loading = ref<boolean>(false);
const todoItem = ref<string>("");
const todoItems = ref<ToDoItem[]>([]);

const refresh = async (): Promise<void> => {
  loading.value = true;
  todoItems.value = await client.call("TodoController.getAllTodoItems", {});
  loading.value = false;
};

onMounted(async (): Promise<void> => {
  await refresh();
});

const addItem = async (): Promise<void> => {
  if (!todoItem.value) {
    return;
  }

  const newItem: ToDoItem = {
    id: "",
    task: todoItem.value,
    completed: false
  };
  await client.call("TodoController.addTodoItem", newItem);
  await refresh();
  todoItem.value = "";
};

const updateItem = async (checked: boolean, id: string) => {
  const item = todoItems.value.find((todo) => {
    return todo.id === id;
  });
  if (!item) {
    return;
  }
  item.completed = checked;
  await client.call("TodoController.updateTodoItem", item);
  await refresh();
};

const deleteItem = async (id: string): Promise<void> => {
  await client.call("TodoController.deleteTodoItem", { id });
  await refresh();
};
</script>
<style scoped lang="scss">
.slds-card {
  width: 500px;
}
.done {
  text-decoration: line-through;
  color: #44c65a;
}
</style>
