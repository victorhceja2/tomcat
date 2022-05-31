function ltrim(sString)
{
    while (sString.substring(0,1) == ' ')
        sString = sString.substring(1, sString.length);

    return sString;
}

function rtrim(sString)
{
    while (sString.substring(sString.length-1, sString.length) == ' ')
    sString = sString.substring(0,sString.length-1);

    return sString;
}

function trim(sString)
{
    while (sString.substring(0,1) == ' ')
        sString = sString.substring(1, sString.length);
    
    while (sString.substring(sString.length-1, sString.length) == ' ')
        sString = sString.substring(0,sString.length-1);

    return sString;
}

function isEmpty(sString) 
{
    if(sString == null)
        return true;
    else
        if(trim(sString).length==0)
            return true;
        else
            return false;
} 

