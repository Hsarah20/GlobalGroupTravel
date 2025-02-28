@isTest
public class UpdateStatusTripsBatchTest {
    
    @testSetup
    static void setupTestData() {
        List<Trip__c> trips = new List<Trip__c>();

        // Trip futur (devrait devenir "A venir")
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(5), End_Date__c = System.today().addDays(10)));

        // Trip en cours (devrait devenir "En cours")
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(-2), End_Date__c = System.today().addDays(3)));

        // Trip terminé (devrait devenir "Terminé")
        trips.add(new Trip__c(Status__c = 'A venir', Start_Date__c = System.today().addDays(-10), End_Date__c = System.today().addDays(-5)));

        // Trip déjà "Annulé" (ne doit pas être modifié)
        trips.add(new Trip__c(Status__c = 'Annulé', Start_Date__c = System.today(), End_Date__c = System.today().addDays(-5))); 
        
        insert trips;
    }

    @isTest
    static void testBatchExecution() {
        // Vérifier les statuts avant exécution
        List<Trip__c> beforeTrips = [SELECT Id, Status__c FROM Trip__c WHERE Status__c != 'Annulé'];
        System.assertEquals(3, beforeTrips.size(), 'Seuls les voyages non annulés doivent être mis à jour');

        // Exécuter le batch
        Test.startTest();
        UpdateStatusTripsBatch batch = new UpdateStatusTripsBatch();
        Database.executeBatch(batch);
        Test.stopTest();

        // Vérifier les résultats après l'exécution du batch
        List<Trip__c> afterTrips = [SELECT Id, Status__c, Start_Date__c, End_Date__c FROM Trip__c];

        for (Trip__c trip : afterTrips) {
            if (trip.Status__c != 'Annulé') { 
                // Vérifier le statut en fonction des dates
                if (trip.Start_Date__c > System.today()) {
                    System.assertEquals('A venir', trip.Status__c, 'Le voyage futur doit être "A venir"');
                } else if (trip.Start_Date__c <= System.today() && trip.End_Date__c >= System.today()) {                    
                    System.assertEquals('En cours', trip.Status__c, 'Le voyage en cours doit être "En cours"');
                } else if (trip.End_Date__c < System.today()) {
                    System.assertEquals('Terminé', trip.Status__c, 'Le voyage terminé doit être "Terminé"');
                }
            } else {
                System.assertEquals('Annulé', trip.Status__c, 'Le voyage annulé ne doit pas être modifié');
            }
        }
    }
}

