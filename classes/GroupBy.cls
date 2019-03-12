global class GroupBy
{
    private static Object getFeldValue(String field, sObject record)
    {
        if (field.contains('.'))
        {
            return getFeldValueCrossObject(field, record);
        }
        else
        {
            return record.get( field );
        }
    }

    private static Object getFeldValueCrossObject(String field, sObject record)
    {
        List<String> fieldPath = field.split('\\.');
        sObject currentObj = record;
        String actualField = fieldPath[0];
        for (Integer i = 0; i < fieldPath.size()-1; i++)
        {
            currentObj = currentObj.getSObject(actualField);
            if (currentObj == null) return null;
            actualField = fieldPath[i+1];
        }

        return currentObj.get( actualField );
    }
    

    global static Map<Date, List<sObject>> dates( String field, List<sObject> records )
    {
        Map<Date, List<sObject>> returnMap = new Map<Date, List<sObject>>();

        for ( sObject record : records )
        {
            Date key = (Date) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<DateTime, List<sObject>> datetimes( String field, List<sObject> records )
    {
        Map<DateTime, List<sObject>> returnMap = new Map<DateTime, List<sObject>>();

        for ( sObject record : records )
        {
            DateTime key = (DateTime) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Decimal, List<sObject>> decimals( String field, List<sObject> records )
    {
        Map<Decimal, List<sObject>> returnMap = new Map<Decimal, List<sObject>>();

        for ( sObject record : records )
        {
            Decimal key = (Decimal) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Integer, List<sObject>> integers( String field, List<sObject> records )
    {
        Map<Integer, List<sObject>> returnMap = new Map<Integer, List<sObject>>();

        for ( sObject record : records )
        {
            Integer key = (Integer) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Id, List<sObject>> ids( String field, List<sObject> records )
    {
        Map<Id, List<sObject>> returnMap = new Map<Id, List<sObject>>();

        for ( sObject record : records )
        {
            Id key = (Id) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<String, List<sObject>> strings( String field, List<sObject> records )
    {
        Map<String, List<sObject>> returnMap = new Map<String, List<sObject>>();

        for ( sObject record : records )
        {
            String key = (String) getFeldValue( field, record );

            if ( returnMap.containsKey( key ) )
            {
                returnMap.get( key ).add( record );
            }
            else
            {
                returnMap.put( key, new List<sObject>{ record } );
            }
        }

        return returnMap;
    }

    global static Map<Id, SObject> idToSObject( String field, List<SObject> records ){
        Map<Id, SObject> returnMap = new Map<Id, SObject>();

        for (SObject record : records){
            returnMap.put(record.Id, record);
        }
        return returnMap;
    }
}