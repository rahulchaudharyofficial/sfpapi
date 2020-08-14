/**
 * Copyright (c), Rahul Chaudhary Official
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the Rahul Chaudhary Official nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
public class PermissionService implements IPermissionService {
    /**
     * If set to true all check methods will always return void, and never throw exceptions.
     * This should really only be set to true if an app-wide setting to disable in-apex
     * FLS and CRUD checks exists and is enabled.
     * Per security best practices setting BYPASS should be an a opt-in, and not the default behavior.
     **/
    private Boolean bypassInternalFlsAndCrud {get;set;}

    public PermissionService() {
        this.bypassInternalFlsAndCrud = false;
    }

    /*
     * This constructor can be used to construct Permission Service which ignores FLS and CRUD checks
     */
    public PermissionService(Boolean bypassInternalFlsAndCrud) {
        this.bypassInternalFlsAndCrud = bypassInternalFlsAndCrud;
    }

    /**
     * This method verify if current user has insert permission on given sObjectType
     * @exception CrudException if the running user does not have insert rights to the {@code objType} SObject.
    */
    public void checkObjectIsInsertable(Schema.SObjectType objType) {
       if(this.bypassInternalFlsAndCrud) {
           return;
       } 
       else if(!objType.getDescribe().isCreateable()) {
            throw new CrudException(OperationType.CREATE,objType);
       }
    }

    /**
     * This method verify if current user has read permission on given sObjectType
     * @exception CrudException if the running user does not have read rights to the {@code objType} SObject.
    */
    public void checkObjectIsReadable(Schema.SObjectType objType) {
        if(this.bypassInternalFlsAndCrud) {
            return;
        } 
        else if(!objType.getDescribe().isAccessible()) {
             throw new CrudException(OperationType.READ,objType);
        }
    }

    /**
     * This method verify if current user has modify permission on given sObjectType
     * @exception CrudException if the running user does not have modify rights to the {@code objType} SObject.
    */
    public void checkObjectIsUpdateable(Schema.SObjectType objType) {
        if(this.bypassInternalFlsAndCrud) {
            return;
        } 
        else if(!objType.getDescribe().isUpdateable()) {
             throw new CrudException(OperationType.MODIFY,objType);
        }
    }


    /**
     * This method verify if current user has delete permission on given sObjectType
     * @exception CrudException if the running user does not have delete rights to the {@code objType} SObject.
    */
    public void checkObjectIsDeletable(Schema.SObjectType objType) {
        if(this.bypassInternalFlsAndCrud) {
            return;
        } 
        else if(!objType.getDescribe().isDeletable()) {
             throw new CrudException(OperationType.DEL,objType);
        }
    }

    /**
     * Checks both insert FLS and CRUD for the specified object type and fields.
     * @exception FLSException if the running user does not have insert rights to any fields in {@code fieldNames}.
     * @exception CrudException if the running user does not have insert rights to {@code objType}
     **/
    public void checkFieldIsInsertable(SObjectType objType, String fieldName) {
        checkObjectIsInsertable(objType);
        
    }

    public void checkFieldIsInsertable(SObjectType objType, SObjectField fieldToken) {

    }
    public void checkFieldIsInsertable(SObjectType objType, DescribeFieldResult fieldDescribe){}
    public void checkFieldIsReadable(SObjectType objType, String fieldName){}
    public void checkFieldIsReadable(SObjectType objType, SObjectField fieldToken){}
    public void checkFieldIsReadable(SObjectType objType, DescribeFieldResult fieldDescribe){}
    public void checkFieldIsUpdateable(SObjectType objType, String fieldName){}
    public void checkFieldIsUpdateable(SObjectType objType, SObjectField fieldToken){}
    public void checkFieldIsUpdateable(SObjectType objType, DescribeFieldResult fieldDescribe){} 
}