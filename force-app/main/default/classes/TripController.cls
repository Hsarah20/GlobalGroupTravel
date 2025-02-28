public with sharing class TripController {
  
    public static List<Trip__c> getTrips() {
        try {
            return [SELECT Id, Name, Destination__c, Start_Date__c, End_Date__c, 
            Number_of_Participants__c, Total_Cost__c, Account__c, Opportunity__c, Status__c 
                    FROM Trip__c];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des voyages : ' + e.getMessage());
        }
    }

    // Create a new trip
    public static Trip__c createTrip(Trip__c newTrip) {
        try {
            insert newTrip;
            return newTrip;
        } catch (DmlException e) {
            throw new TripException('Erreur lors de la création du voyage : ' + e.getMessage());
        }
    }

    // Update a trip
    public static Trip__c updateTrip(Trip__c updatedTrip) {
        try {
            update updatedTrip;
            return updatedTrip;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la mise à jour du voyage : ' + e.getMessage());
        }
    }

    // Delete a trip
    public static void deleteTrip(Id tripId) {
        try {
            Trip__c tripToDelete = [SELECT Id FROM Trip__c WHERE Id = :tripId LIMIT 1];
            delete tripToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la suppression du voyage : ' + e.getMessage());
        }
    }
    public class TripException extends Exception {
        
    }
}