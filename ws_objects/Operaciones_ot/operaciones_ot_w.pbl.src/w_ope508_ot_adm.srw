$PBExportHeader$w_ope508_ot_adm.srw
forward
global type w_ope508_ot_adm from w_abc
end type
type em_codigo from editmask within w_ope508_ot_adm
end type
type st_2 from statictext within w_ope508_ot_adm
end type
type pb_1 from picturebutton within w_ope508_ot_adm
end type
type uo_fecha from u_ingreso_rango_fechas within w_ope508_ot_adm
end type
type cb_1 from commandbutton within w_ope508_ot_adm
end type
type st_1 from statictext within w_ope508_ot_adm
end type
type tab_1 from tab within w_ope508_ot_adm
end type
type tabpage_1 from userobject within tab_1
end type
type st_3 from statictext within tabpage_1
end type
type dw_detail from u_dw_cns within tabpage_1
end type
type dw_master from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_3 st_3
dw_detail dw_detail
dw_master dw_master
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_cns within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_dw_cns within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from u_dw_cns within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tab_1 from tab within w_ope508_ot_adm
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type gb_2 from groupbox within w_ope508_ot_adm
end type
end forward

global type w_ope508_ot_adm from w_abc
integer width = 3817
integer height = 2228
string title = "[OPE508] Consulta por Administrador de OT"
string menuname = "m_cns"
em_codigo em_codigo
st_2 st_2
pb_1 pb_1
uo_fecha uo_fecha
cb_1 cb_1
st_1 st_1
tab_1 tab_1
gb_2 gb_2
end type
global w_ope508_ot_adm w_ope508_ot_adm

type variables
String 	is_plantilla, is_col, is_data_type, is_doc_ot, &
			is_accion, is_ot_adm, is_cod_plant, is_flag_cnta_prsp, &
			is_dolares,	is_seccion_def,is_tip_seccion, is_articulo
Integer ii_ik[]			
DatawindowChild idw_child

u_dw_abc idw_det_ot, idw_det_op, idw_det_art, &
			idw_ot_distribucion, idw_oper_ingresos, idw_ingresos_art, &
			idw_oper_lista_ingreso, idw_lista_op, idw_lista_sol, idw_otros_gastos

DataWindow  idw_lanza_plant, idw_oper_dep, idw_plantilla

// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_d, is_colname_d[], is_coltype_d[], &
			is_tabla_op, is_colname_op[], is_coltype_op[]
			
n_cst_log_diario2	in_log

//Datawindowchild idw_child_und, idw_child_und2
//String  is_col = 'cod_labor', is_flag_Cnta_prsp
//Integer ii_ik[]
//str_parametros ist_datos
end variables

forward prototypes
public subroutine wf_retrieve_dw (string as_nro_labor)
public subroutine of_get_orden (string as_orden)
end prototypes

public subroutine wf_retrieve_dw (string as_nro_labor);///*********************************************************************/
///* Función de Ventana de Recuperación de datos de la Labor*/
///*********************************************************************/
//Long ll_row, ll_oper_sec
//String ls_cod_labor,ls_ot_adm
//dwobject dwo
//
//
//SELECT cod_labor 
//  INTO :ls_cod_labor
//  FROM labor 
// WHERE cod_labor=:as_nro_labor ;
//
//is_accion = 'fileopen'
//
end subroutine

public subroutine of_get_orden (string as_orden);Date ld_fecha_desde, ld_fecha_hasta
String ls_oper_cons_interno, ls_doc_ot
Long ll_count

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()

If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

select count(*) into :ll_count from ot_administracion ot where ot_adm = :as_orden ;

if ll_count = 0 then
	Messagebox( "Error", "Administrador de no existe")		
	Return
end if

SELECT l.oper_cons_interno, l.doc_ot 
  INTO :ls_oper_cons_interno, :ls_doc_ot 
  FROM logparam l 
 WHERE l.reckey='1' ;

//is_articulo = as_orden

tab_1.SelectTab(1)

tab_1.tabpage_1.dw_master.Retrieve(as_orden)
tab_1.tabpage_1.dw_detail.Retrieve(as_orden)
tab_1.tabpage_2.dw_2.Retrieve(as_orden, ld_fecha_desde, ld_fecha_hasta) 
tab_1.tabpage_3.dw_3.Retrieve(as_orden)
tab_1.tabpage_4.dw_4.Retrieve(as_orden, ls_oper_cons_interno, ls_doc_ot)

end subroutine

on w_ope508_ot_adm.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.em_codigo=create em_codigo
this.st_2=create st_2
this.pb_1=create pb_1
this.uo_fecha=create uo_fecha
this.cb_1=create cb_1
this.st_1=create st_1
this.tab_1=create tab_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.em_codigo
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_ope508_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.em_codigo)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.uo_fecha)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.gb_2)
end on

event open;call super::open;// Ancestor Script has been Override
//of_asignar_dws() aqui

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF


//Abrir y recuperar (necesita parametros)
str_parametros sl_param
sl_param = Message.PowerObjectParm

String ls_nro_ot
Long ll_row, ll_operacion

	
	
	wf_retrieve_dw(ls_nro_ot)


	TriggerEvent ('ue_modify')

	//Dirigirse al tab de Operaciones
	tab_1.SelectedTab = 2
	
	
	IF ll_row = 0 Then Return
	
	idw_1.Event ue_output(ll_row)
	
	

end event

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse

tab_1.tabpage_1.dw_master.SetTransObject(sqlca)
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_4.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_master.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_lista_op.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_det_op.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_det_art.SetTransObject(sqlca)


idw_query = tab_1.tabpage_1.dw_master

//wf_reset_dw()
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

type em_codigo from editmask within w_ope508_ot_adm
integer x = 311
integer y = 36
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!"
end type

type st_2 from statictext within w_ope508_ot_adm
integer x = 55
integer y = 160
integer width = 1175
integer height = 72
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope508_ot_adm
integer x = 690
integer y = 40
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Search!"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT OT_ADMINISTRACION.OT_ADM AS CODIGO , '&
								       +'OT_ADMINISTRACION.DESCRIPCION AS DESCRIPCION '&
				   				 	 +'FROM OT_ADMINISTRACION '
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	em_codigo.text = lstr_seleccionar.param1[1]
	st_2.text = lstr_seleccionar.param2[1]
END IF														 

end event

type uo_fecha from u_ingreso_rango_fechas within w_ope508_ot_adm
integer x = 1275
integer y = 92
integer taborder = 50
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(today(), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type cb_1 from commandbutton within w_ope508_ot_adm
integer x = 2679
integer y = 68
integer width = 302
integer height = 104
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_cod

ls_cod = TRIM(em_codigo.text)

of_get_orden( ls_cod )
end event

type st_1 from statictext within w_ope508_ot_adm
integer x = 46
integer y = 52
integer width = 247
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT_ADM :"
boolean focusrectangle = false
end type

type tab_1 from tab within w_ope508_ot_adm
integer x = 41
integer y = 268
integer width = 2898
integer height = 1736
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Datos Generales "
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_3 st_3
dw_detail dw_detail
dw_master dw_master
end type

on tabpage_1.create
this.st_3=create st_3
this.dw_detail=create dw_detail
this.dw_master=create dw_master
this.Control[]={this.st_3,&
this.dw_detail,&
this.dw_master}
end on

on tabpage_1.destroy
destroy(this.st_3)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

type st_3 from statictext within tabpage_1
integer x = 361
integer y = 560
integer width = 1838
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 67108864
long backcolor = 8388608
string text = "USUARIOS POR OT_ADM"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail from u_dw_cns within tabpage_1
integer x = 41
integer y = 652
integer width = 2793
integer height = 916
integer taborder = 20
string dataobject = "d_cns_ot_adm_usuario_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_cns within tabpage_1
integer x = 18
integer y = 60
integer width = 2839
integer height = 464
integer taborder = 20
string dataobject = "d_cns_ot_adm_ff"
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Ordenes de trabajo"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_cns within tabpage_2
integer x = 69
integer y = 48
integer width = 2734
integer height = 1496
integer taborder = 20
string dataobject = "d_cns_orden_trab_x_ot_adm"
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Plantillas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw_cns within tabpage_3
integer x = 14
integer y = 44
integer width = 2821
integer height = 1500
integer taborder = 20
string dataobject = "d_lista_plantilla_x_otadm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Requerimientos pendientes aprobados"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from u_dw_cns within tabpage_4
integer x = 55
integer y = 32
integer width = 2761
integer height = 1528
integer taborder = 20
string dataobject = "d_cns_pendientes_ot_x_otadm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event getfocus;call super::getfocus;idw_query.BorderStyle = StyleRaised!
idw_query = THIS
idw_query.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

 ii_ck[1] = 1         // columnas de lectrua de este dw
 ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

type gb_2 from groupbox within w_ope508_ot_adm
integer x = 1234
integer y = 20
integer width = 1371
integer height = 192
integer taborder = 40
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

