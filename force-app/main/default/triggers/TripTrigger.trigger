trigger TripTrigger on Trip__c (before insert,before update) {

    TripTriggerHandler.checkDatesofTrip(Trigger.new);
}