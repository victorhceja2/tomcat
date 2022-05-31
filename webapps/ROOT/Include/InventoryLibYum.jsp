<%!
    /**
        Se actualiza el archivo de inventario de FMS con el uso ideal del dia actual
    */
    void updateIdealUse()
    {
        //DEBUG
        System.out.println("Actualizando uso ideal");

        String lsCommand = "/usr/local/tomcat/webapps/ROOT/Scripts/upd_use.s";

        try
        {
            Runtime runtime = Runtime.getRuntime();
            Process process = runtime.exec(lsCommand);
            process.waitFor();
        }
        catch(Exception e)
        {
            System.out.println("loadCurrentIdealUse() exception ... " + e);
        }   
    }

    void loadFinantialMov()
    {
        //DEBUG:
        System.out.println("Cargando movimientos financieros");

        String lsCommand = "/usr/local/tomcat/webapps/ROOT/Scripts/finantial_mov.s";

        try
        {
            Runtime runtime = Runtime.getRuntime();
            Process process = runtime.exec(lsCommand);
            process.waitFor();
        }
        catch(Exception e)
        {
            System.out.println("loadFinantialMov() exception ... " + e);
        }
    }

%>
