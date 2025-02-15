({
  init: function (cmp, event, helper) {
    helper.setColumns(cmp);
    var rid = cmp.get("v.recordId");
    var action = cmp.get("c.findProducts");
    action.setParams({ key: rid });

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var returnValue = response.getReturnValue();
        cmp.set("v.loaded", !cmp.get("v.loaded"));
        helper.setData(cmp, response.getReturnValue().products);
      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          title: state,
          message: "Please try again",
          type: "error",
        });
        toastEvent.fire();
      }
    });

    $A.enqueueAction(action);
  },

  handleSort: function (cmp, event, helper) {
    helper.handleSort(cmp, event);
  },

  updateSelectedText: function (cmp, event) {
    var selectedRows = event.getParam("selectedRows");
    cmp.set("v.selectedRowsCount", selectedRows.length);
  },

  handleRowSelection: function (component, event, helper) {
    const selectedRows = event.getParam("selectedRows");

    helper.setSelectedProducts(component, selectedRows);
  },

  handleAddProdctsToMortgageCase: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");

    if (helper.selectedProducts.length == 0) {
      toastEvent.setParams({
        title: "Error!",
        message: "Please select min 1 product",
        type: "error",
      });
      toastEvent.fire();
    } else {
      var saveProductsAction = component.get("c.saveProducts");
      var rid = component.get("v.recordId");
      saveProductsAction.setParams({
        key: rid,
        products: helper.selectedProducts,
      });

      saveProductsAction.setCallback(this, function (response) {
        var state = response.getState();

        if (state === "SUCCESS") {
          toastEvent.setParams({
            title: "Success!",
            message: "Records Saved Successfully",
            type: "success",
          });
          component.set("v.selectedProducts", []);
          helper.setSelectedProducts(component, []);
        } else {
          toastEvent.setParams({
            title: "Error",
            message: "Something went wrong. Please try again! ",
            type: "error",
          });
        }

        toastEvent.fire();
      });

      $A.enqueueAction(saveProductsAction);
    }
  },
});