<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.lang.Integer" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.io.FileNotFoundException" %>

<%!
	int longitud;

	int getLongitud(){
		return longitud;
	}

	String PrintFileExtra(String FileNames){
		String line = "";
		String out = "";
		try{
			BufferedReader br =  new BufferedReader(new FileReader(FileNames));
			while((line = br.readLine()) != null){
				if(line.length() > 10) {
					out = out + line;
				}
			}
			br.close();
		}catch(IOException e){
			out = readerFileOpcion(FileNames);
		}
		return out;
	}

	String PrintFile(String FileNames,int lon){
		String out = "";
		String line = "";
		int x = 1;
		System.out.println("ARCHIVO: " + FileNames);
		if((lon != 0) || (lon == 10)){
			try{
				out = "";
				BufferedReader br =  new BufferedReader(new FileReader(FileNames));
				while((line = br.readLine()) != null){
					if(line.length() > 2) {
				    		//out = out +"<tr><td class='detail-cont' height='10px'><pre>"+ line +"</pre></td></tr>";
						//if(line.equals("***SALTO***") || line == "***SALTO***"){
						String compa = line.trim();
						if(compa.equals("***SALTO***")){
							out = out + "&nbsp;<br><br><br>";
						}
						else{
							out = out + line + "&nbsp;<br>";
						}
					 }
				}
				out = "<tr><td class='detail-cont'><pre>" + out + "</pre></td></tr>";
				br.close();
			}catch(IOException e){
				System.err.println(e);
			}
		}else{
			if((lon != 1) && (lon != 10)){
			try{
				out = "";
				BufferedReader br =  new BufferedReader(new FileReader(FileNames));
				while((line = br.readLine()) != null){
					if(line.length() > 10) {
				    	out = out + "<pre>"+ line +"</pre>";
					 }
				}
				br.close();
			}catch(IOException e){
				System.out.println("No lo encontre aqui");
			}
			}
		}
		if(lon == 1) {
			out = "";
			out = PrintFileExtra(FileNames);
		}
		return out;
	}


	String readerFile(){
	   String line;
	   StringBuffer buffer = new StringBuffer();
	   FileReader fReader;
	   BufferedReader bReader;
		try {
		      fReader = new FileReader("/usr/bin/taco/bin/negocio.out");
				bReader = new BufferedReader(fReader);
				while ((line = bReader.readLine()) != null){
						buffer.append(line);
				}
				bReader.close();
				fReader.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
		    e.printStackTrace();
		}
		return buffer.toString();
	}

	String readerFileOpcion(String FilesIn){
	   String line;
	   StringBuffer buffer = new StringBuffer();
	   FileReader fReader;
	   BufferedReader bReader;
		try {
		      fReader = new FileReader(FilesIn);
				bReader = new BufferedReader(fReader);
				while ((line = bReader.readLine()) != null){
						buffer.append(line);
				}
				bReader.close();
				fReader.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
		    e.printStackTrace();
		}
		return buffer.toString();
	}
%>

