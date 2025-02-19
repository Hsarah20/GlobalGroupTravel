global class UpdateStatusTripsScheduler  implements Schedulable {

    global void execute(SchedulableContext sc) {
        Database.executeBatch(new UpdateStatusTripsBatch(), 200);
    }
}