trigger UpdateApplicationSubmittedDate on Mortgage_Case__c (before update) {
    
    for(Mortgage_Case__c mortgageCase : Trigger.new) {
        // Check if the StageName is changing to 'FMA submitted'
        if(mortgageCase.StageName__c == 'FMA submitted' && Trigger.oldMap.get(mortgageCase.Id).StageName__c != 'FMA submitted') {
            // Set the Application_Submitted_Date__c field to today's date
            mortgageCase.Application_Submitted_Date__c = Date.today();
        } else if(mortgageCase.StageName__c == 'Case offered' && Trigger.oldMap.get(mortgageCase.Id).StageName__c != 'Case offered') {
            // Set the Application_Submitted_Date__c field to today's date
            mortgageCase.Application_Offered_Date__c = Date.today();
        }
    }

}