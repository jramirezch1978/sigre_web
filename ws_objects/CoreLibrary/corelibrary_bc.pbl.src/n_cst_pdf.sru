$PBExportHeader$n_cst_pdf.sru
forward
global type n_cst_pdf from nonvisualobject
end type
end forward

global type n_cst_pdf from nonvisualobject
end type
global n_cst_pdf n_cst_pdf

type variables
Private:
String					is_PrintName = 'Sybase DataWindow PS', is_CustomPostScript = "Yes", &
							is_PrintXLSFOP = "no", is_PrintPDFLib = '1', is_ConfigPdfExport = '0'
Integer					ii_type_export_pdf = 1 //1 = Distill!, 2 = XSLFOP!

n_cst_inifile			invo_inifile
n_cst_wait				invo_wait
end variables

forward prototypes
public subroutine of_set_exp_pdf ()
public function boolean of_config_exp_pdf (string as_value)
public function boolean of_config_exp_pdf ()
public subroutine of_load_param ()
public function boolean of_create_pdf (datastore ads_obj, string as_path)
public function boolean of_create_pdf (datastore ads_obj, string as_path, integer ai_type_export_pdf)
public function boolean of_create_pdf (datawindow adw_report, string as_path)
public function boolean of_create_pdf (datawindow adw_report, string as_path, integer ai_type_export_pdf)
end prototypes

public subroutine of_set_exp_pdf ();
try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	invo_inifile.of_set_parametro("Impresora", "PSPrinter", this.is_PrintName)
	invo_inifile.of_set_parametro("EXPORT_PDF", "CustomPostScript",  this.is_CustomPostScript)
	invo_inifile.of_set_parametro("EXPORT_PDF", "PrintXLSFOP", this.is_PrintXLSFOP)
	invo_inifile.of_set_parametro("EXPORT_PDF", "TypeExportPDF", String(this.ii_type_export_pdf))
	invo_inifile.of_set_parametro("EXPORT_PDF", "PrintPDFLib", this.is_PrintPDFLib)

catch ( Exception ex)
	gnvo_app.of_catch_Exception(ex, 'Hubo una exception en n_Cst_pdf.of_load_param())')
end try


end subroutine

public function boolean of_config_exp_pdf (string as_value);Str_parametros lstr_param

try 
	if gs_user = 'jarch' and this.is_ConfigPdfExport = '1' then
		if MessageBox('Informacion', 'Desea configurar las opciones para exportar el archivo en PDF?', &
						Information!, YesNo!, 2) = 1 then
			
			//Pongo los parametros por defecto
			lstr_param.s_printName 			= is_printName
			lstr_param.s_CustomPostScript	= is_CustomPostScript 	 
			lstr_param.s_printXLSFOP		= is_PrintXLSFOP	
			lstr_param.i_TypeExportPDF		= ii_type_export_pdf
			
			OpenWithParm(w_type_export_pdf, lstr_param)
			
			lstr_param = Message.PowerObjectParm
			if not lstr_param.b_return then return false
			
			is_printName 			= lstr_param.s_printName
			is_CustomPostScript 	= lstr_param.s_CustomPostScript
			is_PrintXLSFOP			= lstr_param.s_printXLSFOP
			
			this.of_set_exp_pdf()
			
			return true
	
			
		end if
	end if

	return true

catch ( Exception ex )
	MessageBox('Exception', 'Ha ocurrido una excepción, por favor verificar. Error: ' + ex.GetMessage())
	return false
end try



end function

public function boolean of_config_exp_pdf ();return this.of_config_exp_pdf('1')
end function

public subroutine of_load_param ();
try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	this.is_PrintName		 		= invo_inifile.of_get_parametro("Impresora", "PSPrinter", this.is_PrintName)
	this.is_CustomPostScript	= invo_inifile.of_get_parametro("EXPORT_PDF", "CustomPostScript",  this.is_CustomPostScript)
	this.is_PrintXLSFOP		 	= invo_inifile.of_get_parametro("EXPORT_PDF", "PrintXLSFOP", this.is_PrintXLSFOP)
	this.is_PrintPDFLib		 	= invo_inifile.of_get_parametro("EXPORT_PDF", "PrintPDFLib", this.is_PrintPDFLib)
	this.ii_type_export_pdf	 	= Integer(invo_inifile.of_get_parametro("EXPORT_PDF", "TypeExportPDF", String(this.ii_type_export_pdf)))
	this.is_ConfigPdfExport		= gnvo_app.of_get_parametro("CONFIG_PDF_EXPORT", "0")
	

catch ( Exception ex)
	gnvo_app.of_catch_Exception(ex, 'Hubo una exception en n_Cst_pdf.of_load_param())')
end try

end subroutine

public function boolean of_create_pdf (datastore ads_obj, string as_path);return this.of_create_pdf( ads_obj, as_path, ii_type_export_pdf)
end function

public function boolean of_create_pdf (datastore ads_obj, string as_path, integer ai_type_export_pdf);String 	ls_Current_Printer

try 
	

	if this.is_PrintPDFLib = '0' then
		
		invo_wait.of_mensaje("Exportando " + as_path + " usando Printer " + is_PrintName + ". Espere unos minutos por favor")
		
		this.of_config_exp_pdf()
		
		if ai_type_export_pdf = 1 then
			// Captura la impresora de default actual 
			ls_current_printer = ads_obj.Describe ( "Datawindow.Printer" ) 
			// Asigne la impresora que tiene asignada para la funcionalidad de PDF 
			ads_obj.Modify("Datawindow.Printer='" + is_PrintName + "'" ) 
			// Especifique el metodo de creación 
			ads_obj.Modify("Datawindow.Export.PDF.Method=Distill!" ) 
			ads_obj.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
		else
			ads_obj.Modify("Export.PDF.Method = XSLFOP! ")
			ads_obj.Modify("Export.PDF.xslfop.print='Yes'")
		end if
	else
		
		invo_wait.of_mensaje("Exportando " + as_path + " usando PDFLib. Espere unos minutos por favor")
		
		ads_obj.Object.DataWindow.Export.PDF.NativePDF.UsePrintSpec = 'Yes'
		ads_obj.Object.DataWindow.Export.PDF.Method = NativePDF!
		ads_obj.Object.DataWindow.Export.PDF.NativePDF.PDFStandard = 1 //PDF/A-1a
		//ads_obj.Object.DataWindow.Print.Orientation = 1 //Landscape!
		//ads_obj.Object.DataWindow.Print.Paper.Size = 1 //1 – Letter 8 1/2 x 11 in
		
	end if
	
	// Salva la datastore a un archivo PDF 
	If ads_obj.saveas(as_path, PDF!, true) <> 1 Then 
		MessageBox("Error en creación de PDF", "No se pudo crear el archivo " + as_path + ".", StopSign!) 
		return false
	End If 
	
	RETURN true

catch ( exception ex )
	gnvo_app.of_catch_exception(ex, 'Error en function n_cst_pdf.of_create_pdf()')
	
finally
	if this.is_PrintPDFLib = '0' then
		if ii_type_export_pdf = 1 then
			// Regresa la impresora de default 
			ads_obj.Modify("Datawindow.Printer='" + ls_current_printer + "'" ) 
		end if
	end if
	
	invo_wait.of_close()
end try

 






end function

public function boolean of_create_pdf (datawindow adw_report, string as_path);return this.of_create_pdf( adw_report, as_path, this.ii_type_export_pdf )
end function

public function boolean of_create_pdf (datawindow adw_report, string as_path, integer ai_type_export_pdf);String 	ls_Current_Printer

try 
	if this.is_PrintPDFLib = '0' then
		
		invo_wait.of_mensaje("Exportando " + as_path + " usando XLSFLOP. Espere unos minutos por favor")
		
		this.of_config_exp_pdf()
		
		if ai_type_export_pdf = 1 then
			// Captura la impresora de default actual 
			ls_Current_Printer = adw_report.Describe ( "Datawindow.Printer" ) 
			
			// Asigne la impresora que tiene asignada para la funcionalidad de PDF 
			adw_report.Modify("Datawindow.Printer='" + this.is_PrintName + "'" ) 
			
			// Especifique el metodo de creación 
			adw_report.Modify("Datawindow.Export.PDF.Method=Distill!" ) 
			adw_report.Object.DataWindow.Export.PDF.Distill.CustomPostScript= is_CustomPostScript
			
		else
			adw_report.Modify("Export.PDF.Method = XSLFOP! ")
			adw_report.Modify("Export.PDF.xslfop.print='" + this.is_PrintXLSFOP + "'")
		end if
		
	else
		invo_wait.of_mensaje("Exportando " + as_path + " usando PDFLib. Espere unos minutos por favor")
		
		adw_report.Object.DataWindow.Export.PDF.NativePDF.UsePrintSpec = 'Yes'
		adw_report.Object.DataWindow.Export.PDF.Method = NativePDF!
		adw_report.Object.DataWindow.Export.PDF.NativePDF.PDFStandard = 1 //PDF/A-1a
		//adw_report.Object.DataWindow.Print.Orientation = 1 //Landscape!
		//adw_report.Object.DataWindow.Print.Paper.Size = 1 //1 – Letter 8 1/2 x 11 in
		
	end if
	
	// Salva la datastore a un archivo PDF 
	If adw_report.saveas(as_path, PDF!, true) <> 1 Then 
		MessageBox("Error en creación de PDF", "No se pudo crear el archivo " + as_path + ".", StopSign!) 
		return false
	End If 
	
	
	RETURN true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Exception en funcion n_Cst_pdf.of_create_pdf()')
finally
	
	if this.is_PrintPDFLib = '0' then
		if ii_type_export_pdf = 1 then
			// Regresa la impresora de default 
			adw_report.Modify("Datawindow.Printer='" + ls_Current_Printer + "'" ) 
		end if
	end if
	
	invo_wait.of_close()
end try





end function

on n_cst_pdf.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_pdf.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_inifile 	= create n_cst_inifile
invo_wait		= create n_cst_wait
end event

event destructor;destroy invo_inifile
destroy invo_Wait
end event

