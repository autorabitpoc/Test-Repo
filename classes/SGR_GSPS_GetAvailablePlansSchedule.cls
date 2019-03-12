//*************************************************************************************
// Name             : SGR_GSPS_GetAvailablePlansSchedule.cls
// Description      : Schedule class to invoke Batch class for fetching All Available Plans GSPS Service
// Created By       : Tarun
// Created Date     : 06/11/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 06/11/2018       Tarun              SFDC-14003 Initial version
// ************************************************************************************

public class SGR_GSPS_GetAvailablePlansSchedule implements Schedulable {

    public void execute(SchedulableContext sc) {
        SGR_GSPS_GetAvailablePlansForkedBatch batch = new SGR_GSPS_GetAvailablePlansForkedBatch (null, 'IL', 0, false);
        Database.executeBatch(batch, 1);
    }

}