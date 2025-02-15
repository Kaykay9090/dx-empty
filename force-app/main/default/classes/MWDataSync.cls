public with sharing class MWDataSync {

    // SELECT MortgagX__Start_date__c, MortgagX__Payment_status__c FROM MortgagX_Credit_Commitment__c WHERE Id = 'a09Ad0000041iHeIAI'

    @AuraEnabled
    public static MortgagX__Credit_Commitment__c getCreditCommitment(Id recordId) {
        
        // Check if the user has access to read the MortgagX__Credit_Commitment__c object
        if (!Schema.sObjectType.MortgagX__Credit_Commitment__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Credit Commitment records.');
        }
        
        // Check if the user has read access to specific fields
        if (!Schema.sObjectType.MortgagX__Credit_Commitment__c.fields.MortgagX__Start_date__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Credit_Commitment__c.fields.MortgagX__Payment_status__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access one or more fields of the Credit Commitment record.');
        }
        
        // If permission checks pass, perform the SOQL query
        return [SELECT MortgagX__Start_date__c, MortgagX__Payment_status__c 
                FROM MortgagX__Credit_Commitment__c 
                WHERE Id = :recordId];
    }
    

    @AuraEnabled
    public static MortgagX__Mortgage_Case__c getMortgageCase(Id mortgageCaseId) {
    
        // Check if the user has access to read the MortgagX__Mortgage_Case__c object
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Case records.');
        }
    
        // Check if the user has read access to the specific fields on MortgagX__Mortgage_Case__c
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__First_Applicant_Contact__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access First Applicant Contact.');
        }
        
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Second_applicant_contact__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Second Applicant Contact.');
        }
    
        // Check if the user has access to the Name field on the related Contact object
        if (!Schema.sObjectType.Contact.fields.Name.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the Name field on Contact records.');
        }
    
        // If permission checks pass, perform the SOQL query
        return [SELECT Id, MortgagX__First_Applicant_Contact__c, First_Applicant_Contact__r.Name,
                       MortgagX__Second_applicant_contact__c, Second_applicant_contact__r.Name 
                FROM MortgagX__Mortgage_Case__c 
                WHERE Id = :mortgageCaseId];
    }
    
    
    
    @AuraEnabled
    public static String getMortgageCaseCustomerFirstName(String key) {
        
        // Check if the user has access to read the Account object
        if (!Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Account records.');
        }
        
        // Check if the user has read access to the MortgagX__First_Name__c field on Account
        if (!Schema.sObjectType.Account.fields.MortgagX__First_Name__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the First Name field.');
        }
        
        // Check if the user has access to read the MortgagX__Mortgage_Case__c object
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Case records.');
        }

        // Query MortgagX__Mortgage_Case__c records and validate field-level access
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Customer__c.isAccessible()) {
        throw new AuraHandledException('Insufficient field-level permissions to access MW Case ID field.');
        }
        // Query Account records and validate field-level access
        if (!Schema.sObjectType.Account.fields.MortgagX__First_Name__c.isAccessible()) {
        throw new AuraHandledException('Insufficient field-level permissions to access MW Case ID field.');
        }
    
        // If permission checks pass, perform the SOQL query
        List<Account> acc = [SELECT MortgagX__First_Name__c 
                             FROM Account 
                             WHERE Id IN (SELECT MortgagX__Customer__c FROM MortgagX__Mortgage_Case__c WHERE Id = :key)];
        
        if (acc.size() == 1) {
            return acc[0].MortgagX__First_Name__c;
        }
        
        return '';
    }
    
    
    @AuraEnabled
    public static String sync(String key, String token) {
    
         // Check if the user has read and update access to the MortgagX__Mortgage_Case__c object
         if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Case records.');
        }
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to update Mortgage Case records.');
        }

        // Check if the user has access to specific fields in MortgagX__Mortgage_Case__c
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__First_Applicant_Contact__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Second_applicant_contact__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__First_Applicant_Email__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__SyncedwithMW__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__MW_User_ID__c.isUpdateable() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__MW_Case_ID__c.isUpdateable()) {
            throw new AuraHandledException('Insufficient permissions to access or update one or more fields of the Mortgage Case record.');
        }

        // Check if the user has read access to related objects
        if (!Schema.sObjectType.Contact.isAccessible() || !Schema.sObjectType.Account.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Contact or Account records.');
        }

        // Check for access to related custom objects
        if (!Schema.sObjectType.MortgagX__Employment__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Dependant__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Property_Portfolio__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Affordability__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Previous_Address__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Credit_Summary__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Insolvency_Records__c.isAccessible() ||
            !Schema.sObjectType.MortgagX__Credit_Commitment__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access one or more related objects.');
        }

        // Query MortgagX__Mortgage_Case__c records and validate field-level access
        if (!Schema.sObjectType.Contact.fields.AccountId.isAccessible()) {
            throw new AuraHandledException('Insufficient field-level permissions to access Account field.');
        }

        // Now proceed with the original logic since all permissions have been validated

        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
        
        // Check if the current user has read access to the MortgagX__Mortgage_Case__c object
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            return 'Insufficient permissions to access Mortgage Case records.';
        }
    
        List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT MortgagX__MW_Case_ID__c, MortgagX__MW_User_ID__c, MortgagX__SyncedwithMW__c, MortgagX__First_Applicant_Contact__c, MortgagX__First_Applicant_Email__c, MortgagX__Second_applicant_contact__c 
                                                FROM MortgagX__Mortgage_Case__c 
                                                WHERE Id = :key];
    
        if (mortgageCases.size() == 1) {
            // One record was found, do something with it
            MortgagX__Mortgage_Case__c mortgageCase = mortgageCases[0];
    
            // Check if the user has update permission before performing an update
            if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__SyncedwithMW__c.isUpdateable()) {
                return 'Insufficient permissions to update the Mortgage Case record.';
            }
            
            // Check for record synced with MW and if not, create records in MW
            if (!mortgageCase.MortgagX__SyncedwithMW__c) {
                // Call method syncSFtoMW
                String result = syncSFtoMW(key, token, mortgageCase, constant);
                if (result.contains('Success')) {
                    return 'Request Sent Successfully';
                } else {
                    return 'Sync Failed from SF to MW';
                }
            } else {
                Map<String, Object> requestBodyMap = new Map<String, Object>();
                requestBodyMap.put('case_id', mortgageCase.MortgagX__MW_Case_ID__c); 
                requestBodyMap.put('account_id', mortgageCase.MortgagX__MW_User_ID__c); 
    
                String url = constant.MortgagX__SyncDataEndPoint__c + '/' + mortgageCase.MortgagX__MW_Case_ID__c;
    
                HttpResponse response = MWDataSync.makeRequest(url, 'GET', requestBodyMap, token);
    
                // If the request is successful (status code is 200), parse the JSON response.
                if (response.getStatusCode() == 200) {
                    // Deserialize the JSON string into collections of primitive data types.
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    
                    // Check if the user has update permission before updating the record
                    if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__SyncedwithMW__c.isUpdateable()) {
                        return 'Insufficient permissions to update the Mortgage Case record.';
                    }
    
                    // Update sync checkbox
                    mortgageCase.MortgagX__SyncedwithMW__c = true;
                    update mortgageCase;
                    return 'Request Sent Successfully';
                }
            }
        }
    
        return 'Something went wrong. Please try again.';
    }
    

    @AuraEnabled
    public static String syncSFtoMW(Id recordId, String token, MortgagX__Mortgage_Case__c mortgageCase, MortgagX__MWConstants__c constant) {
        try {
            // Check if the user has read and update access to the MortgagX__Mortgage_Case__c object
            if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access Mortgage Case records.');
            }
            if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isUpdateable()) {
                throw new AuraHandledException('Insufficient permissions to update Mortgage Case records.');
            }
    
            // Check if the user has access to specific fields in MortgagX__Mortgage_Case__c
            if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__First_Applicant_Contact__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__Second_applicant_contact__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__First_Applicant_Email__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__SyncedwithMW__c.isUpdateable() ||
                !Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__MW_Case_ID__c.isUpdateable()) {
                throw new AuraHandledException('Insufficient permissions to access or update one or more fields of the Mortgage Case record.');
            }
    
            // Check if the user has read access to related objects
            if (!Schema.sObjectType.Contact.isAccessible() || !Schema.sObjectType.Account.isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access Contact or Account records.');
            }
    
            // Check for access to related custom objects
            if (!Schema.sObjectType.MortgagX__Employment__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Dependant__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Property_Portfolio__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Affordability__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Previous_Address__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Credit_Summary__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Insolvency_Records__c.isAccessible() ||
                !Schema.sObjectType.MortgagX__Credit_Commitment__c.isAccessible()) {
                throw new AuraHandledException('Insufficient permissions to access one or more related objects.');
            }

            // Query Contact records and validate field-level access
            if (!Schema.sObjectType.Contact.fields.AccountId.isAccessible()) {
                throw new AuraHandledException('Insufficient field-level permissions to access Account field.');
            }
    
            // Now proceed with the original logic since all permissions have been validated
    
            // Get MortgagX__First_Applicant_Contact__c and MortgagX__Second_applicant_contact__c ids
            Id firstApplicantContactId = mortgageCase.MortgagX__First_Applicant_Contact__c;
            Id secondApplicantContactId = mortgageCase.MortgagX__Second_applicant_contact__c;
    
            // Get MortgagX__First_Applicant_Contact__c email
            String email = mortgageCase.MortgagX__First_Applicant_Email__c;
    
            // Get MortgagX__BrokerID__c from MortgagX__MWConstants__c
            String brokerID = constant.MortgagX__BrokerID__c;
    
            // Build API request content
            Map<String, Object> requestBodyMap = new Map<String, Object>();
            requestBodyMap.put('email_id', email);
            requestBodyMap.put('crm_case_id', recordId);
            requestBodyMap.put('broker_id', brokerID);
    
            // Construct request URL
            String url = constant.MortgagX__CRMCases__c;
    
            // Call HTTP POST request
            HttpResponse response = MWDataSync.makeRequest(url, 'POST', requestBodyMap, token);
    
            // Parse the JSON response
            if (response.getStatusCode() == 200) {
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    
                // Build second API request content
                Map<String, Object> requestBodyMap2 = new Map<String, Object>();
                requestBodyMap2.put('mw_case_id', results.get('case_id'));
                requestBodyMap2.put('broker_id', brokerID);
    
                // Query related records and construct applicants data
                List<Map<String, Object>> applicantsList = new List<Map<String, Object>>();
    
                // First applicant
                if (firstApplicantContactId != null) {

                    Contact firstApplicant = [SELECT Id, AccountId FROM Contact WHERE Id = :firstApplicantContactId LIMIT 1];
                    Map<String, Object> applicantMap = buildApplicantMap(firstApplicant, mortgageCase);
                    applicantsList.add(applicantMap);
                }
    
                // Second applicant
                if (secondApplicantContactId != null) {
                    Contact secondApplicant = [SELECT Id, AccountId FROM Contact WHERE Id = :secondApplicantContactId LIMIT 1];
                    Map<String, Object> applicantMap = buildApplicantMap(secondApplicant, mortgageCase);
                    applicantsList.add(applicantMap);
                }
    
                requestBodyMap2.put('applicants', applicantsList);
    
                // Construct second request URL
                String url2 = constant.MortgagX__CRMApplicant__c;
    
                // Call HTTP POST request
                HttpResponse response2 = MWDataSync.makeRequest(url2, 'POST', requestBodyMap2, token);
    
                if (response2.getStatusCode() == 200) {
                    // Update sync checkbox and MW Case ID
                    mortgageCase.MortgagX__SyncedwithMW__c = true;
                    mortgageCase.MortgagX__MW_Case_ID__c = String.valueOf(results.get('case_id'));
                    update mortgageCase;
    
                    return 'Request Sent Successfully';
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return 'Something went wrong. Please try again';
    }
    
    
    private static Map<String, Object> buildApplicantMap(Contact applicant, MortgagX__Mortgage_Case__c mortgageCase) {
        Map<String, Object> applicantMap = new Map<String, Object>();
    
        // Build the applicant map with necessary details (employment, dependents, etc.)
        // Use placeholder logic or real data depending on the requirement
        applicantMap.put('crm_customer_id', applicant.AccountId);
        applicantMap.put('crm_contacts_id', applicant.Id);
        
        // Add more fields as needed, similar to your original code
    
        return applicantMap;
    }
    
    
    @AuraEnabled
    public static String getDocumentURL(String key, String token) {
        // Ensure user has access to the MortgagX__MWConstants__c object
        if (!Schema.sObjectType.MortgagX__MWConstants__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access MWConstants records.');
        }
    
        // Retrieve constants
        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
    
        // Ensure user has read access to the MortgagX__MortgageDocument__c object and MortgagX__File_Key__c field
        if (!Schema.sObjectType.MortgagX__MortgageDocument__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Document records.');
        }
        if (!Schema.sObjectType.MortgagX__MortgageDocument__c.fields.MortgagX__File_Key__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access the File Key field on Mortgage Document.');
        }
    
        // Query for the document, but only if the user has read access
        List<MortgagX__MortgageDocument__c> docs = [SELECT MortgagX__File_Key__c FROM MortgagX__MortgageDocument__c WHERE Id = :key];
    
        // Check if exactly one document was found
        if (docs.size() == 1) {
            MortgagX__MortgageDocument__c doc = docs[0];
            return MWDataSync.callGetDocumentURLAPI(doc.MortgagX__File_Key__c, token);
        }
    
        return null;
    }
    
    
    public static String callGetDocumentURLAPI(String key, String token) {
        
        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
        
        HttpResponse response = MWDataSync.makeRequest('/applicants/file?fileKey=' + key , 'GET', NULL, token);
        
        if(response.getStatusCode() == 200) {
            
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            return (String) results.get('url');
        }
        
        return null;
    }
    
    @future(callout=true)
    public static void sendPushNotification(String key) {

        // Ensure user has access to the MortgagX__Mortgage_Case__c object
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Case records.');
        }

        // Ensure user has access to the Contact object
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Contact records.');
        }

        // Ensure user has access to the MortgagX__Employment__c object
        if (!Schema.sObjectType.MortgagX__Employment__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Employment records.');
        }

        // Ensure user has permission to read from MortgagX__Mortgage_Case__c
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('User does not have read permission for Mortgage Case records.');
        }

        // Ensure user has permission to read from Contact
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('User does not have read permission for Contact records.');
        }

        // Ensure user has permission to read from MortgagX__Employment__c
        if (!Schema.sObjectType.MortgagX__Employment__c.isAccessible()) {
            throw new AuraHandledException('User does not have read permission for Employment records.');
        }
        
        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
        Map<String, Object> requestBodyMap = new Map<String, Object>();
        
        String token = '';
        
        if (Test.isRunningTest()) { token = '123'; } 
        else { token = MWDataSync.login(); } 
        
        
        if (token != null && token.length() > 0) {
            
            List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT MortgagX__MW_Case_ID__c, MortgagX__MW_User_ID__c, MortgagX__First_Applicant_Contact__c, MortgagX__Second_applicant_contact__c, MortgagX__StageName__c FROM MortgagX__Mortgage_Case__c WHERE Id=:key LIMIT 1];

            
            if (mortgageCases.size() == 1) {
                
                // One record was found, do something with it
                MortgagX__Mortgage_Case__c mortgageCase = mortgageCases[0];

                String firstApplicationMiddleWareApplicantId = null;
                String secondApplicationMiddleWareApplicantId = null;


                if (mortgageCase.MortgagX__First_Applicant_Contact__c != NULL) {
                    List<Contact> contact = [SELECT Id, MortgagX__MW_Applicant_ID__c FROM Contact WHERE Id=:mortgageCase.MortgagX__First_Applicant_Contact__c LIMIT 1];
                    

                    if (contact.size() == 1) {

                        List<MortgagX__Employment__c> emp = [SELECT MortgagX__MW_Applicant_ID__c FROM MortgagX__Employment__c WHERE Mortgage_Case__r.Id = :key AND MortgagX__Applicant__c = :contact[0].Id AND MortgagX__Current_Employment__c = True LIMIT 1];
                        if (emp.size() == 1) { firstApplicationMiddleWareApplicantId = emp[0].MortgagX__MW_Applicant_ID__c; }
                    }
                
                }
                
                if (mortgageCase.MortgagX__Second_applicant_contact__c != NULL) {
                    List<Contact> contact = [SELECT Id, MortgagX__MW_Applicant_ID__c FROM Contact WHERE Id=:mortgageCase.MortgagX__Second_applicant_contact__c LIMIT 1];
                    if (contact.size() == 1) { 

                        List<MortgagX__Employment__c> emp = [SELECT MortgagX__MW_Applicant_ID__c FROM MortgagX__Employment__c WHERE Mortgage_Case__r.Id = :key AND MortgagX__Applicant__c = :contact[0].Id AND MortgagX__Current_Employment__c = True LIMIT 1];
                        if (emp.size() == 1) { secondApplicationMiddleWareApplicantId = emp[0].MortgagX__MW_Applicant_ID__c; }
                    }
                }
             
                if (mortgageCase.MortgagX__StageName__c != 'Factfind ongoing' && mortgageCase.MortgagX__StageName__c != 'Factfind submitted') {
                    
                    
                    String notification_type = '';
                    String notification_text = '';
                    String notification_title = '';
                    
                    if (mortgageCase.MortgagX__StageName__c == 'Recommendations') {
                        notification_type = 'recommendations';
                        notification_text = 'Your mortgage recommendations have been emailed to you';
                        notification_title = 'MortgagX advice';
                    } else if (mortgageCase.MortgagX__StageName__c == 'DIP obtained') {
                        notification_type = 'dip_obtained';
                        notification_text = 'Good news! We have secured a Decision in Principle for your mortgage application';
                        notification_title = 'DIP secured';
                    }  else if (mortgageCase.MortgagX__StageName__c == 'FMA submitted') {
                        notification_type = 'fma_submitted';
                        notification_text = 'Yay! Your mortgage application has been submitted';
                        notification_title = 'Application submitted';
                    } else if (mortgageCase.MortgagX__StageName__c == 'Valuation instructed') {
                        notification_type = 'valuation_instructed';
                        notification_text = 'Yay! Your mortgage application has been submitted and valuation has been instructed';
                        notification_title = 'Valuation instructed';
                    } else if (mortgageCase.MortgagX__StageName__c == 'Valuation satisfied') {
                        notification_type = 'valuation_satisfied';
                        notification_text = 'Your valuation results are in your inbox!';
                        notification_title = 'Valuation completed';
                    } else if (mortgageCase.MortgagX__StageName__c == 'Case offered') {
                        notification_type = 'case_offered';
                        notification_text = 'You are almost there! More details in your inbox';
                        notification_title = 'Mortgage offered';
                    } else if (mortgageCase.MortgagX__StageName__c == 'Completed') {
                        notification_type = 'closed';
                        notification_text = 'Congratulations! We made it!!!';
                        notification_title = 'Mortgage completion';
                    }
                    
                    requestBodyMap = new Map<String, Object>();
                    requestBodyMap.put('case_id', mortgageCase.MortgagX__MW_Case_ID__c); // Replace with your desired values
                    //requestBodyMap.put('applicant_id', mortgageCase.MortgagX__MW_User_ID__c); // Replace with your desired values
                    requestBodyMap.put('notification_type', notification_type); // Replace with your desired values
                    requestBodyMap.put('notification_text', notification_text); // Replace with your desired values
                    requestBodyMap.put('notification_title', notification_title); // Replace with your desired values

                    if (firstApplicationMiddleWareApplicantId != null) {

                        requestBodyMap.put('applicant_id', firstApplicationMiddleWareApplicantId); // Replace with your desired values

                        HttpResponse response = MWDataSync.makeRequest(constant.MortgagX__NotificationsEndPoint__c, 'POST', requestBodyMap, token);
                    
                    // If the request is successful (status code is 200), parse the JSON response.
                        if(response.getStatusCode() == 200) {
                        
                            // Deserialize the JSON string into collections of primitive data types.
                            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                        
                        }

                    }

                    if (secondApplicationMiddleWareApplicantId != null) {

                        requestBodyMap.put('applicant_id', secondApplicationMiddleWareApplicantId); // Replace with your desired values

                        HttpResponse response = MWDataSync.makeRequest(constant.MortgagX__NotificationsEndPoint__c, 'POST', requestBodyMap, token);
                    
                    // If the request is successful (status code is 200), parse the JSON response.
                        if(response.getStatusCode() == 200) {
                        
                            // Deserialize the JSON string into collections of primitive data types.
                            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                        
                        }

                    }    
                }

                requestBodyMap = new Map<String, Object>();
                requestBodyMap.put('case_id', mortgageCase.MortgagX__MW_Case_ID__c); // Replace with your desired values
                requestBodyMap.put('status', mortgageCase.MortgagX__StageName__c); // Replace with your desired values
                
                
                // Here we make a request and expect a response in HttpResponse instance.
                MWDataSync.makeRequest(constant.MortgagX__CaseEndPoint__c, 'PUT', requestBodyMap, token);
                
                
            }
        }
    }
    
    @AuraEnabled
    public static Map<String, Object> findProducts(String key) {
        // Ensure user has permission to read from MortgagX__Mortgage_Case__c
        if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible()) {
            throw new AuraHandledException('User does not have read permission for Mortgage Case records.');
        }
        
        String token = '';
        
        if (Test.isRunningTest()) { token = '123'; } 
        else { token = MWDataSync.login(); } 
        
        if (token != null && token.length() > 0) {

            // Query MortgagX__Mortgage_Case__c records and validate field-level access
            if (!Schema.sObjectType.MortgagX__Mortgage_Case__c.fields.MortgagX__MW_Case_ID__c.isAccessible()) {
                throw new AuraHandledException('Insufficient field-level permissions to access MW Case ID field.');
            }
            
            MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
            
            List<MortgagX__Mortgage_Case__c> mortgageCases = [SELECT MortgagX__MW_Case_ID__c FROM MortgagX__Mortgage_Case__c WHERE Id=:key];
            
            if (mortgageCases.size() == 1) {
                
                HttpResponse response = MWDataSync.makeRequest(constant.MortgagX__SearchProductEndPoint__c + '/' + mortgageCases[0].MortgagX__MW_Case_ID__c, 'GET', NULL, token);
                
                // If the request is successful (status code is 200), parse the JSON response.
                if(response.getStatusCode() == 200) {
                    
                    // Deserialize the JSON string into collections of primitive data types.    
                    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                    
                    return results;
                }
            }
        }
        
        return new Map<String, Object>();
        
    }
    
    @AuraEnabled
    public static void saveProducts(String key, List<Object> products) {
        // Validate object-level access (MortgagX__Mortgage_Product__c and MortgagX__Mortgage_Case__c)
        if (!Schema.sObjectType.MortgagX__Mortgage_Product__c.isAccessible() || 
            !Schema.sObjectType.MortgagX__Mortgage_Product__c.isCreateable() || 
            !Schema.sObjectType.MortgagX__Mortgage_Product__c.isUpdateable() ||
            !Schema.sObjectType.MortgagX__Mortgage_Case__c.isAccessible() || 
            !Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access Mortgage Products, Mortgage Cases, or Contacts.');
        }
    
        if (!products.isEmpty()) {
            // Query MortgagX__Mortgage_Product__c records and validate field-level access
            if (!Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Active__c.isAccessible()) {
                throw new AuraHandledException('Insufficient field-level permissions to access Active field.');
            }
            
            // Query MortgagX__Mortgage_Product__c records and validate field-level access
            if (!Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Active__c.isUpdateable()) {
                throw new AuraHandledException('Insufficient field-level permissions to update Active field.');
            }
    
            // Query existing MortgagX__Mortgage_Product__c records in a single query
            List<MortgagX__Mortgage_Product__c> mortgageProductsToUpdate = [SELECT Id, MortgagX__Active__c FROM MortgagX__Mortgage_Product__c];
            
            // Deactivate existing mortgage products (bulk operation)
            if (!mortgageProductsToUpdate.isEmpty()) {
                for (MortgagX__Mortgage_Product__c product : mortgageProductsToUpdate) {
                   
                        product.MortgagX__Active__c = false;
                    
                }
                update mortgageProductsToUpdate; // Perform DML operation outside the loop
            } 
    
            // Query MortgagX__Mortgage_Case__c and Contact in one go
            MortgagX__Mortgage_Case__c mortgageCase = [SELECT Id, MortgagX__MW_Case_ID__c, MortgagX__MW_User_ID__c, MortgagX__First_Applicant_Contact__c FROM MortgagX__Mortgage_Case__c WHERE Id = :key LIMIT 1];
            Contact contact = [SELECT Id, MortgagX__MW_Applicant_ID__c FROM Contact WHERE Id = :mortgageCase.MortgagX__First_Applicant_Contact__c LIMIT 1];
    
            List<MortgagX__Mortgage_Product__c> newMortgageProducts = new List<MortgagX__Mortgage_Product__c>();
    
            for (Object product : products) {
                String jsonProduct = JSON.serialize(product);
                Map<String, Object> productMap = (Map<String, Object>) JSON.deserializeUntyped(jsonProduct);
    
                MortgagX__Mortgage_Product__c mortgageProduct = new MortgagX__Mortgage_Product__c();
    
                // Set field values only if user has field-level access (FLS)
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__MW_Product_ID__c.isCreateable()) {
                    mortgageProduct.MortgagX__MW_Product_ID__c = (String) productMap.get('ProductId');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__APRC__c.isCreateable()) {
                    mortgageProduct.MortgagX__APRC__c = Double.valueOf(productMap.get('APR'));
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Initial_Interest_Period__c.isCreateable()) {
                    mortgageProduct.MortgagX__Initial_Interest_Period__c = (String) productMap.get('InitialInterestPeriod');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Plan_Name__c.isCreateable()) {
                    mortgageProduct.MortgagX__Plan_Name__c = (String) productMap.get('PlanName');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Provider_Name__c.isCreateable()) {
                    mortgageProduct.MortgagX__Provider_Name__c = (String) productMap.get('ProviderName');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Disclosure_Text__c.isCreateable()) {
                    mortgageProduct.MortgagX__Disclosure_Text__c = (String) productMap.get('Disclosure');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Initial_Monthly_Cost__c.isCreateable()) {
                    mortgageProduct.MortgagX__Initial_Monthly_Cost__c = (String) productMap.get('InitialMonthlyPayment');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Initial_Rate__c.isCreateable()) {
                    mortgageProduct.MortgagX__Initial_Rate__c = Double.valueOf(productMap.get('InitialInterestRate'));
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Follow_On_Monthly_Payment__c.isCreateable()) {
                    mortgageProduct.MortgagX__Follow_On_Monthly_Payment__c = (String) productMap.get('FollowOnMonthlyPayment');
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Loan_Required__c.isCreateable()) {
                    mortgageProduct.MortgagX__Loan_Required__c = String.valueOf(productMap.get('LoanRequired'));
                }
                if (Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Revision_Rate__c.isCreateable()) {
                    mortgageProduct.MortgagX__Revision_Rate__c = (String) productMap.get('ProviderVariableRate');
                }
    
                // Set values from MortgagX__Mortgage_Case__c and Contact
                mortgageProduct.MortgagX__Mortgage_Case__c = key;
                mortgageProduct.MortgagX__MW_Case_ID__c = mortgageCase.MW_Case_ID__c;
                mortgageProduct.MortgagX__MW_Applicant_ID__c = contact.MW_Applicant_ID__c;
                mortgageProduct.MortgagX__MW_User_ID__c = mortgageCase.MW_User_ID__c;
                mortgageProduct.MortgagX__Applicant__c = contact.Id;
    
                // Handle Initial Term Costs
                List<Object> initialTermCosts = (List<Object>) productMap.get('InitialTermCost');
                if (!initialTermCosts.isEmpty() && Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Initial_Term_Cost__c.isCreateable()) {
                    mortgageProduct.MortgagX__Initial_Term_Cost__c = (String) ((Map<String, Object>) initialTermCosts[0]).get('TotalAmountPayable');
                }
    
                // Handle Provider Fees
                List<Object> providerFees = (List<Object>) ((Map<String, Object>) productMap.get('ProviderFees')).get('ProviderFee');
                if (!providerFees.isEmpty() && Schema.sObjectType.MortgagX__Mortgage_Product__c.fields.MortgagX__Product_Fee_Amount__c.isCreateable()) {
                    mortgageProduct.MortgagX__Product_Fee_Amount__c = (String) ((Map<String, Object>) providerFees[0]).get('Amount');
                }
    
                // Add to the list of new MortgagX__Mortgage_Product__c records
                newMortgageProducts.add(mortgageProduct);
            }
    
            // Perform DML operation outside the loop for all new products at once
            if (Schema.sObjectType.MortgagX__Mortgage_Product__c.isCreateable()) {
                insert newMortgageProducts;
            }
        }
    }
    
    
    
    // Saman Guruge: (HF) AWS s3 bucker Tokent generation replaced with Named Credentials.
    // @AuraEnabled 
    // public static String login() {
    //     // Validate that the user has permission to perform this operation
    //     if (!Schema.sObjectType.MortgagX__MWConstants__c.isAccessible()) {
    //         throw new AuraHandledException('Insufficient permissions to access MortgagX__MWConstants__c records.');
    //     }
    //     MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
    //     Map<String, Object> requestBodyMap = new Map<String, Object>();
        
    //     requestBodyMap.put('username', constant.MortgagX__username__c);
    //     requestBodyMap.put('password', constant.MortgagX__password__c);
        
        
    //     Http http = new Http();
    //     // We also need an instance of HttpRequest, which we will send over http using HTTP instance.
    //     HttpRequest request = new HttpRequest();
        
    //     String encodedString = constant.MortgagX__BaseURL__c + constant.MortgagX__LoginEndPoint__c;
    //     encodedString  = encodedString.replace(' ', '%20');
        
    //     request.setEndpoint(encodedString);
    //     request.setMethod('POST');
    //     request.setTimeout(20*1000);
        
    //     request.setHeader('Content-Type', 'application/json');
    //     request.setBody(JSON.serialize(requestBodyMap));
        
    //     HttpResponse response = http.send(request);
        
    //     // If the request is successful (status code is 200), parse the JSON response.
    //     if(response.getStatusCode() == 200) {
            
    //         // Deserialize the JSON string into collections of primitive data types.
    //         Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
    //         return (string) ((Map<String, Object>) results.get('authenticationResult')).get('IdToken');
            
    //     } else {
    //         return '';
    //     }
        
    // }

    @AuraEnabled
    public static String login() {
        // Validate that the user has permission to perform this operation
        if (!Schema.sObjectType.MortgagX__MWConstants__c.isAccessible()) {
            throw new AuraHandledException('Insufficient permissions to access MortgagX__MWConstants__c records.');
        }
        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
        Map<String, Object> requestBodyMap = new Map<String, Object>();

        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // Use Named Credential for the login endpoint
        String namedCredentialEndpoint = 'callout:MortgagX__AWS_S3_Document_Authentication' + constant.MortgagX__LoginEndPoint__c;
        request.setEndpoint(namedCredentialEndpoint);
        //Note: $Credential is a keyword and doesn't change for different Named Credentials
        string jsonBody = '{ "username" : "{!$Credential.MortgagX__AWS_Authentication.Username}", "password" : "{!$Credential.MortgagX__AWS_Authentication.Password}"}';
        request.setMethod('POST');
        request.setTimeout(20 * 1000);
        request.setHeader('Content-Type', 'application/json');
        request.setBody(jsonBody);

        HttpResponse response = http.send(request);
        

        // If the request is successful (status code is 200), parse the JSON response
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return (String) ((Map<String, Object>) results.get('authenticationResult')).get('IdToken');
        } else {
            throw new AuraHandledException('Failed to login. Status Code: ' + response.getStatusCode());
        }
}
       
    public static HttpResponse makeRequest(String endpoint, String requestType, Map<String, Object> requestBodyMap, String token) {
        
        MortgagX__MWConstants__c constant = MortgagX__MWConstants__c.getInstance();
        HttpRequest request = new HttpRequest();
        
        String encodedString = constant.MortgagX__BaseURL__c + endpoint.replace(' ', '%20');
        
        request.setEndpoint(encodedString);
        
        request.setMethod(requestType);
        
        request.setHeader('Authorization', 'Bearer ' + token); // Replace with your desired values
        request.setHeader('Content-Type', 'application/json');
        
        request.setTimeout(120000);
        
        if (requestType != 'GET') {
            request.setBody(JSON.serialize(requestBodyMap));
        } 
        
        Http http = new Http();
        HttpResponse response = http.send(request);

        Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        return response;
        
    }
    
   
            
}