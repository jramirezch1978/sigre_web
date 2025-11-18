$PBExportHeader$w_ope701_orden_trabajo.srw
forward
global type w_ope701_orden_trabajo from w_rpt
end type
type cb_4 from commandbutton within w_ope701_orden_trabajo
end type
type cbx_6 from checkbox within w_ope701_orden_trabajo
end type
type cbx_5 from checkbox within w_ope701_orden_trabajo
end type
type cb_3 from commandbutton within w_ope701_orden_trabajo
end type
type uo_1 from u_ingreso_rango_fechas within w_ope701_orden_trabajo
end type
type dw_report from u_dw_rpt within w_ope701_orden_trabajo
end type
type rb_2 from radiobutton within w_ope701_orden_trabajo
end type
type rb_1 from radiobutton within w_ope701_orden_trabajo
end type
type cb_2 from commandbutton within w_ope701_orden_trabajo
end type
type cb_1 from commandbutton within w_ope701_orden_trabajo
end type
type cbx_4 from checkbox within w_ope701_orden_trabajo
end type
type cbx_3 from checkbox within w_ope701_orden_trabajo
end type
type cbx_2 from checkbox within w_ope701_orden_trabajo
end type
type cbx_1 from checkbox within w_ope701_orden_trabajo
end type
type gb_1 from groupbox within w_ope701_orden_trabajo
end type
type gb_2 from groupbox within w_ope701_orden_trabajo
end type
type gb_3 from groupbox within w_ope701_orden_trabajo
end type
end forward

global type w_ope701_orden_trabajo from w_rpt
integer width = 3538
integer height = 2012
string title = "Listado de Ordenes de Trabajo (OPE701)"
string menuname = "m_rpt_smpl"
long backcolor = 67108864
cb_4 cb_4
cbx_6 cbx_6
cbx_5 cbx_5
cb_3 cb_3
uo_1 uo_1
dw_report dw_report
rb_2 rb_2
rb_1 rb_1
cb_2 cb_2
cb_1 cb_1
cbx_4 cbx_4
cbx_3 cbx_3
cbx_2 cbx_2
cbx_1 cbx_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_ope701_orden_trabajo w_ope701_orden_trabajo

forward prototypes
public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final)
end prototypes

public subroutine wf_genera_cc_sol (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_slc PROCEDURE FOR usp_ope_orden_trabajo_slc
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_slc;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_slc ;
end subroutine

public subroutine wf_genera_cc_rsp (string as_tipo, date ad_fecha_inicio, date ad_fecha_final);DECLARE PB_usp_ope_orden_trabajo_rsp PROCEDURE FOR usp_ope_orden_trabajo_rsp
(:as_tipo,:ad_fecha_inicio,:ad_fecha_final);
EXECUTE PB_usp_ope_orden_trabajo_rsp;


IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF


CLOSE PB_usp_ope_orden_trabajo_rsp ;
end subroutine

on w_ope701_orden_trabajo.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_4=create cb_4
this.cbx_6=create cbx_6
this.cbx_5=create cbx_5
this.cb_3=create cb_3
this.uo_1=create uo_1
this.dw_report=create dw_report
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.cbx_4=create cbx_4
this.cbx_3=create cbx_3
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.cbx_6
this.Control[iCurrent+3]=this.cbx_5
this.Control[iCurrent+4]=this.cb_3
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.dw_report
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.cbx_4
this.Control[iCurrent+12]=this.cbx_3
this.Control[iCurrent+13]=this.cbx_2
this.Control[iCurrent+14]=this.cbx_1
this.Control[iCurrent+15]=this.gb_1
this.Control[iCurrent+16]=this.gb_2
this.Control[iCurrent+17]=this.gb_3
end on

on w_ope701_orden_trabajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_4)
destroy(this.cbx_6)
destroy(this.cbx_5)
destroy(this.cb_3)
destroy(this.uo_1)
destroy(this.dw_report)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.cbx_4)
destroy(this.cbx_3)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report
idw_1.SetTransObject(sqlca)

idw_1.ii_zoom_actual = 80
THIS.Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic

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

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cb_4 from commandbutton within w_ope701_orden_trabajo
integer x = 3054
integer y = 252
integer width = 434
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cliente"
end type

event clicked;
Long ll_count
str_parametros sl_param 


delete from tt_fin_proveedor;

sl_param.dw1		= 'd_abc_lista_crelacion_x_ot_tbl'
sl_param.titulo	= 'Clientes'
sl_param.opcion   = 21
sl_param.db1 		= 1600
sl_param.string1 	= '1CLI'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cbx_6 from checkbox within w_ope701_orden_trabajo
integer x = 837
integer y = 356
integer width = 846
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las OT Con o Sin Cliente"
end type

type cbx_5 from checkbox within w_ope701_orden_trabajo
integer x = 837
integer y = 268
integer width = 846
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todas las OT Con o Sin Maquina"
end type

type cb_3 from commandbutton within w_ope701_orden_trabajo
integer x = 3054
integer y = 144
integer width = 434
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Maquina"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_ope_maquina ;

sl_param.dw1		= 'd_abc_lista_maquina_tbl'
sl_param.titulo	= 'Maquinas'
sl_param.opcion   = 20
sl_param.db1 		= 1600
sl_param.string1 	= '1MAQ'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type uo_1 from u_ingreso_rango_fechas within w_ope701_orden_trabajo
integer x = 837
integer y = 92
integer taborder = 40
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_report from u_dw_rpt within w_ope701_orden_trabajo
integer x = 18
integer y = 536
integer width = 3465
integer height = 1212
integer taborder = 40
string dataobject = "d_cons_ord_tra_sol"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type rb_2 from radiobutton within w_ope701_orden_trabajo
integer x = 2213
integer y = 136
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Responsable"
end type

type rb_1 from radiobutton within w_ope701_orden_trabajo
integer x = 2213
integer y = 44
integer width = 768
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Centro de Costo Solicitante"
end type

type cb_2 from commandbutton within w_ope701_orden_trabajo
integer x = 3054
integer y = 360
integer width = 434
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_cadena []
String ls_flag_tipo
Long   ll_count,ll_count_arr
Date   ld_fecha_inicio,ld_fecha_final

//estados de la solicitud ot
IF cbx_1.checked THEN //ANULADO
	ls_cadena [1] = '0'
END IF

IF cbx_2.checked THEN //ACTIVO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '1'
END IF

IF cbx_3.checked THEN //CERRADO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '2'
END IF

IF cbx_4.checked THEN //PROYECTADO
	ll_count_arr = UpperBound(ls_cadena)
	ls_cadena [ll_count_arr + 1] = '3'
END IF


IF UpperBound(ls_cadena) = 0 THEN
	Messagebox('Aviso','Debe Seleccionar algun Estado de la Orden Trabajo')
	Return
END IF




//Seleccionar centro de costo
select count(*) 
	into :ll_count 
from tt_ope_cencos ;

IF ll_count = 0 THEN
	Messagebox('Aviso','Debe Seleccionar algun Centro de Costo , Verifique!')
	Return
END IF

//rango de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

//reporte x casos
//cbx_5
//Todas las OT Con o Sin Maquina
//cbx_6
//Todas las OT Con o Sin Cliente

IF Not (cbx_5.checked)  OR Not (cbx_6.checked)THEN  //ALGUNA OPCION ES FALSA
	
   IF Not (cbx_5.checked) AND Not(cbx_6.checked) THEN //LAS DOS OPCIONES SE ENCUENTRAN EN FALSO
		//Todas las OT con maquina y cliente seleccionados
		ls_flag_tipo = '2' 
		/*verificar que han ingresado maquinas y clientes*/
		//maquinas
		select count(*) into :ll_count from tt_ope_maquina   ;
		
		IF ll_count = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Alguna Maquina ,Verifique!')
			Return
		END IF
		
		//clientes
		select count(*) into :ll_count from tt_fin_proveedor ;

		IF ll_count = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Alguna Cliente ,Verifique!')
			Return
		END IF

	ELSEIF Not(cbx_5.checked) THEN  //
		//Todas las OT Con maquinas seleccionadas ,con o sin clientes
		ls_flag_tipo = '3' 
		//maquinas
		select count(*) into :ll_count from tt_ope_maquina   ;
		
		IF ll_count = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Alguna Maquina ,Verifique!')
			Return
		END IF
		
	ELSEIF Not(cbx_6.checked) THEN
		//Todas las OT Con Clientes seleccionadas ,con o sin maquinas
		ls_flag_tipo = '4' 
		
		//clientes
		select count(*) into :ll_count from tt_fin_proveedor ;

		IF ll_count = 0 THEN
			Messagebox('Aviso','Debe Seleccionar Alguna Cliente ,Verifique!')
			Return
		END IF

		
	END IF
ELSE
	ls_flag_tipo = '1' //Todas las OT  CON O SIN MAQUINAS,CLIENTES
END IF

IF rb_1.checked THEN     // Solicitante
	dw_report.dataobject = 'd_cons_ord_tra_sol'
	wf_genera_cc_sol(ls_flag_tipo,ld_fecha_inicio,ld_fecha_final)
ELSEIF rb_2.checked THEN // Responsable
	dw_report.dataobject = 'd_cons_ord_tra_rsp'
	wf_genera_cc_rsp(ls_flag_tipo,ld_fecha_inicio,ld_fecha_final)
END IF


dw_report.Settransobject(sqlca)
dw_report.ii_zoom_actual = 100
ib_preview = FALSE
Parent.TriggerEvent('ue_preview')

//EJECUTO PROCEDIMIENTO




dw_report.retrieve(ls_cadena,ld_fecha_inicio,ld_fecha_final,gs_empresa,gs_user)
dw_report.Object.p_logo.filename = gs_logo

Rollback ;
end event

type cb_1 from commandbutton within w_ope701_orden_trabajo
integer x = 3054
integer y = 36
integer width = 434
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Centro de Costo"
end type

event clicked;Long ll_count
str_parametros sl_param 


delete from tt_ope_cencos ;

sl_param.dw1		= 'd_abc_lista_cencos_tbl'
sl_param.titulo	= 'Centros de Costo'
sl_param.opcion   = 19
sl_param.db1 		= 1600
sl_param.string1 	= '1CCOS'



OpenWithParm( w_abc_seleccion_lista_search, sl_param)

end event

type cbx_4 from checkbox within w_ope701_orden_trabajo
integer x = 64
integer y = 324
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Proyectado"
end type

type cbx_3 from checkbox within w_ope701_orden_trabajo
integer x = 64
integer y = 256
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cerrado"
end type

type cbx_2 from checkbox within w_ope701_orden_trabajo
integer x = 64
integer y = 176
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Activo"
end type

type cbx_1 from checkbox within w_ope701_orden_trabajo
integer x = 64
integer y = 96
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anulado"
end type

type gb_1 from groupbox within w_ope701_orden_trabajo
integer x = 18
integer y = 20
integer width = 768
integer height = 424
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Estados de la Orden Trabajo"
end type

type gb_2 from groupbox within w_ope701_orden_trabajo
integer x = 795
integer y = 20
integer width = 1371
integer height = 192
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas"
end type

type gb_3 from groupbox within w_ope701_orden_trabajo
integer x = 795
integer y = 220
integer width = 919
integer height = 224
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

