public with sharing class OpportunityTriggerHandler{

    public static void checkStatusOppToCreateTrip(List<Opportunity> opps, Map<Id, Opportunity> oldOppMap){

        // Identifier les opps qui viennent de passer en Closed - Won
        List<Opportunity> oppsClosed = new List<Opportunity>(); 
        for(Opportunity opp : opps){
            Opportunity oldOpp = oldOppMap.get(opp.Id);
            if(opp.Stagename == 'Closed Won' && oldOpp.StageName != opp.Stagename){
                oppsClosed.add(opp);
            }
        }

        //Créer des trips à partir de opps qui viennent de se declarer gagne
        List<Trip__c> ListTripsToCreate = new List<Trip__c>(); 
        for(Opportunity o : oppsClosed){

            if (o.AccountId == null) {
                System.debug('L\'opportunité ' + o.Id + ' n\'a pas d\'Account associé.');
                continue;
            }

            // Creation de Trip
            Trip__c newTrip = new Trip__c(                
                Destination__c = o.Destination__c,                
                Status__c = 'A venir',
                Number_of_Participants__c=o.Number_of_Participants__c,
                Account__c = o.AccountId,
                Opportunity__c = o.Id
            );
            
            if (o.Start_Date__c < System.today()) {
                o.addError('La date de début doit être supérieure ou égale à aujourd\'hui.');
            }else if(o.End_Date__c <= o.Start_Date__c) {
                o.addError('La date de fin doit être supérieure à la date de début.');
            }else{
                newTrip.Start_Date__c = o.Start_Date__c;
                newTrip.End_Date__c = o.End_Date__c;
                ListTripsToCreate.add(newTrip);
            }
    
        }
        if (!ListTripsToCreate.isEmpty()) {
            try {
                insert ListTripsToCreate;
                System.debug( ListTripsToCreate.size()  + '  Voyages créés avec succès.');
            } catch (DmlException e) {
                System.debug('Erreur lors de l\'insertion des voyages : ' + e.getMessage());
            }
        }
        
    }
}