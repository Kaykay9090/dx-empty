public with sharing class AffordabilityController {
    
    public static void checkFieldAccessibility(String fieldName) {
        // Describe the Mortgage Case object
        Schema.DescribeSObjectResult objDescribe = Schema.sObjectType.MortgagX__Mortgage_Case__c;
    
        // Fetch field describe result
        Map<String, Schema.SObjectField> fields = objDescribe.fields.getMap();
    
        if (!fields.containsKey(fieldName) || !fields.get(fieldName).getDescribe().isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the ' + fieldName + ' field of the Mortgage Case record.');
        }
    }
    
	// Method to get total affordability expense from a Mortgage Case record
    @AuraEnabled(cacheable=true)
    public static MortgagX__Mortgage_Case__c getTotalAffordabilityExpense(Id mortgageCaseId) {
        // Validate input
        if (String.isBlank(mortgageCaseId)) {
            throw new AuraHandledException('Mortgage Case ID cannot be null or blank.');
        }
    
        // Check read access for the MortgagX__Mortgage_Case__c object
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('You do not have permission to read Mortgage Case records.');
        }

        // Check if the user has access to specific fields in MortgagX__Mortgage_Case__c
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.Name.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Name field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('Name');
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Household_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Household Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Household_Expenses__c');
    
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Living_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Living Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Living_Expenses__c');
    
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Lifestyle_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Lifestyle Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Lifestyle_Expenses__c');        
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Transport_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Transport Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Transport_Expenses__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Children_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Children Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Children_Expenses__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Expenditure_Expenses__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Expenditure Expenses field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Expenditure_Expenses__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Clothing_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Clothing Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Clothing_Sum__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Council_Tax_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Council Tax Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Council_Tax_Sum__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Entertainment_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Entertainment Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Entertainment_Sum__c');  
                
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Gambling_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Gambling Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Gambling_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Groceries_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Groceries Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Groceries_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Insurances_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Insurances Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Insurances_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Investments_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Investments Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Investments_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Leisure_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Leisure Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Leisure_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Mortgage_Rent_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Mortgage Rent Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Mortgage_Rent_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Schooling_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Schooling Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Schooling_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Sports_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Sports Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Sports_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Transport_Travel_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Transport Travel Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Transport_Travel_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Travel_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Travel Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Travel_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__TV_Internet_Communication_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the TV Internet Communication Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__TV_Internet_Communication_Sum__c');  
        
        /* if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Utilities_Sum__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Utilities Sum field of the Mortgage Case record.');
        } */
        checkFieldAccessibility('MortgagX__Utilities_Sum__c');  

    try {
        // Perform SOQL query if read access is granted
        List<MortgagX__Mortgage_Case__c> result = [
            SELECT Id, Name, MortgagX__Household_Expenses__c, MortgagX__Living_Expenses__c, MortgagX__Lifestyle_Expenses__c, MortgagX__Transport_Expenses__c, 
            MortgagX__Children_Expenses__c, MortgagX__Expenditure_Expenses__c, MortgagX__Clothing_Sum__c, MortgagX__Council_Tax_Sum__c, MortgagX__Entertainment_Sum__c, 
            MortgagX__Gambling_Sum__c, MortgagX__Groceries_Sum__c, MortgagX__Insurances_Sum__c, MortgagX__Investments_Sum__c, MortgagX__Leisure_Sum__c, 
            MortgagX__Mortgage_Rent_Sum__c, MortgagX__Schooling_Sum__c, MortgagX__Sports_Sum__c, MortgagX__Transport_Travel_Sum__c, MortgagX__Travel_Sum__c, 
            MortgagX__TV_Internet_Communication_Sum__c, MortgagX__Utilities_Sum__c
            FROM MortgagX__Mortgage_Case__c
            WHERE Id = :mortgageCaseId
            LIMIT 1
        ];

        if (result.isEmpty()) {
            throw new AuraHandledException('No Mortgage Case found with the given ID.');
        }

        return result[0];
    } catch (Exception e) {
        throw new AuraHandledException('Error retrieving Mortgage Case: ' + e.getMessage());
    }
}


  // Method to get Affordability records related to the Mortgage Case
  @AuraEnabled(cacheable=true)
  public static List<MortgagX__Affordability__c> getAffordabilityRecords(Id mortgageCaseId) {
      // Validate input
      if (String.isBlank(mortgageCaseId)) {
          throw new AuraHandledException('Mortgage Case ID cannot be null or blank.');
      }

      // Check read access for the MortgagX__Affordability__c object
      if (!Schema.sObjectType.MortgagX__Affordability__c.isAccessible()) {
          throw new AuraHandledException('You do not have permission to read Affordability records.');
      }
        // Check if the user has access to specific fields in MortgagX__Mortgage_Case__c
        if (!Schema.sObjectType.MortgagX__Affordability__c.fields.Name.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Mortgage_Case__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Mortgage_rent__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Clothing__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Council_Tax__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Schooling__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Leisure__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Entertainment__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Gambling__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Groceries__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Insurances__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Investments__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Sports__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Transport_travel__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Travel__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__TV_Internet_Communication__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.fields.MortgagX__Utilities__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access or update one or more fields of the Affordability record.');
        }

      try {
          // Perform SOQL query if read access is granted
          return [
              SELECT Id, Name, MortgagX__Mortgage_Case__c, MortgagX__Mortgage_rent__c, MortgagX__Clothing__c, MortgagX__Council_Tax__c, MortgagX__Schooling__c, MortgagX__Leisure__c, 
              MortgagX__Entertainment__c, MortgagX__Gambling__c, MortgagX__Groceries__c, MortgagX__Insurances__c, MortgagX__Investments__c, MortgagX__Sports__c, 
              MortgagX__Transport_travel__c, MortgagX__Travel__c, MortgagX__TV_Internet_Communication__c, MortgagX__Utilities__c
              FROM MortgagX__Affordability__c
              WHERE MortgagX__Mortgage_Case__c = :mortgageCaseId
          ];
      } catch (Exception e) {
          throw new AuraHandledException('Error retrieving Affordability records: ' + e.getMessage());
      }
  }

  // Method to update the Mortgage Case record
  @AuraEnabled
  public static void updateMortgageCase(MortgagX__Mortgage_Case__c record) {
    
      // Validate input
      if (record == null || String.isBlank(record.Id)) {
          throw new AuraHandledException('Invalid Mortgage Case record.');
      }

      // Check update access for the MortgagX__Mortgage_Case__c object
      if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isUpdateable()) {
          throw new AuraHandledException('You do not have permission to update Mortgage Case records.');
      }

      try {
          // Perform DML update if update access is granted
          update record;
      } catch (DmlException e) {
          throw new AuraHandledException('Failed to update Mortgage Case record: ' + e.getMessage());
      }
  }

}