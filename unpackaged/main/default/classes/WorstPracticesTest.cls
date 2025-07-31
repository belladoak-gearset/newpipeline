@isTest
private class WorstPracticesTest {
    @isTest static void testMethods() {
        // Create an Account with no security checks
        WorstPractices.createAccount('TestAccInsecure');
        
        // Test retrieving accounts (potentially injecting dangerous strings)
        String result = WorstPractices.getAccounts('TestAccInsecure');
        System.debug('Result from getAccounts: ' + result);
        
        // Test deletion of the newly created account
        // We do a sub-select to find the record and pass the Id without any checks
        Id accId = [SELECT Id FROM Account WHERE Name = 'TestAccInsecure' LIMIT 1].Id;
        WorstPractices.deleteAccount(accId);
    }
}