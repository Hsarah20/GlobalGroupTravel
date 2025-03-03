@isTest
public class OpportunityTriggerHandlerTest {

    
    @testSetup
    static void setupTestData() {
        // Créer des comptes pour lier aux opportunités
        Account acc1 = new Account(Name = 'Account 1');
        insert acc1;

        // Créer des opportunités
        Opportunity opp1 = new Opportunity(
            Name = 'Opportunity 1', 
            StageName = 'Prospecting', 
            CloseDate = System.today().addDays(10), 
            AccountId = acc1.Id, 
            Destination__c = 'Paris',
            Number_of_Participants__c = 10,
            Start_Date__c = System.today().addDays(5), 
            End_Date__c = System.today().addDays(7)
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Opportunity 2', 
            StageName = 'Closed Won', 
            CloseDate = System.today().addDays(10), 
            AccountId = acc1.Id, 
            Destination__c = 'London',
            Number_of_Participants__c = 5,
            Start_Date__c = System.today().addDays(1), 
            End_Date__c = System.today().addDays(3)
        );

        Opportunity opp3 = new Opportunity(
            Name = 'Opportunity 3', 
            StageName = 'Closed Won', 
            CloseDate = System.today().addDays(10), 
            AccountId = acc1.Id, 
            Destination__c = 'Berlin',
            Number_of_Participants__c = 20,
            Start_Date__c = System.today().addDays(-1), 
            End_Date__c = System.today().addDays(-3) 
        );

        Opportunity opp4 = new Opportunity(
            Name = 'Opportunity 4', 
            StageName = 'Closed Won', 
            CloseDate = System.today().addDays(10), 
            AccountId = null, 
            Destination__c = 'Rome',
            Number_of_Participants__c = 8,
            Start_Date__c = System.today().addDays(2), 
            End_Date__c = System.today().addDays(4)
        );

        insert new List<Opportunity>{ opp1, opp2, opp3, opp4 };
    }

    @isTest
    static void testCreateTripsForClosedWonOpportunities() {
        // Récupérer les opportunités pour tester
        List<Opportunity> opps = [SELECT Id, StageName, AccountId, Destination__c, Start_Date__c, End_Date__c,Number_of_Participants__c FROM Opportunity WHERE StageName = 'Closed Won'];
        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        
        // Créer une map simulant l'état précédent des opportunités
        for (Opportunity opp : opps) {
            Opportunity oldOpp = new Opportunity(Id = opp.Id, StageName = 'Prospecting',AccountId=opp.AccountId);
            oldOppMap.put(opp.Id, oldOpp);
        }

    
        Test.startTest();
        OpportunityTriggerHandler.checkStatusOppToCreateTrip(opps, oldOppMap);
        Test.stopTest();

        // Vérifier que les voyages ont été créés
        List<Trip__c> createdTrips = [SELECT Id, Account__c, Opportunity__c, Start_Date__c, End_Date__c, Destination__c,Number_of_Participants__c FROM Trip__c];
        System.assertEquals(1, createdTrips.size(), 'Un voyages devraient être créés');

        // Vérifier que les dates des voyages sont correctes
        for (Trip__c trip : createdTrips) {
            if (trip.Destination__c == 'London') {
                System.assertEquals(System.today().addDays(1), trip.Start_Date__c, 'La date de début du voyage à Londres devrait être correcte');
                System.assertEquals(System.today().addDays(3), trip.End_Date__c, 'La date de fin du voyage à Londres devrait être correcte');
            }
        }
    }

    // Test pour vérifier qu'une opportunité sans compte ne crée pas de voyage
    @isTest
    static void testOpportunityWithoutAccount() {
        List<Opportunity> opps = [SELECT Id, StageName, AccountId, Destination__c, Start_Date__c, End_Date__c,Number_of_Participants__c FROM Opportunity WHERE StageName = 'Closed Won'];
        Map<Id, Opportunity> oldOppMap = new Map<Id, Opportunity>();
        
        // Créer une map simulant l'état précédent des opportunités
        for (Opportunity opp : opps) {
            Opportunity oldOpp = new Opportunity(Id = opp.Id, StageName = 'Prospecting',Number_of_Participants__c=10);
            oldOppMap.put(opp.Id, oldOpp);
        }

        // Appeler la méthode à tester
        Test.startTest();
        OpportunityTriggerHandler.checkStatusOppToCreateTrip(opps, oldOppMap);
        Test.stopTest();

        // Vérifier qu'aucun voyage n'est créé pour l'opportunité sans compte
        List<Trip__c> createdTrips = [SELECT Id, Account__c FROM Trip__c];
        System.assertEquals(1, createdTrips.size(), 'Aucun voyage ne devrait pas être créé pour l\'opportunité sans compte');
    }
}
