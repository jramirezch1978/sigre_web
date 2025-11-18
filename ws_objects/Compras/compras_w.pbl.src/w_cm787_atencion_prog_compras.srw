$PBExportHeader$w_cm787_atencion_prog_compras.srw
forward
global type w_cm787_atencion_prog_compras from w_report_smpl
end type
type uo_fecha from u_ingreso_rango_fechas within w_cm787_atencion_prog_compras
end type
type cb_3 from commandbutton within w_cm787_atencion_prog_compras
end type
type cbx_usuario from checkbox within w_cm787_atencion_prog_compras
end type
type sle_usuario from singlelineedit within w_cm787_atencion_prog_compras
end type
type cbx_generados from checkbox within w_cm787_atencion_prog_compras
end type
type cbx_comprados from checkbox within w_cm787_atencion_prog_compras
end type
type cbx_atendidos from checkbox within w_cm787_atencion_prog_compras
end type
type gb_2 from groupbox within w_cm787_atencion_prog_compras
end type
end forward

global type w_cm787_atencion_prog_compras from w_report_smpl
integer width = 3241
integer height = 2808
string title = "Resumen de compras x usuario (CM767)"
string menuname = "m_impresion"
uo_fecha uo_fecha
cb_3 cb_3
cbx_usuario cbx_usuario
sle_usuario sle_usuario
cbx_generados cbx_generados
cbx_comprados cbx_comprados
cbx_atendidos cbx_atendidos
gb_2 gb_2
end type
global w_cm787_atencion_prog_compras w_cm787_atencion_prog_compras

type variables

end variables

on w_cm787_atencion_prog_compras.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.uo_fecha=create uo_fecha
this.cb_3=create cb_3
this.cbx_usuario=create cbx_usuario
this.sle_usuario=create sle_usuario
this.cbx_generados=create cbx_generados
this.cbx_comprados=create cbx_comprados
this.cbx_atendidos=create cbx_atendidos
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fecha
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.cbx_usuario
this.Control[iCurrent+4]=this.sle_usuario
this.Control[iCurrent+5]=this.cbx_generados
this.Control[iCurrent+6]=this.cbx_comprados
this.Control[iCurrent+7]=this.cbx_atendidos
this.Control[iCurrent+8]=this.gb_2
end on

on w_cm787_atencion_prog_compras.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fecha)
destroy(this.cb_3)
destroy(this.cbx_usuario)
destroy(this.sle_usuario)
destroy(this.cbx_generados)
destroy(this.cbx_comprados)
destroy(this.cbx_atendidos)
destroy(this.gb_2)
end on

event ue_retrieve;call super::ue_retrieve;String  	ls_usuario, ls_estado, ls_mensaje
Date 		ld_desde, ld_hasta

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

if cbx_usuario.checked = false then
	ls_usuario = '%%'
else
	ls_usuario = trim(sle_usuario.text) + '%'
end if

ls_estado = ''

if cbx_generados.checked = true then
	ls_estado += '1'
end if

if cbx_comprados.checked = true then
	ls_estado += '2'
end if

if cbx_atendidos.checked = true then
	ls_estado += '3'
end if

if len(ls_estado) = 0 then
	MessageBox('Aviso', 'Debe indicar algun estado')
	return
end if

//create or replace procedure USP_CMP_RPT_PROG_COMPRAS(
//       adi_fecha1       IN DATE,
//       adi_fecha2       IN DATE,
//       asi_usuario      IN usuario.cod_usr%TYPE,
//       asi_estado       IN VARCHAR2
//) IS

DECLARE 	USP_CMP_RPT_PROG_COMPRAS PROCEDURE FOR
			USP_CMP_RPT_PROG_COMPRAS( :ld_desde,
											  :ld_hasta,
											  :ls_usuario,
											  :ls_estado);

EXECUTE 	USP_CMP_RPT_PROG_COMPRAS;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_CMP_RPT_PROG_COMPRAS: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_CMP_RPT_PROG_COMPRAS;

idw_1.SetTransobject( SQLCA )
this.event ue_preview()
idw_1.Object.DataWindow.Print.Orientation = 2
idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))

idw_1.Retrieve()

idw_1.object.titulo_1.text 	= 'Del : ' & 
		+ STRING(ld_desde, "DD/MM/YYYY") + ' Al : ' &
		+ STRING(ld_hasta, "DD/MM/YYYY")		

idw_1.object.t_user.text 	  = gs_user
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text  = gs_empresa



end event

event ue_preview;call super::ue_preview;ib_preview = false
end event

event ue_open_pre;call super::ue_open_pre;sle_usuario.text = gs_user
end event

type dw_report from w_report_smpl`dw_report within w_cm787_atencion_prog_compras
integer x = 0
integer y = 320
integer width = 3003
integer height = 1532
string dataobject = "d_rpt_atencion_prog_compras_tbl"
end type

type uo_fecha from u_ingreso_rango_fechas within w_cm787_atencion_prog_compras
integer x = 14
integer y = 28
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_3 from commandbutton within w_cm787_atencion_prog_compras
integer x = 2546
integer y = 16
integer width = 402
integer height = 112
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;SetPointer(HourGlass!)
parent.Event ue_retrieve()
SetPointer(Arrow!)
end event

type cbx_usuario from checkbox within w_cm787_atencion_prog_compras
integer x = 1422
integer y = 28
integer width = 475
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar x Usuario"
end type

event clicked;if this.checked then
	sle_usuario.enabled = true
else
	sle_usuario.enabled = false
end if
end event

type sle_usuario from singlelineedit within w_cm787_atencion_prog_compras
event dobleclick pbm_lbuttondblclk
integer x = 1897
integer y = 28
integer width = 329
integer height = 80
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT distinct u.cod_usr AS CODIGO_usuario, " &
	  	 + "u.nombre AS nombre_usuario " &
	    + "FROM usuario u, " &
		 + "prog_compras pc " &
		 + "where pc.cod_usr = u.cod_usr " & 
		 + "and pc.flag_estado <> '0' " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
end if

end event

event modified;String 	ls_codigo, ls_data

ls_codigo = this.text
if ls_codigo = '' or IsNull(ls_codigo) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de origen')
	return
end if

SELECT nombre 
	INTO :ls_data
FROM origen
where cod_origen = :ls_codigo ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	this.text = ''
	return
end if


end event

type cbx_generados from checkbox within w_cm787_atencion_prog_compras
integer x = 87
integer y = 196
integer width = 361
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Generados"
boolean checked = true
end type

type cbx_comprados from checkbox within w_cm787_atencion_prog_compras
integer x = 457
integer y = 196
integer width = 361
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comprados"
end type

type cbx_atendidos from checkbox within w_cm787_atencion_prog_compras
integer x = 827
integer y = 196
integer width = 361
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Atendidos"
end type

type gb_2 from groupbox within w_cm787_atencion_prog_compras
integer x = 37
integer y = 128
integer width = 1198
integer height = 176
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estados del Prog Compras"
end type

