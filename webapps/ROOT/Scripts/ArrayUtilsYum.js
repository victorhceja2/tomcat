function in_array(value, arrayToSearch) {
    var sValue = new String(value);
	for (s = 0; s < arrayToSearch.length; s++) {
		thisEntry = arrayToSearch[s].toString();
		if (thisEntry == sValue) {
			return true;
		}
	}
	return false;
}

    /**Construye un array con el mismo valor inicial en todos los elementos*/
    function simpleArray(size, value)
        {
            var laSimpleArray = new Array(size);

            for(var li=0; li<laSimpleArray.length; li++)
                if(value != null)
                    laSimpleArray[li] = value;
                else
                    laSimpleArray[li] = 0;

            return laSimpleArray;
        }
 
