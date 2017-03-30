# Assignment One

* **Scenario**:

  * Guidewire software has sales offices across the globe to support global business. Sales rep create opportunities to track deals and record opportunity amount. For example, sales rep in US creates opportunity & records amount in USD, and sales rep in UK records amount in GBP.  The Account owner should be able to see the total amount from all opportunities in USD.

  * In salesforce, the corporate currency is set to USD. Multicurrency and dated exchange rate are enabled too to support global business model.

* **Task** :

  * Create Rollup summary field Total Value of Won Opportunities (label), Total_Value_of_Won_Opps_derived__c (Api) in Account Object.

  * Use sum(Amount_USD__c) in the rollup field for Closed won opportunities.

  * Create currency field (15,2) Amount_USD__c in opportunity object.

  * Create before insert, before update trigger on Opportunity to convert opportunity amount that are in different currencies to USD and update the USD in Amount_USD__c based on the dated exchange rate tied to closed date on the opportunity. The trigger should invoke apex class which will contain all the code.

  * Create test class for 90% code coverage.

* **P.S.**
  You can use custom object DatedExchangeRate with similar metadata as standard one. Plus create custom currency field ISO currency code in the opportunity object.

* **Solution** :
  * Classes
    * OpportunityTriggerHandler.cls
    * TestOpportunityTriggerHandler.cls
    * TestUtils.cls

  * Triggers
    * OpportunityTrigger.trigger

  * Custom Object
    * DatedExchangeRate__c.object

  * Custom Tabs
    * DatedExchangeRate__c.tab

  * Custom Fields
    * Account.Total_Value_of_Won_Opps_derived__c
    * Opportunity.Amount_USD__c
    * Opportunity.IsoCode__c

  * Miscellaneous
    * Besides the System Administrator user, I created another user called “tuser@jz.com” with Standard User profile for testing purpose, and granted its account login access to System Administrator for a year;
    * I added “0.0.0.0 - 255.255.255.255” IP login range for System Administrator profile to skip Identity Verification, so System Administrator can login from anywhere without verification code;
