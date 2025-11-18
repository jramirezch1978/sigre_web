$PBExportHeader$w_sg520_tabla_modificaciones.srw
forward
global type w_sg520_tabla_modificaciones from w_cns_smpl
end type
type cb_1 from commandbutton within w_sg520_tabla_modificaciones
end type
type st_1 from statictext within w_sg520_tabla_modificaciones
end type
type uo_rango from u_ingreso_rango_fechas within w_sg520_tabla_modificaciones
end type
type ddlb_tabla from u_ddlb within w_sg520_tabla_modificaciones
end type
end forward

global type w_sg520_tabla_modificaciones from w_cns_smpl
integer width = 3122
integer height = 1664
string title = "Modificaciones a Tablas (SG520)"
string menuname = "m_cns_simple"
long backcolor = 12632256
cb_1 cb_1
st_1 st_1
uo_rango uo_rango
ddlb_tabla ddlb_tabla
end type
global w_sg520_tabla_modificaciones w_sg520_tabla_modificaciones

type variables
String	is_tabla
end variables

on w_sg520_tabla_modificaciones.create
int iCurrent
call super::create
if this.MenuName = "m_cns_simple" then this.MenuID = create m_cns_simple
this.cb_1=create cb_1
this.st_1=create st_1
this.uo_rango=create uo_rango
this.ddlb_tabla=create ddlb_tabla
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.uo_rango
this.Control[iCurrent+4]=this.ddlb_tabla
end on

on w_sg520_tabla_modificaciones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.uo_rango)
destroy(this.ddlb_tabla)
end on

event ue_retrieve;call super::ue_retrieve;String	ls_nombre
Date		ld_inicio, ld_fin
Long		ll_rc

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

ld_inicio = uo_rango.of_get_fecha1()
ld_fin = uo_rango.of_get_fecha2()

ll_rc = idw_1.Retrieve(is_tabla, ld_inicio, ld_fin )

//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text = gs_empresa
//idw_1.object.t_user.text = gs_user
//idw_1.object.t_objeto.text = 'SG720'
//idw_1.object.t_tabla.text = is_tabla
//idw_1.object.t_fechas.text = 'Desde: ' + String(ld_inicio) + ' Hasta: ' + String(ld_fin)

//// Leer nombre de usuario
//    SELECT "GRUPO"."DESCRIPCION"  
//    INTO :ls_nombre  
//    FROM "GRUPO"  
//   WHERE "GRUPO"."GRUPO" = :is_grupo   ;

end event

type dw_cns from w_cns_smpl`dw_cns within w_sg520_tabla_modificaciones
integer x = 9
integer y = 116
string dataobject = "d_tablas_modificaciones_tbl"
boolean vscrollbar = true
boolean hsplitscroll = true
boolean livescroll = false
end type

event dw_cns::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

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

event dw_cns::constructor;call super::constructor;ii_ck[1] = 1  
end event

type cb_1 from commandbutton within w_sg520_tabla_modificaciones
integer x = 2583
integer y = 16
integer width = 325
integer height = 88
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

type st_1 from statictext within w_sg520_tabla_modificaciones
integer x = 9
integer y = 16
integer width = 297
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean enabled = false
string text = "Tabla:"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_rango from u_ingreso_rango_fechas within w_sg520_tabla_modificaciones
integer x = 1262
integer y = 16
integer taborder = 30
boolean bringtotop = true
long backcolor = 12632256
end type

on uo_rango.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; Date	ld_inicio
 
 ld_inicio = RelativeDate (Today(), -7)
 
 of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
 of_set_fecha(ld_inicio, Today()) //para setear la fecha inicial
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final
 


end event

type ddlb_tabla from u_ddlb within w_sg520_tabla_modificaciones
integer x = 343
integer y = 16
integer width = 878
integer height = 780
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
end type

event ue_open_pre;call super::ue_open_pre;is_dataobject = 'd_tablas_modificadas_lista'

ii_cn1 = 1                     // Nro del campo 1
ii_cn2 = 0                     // Nro del campo 2
ii_ck  = 1                     // Nro del campo key
ii_lc1 = 30                     // Longitud del campo 1
ii_lc2 = 0							// Longitud del campo 2

end event

event ue_output;call super::ue_output;is_tabla = aa_key
end event

