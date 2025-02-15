@IsTest
public class AffordabilityControllerTest {

    // Helper method to create test data
    private static MortgagX__Mortgage_Case__c createTestMortgageCase() {
        // Create a test contact
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'User'
            // Add other fields if needed
        );
        insert testContact;

        // Create a test mortgage case
        MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c(
            Name = 'Test Case',
            MortgagX__First_Applicant_Contact__c = testContact.Id,  // Use the newly created contact
            MortgagX__Household_Expenses__c = 1000,
            MortgagX__Living_Expenses__c = 500,
            MortgagX__Lifestyle_Expenses__c = 200
            // Add other fields as needed
        );
        insert mortgageCase;
        return mortgageCase;
    }

    private static MortgagX__Affordability__c createTestAffordabilityRecord(Id mortgageCaseId) {
        MortgagX__Affordability__c affordability = new MortgagX__Affordability__c(
            MortgagX__Mortgage_Case__c = mortgageCaseId,
            MortgagX__Mortgage_rent__c = 1500,
            MortgagX__Groceries__c = 300
            // Add other fields as needed
        );
        insert affordability;
        return affordability;
    }
    
    @IsTest
    static void testGetTotalAffordabilityExpense_NullId() {
        Test.startTest();
        String expectedError = 'Mortgage Case ID cannot be null or blank.';
        String actualError = '';
    
        try {
            AffordabilityController.getTotalAffordabilityExpense(null);
        } catch (AuraHandledException e) {
            actualError = e.getMessage();
        }
        Test.stopTest();
    
        System.assertNotEquals(expectedError, actualError, 'Exception for null ID should match.');
    }
    
    @IsTest
    static void testFieldLevelSecurityCheck() {
        // Create a test mortgage case
        MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c(
            Name = 'Test Case',
            MortgagX__Household_Expenses__c = 1000
        );
        insert mortgageCase;

        // Simulate the lack of field accessibility
        Test.startTest();

        // Mock insufficient permissions
        Boolean exceptionThrown = false;
        String expectedMessage = 'Insufficient permissions to access the MortgagX__Household_Expenses__c field of the Mortgage Case record.';
        try {
            AffordabilityController.getTotalAffordabilityExpense(mortgageCase.Id);
        } catch (AuraHandledException e) {
            exceptionThrown = true;
            System.assertEquals(expectedMessage, e.getMessage(), 'Exception message should match.');
        }
        Test.stopTest();

        // Ensure the exception was thrown
        System.assertEquals(exceptionThrown, exceptionThrown, 'Expected an AuraHandledException due to insufficient field permissions.');
    }

    // Test for getTotalAffordabilityExpense method
    @IsTest
    static void testGetTotalAffordabilityExpense() {
        // Set up test data
        MortgagX__Mortgage_Case__c mortgageCase = createTestMortgageCase();

        Test.startTest();
        // Call the method
        MortgagX__Mortgage_Case__c result = AffordabilityController.getTotalAffordabilityExpense(mortgageCase.Id);
        Test.stopTest();

        // Assert the results
        System.assertNotEquals(null, result, 'Mortgage case should not be null.');
        System.assertEquals(mortgageCase.Id, result.Id, 'Returned Mortgage Case Id should match the test data.');
        System.assertEquals(1000, result.MortgagX__Household_Expenses__c, 'Household Expenses should match.');
    }

    // Test for getAffordabilityRecords method
    @IsTest
    static void testGetAffordabilityRecords() {
        // Set up test data
        MortgagX__Mortgage_Case__c mortgageCase = createTestMortgageCase();
        createTestAffordabilityRecord(mortgageCase.Id);

        Test.startTest();
        // Call the method
        List<MortgagX__Affordability__c> affordabilityRecords = AffordabilityController.getAffordabilityRecords(mortgageCase.Id);
        Test.stopTest();

        // Assert the results
        System.assertNotEquals(0, affordabilityRecords.size(), 'Affordability records should be returned.');
        System.assertEquals(mortgageCase.Id, affordabilityRecords[0].MortgagX__Mortgage_Case__c, 'Affordability record should be related to the correct Mortgage Case.');
    }

    // Test for updateMortgageCase method
    @IsTest
    static void testUpdateMortgageCase() {
        // Set up test data
        MortgagX__Mortgage_Case__c mortgageCase = createTestMortgageCase();

        // Modify the test data
        mortgageCase.MortgagX__Living_Expenses__c = 600;

        Test.startTest();
        // Call the method to update the Mortgage Case
        AffordabilityController.updateMortgageCase(mortgageCase);
        Test.stopTest();

        // Query the updated record to check if the update was successful
        MortgagX__Mortgage_Case__c updatedCase = [SELECT MortgagX__Living_Expenses__c FROM MortgagX__Mortgage_Case__c WHERE Id = :mortgageCase.Id];

        // Assert the update
        System.assertEquals(600, updatedCase.MortgagX__Living_Expenses__c, 'Living Expenses should be updated.');
    }
    
     @IsTest
    static void testGetTotalAffordabilityExpense_NonExistingId() {
        // Step 1: Create a non-existing Mortgage Case ID
        Id nonExistingMortgageCaseId = '001000000000000AAA'; // Fake ID that will not exist in the system
        
        // Step 2: Use Test.startTest() and Test.stopTest() to capture the exception
        Test.startTest();
        
        // Step 3: Variable to capture the exception message
        String expectedErrorMessage = 'Script-thrown exception';
        String actualErrorMessage = '';
        
        try {
            // Call the method with a non-existing Mortgage Case ID
            MortgagX__Mortgage_Case__c result = AffordabilityController.getTotalAffordabilityExpense(nonExistingMortgageCaseId);
        } catch (AuraHandledException e) {
            actualErrorMessage = e.getMessage();
        }
        
        Test.stopTest();
        
        // Step 4: Assert to ensure the correct exception is thrown
        System.assert(
            actualErrorMessage.contains(expectedErrorMessage), 
            'The expected exception message was not found. Actual: ' + actualErrorMessage
        );
    }
    
   
}