$PBExportHeader$w_pr501_atrib_prod_final_new.srw
forward
global type w_pr501_atrib_prod_final_new from w_rpt
end type
type dw_report from u_dw_rpt within w_pr501_atrib_prod_final_new
end type
type sle_desc_ot_adm from singlelineedit within w_pr501_atrib_prod_final_new
end type
type sle_ot_adm from sle_text within w_pr501_atrib_prod_final_new
end type
type pb_1 from picturebutton within w_pr501_atrib_prod_final_new
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_pr501_atrib_prod_final_new
end type
type em_descripcion from editmask within w_pr501_atrib_prod_final_new
end type
type em_origen from singlelineedit within w_pr501_atrib_prod_final_new
end type
type gb_1 from groupbox within w_pr501_atrib_prod_final_new
end type
type gb_2 from groupbox within w_pr501_atrib_prod_final_new
end type
end forward

global type w_pr501_atrib_prod_final_new from w_rpt
integer width = 3451
integer height = 1760
string title = "Reporte de Produccion Por Rango de Fechas(PR501)"
string menuname = "m_reporte"
long backcolor = 67108864
dw_report dw_report
sle_desc_ot_adm sle_desc_ot_adm
sle_ot_adm sle_ot_adm
pb_1 pb_1
uo_fecha uo_fecha
em_descripcion em_descripcion
em_origen em_origen
gb_1 gb_1
gb_2 gb_2
end type
global w_pr501_atrib_prod_final_new w_pr501_atrib_prod_final_new

on w_pr501_atrib_prod_final_new.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
this.sle_desc_ot_adm=create sle_desc_ot_adm
this.sle_ot_adm=create sle_ot_adm
this.pb_1=create pb_1
this.uo_fecha=create uo_fecha
this.em_descripcion=create em_descripcion
this.em_origen=create em_origen
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.sle_desc_ot_adm
this.Control[iCurrent+3]=this.sle_ot_adm
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.uo_fecha
this.Control[iCurrent+6]=this.em_descripcion
this.Control[iCurrent+7]=this.em_origen
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_pr501_atrib_prod_final_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
destroy(this.sle_desc_ot_adm)
destroy(this.sle_ot_adm)
destroy(this.pb_1)
destroy(this.uo_fecha)
destroy(this.em_descripcion)
destroy(this.em_origen)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_ot_adm, ls_origen, ls_ot_adm_desc
this.SetRedraw(true)
ld_fecha1 	= uo_fecha.of_get_fecha1( )
ld_fecha2 	= uo_fecha.of_get_fecha2( )
ls_ot_adm	= sle_ot_adm.Text
ls_origen	= em_origen.text

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'OT_ADM ESTA EN BLANCO, POR FAVOR VERFIQUE', StopSign!)
	return
end if

select descripcion 
into :ls_ot_adm_desc
from ot_administracion a, pd_ot p
where a.ot_adm = p.ot_adm
  and a.ot_adm = :ls_ot_adm;

idw_1.Retrieve(ld_fecha1, ld_fecha2, ls_ot_adm, ls_origen)
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.ot_adm.text  = ls_ot_adm
idw_1.Object.desc_ot_adm.text  = ls_ot_adm_desc
idw_1.Object.t_fecha1.text  = string(ld_fecha1)
idw_1.Object.t_fecha2.text  = string(ld_fecha2)
idw_1.Object.Datawindow.Print.Orientation = '1'
//idw_1.object.t_nombre.text = gs_empresa

end event

type dw_report from u_dw_rpt within w_pr501_atrib_prod_final_new
integer x = 73
integer y = 304
integer width = 3310
integer height = 1036
integer taborder = 40
string dataobject = "d_rpt_produccion_final_cst"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type sle_desc_ot_adm from singlelineedit within w_pr501_atrib_prod_final_new
integer x = 1349
integer y = 140
integer width = 1033
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
borderstyle borderstyle = stylelowered!
end type

type sle_ot_adm from sle_text within w_pr501_atrib_prod_final_new
integer x = 1047
integer y = 140
integer width = 297
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
end type

event modified;call super::modified;string ls_codigo, ls_data

ls_codigo = trim(this.text)

SetNull(ls_data)
SELECT DESCRIPCION  
	into :ls_data
FROM  VW_CAM_USR_ADM 
WHERE COD_USR = :gs_user
  and ot_adm  = :ls_codigo;
  
if ls_data = "" or IsNull(ls_data) then
	Messagebox('Error', "OT_ADM NO EXISTE O NO ESTA AUTORIZADO", StopSign!)
	this.text = ""
	sle_desc_ot_adm.text = ""
	parent.event dynamic ue_reset( )
	return
end if
		
sle_desc_ot_adm.text = ls_data



end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = 'SELECT OT_ADM AS CODIGO, '&   
		 + 'DESCRIPCION  AS DESCR_OT_ADM  '&   
		 + 'FROM  VW_CAM_USR_ADM '&
		 + 'WHERE COD_USR = '+"'"+gs_user+"'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
if ls_codigo <> '' then
	this.Text 		= ls_codigo
	sle_desc_ot_adm.Text = ls_data
end if



end event

type pb_1 from picturebutton within w_pr501_atrib_prod_final_new
integer x = 3163
integer y = 88
integer width = 315
integer height = 180
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\Aceptar_dn.bmp"
alignment htextalign = left!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_retrieve()
SetPointer(Arrow!)
end event

type uo_fecha from u_ingreso_rango_fechas_v within w_pr501_atrib_prod_final_new
event destroy ( )
integer x = 2482
integer y = 88
integer height = 188
integer taborder = 70
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor; of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(today(), today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 //of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type em_descripcion from editmask within w_pr501_atrib_prod_final_new
integer x = 256
integer y = 132
integer width = 663
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_origen from singlelineedit within w_pr501_atrib_prod_final_new
event dobleclick pbm_lbuttondblclk
integer x = 123
integer y = 128
integer width = 128
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT  cod_origen as codigo, " & 
		  +"nombre AS DESCRIPCION " &
		  + "FROM origen " &
		  + "WHERE flag_estado = '1' "
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
if ls_codigo <> '' then
	this.text = ls_codigo
	em_descripcion.text = ls_data
end if

end event

event modified;String 	ls_origen, ls_desc

ls_origen = this.text
if ls_origen = '' or IsNull(ls_origen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
	return
end if

SELECT nombre INTO :ls_desc
FROM origen
WHERE cod_origen =:ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

em_descripcion.text = ls_desc

end event

type gb_1 from groupbox within w_pr501_atrib_prod_final_new
integer x = 78
integer y = 68
integer width = 901
integer height = 180
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen"
end type

type gb_2 from groupbox within w_pr501_atrib_prod_final_new
integer x = 1010
integer y = 68
integer width = 1417
integer height = 180
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "OT_ADM"
end type

