@isTest
public class TestUtils {
	/*
    * @description: create a Account with designated parameters
		* @param: name, used to create Account name
    * @return: a Account
  */
	public static Account createAccount(String name) {
		Account acct = new Account(Name=name);
		return acct;
	}

	/*
    * @description: create a Opportunity with designated parameters
		* @param: accountId, used to create Account Id
		* @param: name, used to create Opportunity name
		* @param: stageName, used to create Opportunity stageName
		* @param: closeDate, used to create Opportunity closeDate
		* @param: amount, used to create Opportunity amount
    * @return: a Opportunity
  */
	public static Opportunity createOpportunity(Id accountId, String name, String stageName, String closeDate, String isoCode, Double amount) {
		Opportunity opp = new Opportunity(AccountId=accountId, Name=name, StageName=stageName, CloseDate=date.Valueof(closeDate), IsoCode__c=isoCode, Amount=amount);
		return opp;
	}

	/*
    * @description: create a DatedExchangeRate with designated parameters
		* @param: conversionRate, used to create DatedExchangeRate conversionRate
		* @param: isoCode, used to create DatedExchangeRate isoCode
		* @param: nextStartDate, used to create DatedExchangeRate nextStartDate
		* @param: startDate, used to create DatedExchangeRate startDate
    * @return: a DatedExchangeRate
  */
	public static DatedExchangeRate__c createDatedExchangeRate(Decimal conversionRate, String isoCode, String nextStartDate, String startDate){
		DatedExchangeRate__c datedExchangeRate = new DatedExchangeRate__c(ConversionRate__c=conversionRate, IsoCode__c=isoCode, NextStartDate__c=date.Valueof(nextStartDate), StartDate__c=date.Valueof(startDate));
		return datedExchangeRate;
	}

}