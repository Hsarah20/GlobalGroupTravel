@isTest
public class CancelTripsBatchTest {
    
    @testSetup
    static void setupTestData() {
        List<Trip__c> trips = new List<Trip__c>();

        // Trip éligibles au batch (Start_Date__c dans 7 jours, Participants < 10)
        trips.add(new Trip__c( Status__c = 'A venir', Start_Date__c = System.today().addDays(7), Number_of_Participants__c = 5));
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(7), Number_of_Participants__c = 3));

        // Trip NON éligible (trop de participants)
        trips.add(new Trip__c( Status__c = 'A venir', Start_Date__c = System.today().addDays(7), Number_of_Participants__c = 15));

        // Trip NON éligible (date hors de la plage)
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(10), Number_of_Participants__c = 5));

        // Trip NON éligible (Number_of_Participants__c NULL)
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(7), Number_of_Participants__c = NULL));

        insert trips;
    }

    @isTest
    static void testBatchExecution() {
        // Vérifier que les voyages sont bien créés et dans le bon état initial
        List<Trip__c> beforeTrips = [SELECT Id, Status__c FROM Trip__c];
        System.assertEquals(5, beforeTrips.size(), 'Tous les voyages doivent être créés');
        for (Trip__c trip : beforeTrips) {
            System.assertEquals('A venir', trip.Status__c, 'Le statut initial doit être "A venir"');
        }

        // 🏁 Lancer le batch
        Test.startTest();
        CancelTripsBatch batch = new CancelTripsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifier les résultats après l'exécution du batch
        List<Trip__c> afterTrips = [SELECT Id, Status__c, Number_of_Participants__c, Start_Date__c FROM Trip__c];

        Integer cancelledCount = 0;
        Integer unchangedCount = 0;

        for (Trip__c trip : afterTrips) {
            if (trip.Start_Date__c == System.today().addDays(7) && trip.Number_of_Participants__c < 10 && trip.Number_of_Participants__c != null) {
                System.assertEquals('Annulé', trip.Status__c, 'Le voyage doit être annulé');
                cancelledCount++;
            } else {
                System.assertEquals('A venir', trip.Status__c, 'Les voyages non éligibles doivent rester inchangés');
                unchangedCount++;
            }
        }

        // Vérifier que seuls les voyages éligibles ont été annulés
        System.assertEquals(2, cancelledCount, '2 voyages doivent être annulés');
        System.assertEquals(3, unchangedCount, '3 voyages ne doivent pas être modifiés');
    }
}
