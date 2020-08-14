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
    * FlsException represents a running user's lack of field level security to a specific field at a profile (or permission set) level
    * Sharing and CRUD security issues will never cause this to be thrown.
**/
public class FLSException extends SecurityException {

    private Schema.SObjectField fieldToken;

    public FLSException(OperationType operation, Schema.SObjectType objectType, Schema.SObjectField fieldToken) {
        this.fieldToken = fieldToken;
        this.objectType = objectType;
        this.operation = operation;

        switch on operation {
            when CREATE {
                this.setMessage(System.Label.security_error_field_not_insertable);
            }
            when READ {
                this.setMessage(System.Label.security_error_field_not_readable);
            }
            when MODIFY {
                this.setMessage(System.Label.security_error_field_not_updateable);
            }
            when else {
                //TODO
                System.debug('Lets take care of this later');
            }
        }

        String.format(this.getMessage(), new List<String> {
            objectType.getDescribe().getName(),
            fieldToken.getDescribe().getName()
        });
    }
}