/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mobilehub.controller.datastructure;
import com.mobilehub.model.ModelDetails;
import java.util.Stack;
/**
 *
 * @author ROG STRIX
 */
public class UndoStack {
    private Stack<StackAction> undoStack;

    public UndoStack() {
        undoStack = new Stack<>();
    }

    public void pushAction(StackAction action) {
        undoStack.push(action);
    }

    public StackAction popAction() {
        if (!undoStack.isEmpty()) {
            return undoStack.pop();
        }
        return null;
    }

    public boolean isEmpty() {
        return undoStack.isEmpty();
    }

    public void clearStack() {
        undoStack.clear();
    }

    // Inner class to represent actions (ADD, UPDATE, DELETE)
    public static class StackAction {
        public enum ActionType {
            ADD, UPDATE, DELETE
        }

        private ActionType type;
        private ModelDetails model;
        private int index; // Index for UPDATE and DELETE actions

        // Constructor for ADD action
        public StackAction(ActionType type, ModelDetails model) {
            this.type = type;
            this.model = model;
            this.index = -1; // Not needed for ADD
        }

        // Constructor for UPDATE and DELETE actions
        public StackAction(ActionType type, ModelDetails model, int index) {
            this.type = type;
            this.model = model;
            this.index = index;
        }

        public ActionType getType() {
            return type;
        }

        public ModelDetails getModel() {
            return model;
        }

        public int getIndex() {
            return index;
        }
    }
}