@isTest
global class TestMWDataSyncMock {
    
    // Create a mock HTTP response for the authentication callout
    global class MockAuthSuccessHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"authenticationResult": { "IdToken": "abc" }}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    
    global class MockAuthFailedHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"access_token": "mock_token"}');
            response.setStatusCode(400);
            return response;
        }
    }
    
    // Create a mock HTTP response for the authentication callout
    global class MockDocumentSuccessHttpResponseGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(200);
            return response;
        }
    }
    
        // Create a mock HTTP response for the authentication callout
    global class MockDocumentSuccessHttpResponseFailedGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(400);
            return response;
        }
    }
    
            // Create a mock HTTP response for the authentication callout
    global class MockSyncHttpResponseSuccessGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class MockSendNotificationHttpResponseSuccessGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class MockFindProductsHttpResponseSuccessGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(200);
            return response;
        }
    }
    
    global class MockFindProductsHttpResponseFailedGenerator implements HttpCalloutMock {
        global HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"url": "http://localhost"}');
            response.setStatusCode(400);
            return response;
        }
    }
}