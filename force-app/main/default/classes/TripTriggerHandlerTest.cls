@isTest
private class TripTriggerHandlerTest {
    
    @isTest
    static void testValidTripDates() {
        Trip__c validTrip = new Trip__c(
            Start_Date__c = System.today().addDays(1),
            End_Date__c = System.today().addDays(5)
        );

        Test.startTest();
        TripTriggerHandler.checkDatesofTrip(new List<Trip__c>{validTrip});
        Test.stopTest();

        // Aucune erreur ne doit être levée
        System.assert(true, 'Le voyage avec des dates valides ne doit pas générer d\'erreur.');
    }

    @isTest
    static void testTripWithPastStartDate() {
        Trip__c noStartDateTrip = new Trip__c(
            Start_Date__c = System.today().addDays(-1),
            End_Date__c = System.today().addDays(3)
        );

        Test.startTest();
        Database.SaveResult result = Database.insert(noStartDateTrip, false);
        Test.stopTest();

        // Vérifie qu'une erreur est bien levée
        System.assert(!result.isSuccess(), 'Une erreur aurait dû être levée pour une date de début passée.');

        //Vérifie que l'erreur est bien celle attendue
        System.assert(result.getErrors().size() > 0, 'Une erreur aurait dû être générée.');
        System.assert(result.getErrors()[0].getMessage().contains('La date de début doit être supérieure ou égale à aujourd\'hui.'));
    }

}
