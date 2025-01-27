/**
 * This class contains deliberate security flaws and poor design.
 * DO NOT USE IN PRODUCTION.
 */
public without sharing class WorstPractices {

    // Hard-coded credentials/tokens (Security Risk #1)
    public static final String HARDCODED_PASSWORD = 'SuperSecret123';
    public static final String HARDCODED_TOKEN    = 'TokenXYZ456';

    /**
     * Demonstrates:
     *  - SOQL Injection by concatenating unsanitized user input (Security Risk #2)
     *  - Potentially large unbounded queries with no pagination (Performance Issue #1)
     *  - No CRUD or FLS checks (Security Risk #3)
     *  - No error handling
     */
    public static String getAccounts(String userInput) {
        // Dangerous dynamic SOQL
        String soql = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + userInput + '%\'';
        List<Account> accts = Database.query(soql);

        // Inefficient repeated queries inside a loop (Performance Issue #2)
        for (Account a : accts) {
            // No check for user permissions, no try/catch
            List<Contact> cons = [SELECT Id, LastName FROM Contact WHERE AccountId = :a.Id];
            // Arbitrarily doing something with contacts
            System.debug('Found contacts: ' + cons);
        }

        // Returning raw JSON with potentially sensitive data (Privacy Concern #1)
        return JSON.serialize(accts);
    }

    /**
     * Demonstrates:
     *  - Insecure direct object reference (IDOR) (Security Risk #4)
     *  - No user access/sharing checks (Security Risk #5)
     *  - No error handling
     */
    public static void deleteAccount(Id accountId) {
        // Ignores sharing rules (class is declared 'without sharing')
        // Directly deletes the record if found
        delete [SELECT Id, Name FROM Account WHERE Id = :accountId];
    }

    /**
     * Demonstrates:
     *  - No validation on incoming data
     *  - DML without exception handling
     *  - No CRUD or FLS checks
     */
    public static void createAccount(String name) {
        // Blindly inserts an Account
        Account a = new Account(Name = name);
        insert a;
    }
}

/**
 * Minimal test class with poor coverage strategy. 
 * Just enough coverage to deploy, but does not actually assert correct behavior.
 */