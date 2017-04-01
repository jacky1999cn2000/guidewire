public with sharing class ThreePointerListControllerExt {

  private ApexPages.StandardSetController standardSetController;

  public ThreePointerListControllerExt(ApexPages.StandardSetController stdSetController) {
    this.standardSetController = stdSetController;
  }

  public PageReference madeAll() {
    List<Three_Pointer__c> selectedListViewRecords = (List<Three_Pointer__c>)standardSetController.getSelected();
    for(Three_Pointer__c record : selectedListViewRecords) {
      record.Result__c = 'MADE';
    }
    update selectedListViewRecords;
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('retURL'));
  }

  public PageReference missedAll() {
    List<Three_Pointer__c> selectedListViewRecords = (List<Three_Pointer__c>)standardSetController.getSelected();
    for(Three_Pointer__c record : selectedListViewRecords) {
      record.Result__c = 'MISSED';
    }
    update selectedListViewRecords;
    return new PageReference('/'+ApexPages.currentPage().getParameters().get('retURL'));
  }
}