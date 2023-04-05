/*
-------
Name:
GenerateGuidAction.cls
========================================================
========================================================
Purpose:
-------

========================================================
========================================================
Verison     Author         Date           Detail
v1.0        C Stuart       xx-xx-xx       
*/
global with sharing class GenerateGuidAction {
    
    /***************************************\
    @Method Name : generateGuid
    @Author      : Chandler Stuart
    @Description : Apex Action to be pass through a Flow, to generate a 16 digit GUID for the Password reset token
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
