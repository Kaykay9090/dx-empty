trigger MortgageCaseTrigger on Mortgage_Case__c (after insert, after update) {
    
    if(Trigger.isInsert) {
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(Trigger.new, null, false);
    }
    
    if(Trigger.isUpdate) {
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(Trigger.new, Trigger.oldMap, true);
    }
}