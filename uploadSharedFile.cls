public class uploadSharedFile {
        
    public User u = [SELECT Id, ContactId, Contact.AccountID FROM User WHERE Id = :UserInfo.getUserId()];
    public SharedFile__c sf = new SharedFile__c();
    public String attachmentId;
    public Id acct = ApexPages.CurrentPage().getParameters().get('accid');
    Id profileId = UserInfo.getProfileId();
    String profileName = [Select Name from Profile where Id = :profileId Limit 1].Name;
    public Attachment attachment {
    get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
    set;
    }

    public uploadSharedFile(ApexPages.StandardController stdController) {
        this.sf = (SharedFile__c)stdController.getRecord();
    }
    
    public PageReference back() {
        return new PageReference('/'+acct);
    }
    
    public void createSF() {
        if(profileName == 'Nextep Community Plus - Admin') {
            sf.OwnerId = UserInfo.getUserId();
            sf.Account__c = u.Contact.AccountId;
            sf.FileName__c = attachment.name;
        }
        else {
            sf.OwnerId = UserInfo.getUserId();
            sf.Account__c = acct;
            sf.FileName__c = attachment.name;
        }

        insert sf;
    }
    
    public PageReference attachFile() {
        if(profileName == 'Nextep Community Plus - Admin') {
            if(attachment.BodyLength > 2097152) {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - File too big'));
                return new PageReference('/uploaderror');
            }
            
            else {
            
                createSF();
            
                attachment.OwnerId = UserInfo.getUserId();
                attachment.ParentId = sf.Id;
            
                try {
                    insert attachment;
                    attachmentId = Id.valueOf(attachment.id);
                    sf.Attachment__c = attachmentId;
                    attachment.Body = null;
                    update sf;
                } catch (DMLException e){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - please contact someone?'));
                }
                return new PageReference('/files');
            }
        }
        else {
            createSF();
        
            attachment.OwnerId = UserInfo.getUserId();
            attachment.ParentId = sf.Id;
        
            try {
                insert attachment;
                attachmentId = Id.valueOf(attachment.id);
                sf.Attachment__c = attachmentId;
                update sf;
            } catch (DMLException e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment - please contact someone?'));
            }
            //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
            return new PageReference('/'+acct);
        }
    }

}