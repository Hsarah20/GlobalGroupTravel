trigger OpportunityTrigger on Opportunity (after update) {
    OpportunityTriggerHandler.checkStatusOppToCreateTrip(Trigger.new,trigger.oldMap);
}