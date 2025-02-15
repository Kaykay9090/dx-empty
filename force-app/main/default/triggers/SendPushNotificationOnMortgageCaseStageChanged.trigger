trigger SendPushNotificationOnMortgageCaseStageChanged on Mortgage_Case__c (after update) {
    for (Mortgage_Case__c newRecord : Trigger.new) {
        
        Mortgage_Case__c oldRecord = Trigger.oldMap.get(newRecord.Id);
        
        if (oldRecord.StageName__c != newRecord.StageName__c) {
            //MWDataSync.sendPushNotification(newRecord.Id);
        } 
        }

}