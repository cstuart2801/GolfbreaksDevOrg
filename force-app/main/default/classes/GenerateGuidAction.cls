/*
-------
Name:
GenerateGuidAction.cls
========================================================
========================================================
Purpose:
-------
Invocable class to allow functionaitlity to be pass through Apex Actions
========================================================
========================================================
Verison     Author         Date           Detail
v1.0        C Stuart       06-04-23      Inital Development - add generateGuid method
*/
global with sharing class GenerateGuidAction {
    
    /***************************************\
    @Method Name : generateGuid
    @Author      : Chandler Stuart
    @Description : Invocable method added to allow code to be executed via flow & return a output value of a GUID
    @Return      : Returns a 16 digit guid
    /***************************************/

    @InvocableMethod(label='Generate Guid' description= 'Create\'s a GUID')
    public static List<String> generateGuid(){
        List<String> guidList = new List<String>();
        String guid = GlobalUtilityClass.newGuid();
        guidList.add(guid);
        return guidList;
    }
}
