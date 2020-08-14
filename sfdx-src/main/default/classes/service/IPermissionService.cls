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

/**
 * @author Rahul Chaudhary <rahulchaudharyofficial@outlook.com>
 * @version 1.0
 */
public interface IPermissionService {
    /*
     * Object Level
    */
    void checkObjectIsInsertable(Schema.SObjectType objType);
    void checkObjectIsReadable(Schema.SObjectType objType);
    void checkObjectIsUpdateable(Schema.SObjectType objType);
    void checkObjectIsDeletable(Schema.SObjectType objType);

    /*
     * Field Level
    */
    void checkFieldIsInsertable(SObjectType objType, String fieldName);
    void checkFieldIsInsertable(SObjectType objType, SObjectField fieldToken);
    void checkFieldIsInsertable(SObjectType objType, DescribeFieldResult fieldDescribe);

    void checkFieldIsReadable(SObjectType objType, String fieldName);
    void checkFieldIsReadable(SObjectType objType, SObjectField fieldToken);
    void checkFieldIsReadable(SObjectType objType, DescribeFieldResult fieldDescribe);

    void checkFieldIsUpdateable(SObjectType objType, String fieldName);
    void checkFieldIsUpdateable(SObjectType objType, SObjectField fieldToken);
    void checkFieldIsUpdateable(SObjectType objType, DescribeFieldResult fieldDescribe);
}