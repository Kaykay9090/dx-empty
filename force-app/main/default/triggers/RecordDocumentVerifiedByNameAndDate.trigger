trigger RecordDocumentVerifiedByNameAndDate on MortgageDocument__c (before update) {
    
    for (MortgageDocument__c record : Trigger.new) {
        if (record.Verified__c) {
            // Checkbox is checked, update custom fields
            record.Verified_By__c = UserInfo.getUserId();
            record.Verified_Date_and_Time__c = System.now();
           
        }
    }

}