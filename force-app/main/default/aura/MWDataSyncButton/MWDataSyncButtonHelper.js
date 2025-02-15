({
	syncRecord : function(component, tokenValue) {
		
        var rid = component.get("v.recordId");
        var syncAction = component.get("c.sync");
        syncAction.setParams({key : rid, token : tokenValue});
        
                
        syncAction.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                
                if (response.getReturnValue() != '') {
                    alert(response.getReturnValue());
                }
                
            } else {
                alert("Error calling Apex method: " + state)
            }
         });
                
         $A.enqueueAction(syncAction);
        
	}
})