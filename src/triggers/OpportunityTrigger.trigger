trigger OpportunityTrigger on Opportunity (before insert, before update) {
  OpportunityTriggerHandler.triggerHandler(Trigger.new);
}