({
	openDocument : function(component, tokenValue) {
		
        var rid = component.get("v.recordId");
        var openDocURLAction = component.get("c.getDocumentURL");
        openDocURLAction.setParams({key : rid, token : tokenValue});
        
                
        openDocURLAction.setCallback(this, function(response) {
            
            var state = response.getState();

            if (state === "SUCCESS") {
                window.open(response.getReturnValue());
            } else {
                alert("Something went wrong");
            }
         });
                
         $A.enqueueAction(openDocURLAction);
        
	}
})