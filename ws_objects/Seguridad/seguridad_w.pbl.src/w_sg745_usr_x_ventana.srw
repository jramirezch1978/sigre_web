$PBExportHeader$w_sg745_usr_x_ventana.srw
forward
global type w_sg745_usr_x_ventana from w_report_smpl
end type
type cb_1 from commandbutton within w_sg745_usr_x_ventana
end type
type uo_fecha from u_ingreso_rango_fechas within w_sg745_usr_x_ventana
end type
type sle_ventana from singlelineedit within w_sg745_usr_x_ventana
end type
type st_1 from statictext within w_sg745_usr_x_ventana
end type
end forward

global type w_sg745_usr_x_ventana from w_report_smpl
integer width = 2898
integer height = 1804
string title = "Accesos x Ventana (SG745)"
string menuname = "m_rpt_simple"
long backcolor = 67108864
cb_1 cb_1
uo_fecha uo_fecha
sle_ventana sle_ventana
st_1 st_1
end type
global w_sg745_usr_x_ventana w_sg745_usr_x_ventana

type variables

end variables

on w_sg745_usr_x_ventana.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.sle_ventana=create sle_ventana
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.sle_ventana
this.Control[iCurrent+4]=this.st_1
end on

on w_sg745_usr_x_ventana.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.sle_ventana)
destroy(this.st_1)
end on

event ue_retrieve;call super::ue_retrieve;Date	ld_inicial, ld_final
String	ls_texto

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

ld_inicial = uo_fecha.of_get_fecha1()
ld_final   = uo_fecha.of_get_fecha2()

ls_texto = '__' + sle_ventana.text + '%'

idw_1.Retrieve(ls_texto, ld_inicial, ld_final)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'SIG745'
idw_1.object.t_subtitulo.text = 'del: ' + String(ld_inicial, 'dd/mm/yy') + ' al: ' + String(ld_final, 'dd/mm/yy')
end event

type dw_report from w_report_smpl`dw_report within w_sg745_usr_x_ventana
integer x = 14
integer y = 140
string dataobject = "d_acceso_usr_obj_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

String		ls_tipo_doc
STR_CNS_POP lstr_1

CHOOSE CASE dwo.Name
	CASE "cant_pendiente" 
		lstr_1.DataObject = 'd_articulo_mov_tbl'
		lstr_1.Width = 1700
		lstr_1.Height= 1000
		lstr_1.Arg[1] = GetItemString(row,'cod_origen')
		lstr_1.Arg[2] = String(GetItemNumber(row,'nro_mov'))
		lstr_1.Title = 'Movimientos Relacionados'
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
	CASE "nro_doc"
		ls_tipo_doc = TRIM(GetItemString(row,'tipo_doc'))	
		CHOOSE CASE ls_tipo_doc
			CASE 'OT'
				lstr_1.DataObject = 'd_orden_trabajo_oper_sec_ff'
				lstr_1.Width = 2000
				lstr_1.Height= 1800
				lstr_1.Arg[1] = GetItemString(row,'nro_doc')
				lstr_1.Arg[2] = GetItemString(row,'oper_sec')
				lstr_1.Title = 'Orden de Trabajo'
			CASE 'SC'
				lstr_1.DataObject = 'd_sol_compra_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1200
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Compra'
			CASE 'SL'
				lstr_1.DataObject = 'd_solicitud_salida_ff'
				lstr_1.Width = 2100
				lstr_1.Height= 800
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Solicitud de Salida'
			CASE 'OC'
				lstr_1.DataObject = 'd_orden_compra_ff'
				lstr_1.Width = 2400
				lstr_1.Height= 1300
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Compra'
			CASE 'OV'
				lstr_1.DataObject = 'd_orden_venta_ff'
				lstr_1.Width = 2300
				lstr_1.Height= 1500
				lstr_1.Arg[1] = GetItemString(row,'cod_origen')
				lstr_1.Arg[2] = GetItemString(row,'nro_doc')
				lstr_1.Title = 'Orden de Venta'
		END CHOOSE
		lstr_1.Tipo_Cascada = 'C'
		of_new_sheet(lstr_1)
END CHOOSE

end event

type cb_1 from commandbutton within w_sg745_usr_x_ventana
integer x = 2048
integer y = 24
integer width = 238
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;PARENT.Event ue_retrieve()
end event

type uo_fecha from u_ingreso_rango_fechas within w_sg745_usr_x_ventana
event destroy ( )
integer x = 27
integer y = 20
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; Date	ld_fecha
 String	st_fecha
 
 st_fecha = '01/01/' + String(year(today()))
 
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(Date(st_fecha), Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final


end event

type sle_ventana from singlelineedit within w_sg745_usr_x_ventana
integer x = 1353
integer y = 24
integer width = 261
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sg745_usr_x_ventana
integer x = 1641
integer y = 32
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ejem:  cm750"
boolean focusrectangle = false
end type

