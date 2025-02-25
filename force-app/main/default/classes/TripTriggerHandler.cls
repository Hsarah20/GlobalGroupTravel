public with sharing class TripTriggerHandler{

    public static void checkDatesofTrip(List<Trip__c> trips){

        for(Trip__c trip : trips){            
            if (trip.Start_Date__c < System.today()) {
                trip.addError('La date de début doit être supérieure ou égale à aujourd\'hui.');
            }
            if (trip.End_Date__c <= trip.Start_Date__c) {
                trip.addError('La date de fin doit être supérieure à la date de début.');
            }  
        }
    }
}