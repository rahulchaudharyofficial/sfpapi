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
public abstract class NamespacedAttributeMap {
    protected String currentNamespace;
    protected Map<String,Object> values;

    public NamespacedAttributeMap(Map<String,Object> values) {
        this.values = values;
        this.currentNamespace = NamespacedAttributeMap.class.getName().substringBefore(NamespacedAttributeMap.class.getName()).removeEnd('.').toLowerCase();
    }


    //A no-args constructor to allow subclasses with different constructor signatures
    protected NamespacedAttributeMap() {
        this(new Map<String,Object>());
    }

    protected virtual Object getObject(String name){
        return this.getObject(name, true);
    }

    protected virtual Object getObject(String name, Boolean considerNamespace){
        if(String.isBlank(name)) {
            return null;
        }
        else {
            //if considerNamespace is true then preferredname = NAMESPACE__APINAME else APINAME
            String preferredValue = ((considerNamespace ? this.currentNamespace+'__' : '')+ name).toLowerCase();

            if(this.values.containsKey(preferredValue)) { //Use if namespace is in play
                return this.values.get(preferredValue);
            }
            else if(considerNamespace) { //Use if name space is not in play only api name is
                return this.values.get(name.toLowerCase());
            }
            else {
                return null;
            }
        }
    }

    public virtual Boolean containsKey(String name){
        return this.containsKey(name, true);
    }

    public virtual Boolean containsKey(String name, Boolean implyNamespace){
        if(name == null) //short-circuit lookup logic since null can't possibly be a valid field name, and it saves us null checking
            return null;
        String preferredValue = ((implyNamespace ? currentNamespace+'__' : '') + name).toLowerCase();
        return (
            values.containsKey(preferredValue) ||
            implyNamespace && values.containsKey(name.toLowerCase())
        );
    }

    public virtual Integer size(){
        return values.size();
    }

    /**
	* Returns the key set of the map.
	* Note: unlike other NamespacedAttributeMap methods keySet defaults implyNamespace to false if not specified.
	*/
	public virtual Set<String> keySet(){
		return this.keySet(false);
	}

    public virtual Set<String> keySet(Boolean implyNamespace){
        if(implyNamespace){
            Set<String> result = new Set<String>();
            for(String key:values.keySet()){
                result.add(
                    key.removeStartIgnoreCase(currentNamespace+'__')
                );
            }
            return result;
        }else{
            return values.keySet();
        }
    }
}
