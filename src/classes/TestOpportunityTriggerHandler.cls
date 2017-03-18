@isTest
private class TestOpportunityTriggerHandler {

	/*
    * @scenario: verify each individual success & failure scenarios via insert
  */
	@isTest static void test_insert() {
		// prepare dated exchange rates
		List<DatedExchangeRate__c> datedExchangeRateList = new List<DatedExchangeRate__c>();
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.14489, 'CNY', '2018-04-01', '2017-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.14488, 'CNY', '2017-04-01', '2016-04-01'));
		insert datedExchangeRateList;

		// prepare account
		Account acct = TestUtils.createAccount('acct');
		insert acct;

		// prepare opportunities
		List<Opportunity> oppList = new List<Opportunity>();
		// opp0 - StageName is not 'Closed Won'
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp0', 'Prospecting', '2017-03-17', null, null));
		// opp1 - ISO code is null
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp1', 'Closed Won', '2017-03-17', null, 1000));
		// opp2 - Amount is null
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp2', 'Closed Won', '2017-03-17', 'CNY', null));
		// opp3 - CloseDate is not available in dated exchange rates
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp3', 'Closed Won', '2019-03-17', 'CNY', 1000));
		// opp4 - ISO is 'USD'
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp4', 'Closed Won', '2017-03-17', 'USD', 1000));
		// opp5 - ISO is 'CNY' and closeDate is '2017-03-17'
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp5', 'Closed Won', '2017-03-17', 'CNY', 1000));
		// opp6 - ISO is 'CNY' and closeDate is '2018-03-17'
		oppList.add(TestUtils.createOpportunity(acct.Id, 'opp6', 'Closed Won', '2018-03-17', 'CNY', 1000));

		Test.startTest();
		Database.SaveResult[] srList = Database.insert(oppList, false);
		Test.stopTest();

		// do verifications

		System.assertEquals(srList[0].isSuccess(), true);

		System.assertEquals(srList[1].isSuccess(), false);
		System.assertEquals(srList[1].getErrors()[0].getMessage(), 'Make sure you entered valid values for Currency ISO Code and Amount');

		System.assertEquals(srList[2].isSuccess(), false);
		System.assertEquals(srList[2].getErrors()[0].getMessage(), 'Make sure you entered valid values for Currency ISO Code and Amount');

		System.assertEquals(srList[3].isSuccess(), false);
		System.assertEquals(srList[3].getErrors()[0].getMessage(), 'Conversion rate for date 3/17/2019 is not available');

		System.assertEquals(srList[4].isSuccess(), true);
		System.assertEquals(srList[5].isSuccess(), true);
		System.assertEquals(srList[6].isSuccess(), true);

		List<Opportunity> verifyOppList = [SELECT Id, Name, Amount_USD__c FROM Opportunity WHERE Name = 'opp4' OR Name = 'opp5' OR Name = 'opp6'];
		for(Opportunity opp : verifyOppList){
			if(opp.Name == 'opp4'){
				System.assertEquals(opp.Amount_USD__c, 1000);
			}
			if(opp.Name == 'opp5'){
				System.assertEquals(opp.Amount_USD__c, 144.88);
			}
			if(opp.Name == 'opp6'){
				System.assertEquals(opp.Amount_USD__c, 144.89);
			}
		}

		Account verifyAcct = [SELECT Id, Total_Value_of_Won_Opps_derived__c FROM Account WHERE Id =: acct.Id];
		System.assertEquals(verifyAcct.Total_Value_of_Won_Opps_derived__c, 1289.77);
	}

	/*
    * @scenario: verify bulk operation via update
  */
	@isTest static void test_update() {
		// prepare dated exchange rates
		List<DatedExchangeRate__c> datedExchangeRateList = new List<DatedExchangeRate__c>();
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.14489, 'CNY', '2018-04-01', '2017-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.14488, 'CNY', '2017-04-01', '2016-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(1.07716, 'EUR', '2018-04-01', '2017-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(1.07715, 'EUR', '2017-04-01', '2016-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(1.23550, 'GBP', '2018-04-01', '2017-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(1.23549, 'GBP', '2017-04-01', '2016-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.00883, 'JPY', '2018-04-01', '2017-04-01'));
		datedExchangeRateList.add(TestUtils.createDatedExchangeRate(0.00882, 'JPY', '2017-04-01', '2016-04-01'));
		insert datedExchangeRateList;

		// prepare account
		Account acct = TestUtils.createAccount('acct');
		insert acct;

		// prepare opportunities
		List<Opportunity> oppList = new List<Opportunity>();

		// 1000*50 = 50000
		for(Integer i = 0; i < 50; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2017-03-17', 'USD', 1000));
		}
		// 144.88 * 50 = 7244
		for(Integer i = 50; i < 100; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2017-03-17', 'CNY', 1000));
		}
		// 1077.15 * 50 = 53857.5
		for(Integer i = 100; i < 150; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2017-03-17', 'EUR', 1000));
		}
		// 1235.50 * 50 = 61775
		for(Integer i = 150; i < 200; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2018-03-17', 'GBP', 1000));
		}
		// 8.83 * 50 = 441.5
		for(Integer i = 200; i < 250; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2018-03-17', 'JPY', 1000));
		}
		// 0
		for(Integer i = 250; i < 300; i++){
			oppList.add(TestUtils.createOpportunity(acct.Id, 'opp'+i, 'Closed Won', '2017-03-17', null, 1000));
		}

		Test.startTest();
		Database.SaveResult[] srList = Database.insert(oppList, false);
		Test.stopTest();

		// do verification 
		Account verifyAcct = [SELECT Id, Total_Value_of_Won_Opps_derived__c FROM Account WHERE Id =: acct.Id];
		System.assertEquals(verifyAcct.Total_Value_of_Won_Opps_derived__c, 173318.00);
	}

}