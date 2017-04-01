public with sharing class ThreePointerControllerExt {

  private final Three_Pointer__c mysObject;

  public ThreePointerControllerExt(ApexPages.StandardController stdController) {
    this.mysObject = (Three_Pointer__c)stdController.getRecord();
  }

  public PageReference made() {
    mysObject.Result__c = 'MADE';
    update mysObject;
    return new PageReference('/'+mysObject.get('id'));
  }

  public PageReference missed() {
    mysObject.Result__c = 'MISSED';
    update mysObject;
    return new PageReference('/'+mysObject.get('id'));
  }
}