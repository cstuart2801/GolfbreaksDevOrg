/*
Name:  AP23_TestDataFactory.cls
======================================================
======================================================
Purpose:
-------
Test Data Factory to be used in all Apex classes.
======================================================
======================================================
History
------- 
Ver. Author        Date         Detail
1.0  Emman Flores  2016-04-02   Initial development
1.1  Simon Molloy  2017-11-09   New methods for Sprint / Sprint Item management
1.2  J Radcliffe   2019-05-02   RequestQueueBatch_Test coverage bug fix - Adding Object Field Mapping entries
1.3  J Radcliffe   2019-06-13   New Method createGolfbreaksBusinessUnits
1.4  J Radcliffe   2019-10-22   Modify createPersonAccount Method to return Person Accounts with unique email addresses
1.5  J Radcliffe   2020-01-23   New createStandardUsers Method and createAdminUsers Method 
1.6  J Radcliffe   2023-02-23   New methods - createVenueAccounts & createGolfCourses
1.7  C Stuart      2023-03-20   New Methods - createOutboundCallout & routingLogEntry
1.8  J Radcliffe   2023-04-23   New Method - createIndividuals
1.9  C Stuart      2023-04-06   New Method - generate Guid
*/
@isTest
public with sharing class AP23_TestDataFactory {
/*
    public static Map<String, Id> getRecordType(String objectName) {
        List<RecordType> Rectypes = [SELECT Name, Id FROM RecordType WHERE sObjectType = :objectName AND isActive = TRUE];
        Map<String, Id> RecordTypes = new Map<String, Id> {};
        for (RecordType rt : Rectypes) {
            RecordTypes.put(rt.Name, rt.Id);
        }
        return RecordTypes;
    }

    public static List<Account_Validation__c> createAccountValidationRulesByUserId(Id runningUserId){
        List<Account_Validation__c> valList = new List<Account_Validation__c>();
        valList.add(new Account_Validation__c(SetupOwnerId = runningUserId, 
                                                Create_Ancillary_Accounts__c = true,
                                                Create_Chain_Account__c = true,
                                                Create_Client_Account__c = true));

        return valList;
    }

    public static List<Account_Validation__c> createAccountValidationRulesByProfileId(Id userProfileId){
        List<Account_Validation__c> valList = new List<Account_Validation__c>();
        valList.add(new Account_Validation__c(SetupOwnerId = userProfileId, 
                                                Create_Ancillary_Accounts__c = true,
                                                Create_Chain_Account__c = true,
                                                Create_Client_Account__c = true));

        return valList;
    }

    public static List<Account> createAccount(Integer num) {

        Map<String, Id> accountRecordTypes = getRecordType('Account');
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < num; i++) {
            Account acc = new Account();
            //acc.RecordTypeId = accountRecordTypes.get('Business Account');
            acc.RecordTypeId = accountRecordTypes.get('Business');
            acc.Name = 'Test Account ' + i;
            acc.Phone = '+441231234567';
            accList.add(acc);
        }
        return accList;
    }

    //1.6+
    public static List<Account> createVenueAccounts(Integer num, Boolean doInsert){
        
        Id venueRTId = ApplicationConstant.ACC_RECTYPEID_VENUE;

        List<Account> accList = new List<Account>();
        for (integer i = 0 ; i < num ; i++){
            Account acc = new Account();
            acc.Name = 'Venue Account'+(i+1);
            acc.RecordTypeId = venueRTId;
            acc.Is_Active__c = true;
            acc.Golfbreaks_Venue_Id__c = i+1234;
            accList.add(acc);
        }

        if(doInsert){
            insert accList;
        }
        
        return accList;

    }

    //1.6+
    public static List<GolfCourse__c> createGolfCourses(Integer num, List<Account> venueAccounts, Boolean doInsert){

        List<GolfCourse__c> golfCourses = new List<GolfCourse__c>();
        for(Account venue : venueAccounts){
            for(Integer i=0;i<num;i++){
                golfCourses.add(new GolfCourse__c(
                    Name=venue.Name+' Course '+(i+1),
                    Account__c=venue.Id,
                    Golfbreaks_Golf_Course_ID__c=venue.Golfbreaks_Venue_Id__c+(i+1),
                    Is_Active__c = true
                ));
            }
        }
        if(doInsert){
            insert golfCourses;
        }
        return golfCourses;
    }

    public static List<Account> createPersonAccount(Integer num, Boolean isUnique){//1.4~
        Map<String, Id> accountRecordTypes = getRecordType('Account');
        List<Account> accList = new List<Account>();
        for (integer i = 0 ; i < num ; i++){
            Account acc = new Account();
            acc.RecordTypeId = accountRecordTypes.get('Client');
            acc.Salutation = 'Mr.';
            acc.FirstName = 'Test';
            acc.LastName = (isUnique)?'Person'+i:'Person';
            acc.PersonEmail = (isUnique)? 'test.person'+i+'@myemail.com':'test.person@myemail.com';//1.4~
            acc.PersonMobilePhone = '+441234567890';
            accList.add(acc);
        }
        return accList;
    }

    public static List<Account> createPersonAccount(Integer num){//1.4+
        return createPersonAccount(num,false);
    }

    public static List<Account> createBusinessAccount(integer num){
        Map<String, Id> accountRecordTypes = getRecordType('Account');
        List<Account> accList = new List<Account>();
        for (integer i = 0 ; i < num ; i++){
            Account acc = new Account();
            acc.RecordTypeId = accountRecordTypes.get('Business Account');
            acc.Name = 'Business Account ' + i;
            accList.add(acc);
        }
        return accList;    
    }

    public static List<Account> createAccountWithRecType(Integer num, String recType) {

        Map<String, Id> accountRecordTypes = getRecordType('Account');
        List<Account> accList = new List<Account>();
        for (Integer i = 0; i < num; i++) {
            Account acc = new Account();
            acc.RecordTypeId = accountRecordTypes.get(recType);
            if (recType == 'Client') acc.Lastname = 'Test Account ' + i;
            else acc.Name = 'Test Account ' + i;
            acc.Phone = '+441231234567';
            accList.add(acc);
        }
        return accList;
    }


    public static List<Contact> createContactList(Integer num, Account acc) {

        Map<String, Id> contactRecordTypes = getRecordType('Contact');
        List<Contact> conList = new List<Contact>();
        for (Integer i = 0; i < num; i++) {
            Contact con = new Contact();
            //Bhushan Sukumar - commenting out as there is no record type 'Business Contact' in Contacts
            //con.RecordTypeId = contactRecordTypes.get('Business Contact');
            con.RecordTypeId = contactRecordTypes.get('Customer');
            con.AccountId = acc.id;
            con.LastName = 'Test Contact ' + i;
            con.Phone = '+441231234567';
            con.Roles__c = 'Accounts contact';
            conList.add(con);
        }
        return conList;
    }
    
    public static List<Sales_Agent_Attributes__c> createSalesAgentAttribute(Integer num, User u) {
        List<Sales_Agent_Attributes__c> SAAList = new List<Sales_Agent_Attributes__c>();
        for (Integer i = 0; i < num; i++) {
            Sales_Agent_Attributes__c SAA = new Sales_Agent_Attributes__c();
            SAA.Sales_Rep__c = u.Id;
            SAA.Sales_Agent_ID__c = 'AGENTID'+ i;
            SAA.Current_Number_of_Open_Leads_Opps__c = 5;
            SAA.Max_Number_of_Open_Leads_Opportunities__c = 10;
            SAA.Team__c = 'S- EU 8+ Sales Team';
            SAAList.add(SAA);
        }
        return SAAList;
    }

    //2017-11-09 : SM : New methods for Chaneg Request / Department / Sprint / Sprint Item creation
    public static List<Change_Request__c> createChangeRequest(RecordType whichRT, integer num){
        RecordType rt;
        if (null == whichRT){
            rt = [select Id from RecordType where DeveloperName = 'Feature' AND SObjectType = 'Change_Request__c' LIMIT 1];
        }else {
            rt = whichRT;
        }

        List<Change_Request__c> crList = new List<Change_Request__c>();
        for (integer i = 0 ; i < num ; i++){
            Change_Request__c cr = new Change_Request__c();
            cr.RecordTypeId = rt.Id;
            cr.Title__c = 'Test CR ' + i;
            crList.add(cr);
        }

        return crList;
    }


    public static List<Department__c> createDepartment(integer num, List<User> mgrList){
        List<Department__c> deptList = new List<Department__c>();
        for (integer i = 0 ; i < num ; i++){
            Department__c dept = new Department__c(Name = 'Department ' + i);
            dept.Department_Manager__c = mgrList[i].Id;
            deptList.add(dept);
        }

        return deptList;
    }

    public static List<Employment__c> createEmployment(integer num, List<Department__c> depts){
        List<Employment__c> empList = new List<Employment__c>();
        for (Department__c d : depts){
            for (integer i = 0 ; i < num ; i++){
                Employment__c e = new Employment__c();
                e.Department__c = d.Id;
                e.Start_Date__c = Date.today().addYears(-1);
                empList.add(e);
            }    
        }

        return empList;
        
    }

    public static List<Sprint__c> createSprint(integer num){
        List<Sprint__c> sprintList = new List<Sprint__c>();
        for (integer i = 0 ; i < num ; i++){
            Sprint__c s = new Sprint__c(Name = 'Sprint ' + i);
            s.Start_Date__c = Date.today();
            s.End_Date__c = Date.today().addDays(14);
            s.Type__c = 'Salesforce - Standard';
            sprintList.add(s);
        }

        return sprintList;
    }

    public static List<Sprint_Item__c> createSprintItem(List<Sprint__c> sprints, Change_Request__c cr, integer num){
        List<Sprint_Item__c> siList = new List<Sprint_Item__c>();
        for (Sprint__c s : sprints){
            for (integer i = 0 ; i < num ; i++){
                Sprint_Item__c si = new Sprint_Item__c();
                si.Sprint__c = s.Id;
                si.Title__c = 'Test Sprint Item ' + i;
                si.Description__c = 'Test Sprint Item ' + i;
                si.Priority__c = 'P2';
                si.Origin__c = 'Change Request';
                si.Change_Request__c = cr.Id;
                siList.add(si);
            }
        }

        return siList;
    }

    public static List<Object_Field_Mapping__c> createObjectFieldMappingsByObject(String objectName){
        List<Object_Field_Mapping__c> ofmList = new List<Object_Field_Mapping__c>();
        if ('LEAD'.equalsIgnoreCase(objectName)){
            ofmList.add(new Object_Field_Mapping__c(Name = 'LeadName', Object_API_Name__c = objectName, Field_API_Name__c = 'Name'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'AdditionalInformation', Object_API_Name__c = objectName, Field_API_Name__c = 'AdditionalInformation__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'GBCampaignId', Object_API_Name__c = objectName, Field_API_Name__c = 'GolfBreaks_Campaign_ID__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Account', Object_API_Name__c = objectName, Field_API_Name__c = 'Account__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Email', Object_API_Name__c = objectName, Field_API_Name__c = 'Email'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'FirstName', Object_API_Name__c = objectName, Field_API_Name__c = 'FirstName'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'LastName', Object_API_Name__c = objectName, Field_API_Name__c = 'LastName'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'NewsletterSignup', Object_API_Name__c = objectName, Field_API_Name__c = 'NewsletterSignUp__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Nights', Object_API_Name__c = objectName, Field_API_Name__c = 'Nights__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Phone', Object_API_Name__c = objectName, Field_API_Name__c = 'Phone'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'MobilePhone', Object_API_Name__c = objectName, Field_API_Name__c = 'MobilePhone'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'HomePhone', Object_API_Name__c = objectName, Field_API_Name__c = 'HomePhone__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'PreferredTravelDate', Object_API_Name__c = objectName, Field_API_Name__c = 'PreferredTravelDate__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'PromoCode', Object_API_Name__c = objectName, Field_API_Name__c = 'PromoCode__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Salutation', Object_API_Name__c = objectName, Field_API_Name__c = 'Salutation'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'TravelGroupSize', Object_API_Name__c = objectName, Field_API_Name__c = 'TravelGroupSize__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'SalesRegion', Object_API_Name__c = objectName, Field_API_Name__c = 'SalesRegion__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Venue', Object_API_Name__c = objectName, Field_API_Name__c = 'Venue__c'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'Owner', Object_API_Name__c = objectName, Field_API_Name__c = 'OwnerId'));
            ofmList.add(new Object_Field_Mapping__c(Name = 'PGA', Object_API_Name__c = objectName, Field_API_Name__c = 'PGA__c'));
        }else if ('CASE'.equalsIgnoreCase(objectName)){
            ofmList.add(new Object_Field_Mapping__c(Name = 'CaseSubject', Object_API_Name__c = objectName, Field_API_Name__c = 'Subject'));
        }else if ('OPPORTUNITY'.equalsIgnoreCase(objectName)){
            ofmList.add(new Object_Field_Mapping__c(Name = 'OppName', Object_API_Name__c = objectName, Field_API_Name__c = 'Name'));
        }else if ('TASK'.equalsIgnoreCase(objectName)){
            ofmList.add(new Object_Field_Mapping__c(Name = 'TaskSubject', Object_API_Name__c = objectName, Field_API_Name__c = 'Subject'));
        }

        return ofmList;
    }

    public static List<Opportunity> createOpportunity(Integer num, String stageName, Account acc) {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < num; i++) {
            Opportunity opp = new Opportunity();
            opp.AccountId = acc.Id;
            opp.Name = 'Test Opportunity' + i;
            opp.Address__c = 'Test Address';
            opp.StageName = stageName;
            if (stageName == ApplicationConstant.OPP_STAGE_NOSALE ||
                    stageName == ApplicationConstant.OPP_STAGE_DUPLICATE) {
                opp.NoSaleReason__c = 'No availability';
                opp.NoSaleReasonComments__c = 'Test';
                opp.NoSaleReasonCompetitor__c = 'Other';
            }
            opp.DiaryDate__c = date.today();
            opp.CloseDate = date.today().addDays(10);
            oppList.add(opp);
        }
        return oppList;
    }
    
    public static List<Entitlement> createEntitlement(Integer num, Account acc) {
        List<Entitlement> entitleList = new List<Entitlement>();
        for (Integer i = 0; i < num; i++) {
            Entitlement ent = new Entitlement();
            ent.Name = 'Service Case';
            ent.AccountId = acc.Id;  
            ent.StartDate = system.today();
            ent.EndDate = system.today() + 30;
            entitleList.add(ent);
        }
        return entitleList;
    }

    public static List<Lead> createLead(Integer num) {
        List<Lead> leadList = new List<Lead>();
        for (Integer i = 0; i < num; i++) {
            Lead l = new Lead();
            l.FirstName = 'Lead Last Name' + i;
            l.Email = 'test@email.com';
            l.LastName = 'Lead Last Name' + i;
            l.Company = 'Lead Company' + i;
            l.Status = 'New';
            l.Phone = '+441434634996';
            leadList.add(l);
        }
        return leadList;
    }

    public static List<Lead> createLead(Integer num, String Rating) {
        List<Lead> leadList = new List<Lead>();
        for (Integer i = 0; i < num; i++) {
            Lead l = new Lead();
            l.FirstName = 'Lead LastName_' + Rating + i;
            l.Email = 'test@email.com';
            l.LastName = 'Lead Last Name' + i;
            l.Company = 'Lead Company' + i;
            l.Status = 'New';
            l.Phone = '+441434634996';
            l.Rating = Rating;

            leadList.add(l);
        }
        return leadList;
    }

    public static List<Lead> createLead(Integer num, Id accId) {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0 ; i < num ; i++) {
            Lead l = new Lead();
            l.Email = 'test@email.com';
            l.LastName = 'Lead Last Name' + i;
            l.Company = 'Lead Company' + i;
            l.Status = 'New';
            l.Account__c = accId;
            leads.add(l);
        }
        return leads;
    }

    public static List<Booking__c> createBooking(Integer num, Account acc, ID opp) {
        List<Booking__c> bookingList = new List<Booking__c>();
        for (Integer i = 0; i < num; i++) {
            Booking__c booking = new Booking__c();
            booking.Account__c = acc.Id;
            booking.Sales_Region_Group__c = 'UK & Ireland';
            booking.TECH_Opportunity__c = opp;
            booking.Sale_Price_Gross__c = 2932;
            booking.Golfbreaks_Booking_Number__c = i+'1234';
            //booking.TravelReturnDate2__c = date.today();
            bookingList.add(booking);
        }
        return bookingList;
    }

    public static List<Booking__c> createBooking(Integer num, Id accId, ID oppId) {
        List<Booking__c> bookingList = new List<Booking__c>();
        for (Integer i = 0; i < num; i++) {
            Booking__c booking = new Booking__c();
            booking.Account__c = accId;
            booking.Sales_Region_Group__c = 'UK & Ireland';
            booking.TECH_Opportunity__c = oppId;
            booking.Sale_Price_Gross__c = 2932;
            booking.AmountPaid__c = 100;
            //booking.TravelReturnDate2__c = date.today();
            bookingList.add(booking);
        }
        return bookingList;
    }

    public static List<GuestGroup__c> createGuestGroups(Integer num, Id bookingId){
        List<GuestGroup__c> guestGroups = new List<GuestGroup__c>();
        for(Integer i=0;i<num;i++){
            guestGroups.add(new GuestGroup__c(
                Booking__c = bookingId,
                Name = 'Test Group '+i
            ));
        }
        return guestGroups;
    }

    public static List<BookingGuest__c> createBookingGuests(Integer num, Id guestGroupId){
        List<BookingGuest__c> guests = new List<BookingGuest__c>();
        for(Integer i=0;i<num;i++){
            guests.add(new BookingGuest__c(
                GuestGroup__c = guestGroupId,
                GolfbreaksBookingGuestId__c = 1234+i,
                GolfbreaksGuestGroupId__c = 5678
            ));
        }
        return guests;
    }

    public static List<BookingTask__c> createBookingTasks(Integer num, Id bookingId, Id guestId){
        return createBookingTasks(num,bookingId,guestId,ApplicationConstant.BOOKING_TASK_STATUS_REQUIRED);
    }

    public static List<BookingTask__c> createBookingTasks(Integer num, Id bookingId, Id guestId, String status){
        List<BookingTask__c> tasks = new List<BookingTask__c>();
        for(Integer i=0;i<num;i++){
            tasks.add(new BookingTask__c(
                AssignedTo__c=guestId,
                Booking__c=bookingId,
                Status__c=status
            ));
        }
        return tasks;
    }

    public static List<BookingDocument__c> createBookingDocuments(Integer num, Id bookingId, Id guestId){
        List<BookingDocument__c> docs = new List<BookingDocument__c>();
        for(Integer i=0;i<num;i++){
            docs.add(new BookingDocument__c(
                BookingGuest__c=guestId,
                Booking__c=bookingId,
                Name='Test Booking Doc '+(i+1),
                DateAdded__c = system.today(),
                Filelocation__c = 'df33a34c-6e96-4835-bd99-daedc9c39411.pdf'
            ));
        }
        return docs;
    }

    public static List<Case> createCase(Integer num, Account acc) {
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < num; i++) {
            Case cas = new Case();
            cas.status = 'Open';
            cas.Type = 'Amendment';
            cas.AccountId = acc.Id;
            caseList.add(cas);
        }
        return caseList;
    }

    public static List<Case> createCase(Integer num, Id accId, Id bookingId) {
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < num; i++) {
            Case cas = new Case();
            cas.status = 'New';
            cas.Type = 'Amendment';
            cas.AccountId = accId;
            cas.Booking__c = bookingId;
            caseList.add(cas);
        }
        return caseList;
    }

    public static List<Case> createCaseWithOpp(Integer num, Id accId, Id oppId) {
        List<Case> caseList = new List<Case>();
        for (Integer i = 0; i < num; i++) {
            Case cas = new Case();
            cas.status = 'New';
            cas.Type = 'Amendment';
            cas.AccountId = accId;
            cas.Opportunity__c = oppId;
            caseList.add(cas);
        }
        return caseList;
    }

    public static Case createCaseAdmin(Id accId, Id bookingId) {
            Case cas = new Case();
            cas.status = 'New';
            cas.Type = 'Admin';
            cas.AccountId = accId;
            cas.Booking__c = bookingId;
            cas.RecordTypeId = ApplicationConstant.CASERECTYPEID_ADMIN;
            return cas;
    }

    public static List<Expected_Payment__c> createExpectedPayment(
        Integer num, Booking__c testBooking, String epaymentType, Decimal epaymentAmount) {

        List<Expected_Payment__c> epaymentList = new List<Expected_Payment__c>();
        for (Integer i = 0; i < num; i++) {
            Expected_Payment__c exp = new Expected_Payment__c();
            exp.Name = 'Test EXP '+i;
            exp.Booking__c = testBooking.Id;
            exp.ExpectedPaymentType__c = epaymentType;
            exp.Expected_Amount__c = epaymentAmount;
            exp.Expected_Payment_Date__c = Date.today().addDays(5);
            epaymentList.add(exp);
        }
        return epaymentList;

    }

    public static Expected_Payment__c createExpectedPaymentRecord(Booking__c testBooking, String epaymentType, Decimal epaymentAmount) {

            Expected_Payment__c exp = new Expected_Payment__c();
            exp.Name = 'Test EXP '; 
            exp.Booking__c = testBooking.Id;
            exp.ExpectedPaymentType__c = epaymentType;
            exp.Expected_Amount__c = epaymentAmount;
            exp.Expected_Payment_Date__c = Date.today().addDays(5);  
            
         return exp;   

    }

    public static List<Quote__c> createQuote(Integer num, String name, Opportunity testOpp, Account testAcc) {
        List<Quote__c> quoteList = new List<Quote__c>();
        for (Integer i = 0; i < num; i++) {
            Quote__c qq = new Quote__c();
            qq.Name = name;
            qq.Opportunity__c = testOpp.Id;
            qq.Account__c = testAcc.Id;
            quoteList.add(qq);
        }
        return quoteList;
    }

    public static List<Campaign> createCampaign(Integer num, Id mrktingStratId) {
        List<Campaign> cmpgnList = new List<Campaign>();
        for (Integer i = 0; i < num; i++) {
            Campaign cmpgn = new Campaign();
            cmpgn.Name = 'Golfo Estreito Campaign' + i;
            cmpgn.Type = ApplicationConstant.CAMPAIGN_MARKETING_CAMPAIGN_EVENT;
            cmpgn.IsActive = true;
            cmpgn.StartDate = System.today() - 2;
            cmpgn.EndDate = System.today() + 10;
            cmpgn.MarketingStrategy__c =  mrktingStratId;
            cmpgnList.add(cmpgn);
        }
        return cmpgnList;
    }
    //
    public static List<CampaignForecast__c> createCampaignForecast(Integer num, Account acc, Campaign cmp, BudgetCostCenter__c cntre) {
        List<CampaignForecast__c> cpFrcstList = new List<CampaignForecast__c>();
        for (Integer i = 0; i < num; i++) {
            CampaignForecast__c cmpgnFrcst = new CampaignForecast__c();
            cmpgnFrcst.Name = 'Pinchando los Greenes' + i;
            cmpgnFrcst.Approved__c = false;
            cmpgnFrcst.Approved_Date__c = System.today();
            cmpgnFrcst.AssociatedCampaign__c = cmp.Id;
            cmpgnFrcst.Committed__c = true;
            cmpgnFrcst.Supplier__c = acc.Id;
            cmpgnFrcst.AssociatedBudgetFinancialAccount__c = cntre.Id;
            cmpgnFrcst.ForecastedCost__c = i;
            cpFrcstList.add(cmpgnFrcst);
        }
        return cpFrcstList;
    }

    public static List<POInvoice__c> createPOInvoice(Integer num, Account acc, Nominal_Code__c nmCode) {
        List<POInvoice__c> poInvoiceList = new List<POInvoice__c>();
        for (Integer i = 0; i < num; i++) {
            POInvoice__c poInv = new POInvoice__c();
            poInv.Nominal_Code__c = nmCode.Id;
            poInv.Invoice_Date__c = System.today();
            poInv.InvoiceReference__c = 'INV-RRR-11' + i;
            poInv.Total_Amount__c = 2002;
            poInv.Account__c = acc.Id;
            poInvoiceList.add(poInv);
        }
        return poInvoiceList;
    }
    
    public static List<Task> createTask(Integer num, Case cs){
        List<Task> tskList = new List<Task>();
        for(Integer i = 0; i <num; i++){
            Task inTask = new Task();            
            inTask.WhoId = cs.ContactId;
            inTask.WhatId = cs.Id;
            inTask.Subject = 'Call Back Request';   
            inTask.Call_Back_Date_and_Time_Activity__c = System.today();
            inTask.ActivityDate = System.today();
            tskList.add(inTask);
        }
        return tskList;
    }

    public static List<Task> createTaskDynamic(Integer num, Case cs, String subject){
        List<Task> tskList = new List<Task>();
        for(Integer i = 0; i <num; i++){
            Task inTask = new Task();            
            inTask.WhoId = cs.ContactId;
            inTask.WhatId = cs.Id;  
            inTask.Subject = subject; 
            inTask.Call_Back_Date_and_Time_Activity__c = System.today();
            inTask.ActivityDate = System.today();
            tskList.add(inTask);
        }
        return tskList;
    }
    
        public static List<Event> createEvent(Integer num, Case cs){
        List<Event> eveList = new List<Event>();
        for(Integer i = 0; i <num; i++){
            Event inEvent = new Event();            
            inEvent.WhoId = null;
            inEvent.WhatId = cs.Id;
            inEvent.DurationInMinutes = 1;
            inEvent.ActivityDateTime = System.today();
            inEvent.Subject = 'Call Back Request';  
            inEvent.Call_Back_Date_and_Time_Activity__c = System.today();
            inEvent.ActivityDate = System.today();
            inEvent.Call_Notes__c = 'abc';
            inEvent.Description = 'description';
            eveList.add(inEvent);
        }
        return eveList;
    }
    
    //Create Marketing  Strategy
    public static List<MarketingStrategy__c> createMarketingStrategy(Integer num){
        List<MarketingStrategy__c> mStratList = new List<MarketingStrategy__c>();
        for(Integer i = 0; i <num; i++){
            MarketingStrategy__c mStrat = new MarketingStrategy__c();            
            mStrat.Name = 'Marketing Strategy ' +String.valueOf(i);
            mStrat.CurrencyIsoCode = 'GBP';
            mStratList.add(mStrat);
        }
        return mStratList;
    }  
    
    public static LeadScoringRule__c createScoringRules(Boolean isActive, String recordType, String fieldName, String objName, String operator, String value, Integer points){
        RecordType rec = [SELECT Id, DeveloperName, Name FROM RecordType WHERE SobjectType =: objName AND Name=: recordType LIMIT 1]; 
        LeadScoringRule__c csrule = new LeadScoringRule__c();
        csRule.Value__c = value;
        csrule.Operator__c = operator;
        csrule.Active__c = isActive;
        csrule.Name = 'Case Scoring Test';
        csrule.FieldLabel__c  = fieldName;
        csrule.RecordType__c = rec.Id;
        csrule.Record_Type_Name__c = recordType;
        csrule.Points__c = points;
        return csrule;
    }
    
    ////Create Marketing Budget
    public static List<MarketingBudget__c> createMarketingBudget(Integer num){
        List<MarketingBudget__c> mBudgList = new List<MarketingBudget__c>();
        for(Integer i = 0; i <num; i++){
            MarketingBudget__c mBudg = new MarketingBudget__c();            
            mBudg.Name = 'Marketing Budget ' +String.valueOf(i);
            mBudg.CurrencyIsoCode = 'GBP';
            mBudgList.add(mBudg);
        }
        return mBudgList;
    }  

    ////Create Nominal Code       
    public static List<Nominal_Code__c> createNominalCode(Integer num, Decimal Budget){
        List<Nominal_Code__c> lNC = new List<Nominal_Code__c>();
        for(Integer i = 0; i <num; i++){
            Nominal_Code__c NC = new Nominal_Code__c();            
            NC.Name = 'Nominal Code ' +String.valueOf(i);
            NC.Nominal_Code_Name__c = 'Nominal Code ' +String.valueOf(i);
            NC.Budget__c = Budget;
            NC.CurrencyIsoCode = 'GBP';
            lNC.add(NC);
        }
        return lNC;
    }  
    
    //Create Budget Cost Center       
    public static List<BudgetCostCenter__c> createBudgetCostCenter(Integer num, Id MarketingBudgetId, Id NominalCodeId){
        List<BudgetCostCenter__c> lBCC = new List<BudgetCostCenter__c>();
        for(Integer i = 0; i <num; i++){
            BudgetCostCenter__c mBCC = new BudgetCostCenter__c();            
            mBCC.Name = 'Budget Cost Center ' +String.valueOf(i);
            mBCC.CurrencyIsoCode = 'GBP';
            mBCC.MarketingBudget__c = MarketingBudgetId;
            mBCC.Nominal_Code__c = NominalCodeId;
            lBCC.add(mBCC);
        }
        return lBCC;
    }    
    
    //Create Committed Fund
    public static List<PurchaseOrder__c> createCommittedFund(Integer num, Decimal Budget, Id CampaignId, Id SupplierId, Id BudgetId){
        List<PurchaseOrder__c> lPO = new List<PurchaseOrder__c>();
        for(Integer i = 0; i <num; i++){
            PurchaseOrder__c PO = new PurchaseOrder__c();            
            PO.Name = 'Committed Fund ' +String.valueOf(i);
            PO.Amount__c = Budget;
            PO.CurrencyIsoCode = 'GBP';
            PO.Campaign__c = CampaignId;
            PO.Supplier__c = SupplierId;
            PO.BudgetCostCenter__c = BudgetId;
            lPO.add(PO);
        }
        return lPO;
    }
    
    //Create Monthly Sales Targets
    public static Monthly_Sales_Target__c createMonthlySalesTargetByGrossProfit(User salesAgent, Date targetDate){
        Id recordTypeId = ApplicationConstant.MONTHLY_SALES_TARGET_GROSS_PROFIT;
        Monthly_Sales_Target__c monthlySalesTarget = 
            new Monthly_Sales_Target__c( SalesAgent__c = salesAgent.Id, 
                                         Working_Days_in_a_month__c = 20,
                                         Target_Month_Year__c = targetDate,
                                         RecordTypeId = recordTypeId);
        return monthlySalesTarget;
    }  
    
    //Create Monthly Sales Targets
    public static Monthly_Sales_Target__c createMonthlySalesTargetByBookings(User salesAgent, Date targetDate){
        Id recordTypeId = ApplicationConstant.MONTHLY_SALES_TARGET_BOOKINGS;
        Monthly_Sales_Target__c monthlySalesTarget = 
            new Monthly_Sales_Target__c( SalesAgent__c = salesAgent.Id, 
                                         Working_Days_in_a_month__c = 20,
                                         Target_Month_Year__c = targetDate,
                                         RecordTypeId = recordTypeId);
        return monthlySalesTarget;
    }  

    public static List<Request_Queue__c> createRequestQueue(Integer num){
        List<Request_Queue__c> requestQueueList = new List<Request_Queue__c>();

        for(integer i=0; i<=num; i++){
            Request_Queue__c req = new Request_Queue__c();
            req.CurrencyIsoCode = 'GBP';
            req.Priority__c = '1';
            req.Request_Status__c = 'Processing';
            req.Request_Payload__c = '1';
            requestQueueList.add(req);
        }
         return requestQueueList;
    }


    public static List<LeadScoreMapping__c> getCasePriorityList(){
        List<LeadScoreMapping__c> lsmList = new List<LeadScoreMapping__c>();

        LeadScoreMapping__c lsmP1 = new LeadScoreMapping__c();
        lsmP1.RuleType__c = 'Case';
        lsmP1.LeadScoreMinimumValue__c = 70;
        lsmP1.LeadScoreMaximumValue__c = 100;
        lsmP1.CasePriority__c = 'P1';
        lsmList.add(lsmP1);

        LeadScoreMapping__c lsmP2 = new LeadScoreMapping__c();
        lsmP2.RuleType__c = 'Case';
        lsmP2.LeadScoreMinimumValue__c = 31;
        lsmP2.LeadScoreMaximumValue__c = 69;
        lsmP2.CasePriority__c = 'P2';
        lsmList.add(lsmP2);

        LeadScoreMapping__c lsmP3 = new LeadScoreMapping__c();
        lsmP3.RuleType__c = 'Case';
        lsmP3.LeadScoreMinimumValue__c = 0;
        lsmP3.LeadScoreMaximumValue__c = 30;
        lsmP3.CasePriority__c = 'P3';
        lsmList.add(lsmP3);

        LeadScoreMapping__c lsmP4 = new LeadScoreMapping__c();
        lsmP4.RuleType__c = 'Case';
        lsmP4.LeadScoreMinimumValue__c = 100;
        lsmP4.LeadScoreMaximumValue__c = 200;
        lsmP4.CasePriority__c = 'P4';
        lsmList.add(lsmP4);

        return lsmList;
    }  

    public static List<LeadScoringRule__c> getLeadScoringRuleForCase(){
        List<LeadScoringRule__c> lsrList = new List<LeadScoringRule__c>();
        LeadScoringRule__c lsRule1 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(),
                                                            Name = 'Case',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Case Origin',
                                                            Value__c = 'Email',
                                                            Operator__c = 'equals',
                                                            Points__c = 140);
        
        lsrList.add(lsRule1);
        LeadScoringRule__c lsRule2 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(),
                                                            Name = 'Customer Satisfaction: Very Dissatisfied',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Customer Satisfaction',
                                                            Value__c = 'Very Dissatisfied',
                                                            Operator__c = 'equals',
                                                            Points__c = 40);
        lsrList.add(lsRule2);
        LeadScoringRule__c lsRule3 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(),
                                                            Name = 'Service Case',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Accountable for Issue',
                                                            Value__c = 'Service',
                                                            Operator__c = 'equals',
                                                            Points__c = 35);
        lsrList.add(lsRule3);
        LeadScoringRule__c lsRule4 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Is First Contact Resolved: True',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Is First Contact Resolved',
                                                            Value__c = 'True',
                                                            Operator__c = 'equals',
                                                            Points__c = 7);
        lsrList.add(lsRule4);

        //Account Name
        LeadScoringRule__c lsRule5 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for Not Equal',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Case Origin',
                                                            Value__c = 'phone',
                                                            Operator__c = 'not equals',
                                                            Points__c = 20);

        
        LeadScoringRule__c lsRule6 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for contains',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Case Origin',
                                                            Value__c = 'email',
                                                            Operator__c = 'contains',
                                                            Points__c = 20);

        lsrList.add(lsRule6);

        LeadScoringRule__c lsRule7 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for equals number',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Time taken to resolve',
                                                            Value__c = '5.02',
                                                            Operator__c = 'equals',
                                                            Points__c = 20);

        lsrList.add(lsRule7);

        LeadScoringRule__c lsRule8 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for not equals number',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Time taken to resolve',
                                                            Value__c = '2.01',
                                                            Operator__c = 'not equals',
                                                            Points__c = 20);

        lsrList.add(lsRule8);

        LeadScoringRule__c lsRule9 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for starts with',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Case Origin',
                                                            Value__c = 'email',
                                                            Operator__c = 'starts with',
                                                            Points__c = 20);

        lsrList.add(lsRule9);

        LeadScoringRule__c lsRule10 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for less than/greater than',
                                                            Active__c = true,
                                                            FieldLabel__c = 'No. of Updates',
                                                            Value__c = '0',
                                                            MinimumValue__c = 1,
                                                            MaximumValue__c = 10,
                                                            Operator__c = 'less than/greater than',
                                                            Points__c = 2);

        lsrList.add(lsRule10);


        LeadScoringRule__c lsRule11 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for not equals 2',
                                                            Active__c = true,
                                                            FieldLabel__c = 'No. of Updates',
                                                            Value__c = '0',
                                                            Operator__c = 'not equals',
                                                            Points__c = 2);

        lsrList.add(lsRule11);

        LeadScoringRule__c lsRule12 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for equals 2',
                                                            Active__c = true,
                                                            FieldLabel__c = 'No. of Updates',
                                                            Value__c = '5',
                                                            Operator__c = 'equals',
                                                            Points__c = 2);

        lsrList.add(lsRule12);

        LeadScoringRule__c lsRule13 = new LeadScoringRule__c(RecordType__c = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId(),
                                                            RecordTypeId =Schema.SObjectType.LeadScoringRule__c.getRecordTypeInfosByName().get('Scoring Rules for Cases').getRecordTypeId(), 
                                                            Name = 'Test for equals 3',
                                                            Active__c = true,
                                                            FieldLabel__c = 'Case Status',
                                                            Value__c = 'Closed',
                                                            Operator__c = 'equals',
                                                            Points__c = 1);

        lsrList.add(lsRule13);
        
        return lsrList;
    }

    public static List<Object_Field_Mapping__c> getCustomSettingObjectFieldMapping(){
        List<Object_Field_Mapping__c> customSettings = new List<Object_Field_Mapping__c>();
        Object_Field_Mapping__c objctFieldMapping = new Object_Field_Mapping__c(); 

        objctFieldMapping.Name = '101';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'Salutation';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '102';
        objctFieldMapping.Field_API_Name__c = 'FirstName';
        objctFieldMapping.Object_API_Name__c ='Account';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '103';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'LastName';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '104';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonEmail';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '105';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonMobilePhone';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '106';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonHomePhone';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = '107';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonOtherPhone';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AdditionalInformation';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'AdditionalInformation__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AffiliateCampaignID';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'GolfBreaks_Campaign_ID__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'ClientAccountID';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Account__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Email';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Email';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'FirstName';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'FirstName';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'LastName';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'LastName';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Lead Owner';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'OwnerId';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'NewsletterSignUp';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'NewsletterSignUp__c';
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountNewsletterSignUp';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'NewsletterSignUp__c';
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountIsPGA';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'Is_PGA__pc';  
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountPersonMailingStreet';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonMailingStreet';  
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountPersonMailingPostalCode';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonMailingPostalCode';  
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountPersonMailingCity';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonMailingCity';  
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountPersonMailingCountry';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'PersonMailingCountry';  
        customSettings.add(objctFieldMapping);
        
        //1.2 Added 02/05/19
        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'AccountMailing_State_County__pc';
        objctFieldMapping.Object_API_Name__c ='Account';
        objctFieldMapping.Field_API_Name__c = 'Mailing_State_County__pc';  
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Nights';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Nights__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Phone';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'MobilePhone';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'PreferredTravelDate';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'PreferredTravelDate__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'PromotionCode';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'PromoCode__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'SalesRegion';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'SalesRegion__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Salutation';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Salutation';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'TravelGroupSize';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'TravelGroupSize__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Venue';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Venue__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'VenueAccountIDs';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Description';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Home Phone';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'HomePhone__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Work Phone';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'Phone';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Is PGA';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'PGA__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Record Type ID';
        objctFieldMapping.Object_API_Name__c ='Lead';
        objctFieldMapping.Field_API_Name__c = 'RecordTypeId';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Golfbreaks Enquiry Id';
        objctFieldMapping.Object_API_Name__c ='Opportunity';
        objctFieldMapping.Field_API_Name__c = 'GolfbreaksEnquiryId__c';
        customSettings.add(objctFieldMapping);

        objctFieldMapping = new Object_Field_Mapping__c();
        objctFieldMapping.Name = 'Owner Id';
        objctFieldMapping.Object_API_Name__c ='Opportunity';
        objctFieldMapping.Field_API_Name__c = 'OwnerId';
        customSettings.add(objctFieldMapping);  

        return customSettings;
    } 

    //1.3 
    public static List<Golfbreaks_Business_Unit__c> createBusinessUnitsAndTerritories(Integer count, Integer numOfTerritories, Boolean returnData){
        system.debug('Creating '+count+' Business Units with '+numOfTerritories+' Territories');
        List<Golfbreaks_Business_Unit__c> newBUs = new List<Golfbreaks_Business_Unit__c>();
        for(Integer i = 0;i<count;i++){
            system.debug('Business Unit: '+i);
            Golfbreaks_Business_Unit__c bu = new Golfbreaks_Business_Unit__c();
            bu.Name = 'Test Business Unit';
            newBUs.add(bu);
        }
        insert newBus;
        //Note - When a BU is inserted a default territory is implicitly created
        if(numOfTerritories > 0){
            if(numOfTerritories > 1){
                system.debug('New Territories Start');
                //More Territories for each BU are required (in addition to the implicitly created Territory)
                List<Territory__c> newTs = new List<Territory__c>();
                for(Golfbreaks_Business_Unit__c gbu : newBUs){
                    for(Integer i = 0; i<(numOfTerritories-1);i++){
                        system.debug('Territory: '+i);
                        Territory__c t = new Territory__c();
                        t.Name = 'Test Territory '+i;
                        t.BusinessUnit__c = gbu.Id;
                    }
                }
                insert newTs;
                system.debug('New Territories Stop');
            }
        }else{
            //Delete the territories that were implicitly created (by PB) on BU Insert
            delete [Select Id From Territory__c];
        }
        if(returnData){
            return [Select Id, (Select Id, IsDefault__c, BusinessUnit__c, Countries__c, Name From Territories__r), Name, IsDefault__c From Golfbreaks_Business_Unit__c];
        }else{
            return null;
        }
        
    }

    //1.5+
    public static List<User> createStandardUsers(Integer count, String lastName, Boolean doInsert){
        Id profileId = [Select Id From Profile Where Name Like '%Standard User%' Limit 1].Id;        
        List<User> users = new List<User>();
        for(Integer i=0; i<count; i++){
            User u = new User();
            u.FirstName = 'Test';
            u.LastName = lastName+i;
            u.IsActive = true;
            u.Username = 'testUser'+i+lastName+'@example.com'+System.currentTimeMillis();//Ensure it is unique
            u.Email = 'test'+i+lastName+'@example.com';
            u.Alias = 'alias'+i;
            u.TimeZoneSidKey = UserInfo.getTimeZone().getId();
            u.LocaleSidKey = UserInfo.getLocale();
            u.LanguageLocaleKey = UserInfo.getLanguage();
            u.EmailEncodingKey = 'UTF-8';
            u.ProfileId = profileId;
            users.add(u);
        }
        
        if(doInsert && users.size()>0){
            insert users;
        }
        
        return users;
    }

    //1.5+
    public static List<User> createAdminUsers(Integer count, String lastName, Boolean doInsert){
        Id profileId = [Select Id From Profile Where Name Like 'System Administrator' Limit 1].Id;        
        List<User> users = new List<User>();
        for(Integer i=0; i<count; i++){
            User u = new User();
            u.FirstName = 'Admin';
            u.LastName = lastName+i;
            u.IsActive = true;
            u.Username = 'adminUser'+i+lastName+'@example.com'+System.currentTimeMillis();//Ensure it is unique
            u.Email = 'admin'+i+lastName+'@example.com';
            u.Alias = 'alias'+i;
            u.TimeZoneSidKey = UserInfo.getTimeZone().getId();
            u.LocaleSidKey = UserInfo.getLocale();
            u.LanguageLocaleKey = UserInfo.getLanguage();
            u.EmailEncodingKey = 'UTF-8';
            u.ProfileId = profileId;
            users.add(u);
        }
        
        if(doInsert && users.size()>0){
            insert users;
        }
        
        return users;
    }
    
    //1.7 - createOutboundCallout (This method will sucessfully create Outbound Bound Callout records in Bulk when required)
    public static List<OutboundCallout__c> createOutboundCallout(Integer num){
     
        // Create the Outbound Callout Data
        List<OutboundCallout__c> ocList = new List<OutboundCallout__c>();
        for(Integer i = 0 ; i < num ; i++){
            OutboundCallout__c oc = new OutboundCallout__c();
            oc.Endpoint__c = ApplicationConstant.OUTBOUND_CALLOUT_ENDPOINT + i;
            oc.Method__c = ApplicationConstant.OUTBOUND_CALLOUT_HTTP_METHOD_REQUEST;
            oc.ContentTypeHeader__c = ApplicationConstant.OUTBOUND_CALLOUT_CONTENT_TYPE_HEADER_JSON;
            oc.AcceptHeader__c = ApplicationConstant.OUTBOUND_CALLOUT_ACCEPT_HEADER_ANY;              
            oc.Body__c = ApplicationConstant.OUTBOUND_CALLOUT_BODY;
            oc.DataEventType__c = ApplicationConstant.OUTBOUND_CALLOUT_DATA_EVENT_TYPE_CH_OPP_CREATE;
            oc.Status__c = Label.Picklist_Value_OutboundCallout_Status_New;
            ocList.add(oc);
        }   
        return ocList;
    }

    //1.7 - createRoutingLogEntry (This method will sucessfully creates Routing Log Entries in Bulk to be actioned via other classes)
    public static List<GBWire__RoutingLogEntry__c> createRoutingLogEntry(Integer num){

        // Create routing Log Entry Data
        List<GBWire__RoutingLogEntry__c> routeLogEntryList = new List<GBWire__RoutingLogEntry__c>();
        for(Integer i = 0 ; i < num ; i++){
            GBWire__RoutingLogEntry__c routeLogEntry = new GBWire__RoutingLogEntry__c();
            routeLogEntry.GBWire__Message__c = ApplicationConstant.ROUTING_LOG_ENTRY_MESSAGE;
            routeLogEntryList.add(routeLogEntry);
        }
        return routeLogEntryList;
    }

    //1.8 - Create a blank individual entry for the accounts provided
    public static List<Individual> createIndividuals(List<Account> accs, Boolean doInsert){
        List<Individual> individuals = new List<Individual>();
        for(Account acc : accs){
            individuals.add(new Individual(Account__c=acc.Id,FirstName=acc.FirstName,LastName=acc.LastName));
        }
        if(doInsert) insert individuals;
        return individuals;
    }

    public static Map<Id,SObject> convertListToMap(List<SObject> records){
        String dataType = String.valueOf(records[0].getSObjectType());
        Type t= Type.forName('Map<Id,'+dataType+'>');  
        Map<Id,SObject> sObjectMap =(Map<Id,SObject>)t.newInstance();
        for(SObject record:records){
            sObjectMap.put((Id)record.get('Id'),record);
        }
        return sObjectMap;
    }*/

    //1.9 - Generate GUID (This method will succesfully generate a Global Unique Identifier (GUID))
    public static List<String> generateGuid(Integer num){
        // Generate GUID
        List<String> guidList = new List<String>();
        for(Integer i=0 ; i<100 ; i++){
            String genGuid = GlobalUtilityClass.newGuid();
            guidList.add(genGuid);
        }
        return guidList;
    }

}