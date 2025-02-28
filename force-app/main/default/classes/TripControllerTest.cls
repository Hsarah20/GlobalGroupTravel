@isTest
public with sharing class TripControllerTest {
    
    private static Trip__c createTestTrip(String status) {
        Trip__c trip = new Trip__c(
            Status__c = status,
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(15),
            Number_of_Participants__c = 5
        );
        insert trip;
        return trip;
    }

    @isTest
    public static void testGetTrips() {
        // Création d'un voyage de test
        Trip__c testTrip = createTestTrip('A venir');

        // Exécution de la méthode
        Test.startTest();
        List<Trip__c> trips = TripController.getTrips();
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(trips.size(), 0, 'La liste des voyages ne doit pas être vide');
    }

    @isTest
    public static void testCreateTrip() {
        Trip__c trip = new Trip__c(
            Status__c = 'A venir',
            Destination__c = 'Paris',
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(15),
            Number_of_Participants__c = 5
        );

        Test.startTest();
        Trip__c createdTrip = TripController.createTrip(trip);
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(createdTrip.Id, null, 'L\'ID du voyage créé ne doit pas être null');
        System.assertEquals(createdTrip.Status__c, 'A venir', 'Le Status du voyage doit correspondre');
    }

    @isTest
    public static void testUpdateTrip() {
        Trip__c testTrip = createTestTrip('A venir');

        // Modification du voyage
        testTrip.Status__c = 'Terminé';

        Test.startTest();
        Trip__c updatedTrip = TripController.updateTrip(testTrip);
        Test.stopTest();

        // Vérification en base de données
        Trip__c fetchedTrip = [SELECT Name,Status__c FROM Trip__c WHERE Id = :testTrip.Id];

        // Vérifications
        System.assertEquals(updatedTrip.Status__c, 'Terminé', 'Le voyage mis à jour doit avoir le bon statut');
        System.assertEquals(fetchedTrip.Status__c, 'Terminé', 'Le voyage en base doit être correctement mis à jour');
    }

    @isTest
    public static void testDeleteTrip() {
        Trip__c testTrip = createTestTrip('A venir');

        Test.startTest();
        TripController.deleteTrip(testTrip.Id);
        Test.stopTest();

        // Vérification que le voyage a été supprimé
        Integer count = [SELECT COUNT() FROM Trip__c WHERE Id = :testTrip.Id];
        System.assertEquals(count, 0, 'Le voyage doit être supprimé');
    }

}
