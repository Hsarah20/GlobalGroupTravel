public with sharing class AccountController {

    //Get a list of Accounts
    public static List<Account> getAccounts() {
        try {
            return [SELECT Id, Name, Phone, Industry, Type 
                    FROM Account 
                    WHERE IsDeleted = false];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des comptes : ' + e.getMessage());
        }
    }

  
    public static Account createAccount(Account newAccount) {
        try {
            insert newAccount;
            return newAccount;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création du compte : ' + e.getMessage());
        }
    }

    //Update Account
    public static Account updateAccount(Account updatedAccount) {
        try {
            update updatedAccount;
            return updatedAccount;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la mise à jour du compte : ' + e.getMessage());
        }
    }
    //Delete Account
    public static void deleteAccount(Id accountId) {
        try {
            Account accountToDelete = [SELECT Id FROM Account WHERE Id = :accountId LIMIT 1];
            delete accountToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la suppression du compte : ' + e.getMessage());
        }
    }

}