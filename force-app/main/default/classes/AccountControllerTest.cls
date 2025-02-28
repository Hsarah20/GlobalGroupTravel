@isTest
public class AccountControllerTest {
    
    @TestVisible
    private static Account createTestAccount(String name) {
        Account acc = new Account(
            Name = name,
            Phone = '0123456789',
            Industry = 'Technology',
            Type = 'Customer'
        );
        insert acc;
        return acc;
    }

    @isTest
    public static void testGetAccounts() {
        // Création de données de test
        Account testAcc = createTestAccount('Test Account');

        // Exécution de la méthode
        Test.startTest();
        List<Account> accounts = AccountController.getAccounts();
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(accounts.size(), 0, 'La liste des comptes ne doit pas être vide');
        System.assert(accounts.contains(testAcc), 'Le compte de test doit être présent');
    }
    @isTest
    public static void testCreateAccount() {
        Account newAcc = new Account(
            Name = 'New Test Account',
            Phone = '0987654321',
            Industry = 'Finance',
            Type = 'Prospect'
        );

        Test.startTest();
        Account createdAcc = AccountController.createAccount(newAcc);
        Test.stopTest();

        // Vérifications
        System.assertNotEquals(createdAcc.Id, null, 'L\'ID du compte créé ne doit pas être null');
        System.assertEquals(createdAcc.Name, 'New Test Account', 'Le nom du compte doit correspondre');
    }

    // Test de mise à jour d'un compte
    @isTest
    public static void testUpdateAccount() {
        Account testAcc = createTestAccount('Account Before Update');

        // Modification du compte
        testAcc.Name = 'Account After Update';

        Test.startTest();
        Account updatedAcc = AccountController.updateAccount(testAcc);
        Test.stopTest();

        // Récupération du compte en base
        Account fetchedAcc = [SELECT Name FROM Account WHERE Id = :testAcc.Id];

        // Vérifications
        System.assertEquals(updatedAcc.Name, 'Account After Update', 'Le compte mis à jour doit avoir le bon nom');
        System.assertEquals(fetchedAcc.Name, 'Account After Update', 'Le compte en base doit être correctement mis à jour');
    }

    // Test de suppression d'un compte
    @isTest
    public static void testDeleteAccount() {
        Account testAcc = createTestAccount('Account To Delete');

        Test.startTest();
        AccountController.deleteAccount(testAcc.Id);
        Test.stopTest();

        // Vérification que le compte a été supprimé
        Integer count = [SELECT COUNT() FROM Account WHERE Id = :testAcc.Id];
        System.assertEquals(count, 0, 'Le compte doit être supprimé');
    }

}