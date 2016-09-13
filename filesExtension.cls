public class filesExtension {
    
    SharedFile__c sf  {get;set;}
    User u = [SELECT Id, ContactId, Contact.AccountID, Account.Name FROM User WHERE Id = :UserInfo.getUserId()];
    Id profileId = UserInfo.getProfileId();
    String profileName = [Select Name from Profile where Id = :profileId Limit 1].Name;
    public List<SharedFile__c> sFiles;
    
    public filesExtension(ApexPages.StandardController stdController) {
        this.sf = (SharedFile__c)stdController.getRecord();
    }
    
    public List<SharedFile__c> getSFiles() {
        if (sFiles == null) {
            if(profileName == 'Nextep Community Plus - Admin') {
            sFiles = [SELECT Id, FileName__c, Link__c, Account__c, Attachment__c, ShareWith__c, CreatedDate 
                      FROM SharedFile__c 
                      WHERE Attachment__c != null 
                      AND Account__c = : u.Contact.AccountId 
                      AND SharedFile__c.Archived__c = FALSE
                      AND (SharedFile__c.ShareWith__c = 'Company' OR SharedFile__c.ShareWith__c = 'Admins Only')];
            }
            else if(profileName == 'Nextep Community - WSE') {
                sFiles = [SELECT Id, FileName__c, Link__c, Account__c, Attachment__c , ShareWith__c, CreatedDate
                      FROM SharedFile__c 
                      WHERE Attachment__c != null 
                      AND Account__c = : u.Contact.AccountId 
                      AND SharedFile__c.Archived__c = FALSE
                      AND SharedFile__c.ShareWith__c = 'Company'];
            }
        }
        return sFiles;
    }
    
    

}