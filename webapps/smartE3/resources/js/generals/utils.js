//////////////////////////////////////////////////////////////////////////////////////
//                                 DataUtils
/////////////////////////////////////////////////////////////////////////////////////

var DataUtils = {
    getQueryColSpliter : function() {
        return "_|_";
    },

    getQueryRowSpliter : function() {
        return "_||_";
    },
    
    getQueryPageSpliter : function() {
        return "_|||_";
    },
    
    getValidValue : function(psValue, psDefaultValue) {
        return  (psValue!=null && typeof psValue != 'undefined')?psValue:psDefaultValue;
    },
    
    normalizeFunctionCall : function(psFunctionCall) {
        return psFunctionCall.replace(",","','","g").replace("(","('","g").replace(")","')","g");
    },
    
    getValidAlign : function(psAlign) {
        var lsAlign = psAlign.toLowerCase();
        
        if (lsAlign=="center" || lsAlign == "left" || lsAlign=="right") {
            return lsAlign;
        } else {
            return "";
        }
    },
    
    getValidBoolean : function(pbValue, pbDefault) {

        if (pbValue.replace(/^\s+|\s+$/g, '')=="true" || pbValue.replace(/^\s+|\s+$/g, '')==true) 
            return true;
        else if (pbValue.replace(/^\s+|\s+$/g, '')=="false" || pbValue.replace(/^\s+|\s+$/g, '')==false)
          return false;
        
        else 
          return pbDefault
    },

    getValidNumber : function(psValue,pdDefault) {
        if (psValue.isNumber()) 
            return psValue*1;
        else
            return pdDefault;
    },
    
    getTime : function() {
        var lsTime = (new Date()).toTimeString();
        
        return lsTime.substring(0 ,5);
    },
    
    getUTCTime : function() {
        return (new Date()).valueOf();
    },
    
    getDateWOD : function() {
        var loDate = new Date();
        
        var lsYear = loDate.getFullYear()+"";
        var lsMonth = "0" + (loDate.getMonth()+1);
        var lsDay = "0" + loDate.getDate();

        //var lsMonth = "0" + (loDate.getUTCMonth()+1);
        //var lsDay = "0" + loDate.getUTCDate();
        
        return lsYear + lsMonth.substring(lsMonth.length-2) + lsDay.substring(lsDay.length-2);
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////
//////////                           HASH
////////////////////////////////////////////////////////////////////////////////////////////////
function Hash() {
	//Miembros publicos
	this.miLength = 0;
	this.maItems = new Array();

	//Constructor
	for (var li = 0; li < arguments.length; li+=2) {
		if (typeof(arguments[li + 1]) != 'undefined') {
			this.maItems[arguments[li]] = arguments[li + 1];
			this.miLength++;
		}
	}
        
        this.getLength = function() {
            return this.miLength;
        }
        
        this.hasItems = function() {
            return this.getLength()>0;
        }
   
	this.removeItem = function(psKey) {
		var msValue;
               if (typeof(this.maItems[psKey]) != 'undefined') {
			this.miLength--;
			msValue = this.maItems[psKey];
			delete(this.maItems[psKey]);
		}
	   
		return msValue;
	}

	this.getItem = function(psKey) {
            return this.maItems[psKey];
	}
        
        this.getItems = function() {
            return this.maItems;
        }
        
        this.getArray = function() {
            var laData = new Array();
            var liIndex = 0;
            
            for (var lsKey in this.maItems) {
                laData[liIndex++] = this.maItems[lsKey];
            }
            
            return laData;
        }

        this.getFirstKey = function() {
            var lsKey;

            for (lsKey in this.maItems) { break; }

            return lsKey;
        }
            
        this.getLastKey = function() {
            var lsLastKey = "-1";
            
            for (var lsKey in this.maItems) {
                lsLastKey = lsKey;
            }
            
            return lsLastKey;
        }

        this.getFirst = function() {
            var lsKey;
            for (lsKey in this.maItems) {break;}

            return this.getItem(lsKey);
        }

        this.getLast = function() {
            var lsKey;
            for (lsKey in this.maItems) {}

            return this.getItem(lsKey);
        }


	this.hasItem = function(psKey) {
		return(typeof(this.maItems[psKey]) != 'undefined');
	}

	this.setItem = function(psKey, psValue) {
		if (typeof(psValue) != 'undefined') {
			if (!this.hasItem(psKey)) {
				this.miLength++;
			}

			this.maItems[psKey] = psValue;
		}
	   
		return(psValue);
	}
        
        this.removeAll = function() {
            this.miLength = 0;
            this.maItems = new Array();
        }
        
        this.addItemsFromHash = function(poHash) {
            if (poHash==null) return;
            
            for (var lsKey in poHash.maItems) {
                if (!this.hasItem(lsKey)) this.setItem(lsKey, poHash.maItems[lsKey]);
            }
        }
        
        this.setItemsFromHash = function(poHash) {
            this.removeAll();
            if (poHash==null) return;
            this.addItemsFromHash(poHash);
        }
        
        this.setArrayItem = function(psKey, poValue) {
		if (typeof(poValue) != 'undefined') {
			if (!this.hasItem(psKey)) {
				this.miLength++;
				this.maItems[psKey] = new Array();
			}

			this.maItems[psKey].push(poValue);
		}
	   
		return(poValue);
	}
            
        this.toString = function() {
            var lsKey;
            var lsString = "{";
            
            for (lsKey in this.maItems) {
                lsString+=lsKey + "=" + this.maItems[lsKey] + ","
            }
            
            return lsString + "}";
        }
}
//////////////////////////////////////////////////////////////////////////////
///
///                  Generales
///
//////////////////////////////////////////////////////////////////////////////
function getWindowWidth() {
        var liWindowWidth = (window.innerWidth)?window.innerWidth:document.body.clientWidth;
        return(liWindowWidth);
    }

    function getWindowHeight() {
        var liWindowHeight = (window.innerHeight)?window.innerHeight:document.body.clientHeight;	
        return(liWindowHeight);
    }
  