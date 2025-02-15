({
  doInit: function (component, event, helper) {

    let currentYear = new Date().getFullYear();

    let years = [];

    for (let i = 0; i < 6; i++) {
      years.push(currentYear - i);
    }

    component.set("v.years", years);

    // Prepare the months array
    let months = ["J", "F", "M", "A", "M", "J", "J", "A", "S", "O", "N", "D"];
    
    component.set("v.months", months);

    var action = component.get("c.getCreditCommitment");
    action.setParams({ recordId: component.get("v.recordId") });

    action.setCallback(this, function (response) {
      
        var state = response.getState();

      if (state === "SUCCESS") {

        helper.populateData(component, response.getReturnValue()); 


      } else {
        console.error("Failed to retrieve Opportunity: " + state);
      }
    

    });

    $A.enqueueAction(action);
  },
});