//*************************************************************************************
// Name             : SGR_BAP_GetProducerDataRequest.cls
// Description      : This class contains input format received from BAP.
// Created By       : Akbar Hussain Salisabgari 
// Created Date     : 12/28/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 12/28/2018       Akbar             SFDC-15963->BAP Webservice 
// ************************************************************************************
public class SGR_BAP_GetProducerDataRequest {
	public String producerNumber;
    public String producerName;
    public String accountName;
    public String accountNumber;
    public String effectiveDate;
    public Integer pageSize;
    public Integer pageNumber;
}