class GlobalUtils{
  static String storeId ='26344';//'26286'; //'';//'25557'; // Replace with your storeID
  static String key='CFN3~5G2DW@Qh2tQ';//'3T4x@bGfnD~4BxHj';//'';//'''';//'qMB6w@wm3tf-Gwrw';//'';//pQ6nP-7rHt@5WRF//Authentication Key : The Authentication Key will be supplied by Telr as part of the Mobile API setup process after you request that this integration type is enabled for your account. This should not be stored permanently within the App.
  static String testmode='1'; // Test mode : Test mode of zero indicates a live transaction. If this is set to any other value the transaction will be treated as a test.
  static String custref=''; //This is parameter to identify the customers saved card details.
  static String devicetype='iOS'; // Let it be static as iOS for both
  static String deviceid='84173CD1-62DA-4594-87A5-624E038895C8';  // Application device ID
  static String appname='Shormeh'; // Application name
  static String version='1.0.3';// Application version
  static String appuser='2';// Application user ID : Your reference for the customer/user that is running the App. This should relate to their account within your systems.
  static String appid='17512'; //  Application installation ID
  static String transtype='paypage';/* auth Transaction type
                                                    'auth'   : Seek authorisation from the card issuer for the amount specified. If authorised, the funds will be reserved but will not be debited until such time as a corresponding capture command is made. This is sometimes known as pre-authorisation.
                                                    'sale'   : Immediate purchase request. This has the same effect as would be had by performing an auth transaction followed by a capture transaction for the full amount. No additional capture stage is required.
                                                    'verify' : Confirm that the card details given are valid. No funds are reserved or taken from the card.
                                                */

  static String transclass='ecom'; // Transaction class only 'paypage' is allowed on mobile, which means 'use the hosted payment page to capture and process the card details'
  static String firstref='';// (Optinal) Previous user transaction detail reference : The previous transaction reference is required for any continuous authority transaction. It must contain the reference that was supplied in the response for the original transaction
  static String firstname='Basant'; // Forename : It is the minimum required details for a transaction to be processed
  static String lastname='Hamada';// Surname : the minimum required details for a transaction to be processed
  static String addressline1='Saudi Arabia'; // Street address – line 1: the minimum required details for a transaction to be processed
  static String city='Jeddah'; //the minimum required details for a transaction to be processed
  static String region='Saudi Arabia'; //Optional
  static String country='SA'; // Country : Country must be sent as a 2 character ISO code. A list of country codes can be found at the end of this document. the minimum required details for a transaction to be processed
  static String phone='0500000000'; //the minimum required details for a transaction to be processed.
  static String emailId='amer@miras-ksa.com';//the minimum required details for a transaction to be processed.
  static String paymenttype=''; // Let it be static as 'card', used for saved card feature parameter
  static String currency='aed';
}
