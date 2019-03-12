/***************************************************************************************************************************
Class: GEMS_IndexedCTM
Purpose: Wrapper class used for Case team members

*  Ver     Date(MM/DD/YYYY)  Name            	  Description
*  ---     ----------------  ---------------   	  ----------------------
*  1.1     05/22/2017        Phani Kommareddy  	  SFDC-1503 Prevent implementer change
*  1.2 	   06/02/2017		 Phani Kommareddy	  SFDC-3879 Updates on AS should update Pharmacy scode AS tasks uncompleted	

******************************************************************************************************************************/
public class GEMS_IndexedCTM implements Comparable {
        public Integer index {get;set;}
        public CaseTeamMember record {get;set;}
        public String teamMemberName{get;set;}
    	public String teamMemberRole{get;set;}
    	public boolean isChanged {get;set;}
    
        // Implement the compareTo() method
        public Integer compareTo(Object compareTo) {
            GEMS_IndexedCTM compareToICTM = (GEMS_IndexedCTM)compareTo;
            if (index == compareToICTM.index) return 0;
            if (index > compareToICTM.index) return 1;
            return -1;        
        }
}