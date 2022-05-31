gaMainArray10=new Array(); 
gaMainArray20=new Array(); 
gaMainArray30=new Array();
gaMainArray40=new Array();
gaMainArray50=new Array(); 
gaMainArray60=new Array(); 
gaMainArray70=new Array(); 
gaMainArray100=new Array(); 

function displayContent10() {
    for (index=0;index<gaMainArray10.length;index++) {
        if ((typeof(gaMainArray10[index]) != "undefined") && (gaMainArray10[index]!="")) {
            document.write("<tr class = FrameColor><td>");
            document.write("<font class = TextBodyDesc>");
            document.write(gaMainArray10[index]);
            document.write("</font>");
            document.write("</td></tr>");
        }
    }
}

function displayContent20() {
    for (index=0;index<gaMainArray20.length;index++) {
    	if ((typeof(gaMainArray20[index]) != "undefined") && (gaMainArray20[index]!="")) {
            document.write("<tr><td align = right bgcolor = \'#94B3D6\'>");
            document.write(gaMainArray20[index]);
            document.write("</td></tr>");
	}
    }
}

function displayContent30() {
    for (index=0;index<gaMainArray30.length;index++)	{
	if ((typeof(gaMainArray30[index]) != "undefined") && (gaMainArray30[index]!="")) {
            document.write(gaMainArray30[index]);
	}
    }
}

function displayContent40(){
    for (index=0;index<gaMainArray40.length;index++) {
	if ((typeof(gaMainArray40[index]) != "undefined") && (gaMainArray40[index]!="")) {
            document.write(gaMainArray40[index]);
	}
    }
}

function displayContent50() {
    for (index=0;index<gaMainArray50.length;index++) {
	if ((typeof(gaMainArray50[index]) != "undefined") && (gaMainArray50[index]!="")) {
            document.write(gaMainArray50[index]);
        }
    }
}

function displayContent60() {
    for (index=0;index<gaMainArray60.length;index++) {
	if ((typeof(gaMainArray60[index]) != "undefined") && (gaMainArray60[index]!="")) {
            document.write(gaMainArray60[index]);
	}
    }
}

function displayContent70() {
    for (index=0;index<gaMainArray70.length;index++) {
        if ((typeof(gaMainArray70[index]) != "undefined") && (gaMainArray70[index]!="")) {
            document.write("<tr><td align = right bgcolor = \'#94B3D6\'>");
            document.write(gaMainArray70[index]);
            document.write("</td></tr>");
        }   
    }
}

function displayContent100() {
    for (index=0;index<gaMainArray100.length;index++) {
        if ((typeof(gaMainArray100[index]) != "undefined") && (gaMainArray100[index]!="")) {
            document.write("<tr class = FrameColor><td>");
            document.write("<font class = TextBodyDesc>");
            document.write(gaMainArray100[index]);
            document.write("</font>");
            document.write("</td></tr>");
        }
    }
}
