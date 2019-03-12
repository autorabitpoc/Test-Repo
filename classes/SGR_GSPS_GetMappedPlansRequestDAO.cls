public class SGR_GSPS_GetMappedPlansRequestDAO {
    public String clientId;
    public Date effectiveDate;
    public String division;
    public String fundingType;
    public String marketSegment;
    public transient String opprId;
    public List<SGR_GSPS_GetMappedPlansPlanWrapperDAO> plans;

    public SGR_GSPS_GetMappedPlansRequestDAO() {
        plans = new List<SGR_GSPS_GetMappedPlansPlanWrapperDAO>();
    }

}