/*
-------
Name:
GenerateGuidActionTest.cls
========================================================
========================================================
Purpose:
-------

=========================================================
=========================================================
Verison     Author         Date           Detail
v1.0        C Stuart       05/04/2023     Inital Development - Added 
*/
@isTest
public with sharing class GenerateGuidActionTest {
    
    @isTest
    static void generateGuidTest(){
    
        // Insert test data
        List<String> guidList = AP23_TestDataFactory.generateGuid(100);
        
        System.assertEquals(35, guidList[0].length(), 'Guid Should be 35 digit\'s long'); 
        System.assertEquals(100, guidList.size(), 'List should be 100');       
    }

    @isTest
    static void generateGuidActionTest() {

        List<String> guid = generateGuidAction.generateGuid();
        System.assertEquals(1, guid.size(), 'Guid should only return one');
    }
}