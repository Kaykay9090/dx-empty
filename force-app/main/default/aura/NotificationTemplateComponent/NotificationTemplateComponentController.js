({
  init: function(component, event, helper) {

    /*
    var action = component.get("c.getOpportunity");
    action.setParams({ opportunityId : component.get("v.recordId") });

    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {

          component.set("v.firstApplicant", response.getReturnValue().First_Applicant_Contact__r.Name);
          component.set("v.secondApplicant", response.getReturnValue().Second_applicant_contact__r.Name);

      }
      else {
          console.error("Failed to retrieve Opportunity: " + state);
      }
  });
  $A.enqueueAction(action);*/

  },
    handleChange: function(component, event, helper) {
        
        var selectedOption = component.find('selectOption').get('v.value');

        var rid = component.get("v.recordId");
        console.log(rid);

        component.set("v.selectedOption", selectedOption);

        var notificationMessage = '';

        if (selectedOption === 'Case Assigned') {
          notificationMessage = 'Gotchya details. Currently reviewing...'
 
        } else if (selectedOption === 'Meet your advisor tomorrow') {
          notificationMessage = 'Looking forward to meeting you';
        } else if (selectedOption === 'Meet your advisor today') {
          notificationMessage = 'Speak to you soon';
        } else if (selectedOption === 'Documents Pending') {
          notificationMessage = 'Knock! Knock! Pls check your email. We need few docs from you...';
        } else if (selectedOption === 'Mortgage renewal reminder') {
          notificationMessage = 'Your deal is expiring soon. lets proactively close new deal today!';
        }

        component.set("v.notificationMessage", notificationMessage);
    },
    handleSendNotification: function(component, event, helper) {
      var selectedOption = component.get("v.selectedOption");
      var notificationMessage = component.get("v.notificationMessage");
      /*var action = component.get("c.sendPushNotification");
      action.setParams({
        "option": selectedOption,
        "message": notificationMessage
      });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
          console.log("Notification sent successfully!");
        } else {
          console.log("Error sending notification:");
        }
      });
      $A.enqueueAction(action);*/
    }
  })