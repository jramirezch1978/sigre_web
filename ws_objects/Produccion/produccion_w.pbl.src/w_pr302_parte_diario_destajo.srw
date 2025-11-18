$PBExportHeader$w_pr302_parte_diario_destajo.srw
forward
global type w_pr302_parte_diario_destajo from w_abc_mastdet
end type
type uo_rango from ou_rango_fechas within w_pr302_parte_diario_destajo
end type
type dw_pd_ot from u_dw_abc within w_pr302_parte_diario_destajo
end type
type p_1 from picture within w_pr302_parte_diario_destajo
end type
type cbx_graph from checkbox within w_pr302_parte_diario_destajo
end type
type st_1 from statictext within w_pr302_parte_diario_destajo
end type
type tab_1 from tab within w_pr302_parte_diario_destajo
end type
type cantidad from userobject within tab_1
end type
type dw_cantidad from datawindow within cantidad
end type
type cantidad from userobject within tab_1
dw_cantidad dw_cantidad
end type
type eficiencia from userobject within tab_1
end type
type dw_eficiencia from datawindow within eficiencia
end type
type eficiencia from userobject within tab_1
dw_eficiencia dw_eficiencia
end type
type pago from userobject within tab_1
end type
type dw_pago from datawindow within pago
end type
type pago from userobject within tab_1
dw_pago dw_pago
end type
type tab_1 from tab within w_pr302_parte_diario_destajo
cantidad cantidad
eficiencia eficiencia
pago pago
end type
type st_etiqueta from statictext within w_pr302_parte_diario_destajo
end type
type em_ot_adm from singlelineedit within w_pr302_parte_diario_destajo
end type
type em_descripcion from singlelineedit within w_pr302_parte_diario_destajo
end type
type pb_1 from picturebutton within w_pr302_parte_diario_destajo
end type
type st_2 from statictext within w_pr302_parte_diario_destajo
end type
type st_3 from statictext within w_pr302_parte_diario_destajo
end type
type cb_1 from commandbutton within w_pr302_parte_diario_destajo
end type
end forward

global type w_pr302_parte_diario_destajo from w_abc_mastdet
integer width = 4009
integer height = 1960
string title = "Control de destajos (PR302) "
string menuname = "m_mantto_smpl_real"
windowstate windowstate = maximized!
long backcolor = 67108864
uo_rango uo_rango
dw_pd_ot dw_pd_ot
p_1 p_1
cbx_graph cbx_graph
st_1 st_1
tab_1 tab_1
st_etiqueta st_etiqueta
em_ot_adm em_ot_adm
em_descripcion em_descripcion
pb_1 pb_1
st_2 st_2
st_3 st_3
cb_1 cb_1
end type
global w_pr302_parte_diario_destajo w_pr302_parte_diario_destajo

type variables
Decimal ldc_factor
end variables

forward prototypes
public subroutine of_carga_graph ()
public function integer of_nro_sub_item (datawindow adw_pr)
public function integer of_modify ()
end prototypes

public subroutine of_carga_graph ();long ll_master

ll_master = dw_master.getrow( )

if ll_master <= 0 then
	if cbx_graph.checked = true then
		tab_1.cantidad.dw_cantidad.reset( )
		tab_1.eficiencia.dw_eficiencia.reset( )
		tab_1.pago.dw_pago.reset( )
	end if
else
	if cbx_graph.checked = true then
		tab_1.cantidad.dw_cantidad.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
		tab_1.eficiencia.dw_eficiencia.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
		tab_1.pago.dw_pago.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
	else
		tab_1.cantidad.dw_cantidad.reset( )
		tab_1.eficiencia.dw_eficiencia.reset( )
		tab_1.pago.dw_pago.reset( )
	end if
end if
end subroutine

public function integer of_nro_sub_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

if adw_pr.RowCount() > 0 then
	For li_x 		= 1 to adw_pr.RowCount()
		IF li_item 	< Integer(adw_pr.object.nro_sub_item[li_x]) THEN
			li_item 	= Integer(adw_pr.object.nro_sub_item[li_x])
		END IF
	Next

end if

Return li_item + 1
end function

public function integer of_modify ();return 1
end function

on w_pr302_parte_diario_destajo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl_real" then this.MenuID = create m_mantto_smpl_real
this.uo_rango=create uo_rango
this.dw_pd_ot=create dw_pd_ot
this.p_1=create p_1
this.cbx_graph=create cbx_graph
this.st_1=create st_1
this.tab_1=create tab_1
this.st_etiqueta=create st_etiqueta
this.em_ot_adm=create em_ot_adm
this.em_descripcion=create em_descripcion
this.pb_1=create pb_1
this.st_2=create st_2
this.st_3=create st_3
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_rango
this.Control[iCurrent+2]=this.dw_pd_ot
this.Control[iCurrent+3]=this.p_1
this.Control[iCurrent+4]=this.cbx_graph
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.st_etiqueta
this.Control[iCurrent+8]=this.em_ot_adm
this.Control[iCurrent+9]=this.em_descripcion
this.Control[iCurrent+10]=this.pb_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.cb_1
end on

on w_pr302_parte_diario_destajo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_rango)
destroy(this.dw_pd_ot)
destroy(this.p_1)
destroy(this.cbx_graph)
destroy(this.st_1)
destroy(this.tab_1)
destroy(this.st_etiqueta)
destroy(this.em_ot_adm)
destroy(this.em_descripcion)
destroy(this.pb_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.cb_1)
end on

event resize;//override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.height = newheight - dw_detail.y - 10

tab_1.width = newwidth  - tab_1.x - 10
tab_1.height = newheight  - tab_1.y - 10

tab_1.cantidad.dw_cantidad.width  = newwidth  - tab_1.x - 10
tab_1.cantidad.dw_cantidad.height = newheight - tab_1.y - 100

tab_1.eficiencia.dw_eficiencia.width  = newwidth  - tab_1.x - 10
tab_1.eficiencia.dw_eficiencia.height = newheight - tab_1.y - 100

tab_1.pago.dw_pago.width  = newwidth  - tab_1.x - 10
tab_1.pago.dw_pago.height = newheight - tab_1.y - 100

end event

event ue_open_pre;call super::ue_open_pre;dw_pd_ot.SetTransObject(sqlca)
tab_1.cantidad.dw_cantidad.SetTransObject(sqlca)
tab_1.eficiencia.dw_eficiencia.SetTransObject(sqlca)
tab_1.pago.dw_pago.SetTransObject(sqlca)

dw_pd_ot.of_protect()

//this.event ue_query_retrieve()

select NVL(FACTOR_CALC_DSTJ, 1)
  into :ldc_factor
  from costo_param
 where reckey = '1';
end event

event ue_query_retrieve;date ld_ini, ld_fin
string ls_sql, ls_ot_adm

ld_ini = uo_rango.of_get_fecha1()
ld_fin = uo_rango.of_get_fecha2()
ls_ot_adm = em_ot_adm.text

if IsNull(ls_ot_adm) or em_ot_adm.text = "" then
	MessageBox('PRODUCCIÓN', 'NO HA INGRESO UNA OT_ADM VÁLIDA, VERIFIQUE',StopSign!)
	return
end if

if dw_pd_ot.retrieve(ld_ini , ld_fin, ls_ot_adm)  >= 1 then
	dw_pd_ot.selectrow(1,true)
	dw_pd_ot.setrow(1)
	dw_pd_ot.scrolltorow(1)
else
	dw_pd_ot.reset()
	dw_master.reset()
	dw_detail.reset()
end if
end event

event ue_update;call super::ue_update;long ll_master
ll_master = dw_master.getrow()

if ll_master <= 0 then
	if cbx_graph.checked then
		tab_1.cantidad.dw_cantidad.reset()
		tab_1.eficiencia.dw_eficiencia.reset()
		tab_1.pago.dw_pago.reset()
	end if
else
	if cbx_graph.checked then
		tab_1.cantidad.dw_cantidad.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
		tab_1.eficiencia.dw_eficiencia.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
		tab_1.pago.dw_pago.retrieve(dw_master.object.nro_parte[ll_master], dw_master.object.nro_item[ll_master])
	end if
end if

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_mastdet`dw_master within w_pr302_parte_diario_destajo
integer x = 1403
integer y = 200
integer width = 2450
integer height = 596
string dataobject = "d_pd_ot_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
end event

event dw_master::keydwn;call super::keydwn;long ll_row, ll_total

ll_row = this.getrow()
ll_total = this.rowcount()

if keydown(KeyDownArrow!) = true then
	
	if ll_row = ll_total then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row + 1, true)
	
end if

if keydown(KeyUpArrow!) = true then
	
	if ll_row = 1 then return
	
	this.selectrow(ll_row, false)
	this.selectrow(ll_row - 1, true)
	
end if
end event

event dw_master::ue_insert;//override
return 0
end event

event dw_master::ue_delete;//override
return 0
end event

event dw_master::ue_delete_all;//override
return 0
end event

event dw_master::ue_delete_pre;//override
return 0
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow <= 0 then
	dw_detail.reset()
	if cbx_graph.checked then
		tab_1.cantidad.dw_cantidad.reset()
		tab_1.eficiencia.dw_eficiencia.reset()
		tab_1.pago.dw_pago.reset()
	end if
else
	dw_detail.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow])
	if cbx_graph.checked then
		tab_1.cantidad.dw_cantidad.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow])
		tab_1.eficiencia.dw_eficiencia.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow])
		tab_1.pago.dw_pago.retrieve(this.object.nro_parte[currentrow], this.object.nro_item[currentrow])
	end if
end if
end event

type dw_detail from w_abc_mastdet`dw_detail within w_pr302_parte_diario_destajo
integer x = 0
integer y = 812
integer width = 2912
integer height = 952
string dataobject = "d_pd_ot_asistencia_destajo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master

end event

event dw_detail::doubleclicked;call super::doubleclicked;if this.ii_protect = 1 then return

string ls_col, ls_sql, ls_return1, ls_return2, ls_origen

ls_col = lower(string(dwo.name))

choose case ls_col
	case 'cod_trabajador'
		ls_origen = dw_master.object.nro_parte[dw_master.GetRow()]
		ls_origen = mid(ls_origen,1,2)
		
		ls_sql = "select cod_trabajador as codigo_trabajador, " &
				 + "nom_trabajador as nombre_trabajador " &
				 + "from vw_pr_trabajador " &
				 + "where cod_origen = '" + ls_origen + "' and flag_estado = '1'"

		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.cod_trabajador	[row] = ls_return1
		this.object.nom_trabajador	[row] = ls_return2
		this.ii_update = 1
end choose


end event

event dw_detail::itemchanged;call super::itemchanged;string ls_col, ls_sql, ls_return1, ls_return2, ls_origen

ls_col = lower(string(dwo.name))
ls_origen = dw_master.object.nro_parte[dw_master.GetRow()]
ls_origen = mid(ls_origen,1,2)

choose case ls_col
	case 'cod_trabajador'
		select cr.cod_relacion, cr.nombre 
			into :ls_return1, :ls_return2
			from codigo_relacion cr, maestro m
			where cr.flag_tabla = 'M'
				and m.cod_trabajador = cr.cod_relacion
				and m.flag_estado = '1'
				and cr.cod_relacion = :data
				and m.cod_origen = :ls_origen;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'No existe trabajador')
			setnull(ls_return1)
			setnull(ls_return2)
		end if
		
		this.object.cod_trabajador	[row] = ls_return1
		this.object.nom_trabajador	[row] = ls_return2
		return 2
end choose
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;DateTime ldt_fecha1, ldt_fecha2
DEcimal	ldc_horas

if dw_master.GetRow() = 0 then return

ldt_fecha1 = DateTime(dw_master.object.hora_inicio [dw_master.GetRow()])
ldt_fecha2 = DateTime(dw_master.object.hora_fin 	[dw_master.GetRow()])

select usf_alm_dif_dias(:ldt_fecha1, :ldt_fecha2)
  into :ldc_horas
  from dual;
  
If IsNull(ldc_horas) then ldc_horas = 0   

this.object.tarifa_normal	[al_row] = dw_master.object.costo_unitario[dw_master.getrow()]
this.object.cod_moneda		[al_row] = dw_master.object.cod_moneda		[dw_master.getrow()]
this.object.flag_genera_os	[al_row] = '0'
this.object.cant_destajada	[al_row] = 0
this.object.factor_calculo	[al_row] = ldc_factor
this.object.nro_sub_item	[al_row] = of_nro_sub_item(this)
this.object.horas_efectivas[al_row] = ldc_horas * 24
this.object.und				[al_row] = dw_master.object.und[dw_master.GetRow()]
this.object.und_1				[al_row] = dw_master.object.und[dw_master.GetRow()]
end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

type uo_rango from ou_rango_fechas within w_pr302_parte_diario_destajo
integer x = 1458
integer y = 100
integer height = 80
integer taborder = 30
boolean bringtotop = true
end type

on uo_rango.destroy
call ou_rango_fechas::destroy
end on

type dw_pd_ot from u_dw_abc within w_pr302_parte_diario_destajo
integer y = 200
integer width = 1358
integer height = 596
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pd_ot_de_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event rowfocuschanged;call super::rowfocuschanged;dw_detail.reset()
dw_master.reset()

if currentrow >= 1 then
	if dw_master.retrieve(this.object.nro_parte[currentrow]) >= 1 then
		dw_master.scrolltorow(1)
		dw_master.setrow(1)
		dw_master.selectrow( 1, true)
	end if
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert;//override
return 0
end event

event ue_insert_pre;//override
end event

event ue_delete;call super::ue_delete;//override
return 0
end event

event ue_delete_all;//override
return 0
end event

event ue_delete_pre;call super::ue_delete_pre;//override
return 0
end event

type p_1 from picture within w_pr302_parte_diario_destajo
integer x = 2738
integer y = 104
integer width = 73
integer height = 72
boolean bringtotop = true
string picturename = "Graph!"
boolean focusrectangle = false
end type

event clicked;if cbx_graph.checked then
	cbx_graph.checked = false
else
	cbx_graph.checked = true
end if
parent.of_carga_graph( )
end event

type cbx_graph from checkbox within w_pr302_parte_diario_destajo
integer x = 2661
integer y = 104
integer width = 59
integer height = 72
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

event clicked;parent.of_carga_graph( )
end event

type st_1 from statictext within w_pr302_parte_diario_destajo
integer y = 12
integer width = 311
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "OT_ADM"
alignment alignment = center!
long bordercolor = 67108864
boolean focusrectangle = false
end type

type tab_1 from tab within w_pr302_parte_diario_destajo
event create ( )
event destroy ( )
integer x = 2939
integer y = 812
integer width = 1010
integer height = 944
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
cantidad cantidad
eficiencia eficiencia
pago pago
end type

on tab_1.create
this.cantidad=create cantidad
this.eficiencia=create eficiencia
this.pago=create pago
this.Control[]={this.cantidad,&
this.eficiencia,&
this.pago}
end on

on tab_1.destroy
destroy(this.cantidad)
destroy(this.eficiencia)
destroy(this.pago)
end on

type cantidad from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 974
integer height = 824
long backcolor = 79741120
string text = "Cantidad"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_cantidad dw_cantidad
end type

on cantidad.create
this.dw_cantidad=create dw_cantidad
this.Control[]={this.dw_cantidad}
end on

on cantidad.destroy
destroy(this.dw_cantidad)
end on

type dw_cantidad from datawindow within cantidad
event ue_mousemove pbm_mousemove
integer width = 416
integer height = 400
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_pd_ot_asistencia_destajo_grf"
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + tab_1.x + 40
	st_etiqueta.y = ypos + tab_1.y + 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
	
else
	st_etiqueta.visible = false
end if
end event

type eficiencia from userobject within tab_1
integer x = 18
integer y = 104
integer width = 974
integer height = 824
long backcolor = 79741120
string text = "Eficiencia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_eficiencia dw_eficiencia
end type

on eficiencia.create
this.dw_eficiencia=create dw_eficiencia
this.Control[]={this.dw_eficiencia}
end on

on eficiencia.destroy
destroy(this.dw_eficiencia)
end on

type dw_eficiencia from datawindow within eficiencia
event ue_mousemove pbm_mousemove
integer width = 416
integer height = 400
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_pd_ot_asist_des_efic_grf"
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + tab_1.x + 40
	st_etiqueta.y = ypos + tab_1.y + 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
	
else
	st_etiqueta.visible = false
end if
end event

type pago from userobject within tab_1
integer x = 18
integer y = 104
integer width = 974
integer height = 824
long backcolor = 79741120
string text = "Pago"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pago dw_pago
end type

on pago.create
this.dw_pago=create dw_pago
this.Control[]={this.dw_pago}
end on

on pago.destroy
destroy(this.dw_pago)
end on

type dw_pago from datawindow within pago
event ue_mousemove pbm_mousemove
integer width = 416
integer height = 400
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_pd_ot_asist_des_pago_grf"
boolean border = false
boolean livescroll = true
end type

event ue_mousemove;int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad, ls_mensaje
long ll_row
grObjectType	MouseMoveObject

MouseMoveObject = this.ObjectAtPointer('gr_1', li_Series, li_category)
	if MouseMoveObject = TypeData! or MouseMoveObject = TypeCategory! then

	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
		st_etiqueta.BringToTop = TRUE
	st_etiqueta.x = xpos + tab_1.x + 40
	st_etiqueta.y = ypos + tab_1.y + 10
	st_etiqueta.text = ls_mensaje
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true
	
else
	st_etiqueta.visible = false
end if
end event

type st_etiqueta from statictext within w_pr302_parte_diario_destajo
boolean visible = false
integer x = 3314
integer y = 1464
integer width = 343
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217735
long backcolor = 134217752
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ot_adm from singlelineedit within w_pr302_parte_diario_destajo
event dobleclick pbm_lbuttondblclk
integer y = 104
integer width = 311
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM, O.DESCRIPCION AS DESCRIPCION," &
				  + "P.COD_USR AS USUARIO " &
				  + "FROM OT_ADMINISTRACION O, OT_ADM_USUARIO P " &
				  + "WHERE O.OT_ADM = P.OT_ADM " &
				  + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

em_descripcion.text = ls_data

end if
end event

event modified;//String ls_origen, ls_desc
//
//ls_origen = this.text
//if ls_origen = '' or IsNull(ls_origen) then
//	MessageBox('Aviso', 'Debe Ingresar un codigo de Origen')
//	return
//end if
//
//SELECT descripcion INTO :ls_desc
//FROM ot_administracion
//WHERE ot_adm =:ls_origen;
//
//IF SQLCA.SQLCode = 100 THEN
//	Messagebox('Aviso', 'Codigo de Origen no existe')
//	return
//end if
//
//em_descripcion.text = ls_desc


end event

type em_descripcion from singlelineedit within w_pr302_parte_diario_destajo
integer x = 329
integer y = 104
integer width = 1102
integer height = 72
integer taborder = 70
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

type pb_1 from picturebutton within w_pr302_parte_diario_destajo
integer x = 2917
integer y = 12
integer width = 553
integer height = 184
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Mostrar Partes"
string picturename = "H:\source\BMP\aceptara.bmp"
alignment htextalign = right!
end type

event clicked;// Ancestor Script has been Override

SetPointer(HourGlass!)
Parent.event Dynamic ue_query_retrieve()
SetPointer(Arrow!)
end event

type st_2 from statictext within w_pr302_parte_diario_destajo
integer x = 1467
integer y = 12
integer width = 503
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Rango de Fechas"
alignment alignment = center!
long bordercolor = 67108864
boolean focusrectangle = false
end type

type st_3 from statictext within w_pr302_parte_diario_destajo
integer x = 2555
integer y = 12
integer width = 361
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Ver Grafico"
alignment alignment = center!
long bordercolor = 67108864
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr302_parte_diario_destajo
integer x = 818
integer width = 608
integer height = 96
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Importar Destajeros"
end type

event clicked;string 	ls_labor, ls_ejecutor
long		ll_row
str_parametros lstr_param

if dw_master.RowCount( ) = 0 then return
if dw_pd_ot.RowCount() = 0 then return

ll_row = dw_master.GetRow()

ls_labor 	= dw_master.object.cod_labor		[ll_row]
ls_ejecutor = dw_master.object.cod_ejecutor 	[ll_row]

if ls_labor = '' or IsNull(ls_labor) then
	MessageBox('Aviso', 'Debe indicar un Código de Labor')
	return
end if

if ls_ejecutor = '' or IsNull(ls_ejecutor) then
	MessageBox('Aviso', 'Debe indicar un Código de Ejecutor')
	return
end if

// Si es una salida x consumo interno
lstr_param.w1				= parent
lstr_param.dw_m			= dw_master
lstr_param.dw_d			= dw_detail
lstr_param.dw1      		= 'd_lista_labor_trabajador_tbl'
lstr_param.titulo    	= 'Lista de Trabajadores '
lstr_param.tipo		 	= '2S'     // con un parametro del tipo string
lstr_param.string1   	= ls_labor
lstr_param.string2	 	= ls_ejecutor
lstr_param.opcion    	= 1

OpenWithParm( w_abc_seleccion, lstr_param)


end event

