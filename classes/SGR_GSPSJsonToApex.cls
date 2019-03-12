public class SGR_GSPSJsonToApex{
   /* public class SubPlanGroups {
        public String code {get;set;} 
        public Integer planGroupId {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String lineOfBusiness {get;set;} 
        public String sortOrder {get;set;} 
        public List<Plans_Y> plans {get;set;} 
        public SubPlanGroups(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'planGroupId') {
                            planGroupId = parser.getIntegerValue();
                        } else if (text == 'startDate') {
                            startDate = parser.getText();
                        } else if (text == 'endDate') {
                            endDate = parser.getText();
                        } else if (text == 'lineOfBusiness') {
                            lineOfBusiness = parser.getText();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'plans') {
                            plans = arrayOfPlans_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'SubPlanGroups consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitHeaders {
        public Integer id {get;set;} 
        public Integer sortOrder {get;set;} 
        public BenefitHeaders(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getIntegerValue();
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitHeaders consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Plans {
        public String planName {get;set;} 
        public String planSalesId {get;set;} 
        public String description {get;set;} 
        public String longDescription {get;set;} 
        public String shortDescription {get;set;} 
        public String effectiveDate {get;set;} 
        public String expiryDate {get;set;} 
        public String retiredDate {get;set;} 
        public String division {get;set;} 
        public String network {get;set;} 
        public String channel {get;set;} 
        public Boolean isHsa {get;set;} 
        public Boolean isAllCopay {get;set;} 
        public String sortOrder {get;set;} 
        public List<BenefitHeaderDetails> benefitHeaderDetails {get;set;} 
        public String hsacontribution {get;set;} 
        public List<Notes> notes {get;set;} 
        public Plans(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'planName') {
                            planName = parser.getText();
                        } else if (text == 'planSalesId') {
                            planSalesId = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'longDescription') {
                            longDescription = parser.getText();
                        } else if (text == 'shortDescription') {
                            shortDescription = parser.getText();
                        } else if (text == 'effectiveDate') {
                            effectiveDate = parser.getText();
                        } else if (text == 'expiryDate') {
                            expiryDate = parser.getText();
                        } else if (text == 'retiredDate') {
                            retiredDate = parser.getText();
                        } else if (text == 'division') {
                            division = parser.getText();
                        } else if (text == 'network') {
                            network = parser.getText();
                        } else if (text == 'channel') {
                            channel = parser.getText();
                        } else if (text == 'isHsa') {
                            isHsa = parser.getBooleanValue();
                        } else if (text == 'isAllCopay') {
                            isAllCopay = parser.getBooleanValue();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'benefitHeaderDetails') {
                            benefitHeaderDetails = arrayOfBenefitHeaderDetails(parser);
                        } else if (text == 'hsacontribution') {
                            hsacontribution = parser.getText();
                        } else if (text == 'notes') {
                            notes = arrayOfNotes(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Plans consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String name {get;set;} 
    public String productGroupCode {get;set;} 
    public String division {get;set;} 
    public String effectiveDate {get;set;} 
    public String expiryDate {get;set;} 
    public String marketSegment {get;set;} 
    public String fundingType {get;set;} 
    public String lineOfBusiness {get;set;} 
    public List<PlanGroups> planGroups {get;set;} 
    public SGR_GSPSJsonToApex(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'name') {
                        name = parser.getText();
                    } else if (text == 'productGroupCode') {
                        productGroupCode = parser.getText();
                    } else if (text == 'division') {
                        division = parser.getText();
                    } else if (text == 'effectiveDate') {
                        effectiveDate = parser.getText();
                    } else if (text == 'expiryDate') {
                        expiryDate = parser.getText();
                    } else if (text == 'marketSegment') {
                        marketSegment = parser.getText();
                    } else if (text == 'fundingType') {
                        fundingType = parser.getText();
                    } else if (text == 'lineOfBusiness') {
                        lineOfBusiness = parser.getText();
                    } else if (text == 'planGroups') {
                        planGroups = arrayOfPlanGroups(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class SubPlanGroups_Z {
        public String name {get;set;} 
        public String code {get;set;} 
        public Integer planGroupId {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String lineOfBusiness {get;set;} 
        public String sortOrder {get;set;} 
        public List<SubPlanGroups> subPlanGroups {get;set;} 
        public SubPlanGroups_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'planGroupId') {
                            planGroupId = parser.getIntegerValue();
                        } else if (text == 'startDate') {
                            startDate = parser.getText();
                        } else if (text == 'endDate') {
                            endDate = parser.getText();
                        } else if (text == 'lineOfBusiness') {
                            lineOfBusiness = parser.getText();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'subPlanGroups') {
                            subPlanGroups = arrayOfSubPlanGroups(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'SubPlanGroups_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class PlanGroups {
        public String name {get;set;} 
        public String code {get;set;} 
        public Integer planGroupId {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String lineOfBusiness {get;set;} 
        public String sortOrder {get;set;} 
        public List<SubPlanGroups_Z> subPlanGroups {get;set;} 
        public List<BenefitHeaders> benefitHeaders {get;set;} 
        public PlanGroups(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'planGroupId') {
                            planGroupId = parser.getIntegerValue();
                        } else if (text == 'startDate') {
                            startDate = parser.getText();
                        } else if (text == 'endDate') {
                            endDate = parser.getText();
                        } else if (text == 'lineOfBusiness') {
                            lineOfBusiness = parser.getText();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'subPlanGroups') {
                            subPlanGroups = arrayOfSubPlanGroups_Z(parser);
                        } else if (text == 'benefitHeaders') {
                            benefitHeaders = arrayOfBenefitHeaders(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'PlanGroups consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class SubPlanGroups_X {
        public String name {get;set;} 
        public String code {get;set;} 
        public Integer planGroupId {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String lineOfBusiness {get;set;} 
        public String sortOrder {get;set;} 
        public List<Plans_Y> plans {get;set;} 
        public SubPlanGroups_X(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'planGroupId') {
                            planGroupId = parser.getIntegerValue();
                        } else if (text == 'startDate') {
                            startDate = parser.getText();
                        } else if (text == 'endDate') {
                            endDate = parser.getText();
                        } else if (text == 'lineOfBusiness') {
                            lineOfBusiness = parser.getText();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'plans') {
                            plans = arrayOfPlans_Y(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'SubPlanGroups_X consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class SubPlanGroups_Y {
        public String name {get;set;} 
        public String code {get;set;} 
        public Integer planGroupId {get;set;} 
        public String startDate {get;set;} 
        public String endDate {get;set;} 
        public String lineOfBusiness {get;set;} 
        public String sortOrder {get;set;} 
        public List<Plans_Z> plans {get;set;} 
        public SubPlanGroups_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'code') {
                            code = parser.getText();
                        } else if (text == 'planGroupId') {
                            planGroupId = parser.getIntegerValue();
                        } else if (text == 'startDate') {
                            startDate = parser.getText();
                        } else if (text == 'endDate') {
                            endDate = parser.getText();
                        } else if (text == 'lineOfBusiness') {
                            lineOfBusiness = parser.getText();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'plans') {
                            plans = arrayOfPlans_Z(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'SubPlanGroups_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Plans_Y {
        public String planName {get;set;} 
        public String planSalesId {get;set;} 
        public String description {get;set;} 
        public String longDescription {get;set;} 
        public String shortDescription {get;set;} 
        public String effectiveDate {get;set;} 
        public String expiryDate {get;set;} 
        public String retiredDate {get;set;} 
        public String division {get;set;} 
        public String network {get;set;} 
        public String channel {get;set;} 
        public Boolean isHsa {get;set;} 
        public Boolean isAllCopay {get;set;} 
        public String sortOrder {get;set;} 
        public List<BenefitHeaderDetails> benefitHeaderDetails {get;set;} 
        public String hsacontribution {get;set;} 
        public Plans_Y(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'planName') {
                            planName = parser.getText();
                        } else if (text == 'planSalesId') {
                            planSalesId = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'longDescription') {
                            longDescription = parser.getText();
                        } else if (text == 'shortDescription') {
                            shortDescription = parser.getText();
                        } else if (text == 'effectiveDate') {
                            effectiveDate = parser.getText();
                        } else if (text == 'expiryDate') {
                            expiryDate = parser.getText();
                        } else if (text == 'retiredDate') {
                            retiredDate = parser.getText();
                        } else if (text == 'division') {
                            division = parser.getText();
                        } else if (text == 'network') {
                            network = parser.getText();
                        } else if (text == 'channel') {
                            channel = parser.getText();
                        } else if (text == 'isHsa') {
                            isHsa = parser.getBooleanValue();
                        } else if (text == 'isAllCopay') {
                            isAllCopay = parser.getBooleanValue();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'benefitHeaderDetails') {
                            benefitHeaderDetails = arrayOfBenefitHeaderDetails(parser);
                        } else if (text == 'hsacontribution') {
                            hsacontribution = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Plans_Y consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Plans_Z {
        public String planName {get;set;} 
        public String planSalesId {get;set;} 
        public String description {get;set;} 
        public String longDescription {get;set;} 
        public String shortDescription {get;set;} 
        public String effectiveDate {get;set;} 
        public String expiryDate {get;set;} 
        public String retiredDate {get;set;} 
        public String division {get;set;} 
        public String planLevel {get;set;} 
        public String network {get;set;} 
        public String channel {get;set;} 
        public Boolean isHsa {get;set;} 
        public Boolean isAllCopay {get;set;} 
        public String sortOrder {get;set;} 
        public List<BenefitHeaderDetails> benefitHeaderDetails {get;set;} 
        public String hsacontribution {get;set;} 
        public List<Notes> notes {get;set;} 
        public Plans_Z(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'planName') {
                            planName = parser.getText();
                        } else if (text == 'planSalesId') {
                            planSalesId = parser.getText();
                        } else if (text == 'description') {
                            description = parser.getText();
                        } else if (text == 'longDescription') {
                            longDescription = parser.getText();
                        } else if (text == 'shortDescription') {
                            shortDescription = parser.getText();
                        } else if (text == 'effectiveDate') {
                            effectiveDate = parser.getText();
                        } else if (text == 'expiryDate') {
                            expiryDate = parser.getText();
                        } else if (text == 'retiredDate') {
                            retiredDate = parser.getText();
                        } else if (text == 'division') {
                            division = parser.getText();
                        } else if (text == 'planLevel') {
                            planLevel = parser.getText();
                        } else if (text == 'network') {
                            network = parser.getText();
                        } else if (text == 'channel') {
                            channel = parser.getText();
                        } else if (text == 'isHsa') {
                            isHsa = parser.getBooleanValue();
                        } else if (text == 'isAllCopay') {
                            isAllCopay = parser.getBooleanValue();
                        } else if (text == 'sortOrder') {
                            sortOrder = parser.getText();
                        } else if (text == 'benefitHeaderDetails') {
                            benefitHeaderDetails = arrayOfBenefitHeaderDetails(parser);
                        } else if (text == 'hsacontribution') {
                            hsacontribution = parser.getText();
                        } else if (text == 'notes') {
                            notes = arrayOfNotes(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Plans_Z consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class Notes {
        public Integer id {get;set;} 
        public String type_Z {get;set;} // in json: type
        public String text {get;set;} 
        public Notes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'type') {
                            type_Z = parser.getText();
                        } else if (text == 'text') {
                            text = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'Notes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public class BenefitHeaderDetails {
        public Integer id {get;set;} 
        public String name {get;set;} 
        public String value {get;set;} 
        public BenefitHeaderDetails(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getIntegerValue();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else {
                            System.debug(LoggingLevel.WARN, 'BenefitHeaderDetails consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static SGR_GSPSJsonToApex parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new SGR_GSPSJsonToApex(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    private static List<Notes> arrayOfNotes(System.JSONParser p) {
        List<Notes> res = new List<Notes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Notes(p));
        }
        return res;
    }
    private static List<Plans> arrayOfPlans(System.JSONParser p) {
        List<Plans> res = new List<Plans>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Plans(p));
        }
        return res;
    }
    private static List<Plans_Z> arrayOfPlans_Z(System.JSONParser p) {
        List<Plans_Z> res = new List<Plans_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Plans_Z(p));
        }
        return res;
    }
    private static List<SubPlanGroups_Z> arrayOfSubPlanGroups_Z(System.JSONParser p) {
        List<SubPlanGroups_Z> res = new List<SubPlanGroups_Z>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubPlanGroups_Z(p));
        }
        return res;
    }
    private static List<SubPlanGroups> arrayOfSubPlanGroups(System.JSONParser p) {
        List<SubPlanGroups> res = new List<SubPlanGroups>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubPlanGroups(p));
        }
        return res;
    }
    
    private static List<Plans_Y> arrayOfPlans_Y(System.JSONParser p) {
        List<Plans_Y> res = new List<Plans_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Plans_Y(p));
        }
        return res;
    }
    private static List<BenefitHeaderDetails> arrayOfBenefitHeaderDetails(System.JSONParser p) {
        List<BenefitHeaderDetails> res = new List<BenefitHeaderDetails>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BenefitHeaderDetails(p));
        }
        return res;
    }
    private static List<SubPlanGroups_Y> arrayOfSubPlanGroups_Y(System.JSONParser p) {
        List<SubPlanGroups_Y> res = new List<SubPlanGroups_Y>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubPlanGroups_Y(p));
        }
        return res;
    }
   
    private static List<SubPlanGroups_X> arrayOfSubPlanGroups_X(System.JSONParser p) {
        List<SubPlanGroups_X> res = new List<SubPlanGroups_X>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new SubPlanGroups_X(p));
        }
        return res;
    }
   
 
    private static List<PlanGroups> arrayOfPlanGroups(System.JSONParser p) {
        List<PlanGroups> res = new List<PlanGroups>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new PlanGroups(p));
        }
        return res;
    }
    private static List<BenefitHeaders> arrayOfBenefitHeaders(System.JSONParser p) {
        List<BenefitHeaders> res = new List<BenefitHeaders>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new BenefitHeaders(p));
        }
        return res;
    }
   
  */
}