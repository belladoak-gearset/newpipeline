public with sharing class VulnerableClass {
    // Method to retrieve accounts based on user-provided input
    public static List<Account> getAccounts(String userInput) {
        // BAD PRACTICE: Concatenating user input directly into SOQL (SOQL Injection vulnerability)
        String query = 'SELECT Id, Name, Phone FROM Account WHERE Name LIKE \'%' + userInput + '%\'';
        return Database.query(query);
    }

    // Method to update accounts without FLS or CRUD checks
    public static void updateAccounts(List<Account> accounts) {
        // BAD PRACTICE: Direct DML operations without CRUD or FLS checks
        update accounts;
    }

    // Method to delete accounts without sharing checks (with sharing is ignored in some contexts)
    public static void deleteAccounts(List<Id> accountIds) {
        // BAD PRACTICE: Using Ids without verifying user permissions
        List<Account> accountsToDelete = [SELECT Id FROM Account WHERE Id IN :accountIds];
        delete accountsToDelete;
    }
}