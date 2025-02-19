public with sharing class CancelTripsBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT Id, Status__c,Number_of_Participants__c FROM Trip__c WHERE Start_Date__c = NEXT_N_DAYS:7 AND Number_of_Participants__c < 10 AND Number_of_Participants__c != NULL'
        );
    }
        
    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            trip.Status__c = 'Annulé';
        }
        
        if(!trips.isEmpty()) {
            update trips;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Status Trip est terminé avec succès !');

    }
}