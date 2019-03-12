//*************************************************************************************
// Name             : SGR_GSPS_RequestHeader.cls
// Description      : Class for GSPS Request header
// Created By       : Shankar
// Created Date     : 10/29/2018
// 
// ************************Version Updates********************************************
// Date             Developer           Description
// -----------------------------------------------------------------------------------
// 07/10/2017       Shankar             Initial version
// ************************************************************************************
global class SGR_GSPS_RequestHeader {
	webservice string clientId;
	webservice string jwtToken;
	webservice string oAuthToken;    
}