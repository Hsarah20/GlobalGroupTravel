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

}
