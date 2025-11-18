$PBExportHeader$w_pr712_insumos_fechas_tbl.srw
forward
global type w_pr712_insumos_fechas_tbl from w_rpt
end type
type dw_report from u_dw_rpt within w_pr712_insumos_fechas_tbl
end type
type uo_fecha from u_ingreso_rango_fechas within w_pr712_insumos_fechas_tbl
end type
type pb_1 from picturebutton within w_pr712_insumos_fechas_tbl
end type
type em_origen from singlelineedit within w_pr712_insumos_fechas_tbl
end type
type em_descripcion from editmask within w_pr712_insumos_fechas_tbl
end type
type st_ot_adm from statictext within w_pr712_insumos_fechas_tbl
end type
type sle_ot_adm from sle_text within w_pr712_insumos_fechas_tbl
end type
type gb_1 from groupbox within w_pr712_insumos_fechas_tbl
end type
type gb_2 from groupbox within w_pr712_insumos_fechas_tbl
end type
type gb_3 from groupbox within w_pr712_insumos_fechas_tbl
end type
end forward

global type w_pr712_insumos_fechas_tbl from w_rpt
integer width = 3150
integer height = 2232
string title = "Relación de Insumos(PR712)"
long backcolor = 67108864
dw_report dw_report
uo_fecha uo_fecha
pb_1 pb_1
em_origen em_origen
em_descripcion em_descripcion
st_ot_adm st_ot_adm
sle_ot_adm sle_ot_adm
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_pr712_insumos_fechas_tbl w_pr712_insumos_fechas_tbl

on w_pr712_insumos_fechas_tbl.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.uo_fecha=create uo_fecha
this.pb_1=create pb_1
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.st_ot_adm=create st_ot_adm
this.sle_ot_adm=create sle_ot_adm
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.em_origen
this.Control[iCurrent+5]=this.em_descripcion
this.Control[iCurrent+6]=this.st_ot_adm
this.Control[iCurrent+7]=this.sle_ot_adm
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_pr712_insumos_fechas_tbl.destroy
call super::destroy
destroy(this.dw_report)
destroy(this.uo_fecha)
destroy(this.pb_1)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.st_ot_adm)
destroy(this.sle_ot_adm)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event open;call super::open;IF this.of_access(gs_user, THIS.ClassName()) THEN 
	THIS.EVENT ue_open_pre()
ELSE
	CLOSE(THIS)
END IF
end event

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.Visible = False
idw_1.SetTransObject(sqlca)
//THIS.Event ue_preview()
//This.Event ue_retrieve()
IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

 ii_help = 101           // help topic
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_retrieve;call super::ue_retrieve;Date		ld_fecha1, ld_fecha2
string	ls_ot_adm, ls_origen, ls_desc_ot, ls_desc_origen

ld_fecha1 		= uo_fecha.of_get_fecha1( )
ld_fecha2 		= uo_fecha.of_get_fecha2( )
ls_ot_adm		= sle_ot_adm.Text
ls_origen		= em_origen.Text
ls_desc_ot		= st_ot_adm.text
ls_desc_origen = em_descripcion.text

if ld_fecha2 < ld_fecha1 then
	MessageBox('PRODUCCION', 'RANGO DE FECHAS INVALIDO, POR FAVOR VERIFIQUE', StopSign!)
	return
end if

if ls_ot_adm = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'DEBE SELECCIONAR UNA OT_ADM, POR FAVOR VERFIQUE', StopSign!)
	return
end if

if ls_origen = '' or IsNull(ls_ot_adm) then
	MessageBox('PRODUCCION', 'DEBE UN ORIGEN, POR FAVOR VERFIQUE', StopSign!)
	return
end if

idw_1.Retrieve(ls_ot_adm, ls_origen, ld_fecha1, ld_fecha2)
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.usuario_t.text  = gs_user
idw_1.Object.t_desc_ot_adm.text  = ls_desc_ot
idw_1.Object.t_desc_origen.text  = ls_desc_origen

idw_1.Visible = True

end event

type dw_report from u_dw_rpt within w_pr712_insumos_fechas_tbl
integer x = 46
integer y = 388
integer width = 2505
integer height = 1416
integer taborder = 20
string dataobject = "d_rpt_ot_costo_insumo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type uo_fecha from u_ingreso_rango_fechas within w_pr712_insumos_fechas_tbl
event destroy ( )
integer x = 64
integer y = 64
integer width = 1312
integer taborder = 50
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;date 		ld_fecha1, ld_fecha2
Integer 	li_ano, li_mes

of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/1900'), date('31/12/9999') ) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

li_ano = Year(Today())
li_mes = Month(Today())

if li_mes = 12 then
	li_mes = 1
	li_ano ++
else
	li_mes ++
end if

ld_fecha1 = date('01/' + String( month( today() ) ,'00' ) &
	+ '/' + string( year( today() ), '0000') )

ld_fecha2 = date('01/' + String( li_mes ,'00' ) &
	+ '/' + string(li_ano, '0000') )
ld_fecha2 = RelativeDate( ld_fecha2, -1 )

This.of_set_fecha( ld_fecha1, ld_fecha2 )
end event

type pb_1 from picturebutton within w_pr712_insumos_fechas_tbl
integer x = 2555
integer y = 96
integer width = 315
integer height = 180
integer taborder = 40
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

type em_origen from singlelineedit within w_pr712_insumos_fechas_tbl
event dobleclick pbm_lbuttondblclk
integer x = 1490
integer y = 152
integer width = 206
integer height = 72
integer taborder = 30
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

type em_descripcion from editmask within w_pr712_insumos_fechas_tbl
integer x = 1691
integer y = 152
integer width = 809
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 134217739
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_ot_adm from statictext within w_pr712_insumos_fechas_tbl
integer x = 357
integer y = 228
integer width = 1024
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217729
long backcolor = 134217739
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_ot_adm from sle_text within w_pr712_insumos_fechas_tbl
integer x = 73
integer y = 232
integer width = 270
integer height = 72
integer taborder = 10
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
	//st_ot_adm.text = ""
	parent.event dynamic ue_reset( )
	return
end if
		
//st_ot_adm.text = ls_data

parent.event dynamic ue_retrieve()

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
	st_ot_adm.Text = ls_data
end if


end event

type gb_1 from groupbox within w_pr712_insumos_fechas_tbl
integer x = 41
integer y = 176
integer width = 1399
integer height = 156
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "OT. Adm."
end type

type gb_2 from groupbox within w_pr712_insumos_fechas_tbl
integer x = 1445
integer y = 92
integer width = 1093
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = " Seleccione Origen "
end type

type gb_3 from groupbox within w_pr712_insumos_fechas_tbl
integer x = 37
integer y = 8
integer width = 1399
integer height = 164
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Rango de Fechas"
end type

