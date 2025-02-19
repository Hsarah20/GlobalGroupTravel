global class CancelTripsScheduler  implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new CancelTripsBatch(), 200);
    }
}