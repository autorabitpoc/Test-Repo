public class SGR_GSPS_ProductGroupResponseWrapper {
    public String statusCode;
    public String statusMessage;
    public String errorMessage;
    public List<SGR_GSPS_ProductGroupResponseItems> responseItemsList;
    public class SGR_GSPS_ProductGroupResponseItems {
        public String name;
        public String productGroupCode;
        public List<String> productGroupType;
        public String division;
        public String effectiveDate;
        public String endDate;
        public String marketSegment;
        public String fundingType;
        public String lineOfBusiness;

    }

    public static List<SGR_GSPS_ProductGroupResponseItems> parse(String json) {
        return (List<SGR_GSPS_ProductGroupResponseWrapper.SGR_GSPS_ProductGroupResponseItems>)
                System.JSON.deserialize(json, List<SGR_GSPS_ProductGroupResponseWrapper.SGR_GSPS_ProductGroupResponseItems>.class);
    }

}