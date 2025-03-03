@isTest
public with sharing class ContractControllerTest {
    
    private static Contract createTestContract(String status) {
        Account acc=AccountControllerTest.createTestAccount('Test Account');
        Contract contract = new Contract(
            Status = status,
            StartDate = Date.today(),
            AccountId = acc.Id
        );
        insert contract;
        return contract;
    }

    @isTest
    public static void testGetContracts() {
        // Création d'un contrat de test
        Contract testContract = createTestContract('Draft');

        // Exécution de la méthode
        Test.startTest();
        List<Contract> contracts = ContractController.getContracts();
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(contracts.size(), 0, 'La liste des contrats ne doit pas être vide');
    }

    @isTest
    public static void testCreateContract() {
        Contract newContract = new Contract(
            Status = 'Draft',
            StartDate = Date.today()
        );

        Test.startTest();
        Contract createdContract = ContractController.createContract(newContract);
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(createdContract.Id, null, 'L\'ID du contrat créé ne doit pas être null');
    }

    @isTest
    public static void testUpdateContract() {
        Contract testContract = createTestContract('Draft');

        // Modification du contrat
        testContract.Status = 'Activated';

        Test.startTest();
        Contract updatedContract = ContractController.updateContract(testContract);
        Test.stopTest();

        // Vérification en base de données
        Contract fetchedContract = [SELECT Status FROM Contract WHERE Id = :testContract.Id];

        // Vérifications
        System.assertEquals(updatedContract.Status, 'Activated', 'Le contrat mis à jour doit avoir le bon statut');
        System.assertEquals(fetchedContract.Status, 'Activated', 'Le contrat en base doit être correctement mis à jour');
    }

    @isTest
    public static void testDeleteContract() {
        Contract testContract = createTestContract('Draft');
        Test.startTest();
        ContractController.deleteContract(testContract.Id);
        Test.stopTest();

        // Vérification que le contrat a été supprimé
        Integer count = [SELECT COUNT() FROM Contract WHERE Id = :testContract.Id];
        System.assertEquals(count, 0, 'Le contrat doit être supprimé');
    }

    @isTest
    public static void testDeleteActivatedContract() {
        Contract activatedContract = createTestContract('Draft');
        activatedContract.Status = 'Activated';
        update activatedContract;

        Test.startTest();
        Boolean exceptionThrown = false;
        
        try {
            ContractController.deleteContract(activatedContract.Id);
        } catch (Exception e) {
            exceptionThrown = true;
            System.assert(e.getMessage().contains('Impossible de supprimer un contrat actif.'), 
                'Le message d\'erreur retourné ne correspond pas à l\'attendu.');
        }
    
        Test.stopTest();
    
        // Vérification qu'une exception a bien été levée
        System.assert(exceptionThrown, 'Une exception aurait dû être levée pour un contrat activé.');
    }
    
}
