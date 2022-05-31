/*
 Highcharts JS v4.2.4 (2016-04-14)
 Client side exporting module

 (c) 2015 Torstein Honsi / Oystein Moseng

 License: www.highcharts.com/license
*/
(function(c){
    typeof module==="object"&&module.exports?module.exports=c:c(Highcharts)
    })(function(c){
    function y(c,e){
        var i=l.getElementsByTagName("head")[0],b=l.createElement("script");
        b.type="text/javascript";
        b.src=c;
        b.onload=e;
        i.appendChild(b)
        }
        var e=c.win,g=e.navigator,l=e.document;
    c.CanVGRenderer={};
    
    c.Chart.prototype.exportChartLocal=function(z,A){
        var i=this,b=c.merge(i.options.exporting,z),B=g.userAgent.indexOf("WebKit")>-1&&g.userAgent.indexOf("Chrome")<0,n=b.scale||2,p,s=e.URL||e.webkitURL||e,
        k,t=0,q,o,u,d=function(){
            if(b.fallbackToExportServer===!1)if(b.error)b.error();else throw"Fallback to export server disabled";else i.exportChart(b)
                },v=function(a,j,f,b,m,c,d){
            var h=new e.Image,i,g=function(){
                var b=l.createElement("canvas"),c=b.getContext&&b.getContext("2d"),e;
                try{
                    if(c){
                        b.height=h.height*n;
                        b.width=h.width*n;
                        c.drawImage(h,0,0,b.width,b.height);
                        try{
                            e=b.toDataURL(),f(e,j)
                            }catch(g){
                            if(g.name==="SecurityError"||g.name==="SECURITY_ERR"||g.message==="SecurityError")i(a,j);else throw g;
                        }
                    }else m(a,
                    j)
                }finally{
                d&&d(a,j)
                }
            },k=function(){
        c(a,j);
        d&&d(a,j)
        };
        
    i=function(){
        h=new e.Image;
        i=b;
        h.crossOrigin="Anonymous";
        h.onload=g;
        h.onerror=k;
        h.src=a
        };
        
    h.onload=g;
    h.onerror=k;
    h.src=a
    },w=function(a){
    try{
        if(!B&&g.userAgent.toLowerCase().indexOf("firefox")<0)return s.createObjectURL(new e.Blob([a],{
            type:"image/svg+xml;charset-utf-16"
        }))
        }catch(b){}
    return"data:image/svg+xml;charset=UTF-8,"+encodeURIComponent(a)
    },r=function(a,c){
    var f=l.createElement("a"),d=(b.filename||"chart")+"."+c,m;
    if(g.msSaveOrOpenBlob)g.msSaveOrOpenBlob(a,
        d);
    else if(f.download!==void 0)f.href=a,f.download=d,f.target="_blank",l.body.appendChild(f),f.click(),l.body.removeChild(f);else try{
        if(m=e.open(a,"chart"),m===void 0||m===null)throw"Failed to open window";
    }catch(i){
        e.location.href=a
        }
    },x=function(){
    var a,j,f=i.sanitizeSVG(p.innerHTML);
    if(b&&b.type==="image/svg+xml")try{
        g.msSaveOrOpenBlob?(j=new MSBlobBuilder,j.append(f),a=j.getBlob("image/svg+xml")):a=w(f),r(a,"svg")
        }catch(k){
        d()
        }else a=w(f),v(a,{},function(a){
        try{
            r(a,"png")
            }catch(b){
            d()
            }
        },function(){
        var a=
        l.createElement("canvas"),b=a.getContext("2d"),j=f.match(/^<svg[^>]*width\s*=\s*\"?(\d+)\"?[^>]*>/)[1]*n,h=f.match(/^<svg[^>]*height\s*=\s*\"?(\d+)\"?[^>]*>/)[1]*n,k=function(){
            b.drawSvg(f,0,0,j,h);
            try{
                r(g.msSaveOrOpenBlob?a.msToBlob():a.toDataURL("image/png"),"png")
                }catch(c){
                d()
                }
            };
        
    a.width=j;
    a.height=h;
    e.canvg?k():(i.showLoading(),y(c.getOptions().global.canvasToolsURL,function(){
        i.hideLoading();
        k()
        }))
    },d,d,function(){
        try{
            s.revokeObjectURL(a)
            }catch(b){}
    })
},C=function(a,b){
    ++t;
    b.imageElement.setAttributeNS("http://www.w3.org/1999/xlink",
        "href",a);
    t===k.length&&x()
    };
    
c.wrap(c.Chart.prototype,"getChartHTML",function(a){
    p=this.container.cloneNode(!0);
    return a.apply(this,Array.prototype.slice.call(arguments,1))
    });
i.getSVGForExport(b,A);
k=p.getElementsByTagName("image");
try{
    k.length||x();
    for(o=0,u=k.length;o<u;++o)q=k[o],v(q.getAttributeNS("http://www.w3.org/1999/xlink","href"),{
        imageElement:q
    },C,d,d,d)
    }catch(D){
    d()
    }
};

c.getOptions().exporting.buttons.contextButton.menuItems=[{
    textKey:"printChart",
    onclick:function(){
        this.print()
        }
    },{
    separator:!0
    },
{
    textKey:"downloadPNG",
    onclick:function(){
        this.exportChartLocal()
        }
    },{
    textKey:"downloadSVG",
    onclick:function(){
        this.exportChartLocal({
            type:"image/svg+xml"
        })
        }
    }]
});
