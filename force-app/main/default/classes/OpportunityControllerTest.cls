@isTest
public with sharing class OpportunityControllerTest {

    private static Opportunity createTestOpportunity(String name, Boolean isClosed) {
        Opportunity opp = new Opportunity(
            Name = name,
            StageName = isClosed ? 'Closed Won' : 'Prospecting',
            Amount = 5000,
            CloseDate = Date.today().addDays(30),
            Start_Date__c = Date.today().addDays(10),
            End_Date__c = Date.today().addDays(20),
            Destination__c = 'Rome',
            Number_of_Participants__c = 8,
            AccountId = null 
        );
        insert opp;
        return opp;
    }

    @isTest
    public static void testGetOpportunities() {
        // Création d'une opportunité de test
        Opportunity testOpp = createTestOpportunity('Test Open Opportunity', false);

        // Exécution de la méthode
        Test.startTest();
        List<Opportunity> opportunities = OpportunityController.getOpportunities();
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(opportunities.size(), 0, 'La liste des opportunités ne doit pas être vide');
    }

  
    @isTest
    public static void testCreateOpportunity() {
        Opportunity newOpp = new Opportunity(
            Name = 'New Test Opportunity',
            StageName = 'Qualification',
            Amount = 10000,
            CloseDate = Date.today().addDays(40),
            Start_Date__c = Date.today().addDays(15),
            End_Date__c = Date.today().addDays(25),
            Destination__c = 'Paris',
            Number_of_Participants__c = 12
        );

        Test.startTest();
        Opportunity createdOpp = OpportunityController.createOpportunity(newOpp);
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(createdOpp.Id, null, 'L\'ID de l\'opportunitécréée ne doit pas être null');
        System.assertEquals(createdOpp.Name, 'New Test Opportunity', 'Le nom de l\'opportunité doit correspondre');
    }

   
    @isTest
    public static void testUpdateOpportunity() {
        Opportunity testOpp = createTestOpportunity('Opportunity Before Update', false);

        // Modification de l’opportunité
        testOpp.Name = 'Opportunity After Update';

        Test.startTest();
        Opportunity updatedOpp = OpportunityController.updateOpportunity(testOpp);
        Test.stopTest();

        // Vérification en base de données
        Opportunity fetchedOpp = [SELECT Name FROM Opportunity WHERE Id = :testOpp.Id];

        // Vérifications
        System.assertEquals(updatedOpp.Name, 'Opportunity After Update', 'L\'opportunité mise à jour doit avoir le bon nom');
        System.assertEquals(fetchedOpp.Name, 'Opportunity After Update', 'L\'opportunité en base doit être correctement mise à jour');
    }

    @isTest
    public static void testDeleteOpportunity() {
        Opportunity testOpp = createTestOpportunity('Opportunity To Delete', false);

        Test.startTest();
        OpportunityController.deleteOpportunity(testOpp.Id);
        Test.stopTest();

        // Vérification que l’opportunité a été supprimée
        Integer count = [SELECT COUNT() FROM Opportunity WHERE Id = :testOpp.Id];
        System.assertEquals(count, 0, 'L\'opportunité doit être supprimée');
    }

}
