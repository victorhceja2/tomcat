function roundNumber(number, decimals) {
    alert(number);
	var numberField = number; // Field where the number appears
	var rlength = (decimals!=null? decimals: 2); // The number of decimal places to round to
	var newnumber = Math.round(numberField.value*Math.pow(10,rlength))/Math.pow(10,rlength);

    return newnumber;
}
<!--

/* This script is Copyright (c) Paul McFedries and 
Logophilia Limited (http://www.mcfedries.com/).
Permission is granted to use this script as long as 
this Copyright notice remains in place.*/

function round_decimals(original_number, decimals) {
    var result1 = original_number * Math.pow(10, decimals)
    var result2 = Math.round(result1)
    var result3 = result2 / Math.pow(10, decimals)
    return pad_with_zeros(result3, decimals)
}

function pad_with_zeros(rounded_value, decimal_places) {

    // Convert the number to a string
    var value_string = rounded_value.toString()
    
    // Locate the decimal point
    var decimal_location = value_string.indexOf(".")

    // Is there a decimal point?
    if (decimal_location == -1) {
        
        // If no, then all decimal places will be padded with 0s
        decimal_part_length = 0
        
        // If decimal_places is greater than zero, tack on a decimal point
        value_string += decimal_places > 0 ? "." : ""
    }
    else {

        // If yes, then only the extra decimal places will be padded with 0s
        decimal_part_length = value_string.length - decimal_location - 1
    }
    
    // Calculate the number of decimal places that need to be padded with 0s
    var pad_total = decimal_places - decimal_part_length
    
    if (pad_total > 0) {
        
        // Pad the string with 0s
        for (var counter = 1; counter <= pad_total; counter++) 
            value_string += "0"
        }
    return value_string
}

//-->
