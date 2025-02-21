public with sharing class OpportunityController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
        try {
            return [SELECT Id, Name, StageName, Amount, CloseDate, AccountId, OwnerId
                    FROM Opportunity
                    WHERE IsClosed = false];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des opportunités : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Opportunity createOpportunity(Opportunity newOpportunity) {
        try {
            insert newOpportunity;
            return newOpportunity;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création de l\'opportunité : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static Opportunity updateOpportunity(Opportunity updatedOpportunity) {
        try {
            update updatedOpportunity;
            return updatedOpportunity;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la mise à jour de l\'opportunité : ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteOpportunity(Id opportunityId) {
        try {
            Opportunity oppToDelete = [SELECT Id, IsClosed FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            if (oppToDelete.IsClosed) {
                throw new AuraHandledException('Impossible de supprimer une opportunité fermée.');
            }
            delete oppToDelete;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la suppression de l\'opportunité : ' + e.getMessage());
        }
    }

}