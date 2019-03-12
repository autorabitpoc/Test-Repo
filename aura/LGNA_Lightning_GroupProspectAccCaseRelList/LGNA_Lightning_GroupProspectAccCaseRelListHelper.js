/* 
 * Author:  Rakesh Nunna
 * Initial Version: V1.0
 * Created date: 03/24/2018
 * Discription : Helper calss to the new redirecting page 'LGNA_Lightning_GroupProspectRedirect'
*/
({
    
    navigateToAllCase : function(component, event, tabkey) {
        var objectType = component.get("v.sObjectName");
        var recordId =component.get("v.recordId");
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:LGNA_Lightning_GroupProspectRedirect",
            componentAttributes: {
                rID : component.get("v.recordId"),
                key:tabkey,
                objectType:objectType
            }
        });
        evt.fire();
    },
})