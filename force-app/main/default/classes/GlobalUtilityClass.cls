/*
-------
Name:
GlobalUtilityClass.cls
========================================================
========================================================
Purpose:
-------
Built to provide universal methods for other classes to implement different funcationailty
========================================================
========================================================
Verison     Author         Date           Detail
v1.0        C Stuart       xx-xx-xx       Inital development - Added newGuid method
*/
public with sharing class GlobalUtilityClass {
    
    /***************************************\
    @Method Name : newGuid
    @Author      : Chandler Stuart
    @Description : Generates a Globally Unique Identifier (GUID)
    @Return      : Returns a 16 digit guid
    /***************************************/
    public static String newGuid(){

        private static String kHexChars = '0123456789abcdefABCDEF';
        String returnValue = '';
        Integer nextByte = 0;

        for (Integer i=0 ; i<16 ; i++){

            if (i==4 || i==6 || i==10)
                returnValue += '-';
            
            nextByte = (Math.round(Math.random() * 255)-128) & 255;
            
            if (i==6){
                nextByte = nextByte & 15;
                nextByte = nextByte | (4 << 4);
            }

            if (i==8){
                nextByte = nextByte & 63;
                nextByte = nextByte | 128;
            }

            returnValue += getCharAtIndex(kHexChars, nextByte >> 4);
            returnValue += getCharAtIndex(kHexChars, nextByte & 15);
        }

        return returnValue;

        System.debug('Guid: ' + returnValue);
    }

    public static String getCharAtIndex(String str, Integer index) {

        if (str == null) return null;

        if (str.length() <= 0) return str;

        if (index == str.length()) return null;

        return str.substring(index, index+1);
    }
} 
