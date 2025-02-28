public with sharing class ContractController {

    public static List<Contract> getContracts() {
        try {
            return [SELECT Id, ContractNumber, Status, StartDate, EndDate, AccountId 
                    FROM Contract 
                    WHERE Status != 'Expired'];
        } catch (Exception e) {
            throw new ContractException('Erreur lors de la récupération des contrats : ' + e.getMessage());
        }
    }

    public static Contract createContract(Contract newContract) {  
        Account acc=new Account(Name='AccountName');
        insert acc;
        newContract.AccountId=acc.id;      
        try {
            insert newContract;
            return newContract;
        } catch (DmlException e) {
            throw new ContractException('Erreur lors de la création du contrat : ' + e.getMessage());
        }
    }

    public static Contract updateContract(Contract updatedContract) {
        try {
            update updatedContract;
            return updatedContract;
        } catch (DmlException e) {
            throw new ContractException('Erreur lors de la mise à jour du contrat : ' + e.getMessage());
        }
    }

    public static void deleteContract(Id contractId) {
        try {
            Contract contractToDelete = [SELECT Id, Status FROM Contract WHERE Id = :contractId LIMIT 1];
            if (contractToDelete.Status == 'Activated') {
                throw new ContractException('Impossible de supprimer un contrat actif.');
            }
            delete contractToDelete;
        } catch (DmlException e) {
            throw new ContractException('Erreur lors de la suppression du contrat : ' + e.getMessage());
        }
    }
    public class ContractException extends Exception {
        
    }
}


