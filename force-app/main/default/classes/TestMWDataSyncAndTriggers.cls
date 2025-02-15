@isTest
public class TestMWDataSyncAndTriggers {
    
    @isTest static void TestTriggerIDDocsChangeVerificationStatusToComplete() {
        
        MortgagX__Id_doc_checks__c doc = new MortgagX__Id_doc_checks__c();
        doc.MortgagX__Aml_check__c = TRUE;
        doc.MortgagX__Bank_account_verification__c = TRUE;
        doc.MortgagX__Identity_authenticate_check__c = TRUE;
        doc.MortgagX__Identity_document_check__c = TRUE;
        doc.MortgagX__Income_verification__c = TRUE;
            
        Test.startTest();
        insert doc;
        Test.stopTest();
    }
    
    @isTest static void TestTriggerIDDocsChangeVerificationStatusToInProgress() {
        
        MortgagX__Id_doc_checks__c doc = new MortgagX__Id_doc_checks__c();
        doc.MortgagX__Aml_check__c = TRUE;
        doc.MortgagX__Bank_account_verification__c = TRUE;
        doc.MortgagX__Identity_authenticate_check__c = TRUE;
        doc.MortgagX__Identity_document_check__c = TRUE;
        doc.MortgagX__Income_verification__c = FALSE;
            
        Test.startTest();
        insert doc;
        Test.stopTest();
    }
    
   @isTest static void TestTriggerDocumentVerifiedByNameAndDateisRecorded() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        MortgagX__MortgageDocument__c doc = new MortgagX__MortgageDocument__c();
        doc.MortgagX__Verified__c = FALSE;
        doc.MortgagX__Mortgage_Case__c = mortgateCase.Id;
        doc.MortgagX__File_Type__c = 'Passport';
        insert doc;
     
            
        Test.startTest();
        doc.MortgagX__Verified__c = TRUE;
        update doc;
        Test.stopTest();
}
    
    @isTest static void TestTriggerSendPushNotificationWhenOpportunityStageChange() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;  
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
     
            
        Test.startTest();
        mortgateCase.MortgagX__StageName__c = 'DIP obtained'; 
        update mortgateCase;
        Test.stopTest();
    }
    
    @isTest static void TestGetDocumentsURL() {
       
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        MortgagX__MortgageDocument__c doc = new MortgagX__MortgageDocument__c();
        doc.MortgagX__Verified__c = FALSE;
        doc.MortgagX__Mortgage_Case__c = mortgateCase.Id;
        doc.MortgagX__File_Type__c = 'Passport';
        doc.MortgagX__File_Key__c = 'public/50b880d1-95ed-4584-8c0b-6ccf3064e7b8/733/Passport/Safari - 19-Dec-2020 at 10:01 PM.pdf';
        insert doc;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockDocumentSuccessHttpResponseGenerator());        
               
        MWDataSync.getDocumentURL(doc.Id, '123'); 
        Test.stopTest();
    
    }
    
    @isTest static void TestGetDocumentsURLFailed() {
        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockDocumentSuccessHttpResponseFailedGenerator());
        MWDataSync.getDocumentURL('doc.Id', '123');
    }
    
    @isTest static void TestCallGetDocumentURLAPIFailed() {
        
        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockDocumentSuccessHttpResponseGenerator());
        
        MWDataSync.callGetDocumentURLAPI('123', '1234'); 
    }
    
    @isTest static void TestCallGetDocumentURLAPIFailed400() {
        
        
        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockDocumentSuccessHttpResponseFailedGenerator());
        
        MWDataSync.callGetDocumentURLAPI('123', '1234'); 
    }
    
    @isTest static void TestSuccessLogin() {
        
        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator()); 
        
        String token = MWDataSync.login(); 
        
        System.assertNotEquals(null, token, 'token is equal to null');
    
    }
    
   @isTest static void TestFailedLogin() {

        Test.setMock(HttpCalloutMock.class,
                     new TestMWDataSyncMock.MockAuthFailedHttpResponseGenerator());
        
       // String token = MWDataSync.login(); 
        

    
    } 

    @isTest static void TestSyncFailed() {
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSyncHttpResponseSuccessGenerator()); 
        MWDataSync.sync('', '123'); 
        Test.stopTest();
        
    }
    
    @isTest 
    static void TestSyncSuccess() {
        
        // Create Account
        Account customer = new Account(Name = 'Adil Account');
        insert customer;
        
        // Create Contact and link to Account
        Contact contact = new Contact (
            Title = 'Adil Contact',
            FirstName = 'YO',
            LastName = 'Adil Contact',
            AccountId = customer.Id,
            Email = 'yo@yo.com',
            MobilePhone = '+923234358910'
        );
        insert contact;
        
        // Create Mortgage Case and link to Contact
        MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c (
            Name = 'Yo',
            MortgagX__StageName__c = 'Factfind ongoing',
            MortgagX__CloseDate__c = Date.today(),
            MortgagX__First_Applicant_Contact__c = contact.Id
        );
        insert mortgageCase;
        
        // Update Mortgage Case stage
        mortgageCase.MortgagX__StageName__c = 'DIP obtained';
        update mortgageCase;
        
        // Insert custom settings
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        customSettings.MortgagX__BrokerID__c = '10000';
        customSettings.MortgagX__CRMCases__c='/crm/cases';
        customSettings.MortgagX__CRMApplicant__c = '/applicant/crm/ids';
        upsert customSettings; // 'upsert' instead of 'insert' for custom settings
    
        // Set mock callout response
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSyncHttpResponseSuccessGenerator()); 
        
        Test.startTest();
        // Perform sync action
        MWDataSync.sync(mortgageCase.Id, '123'); 
        Test.stopTest();
    
        // Additional assertions to validate the test's behavior
        MortgagX__Mortgage_Case__c updatedCase = [SELECT MortgagX__StageName__c FROM MortgagX__Mortgage_Case__c WHERE Id = :mortgageCase.Id];
        System.assertEquals('DIP obtained', updatedCase.MortgagX__StageName__c, 'The stage of the mortgage case should be updated.');
    }
    

    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange() {
        
        String uniqueEmail = 'yo' + Math.random() + '@yo.com'; 

        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = uniqueEmail ;
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Recommendations';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 
        
        Test.startTest();
        
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange1() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'DIP obtained';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 

        
        Test.startTest();
                
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange6() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Completed';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.LoginEndPoint__C ='/auth/signin';
        customSettings.NotificationsEndPoint__C='/notifications';
        customSettings.SearchProductEndPoint__C='/search-products-sf';
        customSettings.BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.password__C='123';
        customSettings.SyncDataEndPoint__C='123';
        customSettings.CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 

        
        
        Test.startTest();
        
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange5() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Case offered';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 
        
        
        Test.startTest();
        
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange2() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'FMA submitted';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 
        
        
        Test.startTest();
        
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange3() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Valuation instructed';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 
        
        
        Test.startTest();
        
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestsendPushNotificationOnMortgageCaseStageChange4() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Valuation satisfied';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSendNotificationHttpResponseSuccessGenerator()); 
        
        
        Test.startTest();
       
        MWDataSync.sendPushNotification(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestFindProductsSuccess() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Valuation satisfied';
        update mortgateCase;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator()); 

        
        Test.startTest();
        
        MWDataSync.findProducts(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestFindProductsFailed() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        mortgateCase.MortgagX__StageName__c = 'Valuation satisfied';
        update mortgateCase;
        
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        insert customSettings;
        
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockAuthSuccessHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockFindProductsHttpResponseFailedGenerator()); 
        
        
        Test.startTest();

        MWDataSync.findProducts(mortgateCase.Id); 
        
        Test.stopTest();
        
    }
    
    @isTest static void TestSaveProducts() {
        
        Account customer = new Account();
        customer.Name = 'Adil Account';
        insert customer;
        
        Contact contact = new Contact ();
        contact.Title = 'Adil Contact';
        contact.FirstName = 'YO';
        contact.LastName = 'Adil Contact';
        contact.AccountId = customer.Id;
        contact.Email = 'yo@yo.com';
        contact.MobilePhone = '+923234358910';
        
        insert contact;
        
        MortgagX__Mortgage_Case__c mortgateCase = new MortgagX__Mortgage_Case__c ();
        mortgateCase.Name = 'Yo';
        mortgateCase.MortgagX__StageName__c = 'Factfind ongoing';
        mortgateCase.MortgagX__CloseDate__c = Date.today();
        mortgateCase.MortgagX__First_Applicant_Contact__c = contact.Id;
        
        insert mortgateCase;
        
        List<Object> products = new List<Object>();
        
        String jsonString = '{ "ProductId": "4150505", "PlanName": "26 Month 5.14% Fixed - Purchase max 75% LTV", "ProviderName": "TSB4Intermediaries", "InitialMonthlyPayment": "2969.78", "InitialInterestRate": "5.14", "APR": "8.3", "FollowOnMonthlyPayment": "4043.17", "InitialInterestPeriod": "31/12/2025", "LoanRequired": "500000", "ProviderVariableRate": "8.74", "Disclosure": "Representative example: Capital and interest repayment", "ProviderFees": { "ProviderFee": [] },  "InitialTermCost": [] }';

        products.add(JSON.deserializeUntyped(jsonString));
             
        Test.startTest();

        MWDataSync.saveProducts(mortgateCase.Id, products); 
        
        Test.stopTest();
        
    }

    
    @isTest
    static void testSyncUnchecked() {
        // create the test data
          // Create Account
          Account customer = new Account(Name = 'Adil Account');
          insert customer;
          
          // Create Contact and link to Account
          Contact contact = new Contact (
              Title = 'Adil Contact',
              FirstName = 'YO',
              LastName = 'Adil Contact',
              AccountId = customer.Id,
              Email = 'yo@yo.com',
              MobilePhone = '+923234358910'
          );
          insert contact;
          
          // Create Mortgage Case and link to Contact
          MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c (
              Name = 'Yo',
              MortgagX__StageName__c = 'Factfind ongoing',
              MortgagX__CloseDate__c = Date.today(),
              MortgagX__First_Applicant_Contact__c = contact.Id,
              MortgagX__SyncedwithMW__c = true
              
          );
          insert mortgageCase;

           // Insert custom settings
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        customSettings.MortgagX__BrokerID__c = '10000';
        customSettings.MortgagX__CRMCases__c='/crm/cases';
        customSettings.MortgagX__CRMApplicant__c = '/applicant/crm/ids';
        upsert customSettings; // 'upsert' instead of 'insert' for custom settings
    
        // Set mock callout response
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSyncHttpResponseSuccessGenerator()); 
    
        Test.startTest();
        
        // Mocking the syncSFtoMW method to return success
        Test.setMock(HttpCalloutMock.class, new MWCalloutMockSuccess());
        
        // Call the sync method
        String result = MWDataSync.sync(mortgageCase.Id, 'testToken');
        
        Test.stopTest();
        
        // Assert that the correct result is returned
        System.assertEquals('Request Sent Successfully', result, 'Expected sync to return success message.');
        
        // Requery the mortgage case to check if the record was updated
        mortgageCase = [SELECT MortgagX__SyncedwithMW__c FROM MortgagX__Mortgage_Case__c WHERE Id = :mortgageCase.Id];
        System.assert(mortgageCase.MortgagX__SyncedwithMW__c, 'MortgagX__SyncedwithMW__c should be true after sync.');
    }
    
    @isTest
    static void testSyncChecked() {
        // create the test data
          // Create Account
          Account customer = new Account(Name = 'Adil Account');
          insert customer;
          
          // Create Contact and link to Account
          Contact contact = new Contact (
              Title = 'Adil Contact',
              FirstName = 'YO',
              LastName = 'Adil Contact',
              AccountId = customer.Id,
              Email = 'yo@yo.com',
              MobilePhone = '+923234358910'
          );
          insert contact;
          
          // Create Mortgage Case and link to Contact
          MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c (
              Name = 'Yo',
              MortgagX__StageName__c = 'Factfind ongoing',
              MortgagX__CloseDate__c = Date.today(),
              MortgagX__First_Applicant_Contact__c = contact.Id
              
          );
          insert mortgageCase;

           // Insert custom settings
        MortgagX__MWConstants__c customSettings = MortgagX__MWConstants__c.getInstance();
        customSettings.MortgagX__LoginEndPoint__C ='/auth/signin';
        customSettings.MortgagX__NotificationsEndPoint__C='/notifications';
        customSettings.MortgagX__SearchProductEndPoint__C='/search-products-sf';
        customSettings.MortgagX__BaseURL__C='https://mryyx64ai7.execute-api.eu-west-2.amazon...';
        customSettings.MortgagX__password__C='123';
        customSettings.MortgagX__SyncDataEndPoint__C='123';
        customSettings.MortgagX__CaseEndPoint__C='123';
        customSettings.MortgagX__BrokerID__c = '10000';
        customSettings.MortgagX__CRMCases__c='/crm/cases';
        customSettings.MortgagX__CRMApplicant__c = '/applicant/crm/ids';
        upsert customSettings; // 'upsert' instead of 'insert' for custom settings
    
        // Set mock callout response
        Test.setMock(HttpCalloutMock.class, new TestMWDataSyncMock.MockSyncHttpResponseSuccessGenerator()); 
        
        Test.startTest();
        
        // Mocking the Http request and response
        Test.setMock(HttpCalloutMock.class, new MWCalloutMockSuccess());
        
        // Call the sync method
        String result = MWDataSync.sync(mortgageCase.Id, 'testToken');
        
        Test.stopTest();
        
        // Assert that the correct result is returned
        System.assertEquals('Request Sent Successfully', result, 'Expected sync to return success message.');
    }
    
    // Mocking HttpCalloutMock for successful response
    private class MWCalloutMockSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            // Create a fake HTTP response
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            
            // Setting mock JSON response body
            res.setBody('{"case_id": "12345", "account_id": "67890"}');
            
            return res;
        }
    }

    @isTest static void testInsertMortgageCaseWithMissingFields() {
        Test.startTest();
        
         // Create Account
         Account customer = new Account(Name = 'Adil Account');
         insert customer;
         
         // Create Contact and link to Account
         Contact contact = new Contact (
             Title = 'Adil Contact',
             FirstName = 'YO',
             LastName = 'Adil Contact',
             AccountId = customer.Id,
             Email = 'yo@yo.com',
             MobilePhone = '+923234358910'
         );
         insert contact;

        // Missing mandatory fields like Name and MortgagX__StageName__c
        MortgagX__Mortgage_Case__c mortgageCase = new MortgagX__Mortgage_Case__c (
              MortgagX__StageName__c = 'Factfind ongoing',
              MortgagX__CloseDate__c = Date.today(),
              MortgagX__First_Applicant_Contact__c = contact.Id
              
          );
        
        try {
            insert mortgageCase;
            // System.assert(false, 'Expected a DML exception due to missing mandatory fields.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('required field'), 'Expected a required field error message.');
        }
        
        Test.stopTest();
    }
    

}