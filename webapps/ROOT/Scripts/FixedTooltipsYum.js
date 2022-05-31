
/***********************************************
* Cool DHTML tooltip script II- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
***********************************************/

var offsetfromcursorX=12 //Customize x offset of tooltip
var offsetfromcursorY=5 //Customize y offset of tooltip

var offsetdivfrompointerX=10 //Customize x offset of tooltip DIV relative to pointer image
var offsetdivfrompointerY=14 //Customize y offset of tooltip DIV relative to pointer image. Tip: Set it to (height_of_pointer_image-1).

document.write('<div id="fixtooltip">AQUI</div>') //write out tooltip DIV

var ie=document.all
var ns6=document.getElementById && !document.all
var enablefixtip=false
if (ie||ns6)
{
var fixobj=document.all? document.all["fixtooltip"] : document.getElementById? document.getElementById("fixtooltip") : ""
}

function ietruebody(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function showfixtip(thetext, x, y, thewidth){
if (ns6||ie){
if (typeof thewidth!="undefined") fixobj.style.width=thewidth+"px"
fixobj.innerHTML=thetext
enablefixtip=true
	positionfixtip(x,y);
return false
}
}

function positionfixtip(curX, curY)
{
	if (enablefixtip)
	{
		var nondefaultpos=false;

		fixobj.style.left=curX-fixobj.offsetWidth-offsetfromcursorX+"px";
		fixobj.style.top=curY-offsetfromcursorY+"px";
		fixobj.style.visibility="visible";
	}
}

function hidefixtip(){
if (ns6||ie){
enablefixtip=false
fixobj.style.visibility="hidden"
fixobj.style.backgroundColor=''
fixobj.style.width=''
}
}

