/********************************************************************************************
* BlueShoes Framework;
 This file is part of the php application framework.
* NOTE: This code is stripped (obfuscated). To get the clean documented code goto 
*       www.blueshoes.org and register for the free open source *DEVELOPER* version or 
*       buy the commercial version.
*       
*       In case you've already got the developer version, then this is one of the few 
*       packages/classes that is only available to *PAYING* customers.
*       To get it go to www.blueshoes.org and buy a commercial version.
* 
* @copyright www.blueshoes.org
* @author    sam blum <sam-at-blueshoes-dot-org>
* @author    Andrej Arn <andrej-at-blueshoes-dot-org>
*/
if (!Bs_Objects) {var Bs_Objects = [];
};
function Bs_DataGrid(objectName) {
this.bHeaderFix = true;
this.isReport = false;
this.height = 600;
this.width='100%';
this.padding=2;
this.spacing=0;
this.buttonsDefaultPath = '/Images/Datagrid/';
this.rowClick;
this.sortIgnoreCase = true;
this.useNoDataText = false;
this.noDataText = 'No data.';
this._id;
this._objectId;
this._tagId;
this._header;
this._mainheader;
this._td;
this._tooltip;
this._ftooltip;
this._data;
this._links;
this._objectName = objectName;
this._attachedEvents;

this._screen_width  = screen.width;
this._screen_height = screen.height;

this._colspan_reg_exp = /colspan=\d.*/i;

this._constructor = function() 
{
    this._id = Bs_Objects.length;
    Bs_Objects[this._id] = this;
    this._objectId = "Bs_DateGrid_"+this._id;
}

//Formatting datagrid functions
this.setItalic = function setItalic(cols)
{
    for(var rowId=0; rowId<this._data.length; rowId++){
        for(var columnId=0; columnId< this._data[rowId].length; columnId++){
            if(in_array(columnId, cols)){
                var currentValue = new String(this._data[rowId][columnId]);
                if(currentValue.length == 0 || currentValue == '')
                    currentValue = '&nbsp;';
            
                    this._data[rowId][columnId] = '<i>' + currentValue + '</i>';
            }
        }            
    }
}

this.setLink = function setLink(link, cols)
{
    var datagrid = this._data;

    for(var rowId=0; rowId<this._data.length; rowId++){
        for(var columnId=0; columnId< this._data[rowId].length; columnId++){
            if(in_array(columnId, cols)){
                var newValue = new String(this._data[rowId][columnId]);
                if(newValue.length == 0 || newValue == '')
                    newValue = '&nbsp;';
                else
                    newValue = '<a href="'+link.baseUrl+datagrid[rowId][link.key]+ '" '+ link.extras+'>' + datagrid[rowId][columnId] + '</a>';
            
                this._data[rowId][columnId] = newValue ;
            }
        }            
    }
}

this.setMainHeaders = function(properties)
{
    this._mainheader = properties;
}

this.setHeaders = function(properties)
{
    this._header = properties;
}

this.setDataProps = function(properties)
{
    this._td = properties;
}

this.setTooltips = function(properties)
{
    this._tooltip = properties;
}

this.setFTooltips = function(properties)
{
    this._ftooltip = properties;
}

this.rowClick;

this.setData = function(data)
{
    this._data = data;
}

this.setLinks = function(links)
{
    this._links = links;
}

this.getData = function()
{
    return this._data;
}

this.getDataRow = function(rowId)
{
    return this._data[rowId];
}

this.getNumRows = function()
{
    return this._data.length;
}

this.addRow = function(row) 
{
    this._data[this._data.length] = row;
    if (typeof(bs_dg_globalColumn) == 'undefined')
        this.drawInto(this._tagId);
    else
        this.orderByColumn(bs_dg_globalColumn);
}

this.addRows = function(rows)
{
    for(var i=0; i<rows.length; i++)
        this.addRow(rows[i]);
}

this.removeRow = function(rowNumber) {
var status = this._data.deleteItem(rowNumber -1);
if (status) {
if (typeof(bs_dg_globalColumn) == 'undefined') {
this.drawInto(this._tagId);
} else {
this.orderByColumn(bs_dg_globalColumn);
}
}
return status;
}

this.switchSort = function()
{
    bs_dg_sort_asc = !bs_dg_sort_asc;
}

this.switchOverflow = function() {
if (this.bHeaderFix) {
if (document.getElementById('bsTb' + this._objectId).style.overflow == 'auto') {
this.expand();
} else {
this.collapse();
}
}
}

this.collapse = function() {
if (this.bHeaderFix) {
document.getElementById('overflowButtonImg_' + this._id).src=this.buttonsDefaultPath+'expand.gif';
document.getElementById('overflowButtonImg_' + this._id).alt='Expand';
document.getElementById('bsTb' + this._objectId).style.overflow = 'auto';
}
}

this.expand = function() {
if (this.bHeaderFix) {
document.getElementById('overflowButtonImg_' + this._id).src=this.buttonsDefaultPath+'collapse.gif';
document.getElementById('overflowButtonImg_' + this._id).alt='Collapse';
document.getElementById('bsTb' + this._objectId).style.overflow = 'visible';
}
}

this.openlink = function(rowId, columnId, pwidth, pheight)
{
    var width  = (pwidth != null)?pwidth:1000;
    var height = (pheight != null)?pheight:650;

    var left = Math.abs(this._screen_width - width) / 2;
    var top  = Math.abs(this._screen_height -height) / 2 - 10;

    var value  = new String(this._data[rowId][columnId]);

    if(typeof(this._links) != 'undefined')
    {
        var link  = this._links[columnId];
        if(value.length > 0 && value != '' && value != 'null' && value != 'NA')
        {
            if(link != null && link.baseUrl != 'undefined')
                window.open(link.baseUrl + this._data[rowId][link.key],'auxWindow','height='+height+', width='+width+', left='+left+', top='+top+' menubar=no, scrollbars=yes, resizable=yes'); 
        }
    }        
}

this.render = function()
{
  var out        = new Array();
  var tdSettings = new Array();

  if (this.height > screen.height) this.height = screen.height - 100;
        out[out.length] = '<table id="bsDg_table' + this._objectId + '" bs_dg_objectId="';
		out[out.length] =  this._objectId + '" class="bsDg_table" cellspacing="'+this.spacing;
		out[out.length] = '" cellpadding="'+this.padding+'" width="'+this.width+'" border="0"';
        
  out[out.length] = ' headerCSS="bsDb_tr_header"';
  out[out.length] = '>';
  out[out.length] = '<thead>\n';

  if (typeof(this._mainheader) == 'object') 
  {
    out[out.length] = '<tr class="bsDb_tr_header">';
    for (var i=0; i<this._mainheader.length; i++) 
    {
      tdSettings[i] = new Array();
      if (typeof(this._mainheader[i]) == 'object')
      {
         var text     = this._mainheader[i]['text'];
         var hasProps = true;
      }
      else
      {
         var text     = this._mainheader[i];
         var hasProps = false;
      }

      out[out.length] = '<td';

      if (typeof(this._mainheader[i]['title']) != 'undefined') 
          out[out.length] = ' title="' + this._mainheader[i]['title'] + '"';
    
      if (typeof(this._mainheader[i]['colspan']) != 'undefined') 
            out[out.length] = ' colspan="' + this._mainheader[i]['colspan'] + '"';

      out[out.length] = ' id="' + this._objectId + '_mtitle_td_' + i + '"';
      out[out.length] = ' style="';

      if (this._mainheader[i]['sort'] == true)
          out[out.length] = 'cursor:hand; cursor:pointer; ';

      if (hasProps)
      {
        if(!bs_isEmpty(this._mainheader[i]['align']))
        {
          out[out.length] = 'text-align:' + this._mainheader[i]['align'] + '; ';
          tdSettings[i]['align'] = this._mainheader[i]['align'];
          if (typeof(this._td) == 'object' && this._td[i] != null) 
            if (!bs_isEmpty(this._td[i]['align']))
              tdSettings[i]['align'] = this._td[i]['align'];
        }

        if (!bs_isEmpty(this._mainheader[i]['width']))
          out[out.length] = 'width:' + this._mainheader[i]['width'] + '; ';
      }

      out[out.length] = '"';

      if (!bs_isEmpty(this._mainheader[i]['nowrap']) && this._mainheader[i]['nowrap'])
        out[out.length] = ' nowrap';
    
      if (this._mainheader[i]['sort'] == true) 
        out[out.length] = ' onclick="Bs_Objects['+this._id+'].orderByColumn(' + i + '); '+this._objectName+'.switchSort(); "';

              
      rowThClass = 'default';
      if (!bs_isEmpty(this._mainheader[i]['hclass']))
          rowThClass = this._mainheader[i]['hclass']; 

      out[out.length] = ' class="' + ('bsDb_td_header_'+rowThClass) + '"';

      out[out.length] = '>' + text + '</td>\n';
    }//Fin for

    out[out.length] = '</tr>\n';
    //out[out.length] = '<tbody id="bsTb' + this._objectId + '"';

    //if (moz && this.bHeaderFix)
     //   out[out.length] = ' style="overflow:auto; max-height:'+this.height+'; ">';
    //else
     //   out[out.length] = '>';
  }

  if (typeof(this._header) == 'object') 
  {
    out[out.length] = '<tr class="bsDb_tr_header" valign="top">';
    for (var i=0; i<this._header.length; i++) 
    {
      tdSettings[i] = new Array();
      if (typeof(this._header[i]) == 'object')
      {
        var text     = this._header[i]['text'];
        var hasProps = true;
      }
      else
      {
        var text     = this._header[i];
        var hasProps = false;
      }

      out[out.length] = '<td';

      if (typeof(this._header[i]['title']) != 'undefined') 
        out[out.length] = ' title="' + this._header[i]['title'] + '"';
    
      out[out.length] = ' id="' + this._objectId + '_title_td_' + i + '"';
      out[out.length] = ' style="';

      if (this._header[i]['sort'] == true)
        out[out.length] = 'cursor:hand; cursor:pointer; ';

      if (hasProps)
      {
        if (!bs_isEmpty(this._header[i]['align']))
        {
          out[out.length] = 'text-align:' + this._header[i]['align'] + '; ';
          tdSettings[i]['align'] = this._header[i]['align'];
          if (typeof(this._td) == 'object') 
            if (this._td[i] != null && !bs_isEmpty(this._td[i]['align']))
              tdSettings[i]['align'] = this._td[i]['align'];
        }

        if (!bs_isEmpty(this._header[i]['width']))
            out[out.length] = 'width:' + this._header[i]['width'] + '; ';
      }

      out[out.length] = '"';

      if (!bs_isEmpty(this._header[i]['nowrap']) && this._header[i]['nowrap'])
        out[out.length] = ' nowrap';
    
      if (this._header[i]['sort'] == true) 
        out[out.length] = ' onclick="Bs_Objects['+this._id+'].orderByColumn(' + i + '); '+this._objectName+'.switchSort(); " ';

      rowTdClass = 'default';
      if (typeof(this._header[i] != 'undefined') && typeof(this._header[i]) == 'object' 
          && typeof(this._header[i]['hclass']) != 'undefined') {
        rowTdClass = this._header[i]['hclass'];
      }

      out[out.length] = ' class="' + ('bsDb_td_header_'+rowTdClass) + '"';
      out[out.length] = '>' + text + '</td>';
    }//Fin for

	//EZ
    if (moz && this.bHeaderFix)
      out[out.length] = '<td class="bsDb_td_header_empty">&nbsp;&nbsp;</td>'; //dummy

    out[out.length] = '</tr>';
	out[out.length] = '</thead>\n';


    out[out.length] = '<tbody id="bsTb' + this._objectId + '" ' ;

	//bsTbBs_DateGrid_0

    if (moz && this.bHeaderFix)
	{
      out[out.length] = ' style="overflow: -moz-scrollbars-vertical; max-height:'+(this.height+10)+';" ';
      out[out.length] = ' >';
	}
    else
      out[out.length] = '>';
  }

  if (typeof(this._data) == 'object' && (this._data.length > 0))
  {
    for (var i=0; i<this._data.length; i++)
    {
      out[out.length] = '<tr';

      out[out.length] = ' class="bsDg_tr_row_zebra_' + (i % 2) + '"';

      if(this.isReport != true)
      {
        out[out.length] = ' onmouseover="Bs_Objects['+this._id+'].onMouseOver(this, ' + (i+1) + ', ' + (i % 2) + ')"';
        out[out.length] = ' onmouseout="Bs_Objects['+this._id+'].onMouseOut(this, '   + (i+1) + ', ' + (i % 2) + '); "'; 
        //out[out.length] = ' class="bsDg_tr_row_zebra_' + (i % 2) + '"';
      }

      out[out.length] = ' id="tr_'+i+'">';
      for (var j=0; j<this._data[i].length; j++)
      {
        if ((typeof(this._td) != 'undefined') 
        && this._td[j] != null && this._td[j]['hide'])
          continue;

        var isClickable = false;
        if (bs_isNull(this._data[i][j])) continue;
            
        if (typeof(this._data[i][j]) == 'object')
        {
            var text = (typeof(this._data[i][j]['text']) != 'undefined') ? this._data[i][j]['text'] : '';
        }
        else if (typeof(this._data[i][j]) == 'undefined')
        {
          this._data[i][j] = '';
          var text = this._data[i][j];
        }
        else
          var text = this._data[i][j];

        out[out.length] = '<td';

		if(text.match(this._colspan_reg_exp))
		{
			var _dat = text.split("~");
			var _colspan = _dat[0];
			var licolspan = parseInt(_colspan.substr(_colspan.indexOf("=")+1,2) );
			text = _dat[1];

			out[out.length] = ' ' + _colspan +' class="bsDg_td_colspan">' + text +'</td> \n';
			j = j + licolspan-1;
			continue;
		}


        if (typeof(this._header[j] != 'undefined') && typeof(this._header[j]) == 'object' 
            && typeof(this._header[j]['bclass']) != 'undefined') {
          zebraRowTdClass = 'bsDg_td_' + this._header[j]['bclass'];
        }
        else
          zebraRowTdClass = 'bsDg_td_row_zebra_' + (i % 2);

        if ((typeof(this._td) != 'undefined') 
        && this._td[j] != null && this._td[j]['entry'])
          zebraRowTdClass = zebraRowTdClass + ' bsDg_td_entry';

        out[out.length] = ' class="'+zebraRowTdClass+'" id="bsDg_row_'+i+' bsDg_col_' +j+ '"';

        var mouseover  = ' onmouseover="';
        var mouseout   = ' onmouseout="';

        if ((typeof(this._td) != 'undefined') && 
            this._td[j] != null && (typeof(this._td[j]['onclick']) != 'undefined'))
        {
          if(text != '' && text != 'null' && text != 'NA')
          {
            isClickable = true;

            if(this._td[j]['param1'] != 'undefined' && this._td[j] != null)
                param1 = this._td[j]['param1'];
            else
                param1 = null;

            if(this._td[j]['param2'] != 'undefined' && this._td[j] != null)
                param2 = this._td[j]['param2'];
            else
                param2 = null;

            out[out.length] = ' onclick="' + this._td[j]['onclick'] + '('+ i +','+j + ','+param1+','+param2+'); "';
            mouseover += 'this.className=\'bsDg_td_zebraover\'; ';
            mouseout  += 'this.className=\''+zebraRowTdClass+'\'; ';

          }
        }


        if(typeof(this._tooltip) != 'undefined' &&
           this._tooltip[j] != null && typeof(this._tooltip[j] != 'undefined'))
        {
          if(text != '' && text != 'null' && text != 'NA')
          {
            var _tooltip  = this._tooltip[j].text;
            var _tmpArray = _tooltip.split(" ");

            for (var idx=0; idx<_tmpArray.length; idx++)
            {
              if(_tmpArray[idx].match(/[\d*]/))
              {
                var newValue = eval("this._data["+i+"]"+_tmpArray[idx]);
                _tmpArray[idx] = newValue;
              }                            
            }
            
            var tooltipText = _tmpArray.join(" ");
            var twidth = (this._tooltip[j].width ? this._tooltip[j].width : 100);

            mouseover += ' ddrivetip(\''+tooltipText+'\',' + twidth + ') ';
            mouseout  += ' hideddrivetip() ';
         }
       }

       if(typeof(this._ftooltip) != 'undefined' &&
           this._ftooltip[j] != null && typeof(this._ftooltip[j] != 'undefined'))
       {
          if(text != '' && text != 'null')
          {
            var ftooltip  = this._ftooltip[j].text;
            ftooltip += '(' + i + ', ' + j +')';
            var twidth = (this._ftooltip[j].width ? this._ftooltip[j].width : 100);

            mouseover += ' ddrivetip('+ ftooltip+',' + twidth + ') ';
            mouseout  += ' hideddrivetip()';
         }
      }      

       mouseover += '" ';
       mouseout  += '" ';
        
       out[out.length] = mouseover;
       out[out.length] = mouseout;

       if (typeof(this._data[i][j]['title']) != 'undefined')
         out[out.length] = ' title="' + this._data[i][j]['title'] + '"';

       out[out.length] = ' style="';

       if ((typeof(tdSettings[j]) != 'undefined') &&
           !bs_isEmpty(tdSettings[j]['align']))
         out[out.length] = 'text-align:' + tdSettings[j]['align'] + '; ';

       if ((typeof(this.rowClick) != 'undefined') || isClickable)
         out[out.length] = 'cursor:hand; cursor:pointer; ';
       else
         out[out.length] = 'cursor:default; ';

       out[out.length] = '"';
    
       out[out.length] = '>';
       out[out.length] = (text.length == 0 || text == 'null') ? '&nbsp; ' : text;
       out[out.length] = '</td>\n';
     }
      

     out[out.length] = '</tr>' + "\n";
    }
	
  }
  out[out.length] = '</tbody></table>';

  return out.join('');
}

this.drawInto = function(tagId)
{
    this._tagId = tagId;
	//Para que no se muestre el botton "expand"
    //if (this.bHeaderFix)
     //   overflowbuttonHtml = this._getFixButton('expand');
    //else
        overflowbuttonHtml = '';

document.getElementById(tagId).innerHTML = overflowbuttonHtml + this.render();
var tblElm = document.getElementById('bsDg_table' + this._objectId);
if (tblElm.offsetHeight > this.height) {
if (ie && this.bHeaderFix) {
tblElm.bodyHeight = this.height;
}
} else {
   //if (this.bHeaderFix) document.getElementById('overflowButtonDiv_' + this._id).style.display = 'none';
}
}

this.orderByColumn = function(column)
{
    bs_dg_globalColumn = column;
    if ((typeof(this._header[column]['sort']) != 'undefined') 
        && 
        (this._header[column]['sort'] == 'numeric'))
      bs_dg_sort = 'numeric';
    else
      bs_dg_sort = 'alpha';

    bs_dg_sort_ignoreCase = this.sortIgnoreCase;
    this._data.sort(bs_datagrid_sort);
    this.drawInto(this._tagId);
    var item = this._objectId + '_title_td_' + column;
    var sortClass = ' bsDb_td_header_sort_'+ (bs_dg_sort_asc?'asc':'desc');
    document.getElementById(item).className += ' bsDb_td_header_sort ' + sortClass;
}

this.GetFixButton = function(buttonName) {
this._getFixButton(buttonName);
}
this._getFixButton = function(buttonName) {
var top   = (moz) ? '0' : '16';
var styletag = '';
if (this.width.search('%') < 1) {
top = '20';
var dynawidth = parseInt(this.width);
dynawidth = dynawidth-22;
styletag='style="left:'+dynawidth+'; position:relative; ';
} else if (this.width == "100%") {
styletag='style="float:right; position:relative; ';
} else {
top = '0';
styletag='style="left:0; position:relative; ';
}
styletag += ' top:' + top + '; ';
styletag += '"';
overflowbuttonHtml = '<span id="overflowButtonDiv_' + this._id + '" ' + styletag + '><a href="#" onclick="'+this._objectName+'.switchOverflow(); window.event.returnValue = false; return false; "><img id="overflowButtonImg_' + this._id + '" alt="Expand" src="'+this.buttonsDefaultPath+buttonName+'.gif" border="0"></a></span>';
return overflowbuttonHtml;
}
this.onMouseOver = function(trElm, rowNumber, colorI) {
trElm.className = 'bsDg_tr_row_zebraover_' + colorI;
this.fireEvent('onMouseOver', rowNumber);
}
this.onMouseOut = function(trElm, rowNumber, colorI) {
trElm.className = 'bsDg_tr_row_zebra_' + colorI;
this.fireEvent('onMouseOut', rowNumber);
}
this.attachEvent = function(trigger, yourEvent) {
if (typeof(this._attachedEvents) == 'undefined') {
this._attachedEvents = new Array();
}
if (typeof(this._attachedEvents[trigger]) == 'undefined') {
this._attachedEvents[trigger] = new Array(yourEvent);
} else {
this._attachedEvents[trigger][this._attachedEvents[trigger].length] = yourEvent;
}
}
this.hasEventAttached = function(trigger) {
return (this._attachedEvents && this._attachedEvents[trigger]);
}
this.fireEvent = function(trigger, params)
{
    if (this._attachedEvents && this._attachedEvents[trigger])
    {
        var e = this._attachedEvents[trigger];
        if ((typeof(e) == 'string') || (typeof(e) == 'function'))
            e = new Array(e);
        
        for (var i=0; i<e.length; i++)
        {
            if (typeof(e[i]) == 'function')
                var status = e[i](this, params);
            else if (typeof(e[i]) == 'string')
                var status = eval(e[i]);
        
            if (status == false) return false;
        }
    }
    return true;
}
this._constructor();
}
var bs_dg_globalColumn;
var bs_dg_sort;
var bs_dg_sort_asc=true;
var bs_dg_sort_ignoreCase=true;
function bs_datagrid_sort(a,b) {
if (bs_dg_sort_asc) {
if (typeof(a[bs_dg_globalColumn]) == 'object') {
if (typeof(a[bs_dg_globalColumn]['order']) != 'undefined') {
valA = a[bs_dg_globalColumn]['order'];
} else {
valA = a[bs_dg_globalColumn]['text'];
}
} else {
valA = a[bs_dg_globalColumn];
}
if (typeof(b[bs_dg_globalColumn]) == 'object') {
if (typeof(b[bs_dg_globalColumn]['order']) != 'undefined') {
valB = b[bs_dg_globalColumn]['order'];
} else {
valB = b[bs_dg_globalColumn]['text'];
}
} else {
valB = b[bs_dg_globalColumn];
}
} else {
if (typeof(a[bs_dg_globalColumn]) == 'object') {
if (typeof(a[bs_dg_globalColumn]['order']) != 'undefined') {
valB = a[bs_dg_globalColumn]['order'];
} else {
valB = a[bs_dg_globalColumn]['text'];
}
} else {
valB = a[bs_dg_globalColumn];
}
if (typeof(b[bs_dg_globalColumn]) == 'object') {
if (typeof(b[bs_dg_globalColumn]['order']) != 'undefined') {
valA = b[bs_dg_globalColumn]['order'];
} else {
valA = b[bs_dg_globalColumn]['text'];
}
} else {
valA = b[bs_dg_globalColumn];
}
}
if (bs_dg_sort == 'numeric') {
valA = parseFloat(valA);
valB = parseFloat(valB);
if (valA < valB) {
return 1;
} else if (valA > valB) {
return -1;
} else {
return 0;
}
} else {
if (bs_dg_sort_ignoreCase) {
valA = valA.toLowerCase();
valB = valB.toLowerCase();
}
if (valA > valB) {
return 1;
} else if (valA < valB) {
return -1;
} else {
return 0;
}
}

}

