trigger sgr_UpdateCaseOppty on Case (after insert, after update) {
    set<Id> recid = trigger.newMap.keySet();
    List<Id> rectypid = new List<Id>(recid);
    SGR_FutureTriggerClass.opptyUpdate(rectypid);
}