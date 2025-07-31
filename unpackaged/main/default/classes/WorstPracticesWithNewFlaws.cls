/**
 * A class riddled with poor security & performance practices.
 * 
 * Key issues:
 *  - Hard-coded credentials
 *  - Insecure cookie (no secure/httpOnly)
 *  - Sharing violation via inner class
 *  - Unannotated "test" method
 *  - Uncommented assertion
 *  - Insecure HTTP endpoint
 *  - Logs sensitive information
 * 
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
public with sharing class WorstPracticesWithNewFlaws {

    // 1) Hard-coded sensitive data
    public static final String HARDCODED_PASSWORD = 'MyBadPassword123';

    // Bound to the Visualforce page fields (if used)
    public String username { get; set; }
    public String password { get; set; }

    /**
     * 2) Insecure cookie setter: No 'secure' or 'httpOnly' flags. 
     *    Logs sensitive info.
     */
    public void setInsecureCookie() {
        // This sets a cookie that is neither secure nor httpOnly
        Cookie c = new Cookie('SessionId', 'abcdef123456', null, -1, false);
        ApexPages.currentPage().setCookies(new Cookie[] { c });

        // Logging sensitive info
        System.debug('Set insecure cookie with session ID: ' + c.getValue());
    }

    /**
     * 3) Demonstrate a "sharing violation":
     *    - The top-level class is "with sharing",
     *      but the method delegates to an inner class declared "without sharing".
     *    - We must instantiate the inner class since we removed 'static' from it
     *      to avoid compile errors.
     */
    public List<Account> getAllAccountsIgnoringSharing() {
        // InsecureHelper is declared 'without sharing'
        InsecureHelper helper = new InsecureHelper();
        return helper.getAllAccounts();
    }

    /**
     * 4) Insecure HTTP callout (plain HTTP) + unoptimized resource loading.
     *    - Still uses a top-level static method, which is allowed.
     */
    public static String insecureHttpCallout() {
        HttpRequest req = new HttpRequest();
        // Using non-HTTPS endpoint => insecure
        req.setEndpoint('http://insecure.example.com/largeResource');
        req.setMethod('GET');

        // No exception handling, no timeout adjustments, no caching
        Http http = new Http();
        HttpResponse res = http.send(req);

        return res.getBody();
    }

    /**
     * 5) Simple inner class holding "sensitive" info with no security controls.
     */
    public class InsecureJsonData {
        public String sensitiveInfo;
    }

    /**
     * 6) Logs sensitive information, returns it in an object, 
     *    no encryption or obfuscation.
     */
    public static InsecureJsonData returnSensitiveData() {
        InsecureJsonData data = new InsecureJsonData();
        data.sensitiveInfo = 'Full SSN: 123-45-6789';

        // Logging sensitive data
        System.debug('SENSITIVE LOG: ' + data.sensitiveInfo);
        return data;
    }

    /**
     * 7) "Test method" not annotated with @isTest, so it won't follow test context rules
     *    or appear in coverage. Also has an uncommented assertion with no message.
     */
    public static void testMethodThatIsNotAnnotated() {
        System.assert(false);
    }

    /**
     * Inner class declared WITHOUT SHARING, ignoring record-level security.
     * We removed "static" from this class to avoid compile errors.
     */
    private without sharing class InsecureHelper {
        public List<Account> getAllAccounts() {
            // Ignores user-level sharing
            return [SELECT Id, Name FROM Account];
        }
    }
}