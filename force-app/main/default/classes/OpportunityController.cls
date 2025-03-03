public with sharing class OpportunityController {
    
    public static List<Opportunity> getOpportunities() {
        try {
            return [SELECT Id, Name, StageName, Amount, CloseDate, AccountId, OwnerId,Start_Date__c,End_Date__c,Destination__c,Number_of_Participants__c
                    FROM Opportunity
                    WHERE IsClosed = false];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la récupération des opportunités : ' + e.getMessage());
        }
    }

    public static Opportunity createOpportunity(Opportunity newOpportunity) {
        try {
            insert newOpportunity;
            return newOpportunity;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la création de l\'opportunité : ' + e.getMessage());
        }
    }

    public static Opportunity updateOpportunity(Opportunity updatedOpportunity) {
        try {
            update updatedOpportunity;
            return updatedOpportunity;
        } catch (DmlException e) {
            throw new AuraHandledException('Erreur lors de la mise à jour de l\'opportunité : ' + e.getMessage());
        }
    }

    public static void deleteOpportunity(Id opportunityId) {
        try {
            Opportunity oppToDelete = [SELECT Id, IsClosed FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
            if (oppToDelete.IsClosed) {
                throw new OpportunityException('Impossible de supprimer une opportunité fermée.');
            }
            delete oppToDelete;
        } catch (DmlException e) {
            throw new OpportunityException('Erreur lors de la suppression de l\'opportunité : ' + e.getMessage());
        }
    }
    public class OpportunityException extends Exception {
        
    }

}