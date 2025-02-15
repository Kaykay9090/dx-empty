({
 
	handleClick : function(component, event, helper) {

        var loginAction = component.get("c.login");
 
        loginAction.setCallback(this, function(response) {
            
            var state = response.getState();
            
            if (state === "SUCCESS") {

				helper.openDocument(component, response.getReturnValue());                

            } else {
                alert("Error Opening Document: " + state);

            }
        });
        
        $A.enqueueAction(loginAction);
        
	}
})