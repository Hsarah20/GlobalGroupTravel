public with sharing class UpdateStatusTripsBatch implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
         'SELECT Id, Status__c,Start_Date__c,End_Date__c  FROM Trip__c'
        );
    }
        
    public void execute(Database.BatchableContext bc, List<Trip__c> trips) {
        for (Trip__c trip : trips) {
            if(trip.Start_Date__c > System.today()){
                trip.Status__c = 'A venir';
            }else if(trip.Start_Date__c <= System.today() && trip.End_Date__c >= System.today()){
                trip.Status__c = 'En cours';
            }else if(trip.End_Date__c < System.today()){   
                    trip.Status__c='Terminé';
           
            }
            
        }
        
        if(!trips.isEmpty()) {
           update trips;
        }
    }

    public void finish(Database.BatchableContext bc) {
        System.debug('Batch Status Trip est terminé avec succès !');

    }
}