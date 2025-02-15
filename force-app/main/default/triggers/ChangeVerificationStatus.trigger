trigger ChangeVerificationStatus on Id_doc_checks__c (before insert, before update) {
    
    for (Id_doc_checks__c obj : Trigger.new) {
        
        if (obj.Aml_check__c && obj.Bank_account_verification__c && obj.Identity_authenticate_check__c 
            && obj.Identity_document_check__c && obj.Income_verification__c) {
                obj.Verification_status__c = 'Complete';
            } else {
                obj.Verification_status__c = 'In Progress';
            }
    }

}