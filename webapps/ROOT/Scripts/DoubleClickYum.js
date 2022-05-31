<!--

    //Full control on click and doubleclick events.

    var dcTime=250;    // doubleclick time
    var dcDelay=100;   // no clicks after doubleclick
    var dcAt=0;        // time of doubleclick
    var savEvent=null; // save Event for handling doClick().
    var savEvtTime=0;  // save time of click event.
    var savTO=null;    // handle of click setTimeOut
    var savFunction=null;
 
    function hadDoubleClick()
    {
        var d = new Date();
        var now = d.getTime();
   
        if ((now - dcAt) < dcDelay)
        {
            return true;
        }
    
        return false;
    }
 
    function handleClick(which, method)
    {
        switch (which)
        {
            case "click": 
            // If we've just had a doubleclick then ignore it
            if (hadDoubleClick()) return false;
         
            // Otherwise set timer to act.  It may be preempted by a doubleclick.
            savEvent = which;
            savFunction = method;
            d = new Date();
            savEvtTime = d.getTime();
            savTO = setTimeout("doClick(savEvent, savFunction)", dcTime);
            break;

            case "dblclick":
                doDoubleClick(which, method);
            break;
            default:
        }
    }
 
    function doClick(which, method)
    {
        // preempt if DC occurred after original click.
        if (savEvtTime - dcAt <= 0)
            return false;
   
        setTimeout(method, 1);
    }
 
    function doDoubleClick(which, method)
    {
        var d = new Date();
        dcAt = d.getTime();
        if (savTO != null)
        {
            clearTimeout( savTO );  //Clear pending Click  
            savTO = null;
        }

        setTimeout(method, 1);
    }

// --> 
