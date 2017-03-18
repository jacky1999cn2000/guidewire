public class OpportunityTriggerHandler {

	/* private property - key as IsoCode, value as list of all DatedExchangeRate__c objects with that IsoCode */
	private static Map<String, List<DatedExchangeRate__c>> exchangeRateListMap {
		get{
			if(exchangeRateListMap == null){
				List<DatedExchangeRate__c> exchangeRateList = [SELECT ConversionRate__c,IsoCode__c,NextStartDate__c,StartDate__c FROM DatedExchangeRate__c];
				exchangeRateListMap = new Map<String, List<DatedExchangeRate__c>>();

				for(DatedExchangeRate__c exchangeRate : exchangeRateList){
					if(exchangeRateListMap.keySet().contains(exchangeRate.IsoCode__c)){
						exchangeRateListMap.get(exchangeRate.IsoCode__c).add(exchangeRate);
					}else{
						List<DatedExchangeRate__c> rateByISOList = new List<DatedExchangeRate__c>();
						rateByISOList.add(exchangeRate);
						exchangeRateListMap.put(exchangeRate.IsoCode__c, rateByISOList);
					}
				}
			}
			return exchangeRateListMap;
		}
		set;
	}

	/*
    * @description: get conversion rate based on IsoCode and CloseDate
		* @param: isoCode
		* @param: closeDate
    * @return: conversion code (Double or null)
  */
	private static Double getConversionRate(String isoCode, Date closeDate){
		List<DatedExchangeRate__c> rateByISOList = exchangeRateListMap.get(isoCode);

		if(rateByISOList != null){
			for(DatedExchangeRate__c rate : rateByISOList){
				if(closeDate >= rate.StartDate__c && closeDate < rate.NextStartDate__c){
					return rate.ConversionRate__c;
				}
			}
		}

		return null;
	}

	/*
    * @description: iterate each record, add error for invalid records and updte Amount_USD__c for valid records
		* @param: oppList, list of opportunities
    * @return: void
  */
	public static void triggerHandler(List<Opportunity> oppList) {

		for(Opportunity opp : oppList){

			if(opp.StageName != 'Closed Won') continue;

			if(opp.IsoCode__c == null || opp.Amount == null){
				opp.addError('Make sure you entered valid values for Currency ISO Code and Amount');
			}else{
				if(opp.IsoCode__c == 'USD'){
					opp.Amount_USD__c = opp.Amount;
				}else{
					Double conversionRate = getConversionRate(opp.IsoCode__c, opp.CloseDate);
					if(conversionRate == null){
						opp.addError('Conversion rate for date ' + opp.CloseDate.format() + ' is not available');
					}else{
						opp.Amount_USD__c = opp.Amount * conversionRate;
					}
				}
			}

		}
	}
}