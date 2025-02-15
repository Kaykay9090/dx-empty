public with sharing class ApexSharingHelper {
    List<MortgagX__Mortgage_Case__Share> lstMCShareRecordsToInsert = new List<MortgagX__Mortgage_Case__Share>();
    List<MortgagX__Mortgage_Case__Share> lstMCShareRecordsToDelete = new List<MortgagX__Mortgage_Case__Share>();
    
    public void shareMortgageCaseRecords(
        List<MortgagX__Mortgage_Case__c> lstMortgageCases, 
        Map<Id, MortgagX__Mortgage_Case__c> oldMap, 
        Boolean isUpdate) {

        // Check CRUD Permissions
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('You do not have access to Mortgage Case records.');
        }
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__Share.isCreateable()) {
            throw new AuraHandledException('You do not have permission to insert sharing records.');
        }
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__Share.isDeletable()) {
            throw new AuraHandledException('You do not have permission to delete sharing records.');
        }


        for (MortgagX__Mortgage_Case__c objMC : lstMortgageCases) {
            MortgagX__Mortgage_Case__c oldMC = isUpdate ? oldMap.get(objMC.Id) : null;

            // Handle the sharing based on different roles
            handleSharing(
                'MortgagX__Admin__c', 'Read', objMC.MortgagX__Admin__c, oldMC != null ? oldMC.MortgagX__Admin__c : null, 
                objMC.Id, lstMCShareRecordsToInsert, lstMCShareRecordsToDelete
            );

            handleSharing(
                'MortgagX__Advisor__c', 'Edit', objMC.MortgagX__Advisor__c, oldMC != null ? oldMC.MortgagX__Advisor__c : null, 
                objMC.Id, lstMCShareRecordsToInsert, lstMCShareRecordsToDelete
            );

            handleSharing(
                'MortgagX__Compliance__c', 'Read', objMC.MortgagX__Compliance__c, oldMC != null ? oldMC.MortgagX__Compliance__c : null, 
                objMC.Id, lstMCShareRecordsToInsert, lstMCShareRecordsToDelete
            );

            handleSharing(
                'MortgagX__Principal__c', 'Edit', objMC.MortgagX__Principal__c, oldMC != null ? oldMC.MortgagX__Principal__c : null, 
                objMC.Id, lstMCShareRecordsToInsert, lstMCShareRecordsToDelete
            );
        }

        // Only insert if the list is not empty and user has create access
        if (!lstMCShareRecordsToInsert.isEmpty()) {
            if (Schema.sObjectType.MortgagX__Mortgage_Case__Share.isCreateable()) {
                INSERT lstMCShareRecordsToInsert;
            } else {
                throw new AuraHandledException('You do not have permission to create sharing records.');
            }
        }

        // Only delete if the list is not empty and user has delete access
        if (!lstMCShareRecordsToDelete.isEmpty()) {
            if (Schema.sObjectType.MortgagX__Mortgage_Case__Share.isDeletable()) {
                DELETE lstMCShareRecordsToDelete;
            } else {
                throw new AuraHandledException('You do not have permission to delete sharing records.');
            }
        }
    }

    private void handleSharing(
        String fieldName, String accessLevel, Id newUserOrGroupId, 
        Id oldUserOrGroupId, Id parentId, 
        List<MortgagX__Mortgage_Case__Share> lstToInsert, List<MortgagX__Mortgage_Case__Share> lstToDelete) {

        // Insert new share record if applicable
        if (newUserOrGroupId != null && newUserOrGroupId != oldUserOrGroupId) {
           
                MortgagX__Mortgage_Case__Share newShare = new MortgagX__Mortgage_Case__Share();
                newShare.AccessLevel = accessLevel;
                newShare.ParentId = parentId;
                newShare.UserOrGroupId = newUserOrGroupId;
                newShare.RowCause = Schema.MortgagX__Mortgage_Case__Share.RowCause.MortgagX__Permission_Matrix__c;
                lstMCShareRecordsToInsert.add(newShare);
            
        }

        // Remove old share record if applicable
        if (oldUserOrGroupId != null && newUserOrGroupId == null) {
            
                MortgagX__Mortgage_Case__Share shareToDelete = [
                    SELECT Id 
                    FROM MortgagX__Mortgage_Case__Share 
                    WHERE ParentId = :parentId 
                    AND UserOrGroupId = :oldUserOrGroupId 
                    AND RowCause = :Schema.MortgagX__Mortgage_Case__Share.RowCause.MortgagX__Permission_Matrix__c
                    LIMIT 1
                ];
                if (shareToDelete != null) {
                    lstMCShareRecordsToDelete.add(shareToDelete);
                }
            
        }
    }

    // public class CustomException extends Exception {}
}