function magia() {


    //Harina Secreta
    var secreta_inv = document.getElementById('secreta_inv').value;
    if ( secreta_inv == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('secreta_inv').focus();
        return false;
    }
    var harina_secreta = secreta_inv/75;
    document.getElementById('harina_secreta').innerHTML = harina_secreta.toFixed(2);

    //Harina Cruji
    var cruji_inv = document.getElementById('cruji_inv').value;
    if ( cruji_inv == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('cruji_inv').focus();
        return false;
    }
    var harina_cruji = cruji_inv/75;
    document.getElementById('harina_cruji').innerHTML = harina_cruji.toFixed(2);

    //Harina HotCruji
    var hotcruji_inv = document.getElementById('hotcruji_inv').value;
    if ( hotcruji_inv == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('hotcruji_inv').focus();
        return false;
    }
    var harina_hot = hotcruji_inv/75;
    document.getElementById('harina_hot').innerHTML = harina_hot.toFixed(2);

    //Obtener cabezas pron. sig dia
    var cabezas_secreta_tomorrow = document.getElementById('cabezas_secreta_tomorrow').innerHTML;
    var cabezas_cruji_tomorrow = document.getElementById('cabezas_cruji_tomorrow').innerHTML;
    var cabezas_hot_tomorrow = document.getElementById('cabezas_hot_tomorrow').innerHTML;
    var tenders_piezas_tomorrow = document.getElementById('tenders_piezas_tomorrow').innerHTML;

    var tenders_inv = document.getElementById('tenders_inv').value;

    //Total a marinar Secreta
    var secreta_tarde = document.getElementById('secreta_tarde').innerHTML;
    var marinar_tot_secreta = Number(cabezas_secreta_tomorrow) + Number(secreta_tarde) - Number(secreta_inv);
    document.getElementById('marinar_tot_secreta').innerHTML = marinar_tot_secreta.toFixed(2);

    //Total a marinar cruji
    var cruji_tarde = document.getElementById('cruji_tarde').innerHTML;
    var marinar_tot_cruji = Number(cabezas_cruji_tomorrow) + Number(cruji_tarde) - Number(cruji_inv);
    document.getElementById('marinar_tot_cruji').innerHTML = marinar_tot_cruji.toFixed(2);

    //Total a marinar hotcruji
    var hot_tarde = document.getElementById('hot_tarde').innerHTML;
    var marinar_tot_hot = Number(cabezas_hot_tomorrow) + Number(hot_tarde) - Number(hotcruji_inv);
    document.getElementById('marinar_tot_hot').innerHTML = marinar_tot_hot.toFixed(2);


    //Total a marinar tiras 
    var tenders_tarde = document.getElementById('tenders_tarde').innerHTML;
    var marinar_tot_tenders = Number(tenders_piezas_tomorrow) + Number(tenders_tarde) - Number(tenders_inv);
    document.getElementById('marinar_tot_tenders').innerHTML = marinar_tot_tenders.toFixed(2);

    //70 % marinar secreta
    var marinar_70_secreta = marinar_tot_secreta * 0.7;
    document.getElementById('marinar_70_secreta').innerHTML = marinar_70_secreta.toFixed(2);

    //30 % marinar secreta
    var marinar_30_secreta = marinar_tot_secreta * 0.3;
    document.getElementById('marinar_30_secreta').innerHTML = marinar_30_secreta.toFixed(2);

    //70 % marinar cruji 
    var marinar_70_cruji = marinar_tot_cruji * 0.7;
    document.getElementById('marinar_70_cruji').innerHTML = marinar_70_cruji.toFixed(2);

    //30 % marinar cruji 
    var marinar_30_cruji = marinar_tot_cruji * 0.3;
    document.getElementById('marinar_30_cruji').innerHTML = marinar_30_cruji.toFixed(2);

    //70 % marinar hot
    var marinar_70_hot = marinar_tot_hot * 0.7;
    document.getElementById('marinar_70_hot').innerHTML = marinar_70_hot.toFixed(2);

    //30 % marinar hot
    var marinar_30_hot = marinar_tot_hot * 0.3;
    document.getElementById('marinar_30_hot').innerHTML = marinar_30_hot.toFixed(2);


    //70 % marinar tiras 
    var marinar_70_tenders = marinar_tot_tenders * 0.7;
    document.getElementById('marinar_70_tenders').innerHTML = marinar_70_tenders.toFixed(2);

    //30 % marinar tiras 
    var marinar_30_tenders = marinar_tot_tenders * 0.3;
    document.getElementById('marinar_30_tenders').innerHTML = marinar_30_tenders.toFixed(2);

    //En mallas secreta
    var total_mallas_secreta = marinar_tot_secreta / 2;
    document.getElementById('total_mallas_secreta').innerHTML = total_mallas_secreta.toFixed(2);
    document.getElementById('mallas_secreta').innerHTML = total_mallas_secreta.toFixed(2);
    var horas_secreta = total_mallas_secreta / 40;
    document.getElementById('horas_secreta').innerHTML = horas_secreta.toFixed(2);

    //En mallas cruji
    var total_mallas_cruji = marinar_tot_cruji/ 2;
    document.getElementById('total_mallas_cruji').innerHTML = total_mallas_cruji.toFixed(2);
    document.getElementById('mallas_cruji').innerHTML = total_mallas_cruji.toFixed(2);
    var horas_cruji = total_mallas_cruji / 40;
    document.getElementById('horas_cruji').innerHTML = horas_cruji.toFixed(2);

    //En mallas hot
    var total_mallas_hot = marinar_tot_hot/ 2;
    document.getElementById('total_mallas_hot').innerHTML = total_mallas_hot.toFixed(2);
    document.getElementById('mallas_hot').innerHTML = total_mallas_hot.toFixed(2);
    var horas_hot = total_mallas_hot / 40;
    document.getElementById('horas_hot').innerHTML = horas_hot.toFixed(2);


    // en mallas tiras
    var total_mallas_tenders =  marinar_tot_tenders / 40;
    document.getElementById('total_mallas_tenders').innerHTML = total_mallas_tenders.toFixed(2);

    // Tiempo total marinado
    var total_horas = horas_secreta + horas_cruji + horas_hot;
    document.getElementById('tiempo_marinado').innerHTML = total_horas.toFixed(2);

    //Filete en descong. > 48 hrs BC
    var filetes_bc_48 = document.getElementById('filetes_bc_48').value;
    if ( filetes_bc_48 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_bc_48').focus();
        return false;
    }
    var bc_today = document.getElementById('bc_today').innerHTML;
    var dif_48_bc = filetes_bc_48 - bc_today;
    document.getElementById('dif_48_bc').innerHTML = dif_48_bc.toFixed(2);
    //Bolsas
    var bolsas_48_bc = dif_48_bc / 8;
    document.getElementById('bolsas_48_bc').innerHTML = bolsas_48_bc.toFixed(2);



    //Filete en descong. > 24 hrs BC
    var filetes_bc_24 = document.getElementById('filetes_bc_24').value;
    if ( filetes_bc_24 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_bc_24').focus();
        return false;
    }
    var bc_tomorrow = document.getElementById('bc_tomorrow').innerHTML;
    var dif_24_bc = filetes_bc_24 - bc_tomorrow;
    document.getElementById('dif_24_bc').innerHTML = dif_24_bc.toFixed(2);
    //Bolsas
    var bolsas_24_bc = dif_24_bc / 8;
    document.getElementById('bolsas_24_bc').innerHTML = bolsas_24_bc.toFixed(2);

    //Filete en descong. hoy BC
    var filetes_bc_hoy = document.getElementById('filetes_bc_hoy').value;
    if ( filetes_bc_hoy == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_bc_hoy').focus();
        return false;
    }
    var bc_aftertomorrow = document.getElementById('bc_aftertomorrow').innerHTML;
    var dif_today_bc = filetes_bc_hoy - bc_aftertomorrow;
    document.getElementById('dif_today_bc').innerHTML = dif_today_bc.toFixed(2);
    //Bolsas
    var bolsas_today_bc = dif_today_bc / 8;
    document.getElementById('bolsas_today_bc').innerHTML = bolsas_today_bc.toFixed(2);

    // total bolsas BC
    var total_des_bolsas_bc = Number(bolsas_today_bc) + Number(bolsas_24_bc) + Number(bolsas_48_bc);
    document.getElementById('total_des_bolsas_bc').innerHTML = total_des_bolsas_bc.toFixed(2);
	
    //Filete en descong. > 48 hrs FC
    var filetes_fc_48 = document.getElementById('filetes_fc_48').value;
    if ( filetes_fc_48 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_fc_48').focus();
        return false;
    }
    var fc_today = document.getElementById('fc_today').innerHTML;
    var dif_48_fc = filetes_fc_48 - fc_today;
    document.getElementById('dif_48_fc').innerHTML = dif_48_fc.toFixed(2);
    //Bolsas
    var bolsas_48_fc = dif_48_fc / 8;
    document.getElementById('bolsas_48_fc').innerHTML = bolsas_48_fc.toFixed(2);



    //Filete en descong. > 24 hrs FC
    var filetes_fc_24 = document.getElementById('filetes_fc_24').value;
    if ( filetes_fc_24 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_fc_24').focus();
        return false;
    }
    var fc_tomorrow = document.getElementById('fc_tomorrow').innerHTML;
    var dif_24_fc = filetes_fc_24 - fc_tomorrow;
    document.getElementById('dif_24_fc').innerHTML = dif_24_fc.toFixed(2);
    //Bolsas
    var bolsas_24_fc = dif_24_fc / 8;
    document.getElementById('bolsas_24_fc').innerHTML = bolsas_24_fc.toFixed(2);

    //Filete en descong. hoy FC
    var filetes_fc_hoy = document.getElementById('filetes_fc_hoy').value;
    if ( filetes_fc_hoy == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_fc_hoy').focus();
        return false;
    }
    var fc_aftertomorrow = document.getElementById('fc_aftertomorrow').innerHTML;
    var dif_today_fc = filetes_fc_hoy - fc_aftertomorrow;
    document.getElementById('dif_today_fc').innerHTML = dif_today_fc.toFixed(2);
    //Bolsas
    var bolsas_today_fc = dif_today_fc / 8;
    document.getElementById('bolsas_today_fc').innerHTML = bolsas_today_fc.toFixed(2);

    // total bolsas FC
    var total_des_bolsas_fc = Number(bolsas_today_fc) + Number(bolsas_24_fc) + Number(bolsas_48_fc);
    document.getElementById('total_des_bolsas_fc').innerHTML = total_des_bolsas_fc.toFixed(2);

    //Filete en descong. > 48 hrs Coronel Supreme
    var filetes_cs_48 = document.getElementById('filetes_cs_48').value;
    if ( filetes_cs_48 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_cs_48').focus();
        return false;
    }
    var cs_today = document.getElementById('cs_today').innerHTML;
    var dif_48_cs = filetes_cs_48 - cs_today;
    document.getElementById('dif_48_cs').innerHTML = dif_48_cs.toFixed(2);
    //Bolsas
    var bolsas_48_cs = dif_48_cs / 6;
    document.getElementById('bolsas_48_cs').innerHTML = bolsas_48_cs.toFixed(2);



    //Filete en descong. > 24 hrs CS
    var filetes_cs_24 = document.getElementById('filetes_cs_24').value;
    if ( filetes_cs_24 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_cs_24').focus();
        return false;
    }
    var cs_tomorrow = document.getElementById('cs_tomorrow').innerHTML;
    var dif_24_cs = filetes_cs_24 - cs_tomorrow;
    document.getElementById('dif_24_cs').innerHTML = dif_24_cs.toFixed(2);
    //Bolsas
    var bolsas_24_cs = dif_24_cs / 6;
    document.getElementById('bolsas_24_cs').innerHTML = bolsas_24_cs.toFixed(2);

    //Filete en descong. hoy CS
    var filetes_cs_hoy = document.getElementById('filetes_cs_hoy').value;
    if ( filetes_cs_hoy == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('filetes_cs_hoy').focus();
        return false;
    }
    var cs_aftertomorrow = document.getElementById('cs_aftertomorrow').innerHTML;
    var dif_today_cs = filetes_cs_hoy - cs_aftertomorrow;
    document.getElementById('dif_today_cs').innerHTML = dif_today_cs.toFixed(2);
    //Bolsas
    var bolsas_today_cs = dif_today_cs / 6;
    document.getElementById('bolsas_today_cs').innerHTML = bolsas_today_cs.toFixed(2);

    // total bolsas CS
    var total_des_bolsas_cs = Number(bolsas_today_cs) + Number(bolsas_24_cs) + Number(bolsas_48_cs);
    document.getElementById('total_des_bolsas_cs').innerHTML = total_des_bolsas_cs.toFixed(2);

    //tiras  descong > 48
    var descong_tenders_48 = document.getElementById('descong_tenders_48').value;
    if ( descong_tenders_48 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('descong_tenders_48').focus();
        return false;
    }
    var bolsas_48_tenders = descong_tenders_48 / 40;
    document.getElementById('bolsas_48_tenders').innerHTML = bolsas_48_tenders.toFixed(2);

    //tiras  descong > 24
    var descong_tenders_24 = document.getElementById('descong_tenders_24').value;
    if ( descong_tenders_24 == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('descong_tenders_24').focus();
        return false;
    }
    var bolsas_24_tenders = descong_tenders_24 / 40;
    document.getElementById('bolsas_24_tenders').innerHTML = bolsas_24_tenders.toFixed(2);

    //Tiras  descong hoy
    var descong_tenders_hoy = document.getElementById('descong_tenders_hoy').value;
    if ( descong_tenders_hoy == '' ) {
        alert("Favor de ingresar un valor");
        document.getElementById('descong_tenders_hoy').focus();
        return false;
    }
    var bolsas_today_tenders = descong_tenders_hoy / 40;
    document.getElementById('bolsas_today_tenders').innerHTML = bolsas_today_tenders.toFixed(2);


    var total_descong_tenders = Number(descong_tenders_hoy) + Number(descong_tenders_24) + Number(descong_tenders_48);
    document.getElementById('total_descong_tenders').innerHTML = total_descong_tenders.toFixed(2);

    var total_descong_bols_tenders = Number(bolsas_today_tenders) + Number(bolsas_24_tenders) + Number(bolsas_48_tenders);
    document.getElementById('total_descong_bols_tenders').innerHTML = total_descong_bols_tenders.toFixed(2);
    
}
