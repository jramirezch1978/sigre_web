$PBExportHeader$w_fi749_registro_compras.srw
forward
global type w_fi749_registro_compras from w_rpt
end type
type cb_exportar from commandbutton within w_fi749_registro_compras
end type
type cbx_sunat from checkbox within w_fi749_registro_compras
end type
type cbx_fecha from checkbox within w_fi749_registro_compras
end type
type cbx_fvenc from checkbox within w_fi749_registro_compras
end type
type cb_2 from commandbutton within w_fi749_registro_compras
end type
type cbx_1 from checkbox within w_fi749_registro_compras
end type
type sle_desc from singlelineedit within w_fi749_registro_compras
end type
type sle_origen from singlelineedit within w_fi749_registro_compras
end type
type dw_reporte from u_dw_rpt within w_fi749_registro_compras
end type
type cb_1 from commandbutton within w_fi749_registro_compras
end type
type st_1 from statictext within w_fi749_registro_compras
end type
type st_2 from statictext within w_fi749_registro_compras
end type
type em_year from editmask within w_fi749_registro_compras
end type
type ddlb_mes from dropdownlistbox within w_fi749_registro_compras
end type
type gb_1 from groupbox within w_fi749_registro_compras
end type
type dw_export from datawindow within w_fi749_registro_compras
end type
end forward

global type w_fi749_registro_compras from w_rpt
boolean visible = false
integer width = 3337
integer height = 2188
string title = "[FI749] Reporte de Registro de Compras"
string menuname = "m_reporte"
boolean resizable = false
event ue_save_rep_sunat ( )
cb_exportar cb_exportar
cbx_sunat cbx_sunat
cbx_fecha cbx_fecha
cbx_fvenc cbx_fvenc
cb_2 cb_2
cbx_1 cbx_1
sle_desc sle_desc
sle_origen sle_origen
dw_reporte dw_reporte
cb_1 cb_1
st_1 st_1
st_2 st_2
em_year em_year
ddlb_mes ddlb_mes
gb_1 gb_1
dw_export dw_export
end type
global w_fi749_registro_compras w_fi749_registro_compras

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

event ue_save_rep_sunat();string ls_path, ls_file
int li_rc

IF cbx_sunat.checked = FALSE THEN RETURN
IF dw_export.rowcount() < 1 THEN RETURN

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_export, ls_file )
End If
end event

public function boolean of_validacion_rpt ();//========== VALIDACION DE LA LONGITUD DEL AÑO Y MES ========//

IF len(em_year.text) < 4 OR em_year.text = '0000' THEN 
	Messagebox('EL INGRESO DEL AÑO ESTA MAL','EL AÑO DEBE SER DE 4 DIGITOS')
	em_year.SetFocus()
	RETURN FALSE
END IF 

IF ddlb_mes.text = 'none' or IsNull(ddlb_mes.text) THEN
	Messagebox('EL INGRESO DEL MES ESTA MAL','EL MES DEBE SER DE 2 DIGITOS')
	ddlb_mes.SetFocus()
	RETURN FALSE
END IF	

RETURN TRUE
end function

on w_fi749_registro_compras.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_exportar=create cb_exportar
this.cbx_sunat=create cbx_sunat
this.cbx_fecha=create cbx_fecha
this.cbx_fvenc=create cbx_fvenc
this.cb_2=create cb_2
this.cbx_1=create cbx_1
this.sle_desc=create sle_desc
this.sle_origen=create sle_origen
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.em_year=create em_year
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
this.dw_export=create dw_export
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_exportar
this.Control[iCurrent+2]=this.cbx_sunat
this.Control[iCurrent+3]=this.cbx_fecha
this.Control[iCurrent+4]=this.cbx_fvenc
this.Control[iCurrent+5]=this.cb_2
this.Control[iCurrent+6]=this.cbx_1
this.Control[iCurrent+7]=this.sle_desc
this.Control[iCurrent+8]=this.sle_origen
this.Control[iCurrent+9]=this.dw_reporte
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.st_2
this.Control[iCurrent+13]=this.em_year
this.Control[iCurrent+14]=this.ddlb_mes
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.dw_export
end on

on w_fi749_registro_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_exportar)
destroy(this.cbx_sunat)
destroy(this.cbx_fecha)
destroy(this.cbx_fvenc)
destroy(this.cb_2)
destroy(this.cbx_1)
destroy(this.sle_desc)
destroy(this.sle_origen)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.em_year)
destroy(this.ddlb_mes)
destroy(this.gb_1)
destroy(this.dw_export)
end on

event ue_retrieve;String 	ls_origen,ls_null,ls_nota_cred,ls_flag, &
			ls_nombre_mes, ls_mensaje
Long   	ll_count,ll_inicio, ll_year, ll_mes

ll_year   = Long(em_year.text)
ll_mes    = Long(LEFT(ddlb_mes.text,2))


select nota_cred_nfc 
	into :ls_nota_cred 
from finparam 
where reckey = '1' ;

if cbx_fvenc.checked then
	ls_flag = '1'
else
	ls_flag = '0'
end if


IF not of_validacion_rpt() THEn return

IF cbx_1.checked THEN
	ls_origen = '%'
ELSE
	ls_origen = sle_origen.text
	
	if trim(ls_origen) = '' then
		Messagebox('Aviso','Debe Seleccionar un origen Valido, por favor verifique!', StopSign!)
		sle_origen.SetFocus()
		RETURN
	end if
	
	select count(*) 
		into :ll_count 
	from origen 
	where cod_origen = :ls_origen ;
	  
	IF ll_count = 0 THEN 
		Messagebox('Aviso','Codigo de Origen No Valido', StopSign!)
		sle_origen.SetFocus()
		RETURN
	END IF
END IF

dw_reporte.SetTransObject(SQLCA)

CHOOSE CASE trim(string(ll_mes, '00'))

	CASE '01'
		  ls_nombre_mes = '01 ENERO'
	CASE '02'
		  ls_nombre_mes = '02 FEBRERO'
	CASE '03'
		  ls_nombre_mes = '03 MARZO'
	CASE '04'
		  ls_nombre_mes = '04 ABRIL'
	CASE '05'
		  ls_nombre_mes = '05 MAYO'
	CASE '06'
		  ls_nombre_mes = '06 JUNIO'
	CASE '07'
		  ls_nombre_mes = '07 JULIO'
	CASE '08'
		  ls_nombre_mes = '08 AGOSTO'
	CASE '09'
		  ls_nombre_mes = '09 SEPTIEMBRE'
	CASE '10'
		  ls_nombre_mes = '10 OCTUBRE'
	CASE '11'
		  ls_nombre_mes = '11 NOVIEMBRE'
	CASE '12'
		  ls_nombre_mes = '12 DICIEMBRE'
END CHOOSE
//--

if cbx_sunat.checked then
	dw_reporte.DataObject = 'd_rpt_reg_compras_sunat_tbl'
	dw_export.DataObject = 'd_rpt_reg_compras_sunat1_tbl'
	dw_export.SetTransObject(SQLCA)
else
	dw_reporte.DataObject = 'd_rpt_reg_compras_tbl'
end if

dw_reporte.SetTransObject(SQLCA)

dw_reporte.object.p_logo.filename 		= gs_logo
dw_reporte.object.t_user.text     		= gs_user
dw_reporte.object.t_ano.text      		= string(ll_year, '0000')
dw_reporte.object.t_mes.text      		= ls_nombre_mes

dw_reporte.object.t_razon_social.text 	= gnvo_app.empresa.nombre()
dw_reporte.object.t_ruc.text		 		= gnvo_app.empresa.ruc()

IF cbx_sunat.checked THEN
	dw_export.retrieve(ll_year, ll_mes, ls_origen)
END IF

CHOOSE CASE dw_reporte.retrieve(ll_year, ll_mes, ls_origen)
	CASE 0 
		MessageBox('Numero de Filas Recuperadas','No Hay Datos')
END CHOOSE		
	
//dw_reporte.Modify("vencimiento.Visible='1~tIf(IsNull(flag),0,1)'")	

dw_reporte.Object.DataWindow.Print.Paper.Size = 5
dw_reporte.Object.DataWindow.Print.Orientation = 1

ib_preview = false
event ue_preview()
	
if cbx_fecha.enabled then
	dw_reporte.object.fecha_t.visible = 0
	dw_reporte.object.fecha.visible = 0
end if

end event

event resize;call super::resize;dw_reporte.width  = newwidth  - dw_reporte.x - 10
dw_reporte.height = newheight - dw_reporte.y - 10

end event

event ue_preview;call super::ue_preview;idw_1.ii_zoom_actual = 100
IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Registro de Compras " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
Trigger Event ue_preview()

em_year.text = string(gnvo_app.of_fecha_actual(), 'yyyy')

/*idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
*/

ib_preview = true
THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

type cb_exportar from commandbutton within w_fi749_registro_compras
boolean visible = false
integer x = 2917
integer y = 172
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Exportar"
end type

event clicked;parent.Event ue_save_rep_sunat()
end event

type cbx_sunat from checkbox within w_fi749_registro_compras
integer x = 1947
integer y = 68
integer width = 891
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato SUNAT"
end type

event clicked;if this.checked then
	dw_reporte.object.fecha_t.visible = '0'
	dw_reporte.object.fecha.visible = '0'
	cb_exportar.visible = true
	cb_exportar.enabled = true
else
	dw_reporte.object.fecha_t.visible = 'yes'
	dw_reporte.object.fecha.visible = 'yes'
	cb_exportar.visible = false
	cb_exportar.enabled = false
end if

end event

type cbx_fecha from checkbox within w_fi749_registro_compras
integer x = 1947
integer y = 212
integer width = 891
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ocultar Fecha de Impresión"
end type

event clicked;if this.checked then
	dw_reporte.object.fecha_t.visible = '0'
	dw_reporte.object.fecha.visible = '0'
else
	dw_reporte.object.fecha_t.visible = 'yes'
	dw_reporte.object.fecha.visible = 'yes'
end if

end event

type cbx_fvenc from checkbox within w_fi749_registro_compras
integer x = 1947
integer y = 140
integer width = 891
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Deshabilitar Fecha de Vencimiento"
end type

type cb_2 from commandbutton within w_fi749_registro_compras
integer x = 965
integer y = 168
integer width = 96
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO ,'&
				      				 +'ORIGEN.NOMBRE AS DESCRIPCION '&
				   					 +'FROM ORIGEN '

														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
   sle_origen.text =  lstr_seleccionar.param1[1]
   sle_desc.text   =  lstr_seleccionar.param2[1]
END IF

end event

type cbx_1 from checkbox within w_fi749_registro_compras
integer x = 18
integer y = 164
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos Los Origenes "
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_origen.enabled = false
	sle_origen.text = ""
	sle_desc.text = "TODAS"
else
	sle_origen.enabled = true
	sle_desc.text = ""
end if
end event

type sle_desc from singlelineedit within w_fi749_registro_compras
integer x = 1083
integer y = 168
integer width = 846
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_fi749_registro_compras
integer x = 722
integer y = 168
integer width = 233
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_origen,ls_desc
Long   ll_count


ls_origen = this.text


select count(*) into :ll_count 
  from origen 
 where cod_origen = :ls_origen ;
 
IF ll_count > 0 THEN
	select nombre into :ls_desc from origen 
	 where cod_origen = :ls_origen ;
	 
	sle_desc.text = ls_desc
ELSE
	Setnull(ls_desc)
	sle_desc.text = ls_desc
END IF
 

end event

type dw_reporte from u_dw_rpt within w_fi749_registro_compras
integer y = 336
integer width = 3250
integer height = 1472
integer taborder = 30
string dataobject = "d_rpt_reg_compras_tbl"
boolean livescroll = false
end type

type cb_1 from commandbutton within w_fi749_registro_compras
integer x = 2917
integer y = 44
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type st_1 from statictext within w_fi749_registro_compras
integer x = 41
integer y = 68
integer width = 210
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "AÑO :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi749_registro_compras
integer x = 471
integer y = 68
integer width = 210
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "MES :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_year from editmask within w_fi749_registro_compras
integer x = 274
integer y = 56
integer width = 174
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_fi749_registro_compras
integer x = 704
integer y = 56
integer width = 517
integer height = 856
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fi749_registro_compras
integer width = 3296
integer height = 308
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Periodo"
end type

type dw_export from datawindow within w_fi749_registro_compras
boolean visible = false
integer x = 3022
integer y = 1848
integer width = 155
integer height = 136
integer taborder = 40
string title = "none"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

