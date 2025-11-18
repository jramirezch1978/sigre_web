$PBExportHeader$w_ope502_labor.srw
forward
global type w_ope502_labor from w_abc
end type
type st_2 from statictext within w_ope502_labor
end type
type pb_1 from picturebutton within w_ope502_labor
end type
type sle_codigo from singlelineedit within w_ope502_labor
end type
type uo_fecha from u_ingreso_rango_fechas within w_ope502_labor
end type
type sle_2 from u_sle_codigo within w_ope502_labor
end type
type cb_1 from commandbutton within w_ope502_labor
end type
type st_1 from statictext within w_ope502_labor
end type
type tab_1 from tab within w_ope502_labor
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
type tab_1 from tab within w_ope502_labor
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type gb_2 from groupbox within w_ope502_labor
end type
end forward

global type w_ope502_labor from w_abc
integer width = 3127
integer height = 2228
string title = "[OPE502] Consulta por Labor"
string menuname = "m_cns"
st_2 st_2
pb_1 pb_1
sle_codigo sle_codigo
uo_fecha uo_fecha
sle_2 sle_2
cb_1 cb_1
st_1 st_1
tab_1 tab_1
gb_2 gb_2
end type
global w_ope502_labor w_ope502_labor

type variables
String 	is_plantilla, is_col, is_data_type, is_doc_ot, &
			is_accion, is_ot_adm, is_cod_plant, is_flag_cnta_prsp, &
			is_dolares,	is_seccion_def,is_tip_seccion, is_articulo
Integer ii_ik[]			
DatawindowChild idw_child

u_dw_cns idw_master, idw_detail, idw_2, idw_3, idw_4
StaticText	ist_3


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
public subroutine of_asigna_dw ()
end prototypes

public subroutine wf_retrieve_dw (string as_nro_labor);/*********************************************************************/
/* Función de Ventana de Recuperación de datos de la Labor*/
/*********************************************************************/
Long ll_row, ll_oper_sec
String ls_cod_labor,ls_ot_adm
dwobject dwo


SELECT cod_labor 
  INTO :ls_cod_labor
  FROM labor 
 WHERE cod_labor=:as_nro_labor ;

is_accion = 'fileopen'

end subroutine

public subroutine of_get_orden (string as_orden);Date ld_fecha_desde, ld_fecha_hasta
//idw_query = dw_master
Long ll_count

ld_fecha_desde = uo_fecha.of_get_fecha1()
ld_fecha_hasta = uo_fecha.of_get_fecha2()

If ld_fecha_hasta < ld_fecha_desde then
	MessageBox('Error: ' + this.ClassName(), &
		'Rango de fechas inválido, por favor ingrese nuevamente', &
		Information!)
	Return
End if

Select count(cod_labor) into :ll_count from labor where cod_labor = :as_orden;

if ll_count = 0 then
	Messagebox( "Error", "Labor no existe")		
	Return
end if

is_articulo = as_orden

tab_1.SelectTab(1)

tab_1.tabpage_1.dw_master.Retrieve(as_orden)
tab_1.tabpage_1.dw_detail.Retrieve(as_orden)
tab_1.tabpage_2.dw_2.Retrieve(as_orden)
tab_1.tabpage_3.dw_3.Retrieve(as_orden,ld_fecha_desde,ld_fecha_hasta)
tab_1.tabpage_4.dw_4.Retrieve(as_orden,ld_fecha_desde,ld_fecha_hasta)

//tab_1.tabpage_2.dw_master.Retrieve(as_orden)
//tab_1.tabpage_2.dw_lista_op.Retrieve(as_orden)
//tab_1.tabpage_2.dw_det_op.Retrieve(as_orden)
//tab_1.tabpage_2.dw_det_art.Retrieve(as_orden)


//il_tab2 = 0
//il_tab3 = 0
//il_tab4 = 0
//il_tab5 = 0
end subroutine

public subroutine of_asigna_dw ();idw_master = tab_1.tabpage_1.dw_master
idw_Detail = tab_1.tabpage_1.dw_detail
idw_2		  = tab_1.tabpage_2.dw_2
idw_3		  = tab_1.tabpage_3.dw_3
idw_4		  = tab_1.tabpage_4.dw_4
ist_3		  = tab_1.tabpage_1.st_3

end subroutine

on w_ope502_labor.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_2=create st_2
this.pb_1=create pb_1
this.sle_codigo=create sle_codigo
this.uo_fecha=create uo_fecha
this.sle_2=create sle_2
this.cb_1=create cb_1
this.st_1=create st_1
this.tab_1=create tab_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.pb_1
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.uo_fecha
this.Control[iCurrent+5]=this.sle_2
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.tab_1
this.Control[iCurrent+9]=this.gb_2
end on

on w_ope502_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.pb_1)
destroy(this.sle_codigo)
destroy(this.uo_fecha)
destroy(this.sle_2)
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

of_asigna_dw()

idw_master.SetTransObject(sqlca)
idw_detail.SetTransObject(sqlca)
idw_2.SetTransObject(sqlca)
idw_3.SetTransObject(sqlca)
idw_4.SetTransObject(sqlca)

idw_query = tab_1.tabpage_1.dw_master

//wf_reset_dw()
of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

event resize;call super::resize;of_asigna_dw()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_master.width  = tab_1.tabpage_1.width  - idw_master.x - 10
ist_3.width  = tab_1.tabpage_1.width  - ist_3.x - 10
idw_detail.width  = tab_1.tabpage_1.width  - idw_detail.x - 10
idw_detail.height  = tab_1.tabpage_1.height  - idw_detail.y - 10

idw_2.width  = tab_1.tabpage_2.width  - idw_2.x - 10
idw_2.height  = tab_1.tabpage_2.height  - idw_2.y - 10

idw_3.width  = tab_1.tabpage_3.width  - idw_3.x - 10
idw_3.height  = tab_1.tabpage_3.height  - idw_3.y - 10

idw_4.width  = tab_1.tabpage_4.width  - idw_4.x - 10
idw_4.height  = tab_1.tabpage_4.height  - idw_4.y - 10

end event

type st_2 from statictext within w_ope502_labor
integer y = 128
integer width = 1216
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

type pb_1 from picturebutton within w_ope502_labor
integer x = 635
integer y = 12
integer width = 110
integer height = 96
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
lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS CODIGO , '&
								       +'LABOR.DESC_LABOR AS DESCRIPCION '&
				   				 	 +'FROM LABOR '
														 
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_codigo.text = lstr_seleccionar.param1[1]
	st_2.text = lstr_seleccionar.param2[1]
	
END IF														 

end event

type sle_codigo from singlelineedit within w_ope502_labor
event ue pbm_dwnkey
event ue_tecla pbm_dwnkey
integer x = 229
integer y = 12
integer width = 393
integer height = 100
integer taborder = 30
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
	  from labor 
	 where cod_labor = :ls_nro_orden ;

		 
   IF ll_count = 0 THEN
		Messagebox('Aviso','Labor No Existe ,Verifique!')
		Setnull(ls_nro_orden)
		sle_codigo.text = ls_nro_orden
		Return
	END IF
		
	//cb_1.TriggerEvent(Clicked!)
	
END IF
end event

type uo_fecha from u_ingreso_rango_fechas within w_ope502_labor
integer x = 1275
integer y = 92
integer taborder = 50
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
//of_set_fecha(date('01/01/1900'), date('31/12/9999') // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

on uo_fecha.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_2 from u_sle_codigo within w_ope502_labor
boolean visible = false
integer x = 256
integer y = 12
integer width = 375
integer taborder = 40
integer textsize = -8
boolean enabled = false
integer limit = 8
end type

event constructor;call super::constructor;//ii_prefijo = 2
ii_total = 8
ibl_mayuscula = true
end event

type cb_1 from commandbutton within w_ope502_labor
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

ls_cod = sle_codigo.text

of_get_orden( ls_cod )
end event

type st_1 from statictext within w_ope502_labor
integer x = 37
integer y = 28
integer width = 192
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Labor"
boolean focusrectangle = false
end type

type tab_1 from tab within w_ope502_labor
integer y = 248
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
integer y = 792
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
string text = "EJECUTORES"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_detail from u_dw_cns within tabpage_1
integer y = 864
integer width = 2555
integer height = 524
integer taborder = 20
string dataobject = "d_cns_labor_ejecutor_tbl"
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

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type dw_master from u_dw_cns within tabpage_1
integer width = 2555
integer height = 792
integer taborder = 20
string dataobject = "d_labor_ff_cns"
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
string text = "Plantilla"
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
integer width = 2734
integer height = 1496
integer taborder = 20
string dataobject = "d_cns_labor_x_plantilla"
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

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Orden de Trabajo"
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
integer width = 2821
integer height = 1500
integer taborder = 20
string dataobject = "d_cns_labor_x_ot"
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

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2862
integer height = 1608
long backcolor = 79741120
string text = "Parte Diario"
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
integer width = 2761
integer height = 1528
integer taborder = 20
string dataobject = "d_cns_labor_x_parte_diario"
boolean hscrollbar = true
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

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type gb_2 from groupbox within w_ope502_labor
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

