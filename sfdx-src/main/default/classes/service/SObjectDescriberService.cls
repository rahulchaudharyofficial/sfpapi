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
 * SObjectDescriberService is a semi-intelligent wrapper for standard apex Schema methods.
 * It provides an internal caching layer, to avoid hitting describe limits from repeated use,
 * as well as wrapper classes and methods to make common tasks like working with relationship field name oddities
 * as well namespace handling.
 *
 * Of particular note for use in contexts that may be released as managed packages are the #getFields and get #getGlobalDescribe methods 
 * These return special immutable wrapper objects that automatically imply the current namespace (detected as the one this class is contained in)
 * and allow an older API style of omitting the namespace when working with fields or global describe maps.
 * This allows both upgrading old code to APIv29 by making use of these as a nearly drop in replacement, as well as keeping
 * namespace detection logic encapsulated.
 */

public class SObjectDescriberService implements ISObjectDescriberService {

    private Schema.SObjectType token;
    private Schema.SObjectField fieldName;

    private Schema.DescribeSObjectResult describe { //lazy load - keep this lightweight until we need more data
        get {
            if(describe==null) {
                describe = token.getDescribe();
            }
            return describe;
        }
        set;
    }

    private Map<String,Schema.SObjectField> fields { //lazy load - keep this lightweight until we need more data
		get{
			if(fields == null)
				fields = describe.fields.getMap();
			return fields;
		}
		set;
	}

    private Map<String,Schema.FieldSet> fieldSets { //lazy load - keep this lightweight until we need more data
        get {
            if(fieldSets == null) {
                fieldSets = token.getDescribe().fieldsets.getMap();
            }
            return fieldSets;
        }
        set;
    }

    private FieldsMap wrappedFields {
		get{
			if(wrappedFields == null){
				wrappedFields = new FieldsMap(this.fields);
			}
			return wrappedFields;
		}
		set;
    }

    private Map<String, Schema.SObjectType> globalDescribe {
        get {
            if(globalDescribe == null) {
                globalDescribe = Schema.getGlobalDescribe();
            }
            return globalDescribe;
        }
        set;
    }
    
    /*
     * Constructor
     */
    public SObjectDescriberService(Schema.SObjectType token) {
        if(token == null) {
            throw new InvalidDescribeException('Invalid SObject type: null');
        }
        this.token = token;
    }

    /**
	 * Returns the Schema.SObjectType this fflib_SObjectDescribe instance is based on.
    **/
    
    public Schema.SObjectType getSObjectType() {
        return this.token;
    }    
    
    /**
	 * This method is a convenient shorthand for calling getField(name, true)
	**/
    public Schema.SObjectField getField(String name) {
        return this.getField(name, true);
    }

    public Schema.SObjectField getField(String fieldName, Boolean implyNamespace) {
        Schema.SObjectField result = wrappedFields.get((fieldName.endsWithIgnoreCase('__r') ? (fieldName.removeEndIgnoreCase('__r')+'__c') : fieldName), implyNamespace);        if(result == null) {
            result = wrappedFields.get(fieldName+'Id', implyNamespace); //in case it's a standard lookup in cross-object format
        }
        return result;
    }

    /**
	* Returns the field where isNameField() is true (if any); otherwise returns null
	**/
    public Schema.SObjectField getFieldName() {
        if(fieldName == null) {
            for(Schema.SObjectField field : wrappedFields.values()) {
                if(field.getDescribe().isNameField()) {
                    fieldName = field;
                    break;
                }
            }
        }
        return fieldName;
    }

    /**
	 * Returns the raw Schema.DescribeSObjectResult an fflib_SObjectDescribe instance wraps.
	**/
    public Schema.DescribeSObjectResult getDescribe() {
        return describe;
    }

    /**
	 * This method returns the raw data and provides no namespace handling.
	 * Due to this, __use of this method is discouraged__ in favor of getFields(). 
	**/
    public Map<String,Schema.SObjectField> getFieldsMap() {
        return this.fields;
    }

    public FieldsMap getFields() {
        return wrappedFields;
    }

    public Map<String,Schema.FieldSet> getFieldSetsMap() {
        return fieldSets;
    }

    public void flushCache() {
        globalDescribe = null;
    }

    public Map<String,Schema.SObjectType> getGlobalDescribe() {
        return globalDescribe;
    }
    
}
