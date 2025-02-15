@IsTest
public class ApexSharingHelperTest {
    
    @TestSetup
    static void setupTestData() {
        // Query profiles based on their names
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'Admin' LIMIT 1];
        Profile advisorProfile = [SELECT Id FROM Profile WHERE Name = 'Advisor' LIMIT 1];
        Profile complianceProfile = [SELECT Id FROM Profile WHERE Name = 'Compliance' LIMIT 1];
        Profile principalProfile = [SELECT Id FROM Profile WHERE Name = 'Principal' LIMIT 1];

        // Create test users with corresponding profiles
        User adminUser = createTestUser('Admin', adminProfile.Id);
        User advisorUser = createTestUser('Advisor', advisorProfile.Id);
        User complianceUser = createTestUser('Compli', complianceProfile.Id);
        User principalUser = createTestUser('Princi', principalProfile.Id);

        // Create sample Mortgage Case records
        List<MortgagX__Mortgage_Case__c> mortgageCases = new List<MortgagX__Mortgage_Case__c>();
        for (Integer i = 0; i < 2; i++) {
            MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c(
                Name = 'Test Case ' + i,
                MortgagX__Admin__c = adminUser.Id,
                MortgagX__Advisor__c = advisorUser.Id,
                MortgagX__Compliance__c = complianceUser.Id,
                MortgagX__Principal__c = principalUser.Id
            );
            mortgageCases.add(mortgageCase);
        }
        insert mortgageCases;
    }
    
    // Helper method to create test users
    private static User createTestUser(String alias, Id profileId) {
        User u = new User(
            Alias = alias,
            Email = alias + '@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = alias,
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = profileId,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = alias + '@test.com.sandbox'
        );
        insert u;
        return u;
    }
    
    @IsTest
    static void testInsertSharingRecords() {
        // Fetch test data
        List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT Id, MortgagX__Admin__c, MortgagX__Advisor__c, MortgagX__Compliance__c, MortgagX__Principal__c FROM MortgagX__Mortgage_Case__c];
        
        Test.startTest();
        // Call the sharing helper for the insert case
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(mortgageCases, null, false);
        Test.stopTest();
        
        // Verify that sharing records were created with RowCause = 'Permission_Matrix__c'
        List<MortgagX__Mortgage_Case__Share> shareRecords = [
            SELECT Id, UserOrGroupId, ParentId, RowCause, AccessLevel 
            FROM MortgagX__Mortgage_Case__Share 
            WHERE RowCause = 'MortgagX__Permission_Matrix__c' AND ParentId IN :mortgageCases
        ];
        System.assertEquals(8, shareRecords.size(), 'Expected 8 sharing records (4 per Mortgage Case)');
        
        // Check if the appropriate sharing records were inserted
        for (MortgagX__Mortgage_Case__Share share : shareRecords) {
            System.assert(share.RowCause == 'MortgagX__Permission_Matrix__c', 'RowCause should be Permission_Matrix__c');
            System.assert(share.AccessLevel == 'Read' || share.AccessLevel == 'Edit', 'AccessLevel should be Read or Edit');
        }
    }

    @IsTest
    static void testUpdateSharingRecords() {
        // Fetch test data and simulate an update
        List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT Id, MortgagX__Admin__c, MortgagX__Advisor__c, MortgagX__Compliance__c, MortgagX__Principal__c FROM MortgagX__Mortgage_Case__c];
        Map<Id, MortgagX__Mortgage_Case__c> oldMap = new Map<Id, MortgagX__Mortgage_Case__c>(mortgageCases);
        
        // Query the Advisor test user (created in @TestSetup)
        User advisorUser = [SELECT Id FROM User WHERE Alias = 'Advisor' LIMIT 1];
        
        // Change Admin__c and Advisor__c for testing the update logic
        for (MortgagX__Mortgage_Case__c mortgageCase : mortgageCases) {
            mortgageCase.MortgagX__Admin__c = null; // Admin removed
            mortgageCase.MortgagX__Advisor__c = advisorUser.Id; // Advisor changed to the correct test user with Advisor profile
        }
        update mortgageCases;
        
        Test.startTest();
        // Call the sharing helper for the update case
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(mortgageCases, oldMap, true);
        Test.stopTest();
        
        // Verify that old sharing records were deleted and new ones were inserted with RowCause = 'Permission_Matrix__c'
        List<MortgagX__Mortgage_Case__Share> shareRecords = [
            SELECT Id, UserOrGroupId, ParentId, RowCause, AccessLevel 
            FROM MortgagX__Mortgage_Case__Share 
            WHERE RowCause = 'MortgagX__Permission_Matrix__c'
        ];
        System.assertEquals(6, shareRecords.size(), 'Expected 6 sharing records (3 per Mortgage Case after update)');
        
        // Check if the Admin shares were removed and new Advisor shares were created
        for (MortgagX__Mortgage_Case__Share share : shareRecords) {
            System.assertNotEquals(oldMap.get(share.ParentId).MortgagX__Admin__c, share.UserOrGroupId, 'Old Admin sharing record should be removed.');
            if (share.UserOrGroupId == advisorUser.Id) {
                System.assertEquals('Edit', share.AccessLevel, 'Advisor should have Edit access.');
            }
        }
    }
    
    @IsTest
    static void testDeleteSharingRecords() {
        // Fetch test data and simulate an update where fields are cleared
        List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT Id, MortgagX__Admin__c, MortgagX__Advisor__c, MortgagX__Compliance__c, MortgagX__Principal__c FROM MortgagX__Mortgage_Case__c];
        Map<Id, MortgagX__Mortgage_Case__c> oldMap = new Map<Id, MortgagX__Mortgage_Case__c>(mortgageCases);
        
        // Clear out fields to test deletion
        for (MortgagX__Mortgage_Case__c mortgageCase : mortgageCases) {
            mortgageCase.MortgagX__Admin__c = null;
            mortgageCase.MortgagX__Advisor__c = null;
            mortgageCase.MortgagX__Compliance__c = null;
            mortgageCase.MortgagX__Principal__c = null;
        }
        update mortgageCases;
        
        Test.startTest();
        // Call the sharing helper for the update case
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(mortgageCases, oldMap, true);
        Test.stopTest();
        
        // Verify that all sharing records were deleted with RowCause = 'Permission_Matrix__c'
        List<MortgagX__Mortgage_Case__Share> shareRecords = [
            SELECT Id 
            FROM MortgagX__Mortgage_Case__Share 
            WHERE RowCause = 'MortgagX__Permission_Matrix__c'
        ];
        System.assertEquals(0, shareRecords.size(), 'Expected no sharing records after all fields were cleared.');
    }
    
    @IsTest
    static void testNoChanges() {
        // Fetch test data and do not make any changes
        List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT Id, MortgagX__Admin__c, MortgagX__Advisor__c, MortgagX__Compliance__c, MortgagX__Principal__c FROM MortgagX__Mortgage_Case__c];
        Map<Id, MortgagX__Mortgage_Case__c> oldMap = new Map<Id, MortgagX__Mortgage_Case__c>(mortgageCases);
        
        Test.startTest();
        // Call the sharing helper with no changes
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(mortgageCases, oldMap, true);
        Test.stopTest();
        
        // Verify that no changes were made to sharing records
        List<MortgagX__Mortgage_Case__Share> shareRecords = [
            SELECT Id 
            FROM MortgagX__Mortgage_Case__Share 
            WHERE RowCause = 'MortgagX__Permission_Matrix__c'
        ];
        System.assertEquals(4 * mortgageCases.size(), shareRecords.size(), 'Expected no changes to sharing records.');
    }

    @IsTest
    static void testGovernorLimits() {
        // Create multiple mortgage cases to test governor limits
        List<MortgagX__Mortgage_Case__c> mortgageCases = new List<MortgagX__Mortgage_Case__c>();
        for (Integer i = 0; i < 100; i++) {
            mortgageCases.add(new MortgagX__Mortgage_Case__c(Name = 'Test Case ' + i));
        }
        insert mortgageCases;

        Test.startTest();
        ApexSharingHelper helper = new ApexSharingHelper();
        helper.shareMortgageCaseRecords(mortgageCases, null, false);
        Test.stopTest();
        
        // Verify governor limits are respected
        System.assert(Limits.getDmlRows() <= Limits.getLimitDmlRows(), 'DML row limit exceeded');
        System.assert(Limits.getQueries() <= Limits.getLimitQueries(), 'SOQL query limit exceeded');
    }
}