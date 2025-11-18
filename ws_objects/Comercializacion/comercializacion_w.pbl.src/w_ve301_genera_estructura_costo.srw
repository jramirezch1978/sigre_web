$PBExportHeader$w_ve301_genera_estructura_costo.srw
forward
global type w_ve301_genera_estructura_costo from w_abc_mastdet
end type
type dw_grafico from datawindow within w_ve301_genera_estructura_costo
end type
type st_etiqueta from statictext within w_ve301_genera_estructura_costo
end type
type rb_1 from radiobutton within w_ve301_genera_estructura_costo
end type
type rb_2 from radiobutton within w_ve301_genera_estructura_costo
end type
type st_mensaje from statictext within w_ve301_genera_estructura_costo
end type
end forward

global type w_ve301_genera_estructura_costo from w_abc_mastdet
integer width = 4023
integer height = 1552
string title = "[VE301] Asignacion de Estructura de Costos"
string menuname = "m_mantenimiento_guardar_eliminar"
boolean maxbox = false
windowtype windowtype = popup!
integer ii_pregunta_delete = 1
dw_grafico dw_grafico
st_etiqueta st_etiqueta
rb_1 rb_1
rb_2 rb_2
st_mensaje st_mensaje
end type
global w_ve301_genera_estructura_costo w_ve301_genera_estructura_costo

type variables
string is_origen, is_nro_ov
end variables

on w_ve301_genera_estructura_costo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_guardar_eliminar" then this.MenuID = create m_mantenimiento_guardar_eliminar
this.dw_grafico=create dw_grafico
this.st_etiqueta=create st_etiqueta
this.rb_1=create rb_1
this.rb_2=create rb_2
this.st_mensaje=create st_mensaje
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_grafico
this.Control[iCurrent+2]=this.st_etiqueta
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.st_mensaje
end on

on w_ve301_genera_estructura_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_grafico)
destroy(this.st_etiqueta)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.st_mensaje)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

of_center_window(this)

dw_detail.of_protect( )
end event

event resize;//Override

dw_grafico.height = newheight - dw_grafico.y - 32
dw_grafico.width  = newwidth - dw_grafico.x - 32

dw_detail.height = newheight - dw_detail.y - 32
end event

event open;//Override

if isvalid(message.powerobjectparm) then
	
	str_parametros lstr_parametros
	
	lstr_parametros = message.powerobjectparm
	
	is_origen = lstr_parametros.string1
	is_nro_ov = lstr_parametros.string2
	
	delete from tt_ov_costo_teorico;
	commit;
	
else
	
	messagebox('Aviso','Parametros de la OV no son validos')
	close(this)
	
end if

THIS.EVENT ue_open_pre()
THIS.EVENT ue_dw_share()
THIS.EVENT ue_retrieve_dddw()
end event

event ue_update;//Override
long ll_count

select count(*)
  into :ll_count
  from ov_costo_teorico
 where nro_ov = :is_nro_ov;

if ll_count > 0 then 
	
	if messagebox('Aviso','YA ha sido registrada una plantilla para la OV actual, ~n Desea Reemplazarla?',Question!,YesNo!,1) = 2 then return
	
	delete from ov_costo_teorico
 	 where nro_ov = :is_nro_ov;
	
	if sqlca.sqlcode <> 0 then
		rollback;
		messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
		close(this)
	end if
	
end if

dw_detail.update( )
commit;

Insert Into ov_costo_teorico ( nro_ov, org_amp, nro_amp, servicio,
            costo_unitario, factor_precio, flag_replicacion )
	  select nro_ov, org_amp, nro_amp, servicio,
            costo_unitario, factor_precio, '1'
		 from tt_ov_costo_teorico;

if sqlca.sqlcode = 0 then
	delete from tt_ov_costo_teorico;
	commit;
	dw_detail.ii_update = 0
	close(this)
else
	delete from tt_ov_costo_teorico;
	rollback;
	dw_detail.ii_update = 0
	messagebox('Aviso',string(sqlca.sqlcode)+' '+string(sqlca.sqlerrtext))
	close(this)
end if
end event

type dw_master from w_abc_mastdet`dw_master within w_ve301_genera_estructura_costo
integer x = 37
integer y = 32
integer width = 2126
integer height = 516
string dataobject = "d_abc_plantilla_ov"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'tabular' // tabular form
ii_ss = 1
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

event dw_master::clicked;if row = 0 then return

st_mensaje.visible = true
SetPointer(HourGlass!)
//Override

string ls_plantilla, ls_flag_exportacion, ls_flag_presentacion
decimal{2} ldc_mayor, ldc_menor

ls_plantilla         = this.object.plantilla[row]
ls_flag_exportacion  = this.object.flag_exportacion[row]

if rb_1.checked = true then
	ls_flag_presentacion = 'T'
else
	ls_flag_presentacion = 'P'
end if

delete from tt_ov_costo_teorico;
commit;

declare usp_proc procedure for USP_VE_ASIGNA_COSTOS_OV(:is_origen, :is_nro_ov, :ls_plantilla, :ls_flag_exportacion, :ls_flag_presentacion);
execute usp_proc;

if sqlca.sqlcode = -1 then
	messagebox('Aviso',string(sqlca.sqlcode )+' '+string(sqlca.sqlerrtext))
	rollback;
	return
end if

dw_detail.retrieve( )
dw_grafico.retrieve( )

select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;

dw_grafico.event ue_graphcreate( )

dw_grafico.object.gr_1.Values.autoscale = 0

if ls_flag_presentacion = 'T' then
	dw_grafico.object.gr_1.Values.MaximumValue = long(ldc_mayor + 100)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = long(ldc_menor - 100)
	end if
	
else
	dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
	end if
	
end if
	
st_mensaje.visible = false
SetPointer(Arrow!)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_delete;//Override
messagebox('Aviso','Solamente puede eliminar el calculo de la estructura de la plantilla')
return 1
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve301_genera_estructura_costo
integer x = 37
integer y = 576
integer width = 2130
integer height = 708
string dataobject = "d_asigna_estructura_costo_ov"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

ii_ss = 1
end event

type dw_grafico from datawindow within w_ve301_genera_estructura_costo
event ue_graphcreate pbm_dwngraphcreate
event ue_mousemove pbm_mousemove
integer x = 2194
integer y = 96
integer width = 1723
integer height = 1188
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_graf_asigna_estructura_costo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_graphcreate;//Codigo

string ls_present, ls_calculado, ls_vta_total

if rb_1.checked = true then
	ls_present = 'T'
else
	ls_present = 'P'
end if

If ls_present = 'T' Then
   ls_calculado = 'IMPORTE VENTA (CALC)'
   ls_vta_total = 'IMPORTE VENTA'

Else
   ls_calculado = 'PRECIO VENTA (CALC)'
   ls_vta_total = 'PRECIO VENTA'

End If

this.SetSeriesStyle("gr_1",ls_calculado,LineColor!, 255)
this.SetSeriesStyle("gr_1",ls_calculado,ForeGround!, 255)
this.SetSeriesStyle("gr_1",ls_calculado,Continuous!, 1)
this.SetSeriesStyle("gr_1",ls_calculado,Symbolx!)

this.SetSeriesStyle("gr_1",ls_vta_total,LineColor!, 16711680)
this.SetSeriesStyle("gr_1",ls_vta_total,ForeGround!, 16711680)
this.SetSeriesStyle("gr_1",ls_vta_total,Continuous!, 1)
this.SetSeriesStyle("gr_1",ls_vta_total,Symbolx!)
end event

event ue_mousemove;//codigo
Int  li_Rtn, li_Series, li_Category 
String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
Long ll_row 

grObjectType MouseMoveObject 

MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)

IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
	ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
	ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
	ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
	ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
//	st_etiqueta.x = ( xpos  + this.x ) - ( (len(ls_mensaje) * 20) / 2 )
//	st_etiqueta.y = ypos + 20
	st_etiqueta.move( ( xpos + this.x + 60), ( ypos + this.y + 80) )
	st_etiqueta.text = ls_mensaje 
	st_etiqueta.width = len(ls_mensaje) * 30
	st_etiqueta.visible = true 
ELSE 
 	st_etiqueta.visible = false 
END IF
end event

event constructor;settransobject(sqlca)
end event

type st_etiqueta from statictext within w_ve301_genera_estructura_costo
boolean visible = false
integer x = 3488
integer y = 140
integer width = 347
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217752
boolean border = true
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_ve301_genera_estructura_costo
integer x = 2194
integer y = 32
integer width = 631
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Afecto al Total de Venta"
boolean checked = true
end type

event clicked;if dw_master.getrow() = 0 then return

st_mensaje.visible = true
SetPointer(HourGlass!)

//Override

string ls_plantilla, ls_flag_exportacion, ls_flag_presentacion
decimal{2} ldc_mayor, ldc_menor

ls_plantilla         = dw_master.object.plantilla[dw_master.getrow()]
ls_flag_exportacion  = dw_master.object.flag_exportacion[dw_master.getrow()]

ls_flag_presentacion = 'T'

rollback;

declare usp_proc procedure for USP_VE_ASIGNA_COSTOS_OV(:is_origen, :is_nro_ov, :ls_plantilla, :ls_flag_exportacion, :ls_flag_presentacion);
execute usp_proc;

dw_detail.retrieve( )
dw_grafico.retrieve( )

select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;

dw_grafico.event ue_graphcreate( )

dw_grafico.object.gr_1.Values.autoscale = 0

if ls_flag_presentacion = 'T' then
	dw_grafico.object.gr_1.Values.MaximumValue = long(ldc_mayor + 100)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = long(ldc_menor - 100)
	end if
	
else
	dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
	end if
	
end if
	
st_mensaje.visible = false
SetPointer(Arrow!)
end event

type rb_2 from radiobutton within w_ve301_genera_estructura_costo
integer x = 2898
integer y = 32
integer width = 631
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Afecto al Precio Unitario"
end type

event clicked;if dw_master.getrow() = 0 then return

st_mensaje.visible = true
SetPointer(HourGlass!)

//Override

string ls_plantilla, ls_flag_exportacion, ls_flag_presentacion
decimal{2} ldc_mayor, ldc_menor

ls_plantilla         = dw_master.object.plantilla[dw_master.getrow()]
ls_flag_exportacion  = dw_master.object.flag_exportacion[dw_master.getrow()]

ls_flag_presentacion = 'P'

rollback;

declare usp_proc procedure for USP_VE_ASIGNA_COSTOS_OV(:is_origen, :is_nro_ov, :ls_plantilla, :ls_flag_exportacion, :ls_flag_presentacion);
execute usp_proc;

dw_detail.retrieve( )
dw_grafico.retrieve( )

select max(valor)
  into :ldc_mayor
  from tt_ve_graf_asignacion_costo;

select min(valor)
  into :ldc_menor
  from tt_ve_graf_asignacion_costo;

dw_grafico.event ue_graphcreate( )

dw_grafico.object.gr_1.Values.autoscale = 0

if ls_flag_presentacion = 'T' then
	dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 100)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 100)
	end if
	
else
	dw_grafico.object.gr_1.Values.MaximumValue = integer(ldc_mayor + 1)
	if integer(ldc_menor - 1) < 0 then
		dw_grafico.object.gr_1.Values.MinimumValue = 0
	else
		dw_grafico.object.gr_1.Values.MinimumValue = integer(ldc_menor - 1)
	end if
	
end if

st_mensaje.visible = false
SetPointer(Arrow!)
end event

type st_mensaje from statictext within w_ve301_genera_estructura_costo
boolean visible = false
integer x = 1563
integer y = 544
integer width = 1458
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 255
string text = "Procesando Transaccion, Espere Por Favor..."
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

