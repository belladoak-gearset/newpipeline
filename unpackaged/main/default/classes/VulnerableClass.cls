public without sharing class VulnerableClass {
    // 1. Injection (e.g., SOQL Injection)
    public static List<Account> findAccounts(String nameInput) {
        String query = 'SELECT Id, Name FROM Account WHERE Name LIKE \'%' + nameInput + '%\'';
        return Database.query(query); // User input is directly concatenated into the SOQL query
    }

    // 2. Broken Authentication
    public static User login(String username, String password) {
        // Simulating login without proper authentication
        List<User> users = [SELECT Id, Username FROM User WHERE Username = :username];
        if (!users.isEmpty() && password == 'hardcodedPassword123') { // Hardcoded password!
            return users[0]; // No actual authentication check
        }
        return null;
    }

    // 3. Sensitive Data Exposure
    public static String getSensitiveData() {
        // Exposes sensitive information
        return 'Database Password: admin123, API Key: key-abc123'; // Hardcoding sensitive information
    }

    // 4. XML External Entities (XXE)
    public static String parseXml(String xmlString) {
        // Parses untrusted XML input without validation
        Dom.Document doc = new Dom.Document();
        doc.load(xmlString); // This can be exploited with malicious XML
        return doc.getRootElement().getName();
    }

    // 5. Broken Access Control
    public static void deleteAccount(Id accountId) {
        // Allows deletion without checking user permissions or sharing rules
        Account acc = [SELECT Id FROM Account WHERE Id = :accountId];
        delete acc;
    }

    // 6. Security Misconfiguration
    @AuraEnabled
    public static void publicEndpoint() {
        // Exposes sensitive operation as a public endpoint
        delete [SELECT Id FROM Account LIMIT 10]; // Deletes arbitrary records
    }

    // 7. Cross-Site Scripting (XSS)
    @AuraEnabled
    public static String getHtmlContent(String userInput) {
        // Returns unvalidated user input directly to the client
        return '<div>' + userInput + '</div>'; // Malicious input could lead to XSS
    }

    // 8. Insecure Deserialization
    public static Object insecureDeserialization(String serializedData) {
        // Using JSON.deserialize without validation
        return JSON.deserialize(serializedData, Object.class); // Could result in malicious object creation
    }

    // 10. Insufficient Logging and Monitoring
    public static void processPayment(String paymentInfo) {
        // No logging or monitoring of sensitive operations
        // Payment processing happens silently without audit trails
        System.debug('Processing payment: ' + paymentInfo); // Debugging sensitive data
    }
}