//*************************************************************************************
// Name             : SGR_BAP_GetProducerDataResponse.cls
// Description      : This class contains output format provided to BAP.
// Created By       : Akbar Hussain Salisabgari 
// Created Date     : 12/28/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 12/28/2018       Akbar             SFDC-15963->BAP Webservice 
// ************************************************************************************
public class SGR_BAP_GetProducerDataResponse {
	public String producerNumber;
    public Integer pageNumber;
    public Integer pageSize;
    public Integer totalRecords;
    public String status;
    public String  message;
    public String failureReason;
    public List<ProducerData> producerData;
    
    public class ProducerData{
        public String producerName;
        public String generalAgentName;
        public String producerType;
        public String accountNumber;
        public String accountName;
        public String renewalDate;
        public String postedDate;
	}
}