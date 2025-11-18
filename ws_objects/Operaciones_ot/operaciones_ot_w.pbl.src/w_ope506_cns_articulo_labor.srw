$PBExportHeader$w_ope506_cns_articulo_labor.srw
forward
global type w_ope506_cns_articulo_labor from w_abc
end type
type st_2 from statictext within w_ope506_cns_articulo_labor
end type
type sle_codigo from singlelineedit within w_ope506_cns_articulo_labor
end type
type pb_1 from picturebutton within w_ope506_cns_articulo_labor
end type
type st_1 from statictext within w_ope506_cns_articulo_labor
end type
type cb_1 from commandbutton within w_ope506_cns_articulo_labor
end type
type uo_fecha from u_ingreso_rango_fechas within w_ope506_cns_articulo_labor
end type
type tab_1 from tab within w_ope506_cns_articulo_labor
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_cns within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
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
type tab_1 from tab within w_ope506_cns_articulo_labor
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type gb_2 from groupbox within w_ope506_cns_articulo_labor
end type
end forward

global type w_ope506_cns_articulo_labor from w_abc
integer width = 3113
integer height = 2160
string title = "Consulta de Articulo [OPE506]"
string menuname = "m_cns"
st_2 st_2
sle_codigo sle_codigo
pb_1 pb_1
st_1 st_1
cb_1 cb_1
uo_fecha uo_fecha
tab_1 tab_1
gb_2 gb_2
end type
global w_ope506_cns_articulo_labor w_ope506_cns_articulo_labor

type variables
String 	is_plantilla, is_col, is_data_type, is_doc_ot, &
			is_accion, is_ot_adm, is_cod_plant, is_flag_cnta_prsp, &
			is_dolares,	is_seccion_def,is_tip_seccion, is_articulo
			
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
end variables

forward prototypes
public subroutine of_get_orden (string as_codigo)
public subroutine wf_retrieve_dw (string as_articulo)
end prototypes

public subroutine of_get_orden (string as_codigo);Date ld_fecha_desde, ld_fecha_hasta
Long ll_count

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()

If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

Select count(cod_art) into :ll_count from labor_insumo where cod_art = :as_codigo;

if ll_count = 0 then
	Messagebox( "Error", "Codigo no existe")		
	Return
end if

is_articulo = as_codigo

tab_1.SelectTab(1)
tab_1.tabpage_1.dw_1.Retrieve(as_codigo)
tab_1.tabpage_2.dw_2.Retrieve(as_codigo)
tab_1.tabpage_3.dw_3.Retrieve(as_codigo,ld_fecha_desde,ld_fecha_hasta)
tab_1.tabpage_4.dw_4.Retrieve(as_codigo,ld_fecha_desde,ld_fecha_hasta)
//tab_1.tabpage_2.dw_master.Retrieve(as_orden)
//tab_1.tabpage_2.dw_lista_op.Retrieve(as_orden)
//tab_1.tabpage_2.dw_det_op.Retrieve(as_orden)
//tab_1.tabpage_2.dw_det_art.Retrieve(as_orden)


//il_tab2 = 0
//il_tab3 = 0
//il_tab4 = 0
//il_tab5 = 0
end subroutine

public subroutine wf_retrieve_dw (string as_articulo);/*********************************************************************/
/* Función de Ventana de Recuperación de datos */
/*********************************************************************/
Long ll_row, ll_oper_sec
String ls_cod_labor,ls_ot_adm
dwobject dwo


SELECT cod_art 
  INTO :ls_cod_labor
  FROM labor_insumo 
 WHERE cod_labor=:as_articulo ;

is_accion = 'fileopen'
end subroutine

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

on w_ope506_cns_articulo_labor.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_2=create st_2
this.sle_codigo=create sle_codigo
this.pb_1=create pb_1
this.st_1=create st_1
this.cb_1=create cb_1
this.uo_fecha=create uo_fecha
this.tab_1=create tab_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_codigo
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.uo_fecha
this.Control[iCurrent+7]=this.tab_1
this.Control[iCurrent+8]=this.gb_2
end on

on w_ope506_cns_articulo_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_codigo)
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.uo_fecha)
destroy(this.tab_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_rc

im_1 = CREATE m_rButton      				// crear menu de boton derecho del mouse

tab_1.tabpage_1.dw_1.SetTransObject(sqlca)
tab_1.tabpage_2.dw_2.SetTransObject(sqlca)
tab_1.tabpage_3.dw_3.SetTransObject(sqlca)
tab_1.tabpage_4.dw_4.SetTransObject(sqlca)


idw_query = tab_1.tabpage_1.dw_1

//wf_reset_dw()
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

type st_2 from statictext within w_ope506_cns_articulo_labor
integer x = 69
integer y = 156
integer width = 997
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type sle_codigo from singlelineedit within w_ope506_cns_articulo_labor
event ue_tecla pbm_dwnkey
integer x = 279
integer y = 36
integer width = 448
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF Key = KeyEnter! THEN
	String ls_nro_orden 
	Long   ll_count
	
	ls_nro_orden = sle_codigo.text
	
	select count(*) into :ll_count 
	  from articulo 
	 where cod_art = :ls_nro_orden ;

		 
   IF ll_count = 0 THEN
		Messagebox('Aviso','Articulo No Existe ,Verifique!')
		Setnull(ls_nro_orden)
		sle_codigo.text = ls_nro_orden
		Return
	END IF
		
	//cb_1.TriggerEvent(Clicked!)
	
END IF
end event

type pb_1 from picturebutton within w_ope506_cns_articulo_labor
integer x = 763
integer y = 36
integer width = 114
integer height = 96
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Search!"
alignment htextalign = left!
end type

event clicked;str_seleccionar lstr_seleccionar

				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ARTICULO.COD_ART AS CODIGO , '&
								       +'ARTICULO.NOM_ARTICULO AS DESCRIPCION '&
				   				 	 +'FROM ARTICULO '
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_codigo.text = lstr_seleccionar.param1[1]
	st_2.text = lstr_seleccionar.param2[1]
	
END IF														 

end event

type st_1 from statictext within w_ope506_cns_articulo_labor
integer x = 59
integer y = 52
integer width = 206
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Articulo"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope506_cns_articulo_labor
integer x = 2537
integer y = 68
integer width = 302
integer height = 104
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String ls_cod

ls_cod = sle_codigo.text

of_get_orden( ls_cod )
end event

type uo_fecha from u_ingreso_rango_fechas within w_ope506_cns_articulo_labor
integer x = 1134
integer y = 92
integer taborder = 60
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type tab_1 from tab within w_ope506_cns_articulo_labor
integer x = 46
integer y = 256
integer width = 2990
integer height = 1676
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
integer width = 2953
integer height = 1548
long backcolor = 79741120
string text = "Labores"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_cns within tabpage_1
integer x = 18
integer y = 48
integer width = 2871
integer height = 1432
integer taborder = 20
string dataobject = "d_cns_x_articulo_labor"
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2953
integer height = 1548
long backcolor = 79741120
string text = "Plantillas"
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
integer y = 64
integer width = 2802
integer height = 1420
integer taborder = 20
string dataobject = "d_cns_articulo_x_plantilla"
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
integer width = 2953
integer height = 1548
long backcolor = 79741120
string text = "Ordenes de Trabajo"
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
integer x = 41
integer y = 68
integer width = 2825
integer height = 1404
integer taborder = 20
string dataobject = "d_cns_articulo_x_orden_trabajo"
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
integer width = 2953
integer height = 1548
long backcolor = 79741120
string text = "Partes Diarios"
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
integer y = 60
integer width = 2821
integer height = 1440
integer taborder = 20
string dataobject = "d_cns_articulo_x_parte_diario"
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

type gb_2 from groupbox within w_ope506_cns_articulo_labor
integer x = 1093
integer y = 20
integer width = 1371
integer height = 192
integer taborder = 50
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

