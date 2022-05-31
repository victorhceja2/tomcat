function searchValue() {
    if (document.frmMaster.txtDate.value == '') {
        alert('Por favor introduzca una fecha');
        document.frmMaster.txtDate.focus();
        return(false);
    }
    cleanFields();
    document.frmMaster.findValueGte.value='si';
    document.frmMaster.action='TransPiecesFrm.jsp';
    document.frmMaster.submit();
}

function cleanFields() {
    document.frmMaster.txtTrxS.value = "";
    document.frmMaster.txtTrxG.value = "";
    document.frmMaster.txtSystem.value = "";
    document.frmMaster.txtGerente.value = "";
    document.frmMaster.txtMixAutoS.value = "";
    document.frmMaster.txtMixAutoG.value = "";
    document.frmMaster.txtMixHdS.value = "";
    document.frmMaster.txtMixHdG.value = "";
}

function checkMixes(){
    var ma=document.frmMaster.txtMixAutoG.value ;  
    var mh=document.frmMaster.txtMixHdG.value ;  
    var suma=parseFloat(ma)+parseFloat(mh);

    if (checknumber(ma) && checknumber(mh)) {
        testresult=true ;
    }  else {
        alert("Tienes que ingresar solo Numeros") ;
        return false ;
    }

    if ( suma > 100 ) {
	alert("La suma de tus porcentajes no debe exceder del 100%") ;
        return false ;
    } else {
	testresult=true ;
    }

    return testresult;

}

function checkPzXtra(){

    var x=document.frmMaster.txtGerente.value ;

    if (checknumber(x)) {
        testresult=true ;
    }  else {
        alert("Tienes que ingresar solo Numeros") ;
        return false ;
    }

    if ( x >  99 ) {
        alert("No es posible tener mas de 99 piezas por transaccion");
	return false;
    } else{
        testresult=true ;
    }

    return testresult ;
}

function checknumber(x) {
    var anum=/(^\d+$)|(^\d+\.\d+$)/ ;

    if (anum.test(x)) {
        return true ;
    }  else {
        return false ;
    }
}

function sendValue(){
    document.frmMaster.findValueGte.value = 'no' ;
    document.frmMaster.action = '../Proc/TransPiecesSave.jsp' ;

    var separador="/";

    fsolicitada_tmp1=new String(document.frmMaster.txtDate.value);
    fsolicitada_tmp2 = fsolicitada_tmp1.split(separador);;
    fsolicitada = fsolicitada_tmp2[2].substring(2,4) + "/"+fsolicitada_tmp2[1] + "/"+fsolicitada_tmp2[0];
    fhoy = new String(document.frmMaster.f_hoy.value);
    a_fsolicitada = fsolicitada.split(separador);
    a_fhoy = fhoy.split(separador);
    a_fsolicitada[0]=a_fsolicitada[0]*1 + 2000;
    fsolicitada_ob = new Date(a_fsolicitada[0],a_fsolicitada[1]-1,a_fsolicitada[2]);
    fhoy_ob = new Date (a_fhoy[0],a_fhoy[1]-1, a_fhoy[2]);
    fsolicitada_tstamp = fsolicitada_ob.getTime();
    fhoy_tstamp = fhoy_ob.getTime();
    diferencia = fhoy_tstamp -fsolicitada_tstamp;

    if(diferencia >= 0){
        alert("No se puede hacer ajuste de piezas por transaccion y %TRX del dia de actual y dias pasados!");
        return false;
    }
    if(checkPzXtra() && checkMixes()){
        document.frmMaster.submit() ;
    }
}



