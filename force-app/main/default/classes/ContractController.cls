public with sharing class ContractController {

    @AuraEnabled(cacheable=true)
    public static List<Contract> getContracts() {
        try {
            return [SELECT Id, ContractNumber, Status, StartDate, EndDate, AccountId 
                    FROM Contract 
                    WHERE Status != 'Expired'];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des contrats : ' + e.getMessage());
        }
    }


    @AuraEnabled
    public static Contract createContract(Contract newContract) {
        try {
            insert newContract;
            return newContract;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création du contrat : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Contract updateContract(Contract updatedContract) {
        try {
            update updatedContract;
            return updatedContract;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la mise à jour du contrat : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteContract(Id contractId) {
        try {
            Contract contractToDelete = [SELECT Id, Status FROM Contract WHERE Id = :contractId LIMIT 1];
            if (contractToDelete.Status == 'Activated') {
                throw new AuraHandledException('Impossible de supprimer un contrat actif.');
            }
            delete contractToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la suppression du contrat : ' + e.getMessage());
        }
    }
 
}

