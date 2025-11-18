$PBExportHeader$w_ve020_comisiones.srw
forward
global type w_ve020_comisiones from w_abc_mastdet
end type
type dw_lista from datawindow within w_ve020_comisiones
end type
type st_1 from statictext within w_ve020_comisiones
end type
type tab_1 from tab within w_ve020_comisiones
end type
type fija from userobject within tab_1
end type
type dw_fija from datawindow within fija
end type
type fija from userobject within tab_1
dw_fija dw_fija
end type
type cobertura from userobject within tab_1
end type
type dw_cobertura from datawindow within cobertura
end type
type cobertura from userobject within tab_1
dw_cobertura dw_cobertura
end type
type producto from userobject within tab_1
end type
type dw_producto from datawindow within producto
end type
type producto from userobject within tab_1
dw_producto dw_producto
end type
type tab_1 from tab within w_ve020_comisiones
fija fija
cobertura cobertura
producto producto
end type
end forward

global type w_ve020_comisiones from w_abc_mastdet
integer width = 2926
integer height = 1840
string title = "[VE020] Comisiones"
string menuname = "m_mantenimiento_comisiones"
integer ii_pregunta_delete = 1
event ue_insert_new ( )
event ue_copy_periodo ( )
dw_lista dw_lista
st_1 st_1
tab_1 tab_1
end type
global w_ve020_comisiones w_ve020_comisiones

type variables
date id_fecha_ini
string is_canal
datawindow idw_actual, idw_fija, idw_cobertura, idw_producto
end variables

event ue_insert_new();//Codigo

//Codigo

if isnull(id_fecha_ini) then
	messagebox('Aviso','Debe de Seleccionar una fecha de la lista, ~n Si no existe pueda generar uno')
	return
end if

if isnull(is_canal) or is_canal = '' then
	messagebox('Aviso','Debe de Seleccionar un Canal de Distribucion de la lista')
	return
end if

date ld_fecha_fin

select distinct(fecha_fin)
  into :ld_fecha_fin
  from vendedor_cuota
 where fecha_ini = :id_fecha_ini;

long ll_row

ll_row = idw_actual.insertrow( 0 )

idw_actual.object.fecha_ini[ll_row] = id_fecha_ini
idw_actual.object.fecha_fin[ll_row] = ld_fecha_fin
idw_actual.object.canal[ll_row] = is_canal
idw_actual.object.cod_usr[ll_row] = gs_user

end event

event ue_copy_periodo();//codigo
str_parametros lstr_parametros

date ld_fecha

select max(fecha_ini)
  into :ld_fecha
  from vendedor_cuota;

lstr_parametros.fecha1 = ld_fecha

if (messagebox('Aviso','Esto Borrara todos los datos que estan ingresados para la fecha: '+string(ld_fecha,'dd/mm/yyyy')+'~n  Desea Proseguir?',Question!,YesNo!,1)) = 2 then return

choose case idw_actual.dataobject
		
	case 'd_abc_comision_fija_det'
		lstr_parametros.string1 = 'CF'
	case 'd_abc_comision_cobertura_det'
		lstr_parametros.string1 = 'CC'
	case 'd_abc_comision_producto_det'
		lstr_parametros.string1 = 'CP'
end choose

openwithparm(w_ve020_comisiones_det,lstr_parametros)

if isnull(message.stringparm) or string(message.stringparm) = '1' then
	messagebox('Aviso','Error al momento de hacer la copia')
else
	messagebox('Aviso','Copia Realizada con Exito')
end if
end event

on w_ve020_comisiones.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_comisiones" then this.MenuID = create m_mantenimiento_comisiones
this.dw_lista=create dw_lista
this.st_1=create st_1
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_lista
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.tab_1
end on

on w_ve020_comisiones.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_lista)
destroy(this.st_1)
destroy(this.tab_1)
end on

event ue_open_pre;//Override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton   

dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)
idw_1 = dw_master              			// asignar dw corriente
dw_detail.BorderStyle = StyleLowered! 	// indicar dw_detail como no activado
dw_master.of_protect()         			// bloquear modificaciones 

dw_master.retrieve()

of_position_window(50,50)

idw_actual = idw_fija

dw_lista.settransobject( sqlca )
dw_lista.retrieve( )

idw_fija = tab_1.fija.dw_fija
idw_cobertura = tab_1.cobertura.dw_cobertura
idw_producto  = tab_1.producto.dw_producto

//Protegiendo DW
idw_cobertura.object.cod_art.protect = '1'
idw_cobertura.object.porc_vnt_clt.protect = '1'
idw_cobertura.object.cant_vnt.protect = '1'
idw_cobertura.object.importe.protect = '1'

idw_producto.object.cod_art.protect = '1'
idw_producto.object.vendedor.protect = '1'
idw_producto.object.cantidad.protect = '1'
idw_producto.object.importe.protect = '1'

idw_fija.object.porc_cuota.protect = '1'
idw_fija.object.importe.protect = '1'

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

date ld_fecha, ld_fecha_ini

//Validacion para comision fija
if idw_fija.rowcount( ) > 0 then
		
	ld_fecha = date(idw_fija.object.fecha_ini[1])
	
	select max(fecha_ini)
	  into :ld_fecha_ini
	  from comision_fija;
	 
	if ld_fecha_ini > ld_fecha then
		ib_update_check = false
		messagebox('Aviso','No se pueden Modificar Comisiones una vez que ya han caducado')
		return
	end if
	ib_update_check = true
	
end if

//Validacion para comision cobertura
if idw_cobertura.rowcount( ) > 0 then
		
	ld_fecha = date(idw_cobertura.object.fecha_ini[1])
	
	select max(fecha_ini)
	  into :ld_fecha_ini
	  from comision_cobertura;
	 
	if ld_fecha_ini > ld_fecha then
		ib_update_check = false
		messagebox('Aviso','No se pueden Modificar Comisiones una vez que ya han caducado')
		return
	end if
	ib_update_check = true
	
end if

//Validacion para comision producto
if idw_producto.rowcount( ) > 0 then
	
	ld_fecha = date(idw_producto.object.fecha_ini[1])
	
	select max(fecha_ini)
	  into :ld_fecha_ini
	  from comision_producto;
	 
	if ld_fecha_ini > ld_fecha then
		ib_update_check = false
		messagebox('Aviso','No se pueden Modificar Comisiones una vez que ya han caducado')
		return
	end if
	ib_update_check = true
	
end if
end event

event ue_modify;call super::ue_modify;dw_master.of_protect()

//Des - Protegiendo DW
if idw_cobertura.object.cod_art.protect = '1' then
	idw_cobertura.object.cod_art.protect = '0'
	idw_cobertura.object.porc_vnt_clt.protect = '0'
	idw_cobertura.object.cant_vnt.protect = '0'
	idw_cobertura.object.importe.protect = '0'
else
	idw_cobertura.object.cod_art.protect = '1'
	idw_cobertura.object.porc_vnt_clt.protect = '1'
	idw_cobertura.object.cant_vnt.protect = '1'
	idw_cobertura.object.importe.protect = '1'
end if

if idw_producto.object.cod_art.protect = '1' then
	idw_producto.object.cod_art.protect = '0'
	idw_producto.object.vendedor.protect = '0'
	idw_producto.object.cantidad.protect = '0'
	idw_producto.object.importe.protect = '0'
else
	idw_producto.object.cod_art.protect = '1'
	idw_producto.object.vendedor.protect = '1'
	idw_producto.object.cantidad.protect = '1'
	idw_producto.object.importe.protect = '1'
end if	

if idw_fija.object.porc_cuota.protect = '1' then
	idw_fija.object.porc_cuota.protect = '0'
	idw_fija.object.importe.protect = '0'
else
	idw_fija.object.porc_cuota.protect = '1'
	idw_fija.object.importe.protect = '1'
end if
end event

event ue_set_access;call super::ue_set_access;//Bloqueo del menu insertar para nuevos registros.
THIS.MenuID.item[1].item[1].item[2].enabled = FALSE
end event

event resize;//Override

dw_lista.height = newheight - dw_lista.y

dw_master.width = newwidth - dw_master.x
dw_master.height = (newheight / 4 ) - dw_master.y

tab_1.width = newwidth - tab_1.x
tab_1.height = (newheight / 4) * 3
tab_1.y = dw_master.height + dw_master.y + 10

idw_fija.width = tab_1.width - 69
idw_fija.height = tab_1.height - 156

idw_cobertura.width = tab_1.width - 69
idw_cobertura.height = tab_1.height - 156

idw_producto.width = tab_1.width - 69
idw_producto.height = tab_1.height - 156
end event

event ue_update;//Override

Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_fija.AcceptText()
idw_cobertura.AcceptText()
idw_producto.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
//	IF dw_master.Update() = -1 then		// Grabacion del Master
//		lbo_ok = FALSE
//		ROLLBACK USING SQLCA;
//		ls_msg = "Se ha procedido al rollback"
//		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
//	END IF
//END IF

IF lbo_ok = TRUE THEN
	IF idw_fija.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

if lbo_ok = true then
	if idw_cobertura.update( ) = -1 then
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

if lbo_ok = true then
	if idw_producto.update( ) = -1 then
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	lbo_ok = dw_master.of_save_log()
	lbo_ok = dw_detail.of_save_log()
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()

	f_mensaje("Grabacion realizada satisfactoriamente", "")
END IF
end event

event ue_delete;//Override
Long  ll_row

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

idw_actual.deleterow( idw_actual.getrow() )


end event

type dw_master from w_abc_mastdet`dw_master within w_ve020_comisiones
integer x = 695
integer y = 32
integer width = 2126
integer height = 516
string dataobject = "d_abc_canal_distribucion"
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

event dw_master::clicked;//Override
idw_1 = dw_detail

if row = 0 then return

is_canal = string(this.object.canal[row])

if dw_lista.rowcount( ) > 0 then
	id_fecha_ini = date(dw_lista.object.fecha_ini[dw_lista.getrow()])
else
	messagebox('Aviso','No ha selecionado una fecha valida')
end if

idw_fija.retrieve( is_canal , id_fecha_ini)
idw_cobertura.retrieve( is_canal , id_fecha_ini)
idw_producto.retrieve( is_canal , id_fecha_ini)
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve020_comisiones
event ue_insert_new ( )
boolean visible = false
integer x = 722
integer y = 1384
integer width = 2048
integer height = 200
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

ii_ss = 1
end event

event dw_detail::ue_insert;//Override

integer li_rpta
long ll_i, ll_row

if dw_master.rowcount( ) > 0 then

	li_rpta = messagebox('Aviso','Insertar un Nuevo registro hara que el otro periodo de Comisiones Termine, ~n Desea Ingresar un nuevo Periodo de Comisiones', Question!, YesNo!, 1)
	
	if li_rpta = 2 then return 1
	
	date ld_fecha_fin
	
	ld_fecha_fin = date(today())

	IF dw_master.Update() = -1 then		// Grabacion del Master
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
	
	COMMIT using SQLCA;
	
	update comision_fija
	   set fecha_fin = :ld_fecha_fin
	 where fecha_ini = :id_fecha_ini;
	 
	 if sqlca.sqlcode = 0 then
		commit using sqlca;
	else
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
	
end if

dw_lista.retrieve( )
	
ll_row = dw_lista.insertrow( 0 )
	
dw_lista.scrolltorow(ll_row)
	
dw_lista.object.fecha_ini[ll_row] = date(relativedate(ld_fecha_fin,1))
	
id_fecha_ini = date(relativedate(ld_fecha_fin,1))
	
is_canal	= dw_master.object.canal[dw_master.getrow( )]

this.retrieve( is_canal, id_fecha_ini )
	
this.event ue_insert_new()

if this.object.porc_cuota.protect = '1' then
	dw_detail.of_protect( )
end if

return 1
end event

event dw_detail::itemchanged;call super::itemchanged;if row = 0 then return

this.object.cod_usr[row] = gs_user

end event

event dw_detail::clicked;call super::clicked;idw_actual = this
end event

type dw_lista from datawindow within w_ve020_comisiones
integer x = 37
integer y = 224
integer width = 635
integer height = 1380
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_abc_lista_fechas_vendedor_cuota"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;f_select_current_row(this)
end event

event clicked;
if row = 0 then return

id_fecha_ini = date(this.object.fecha_ini[row])

if dw_master.rowcount( ) > 0 then

	is_canal		 = string(dw_master.object.canal[dw_master.getrow()])
	
else
	
	messagebox('Aviso','No ha seleccionado un Canal de Distribucion Valido')
	
end if

idw_fija.retrieve( is_canal , id_fecha_ini)
idw_cobertura.retrieve( is_canal , id_fecha_ini)
idw_producto.retrieve( is_canal , id_fecha_ini)
end event

type st_1 from statictext within w_ve020_comisiones
integer x = 37
integer y = 32
integer width = 640
integer height = 168
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas sujetas a las cuotas de los Vendedores."
boolean focusrectangle = false
end type

type tab_1 from tab within w_ve020_comisiones
integer x = 695
integer y = 576
integer width = 2126
integer height = 1028
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
fija fija
cobertura cobertura
producto producto
end type

on tab_1.create
this.fija=create fija
this.cobertura=create cobertura
this.producto=create producto
this.Control[]={this.fija,&
this.cobertura,&
this.producto}
end on

on tab_1.destroy
destroy(this.fija)
destroy(this.cobertura)
destroy(this.producto)
end on

event selectionchanged;if newindex = 2 then
	idw_actual = idw_cobertura
elseif newindex = 3 then
	idw_actual = idw_producto
elseif newindex = 1 then
	idw_actual = idw_fija
end if
end event

type fija from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2089
integer height = 900
long backcolor = 79741120
string text = "Comision Fija"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Step!"
long picturemaskcolor = 536870912
dw_fija dw_fija
end type

on fija.create
this.dw_fija=create dw_fija
this.Control[]={this.dw_fija}
end on

on fija.destroy
destroy(this.dw_fija)
end on

type dw_fija from datawindow within fija
integer x = 14
integer y = 16
integer width = 2057
integer height = 864
integer taborder = 10
string title = "none"
string dataobject = "d_abc_comision_fija_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;idw_actual = this
end event

event constructor;settransobject(sqlca)
end event

event itemchanged;if row = 0 then return

this.object.cod_usr[row] = gs_user

end event

event rowfocuschanged;f_select_current_row(this)
end event

type cobertura from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2089
integer height = 900
long backcolor = 79741120
string text = "Comision por Cobertura"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "step!"
long picturemaskcolor = 536870912
dw_cobertura dw_cobertura
end type

on cobertura.create
this.dw_cobertura=create dw_cobertura
this.Control[]={this.dw_cobertura}
end on

on cobertura.destroy
destroy(this.dw_cobertura)
end on

type dw_cobertura from datawindow within cobertura
integer x = 14
integer y = 16
integer width = 2057
integer height = 856
integer taborder = 40
boolean bringtotop = true
string title = "none"
string dataobject = "d_abc_comision_cobertura_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;idw_actual = this
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;if row = 0 then return

if this.object.cod_art.Protect = '1' then return

if dwo.name = 'cod_art' then
		
	String ls_producto
	
	select clase_prod_term
	  into :ls_producto
	  from sig_agricola
	 where reckey = '1';

	str_seleccionar lstr_seleccionar
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT COD_ART AS CODIGO, '&
									 +'NOM_ARTICULO AS DESCRIPCION '&
									 +'FROM ARTICULO '&
									 +"WHERE NVL(FLAG_ESTADO,'1') = '1' "&
									 +"AND COD_CLASE = "+ ls_producto
	
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		this.object.cod_art[row]      = trim( lstr_seleccionar.param1[1])
		this.object.nom_articulo[row] = trim( lstr_seleccionar.param2[1])
	END IF
	
end if
end event

event itemchanged;if row = 0 then return

string ls_desc

this.object.cod_usr[row] = gs_user
	
if dwo.name = 'cod_art' then
	
   select nom_articulo
	  into :ls_desc
	  from articulo
	 where cod_Art = :data;
	
	if ls_desc = '' or isnull(ls_Desc) then
		messagebox('Aviso','Codigo de Articulo no existe')
		setnull(ls_Desc)
		this.object.cod_Art[row] = ls_Desc
		return 1
	end if
	
	this.object.nom_articulo[row] = ls_Desc
	
end if
end event

event rowfocuschanged;f_select_current_row(this)
end event

type producto from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2089
integer height = 900
long backcolor = 79741120
string text = "Comision por Producto"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "step!"
long picturemaskcolor = 536870912
dw_producto dw_producto
end type

on producto.create
this.dw_producto=create dw_producto
this.Control[]={this.dw_producto}
end on

on producto.destroy
destroy(this.dw_producto)
end on

type dw_producto from datawindow within producto
integer x = 14
integer y = 16
integer width = 2039
integer height = 848
integer taborder = 50
boolean bringtotop = true
string title = "none"
string dataobject = "d_abc_comision_producto_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;idw_actual = this
end event

event constructor;settransobject(Sqlca)
end event

event doubleclicked;if row = 0 then return

if this.object.cod_art.Protect = '1' then return

if dwo.name = 'cod_art' then

	String ls_producto
	
	select clase_prod_term
	  into :ls_producto
	  from sig_agricola
	 where reckey = '1';
	
	str_seleccionar lstr_seleccionar
	lstr_seleccionar.s_seleccion = 'S'
	lstr_seleccionar.s_sql = 'SELECT COD_ART AS CODIGO, '&
									 +'NOM_ARTICULO AS DESCRIPCION '&
									 +'FROM ARTICULO '&
									 +"WHERE NVL(FLAG_ESTADO,'1') = '1' "&
									 +"AND COD_CLASE = "+ ls_producto
	
	OpenWithParm(w_seleccionar,lstr_seleccionar)
	
	IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	
	IF lstr_seleccionar.s_action = "aceptar" THEN
		this.object.cod_art[row]      = trim( lstr_seleccionar.param1[1])
		this.object.nom_articulo[row] = trim( lstr_seleccionar.param2[1])
	END IF
	
elseif dwo.name = 'vendedor' then
	
	str_parametros sl_param
	
	sl_param.dw1 = "d_lista_vendedor_x_canal"
	sl_param.titulo = "Analisis"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2
	sl_param.retrieve = 'S'
	sl_param.tipo = '1S'
	sl_param.string1 = is_canal

	OpenWithParm( w_lista, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	if sl_param.titulo <> 'n' then		
		this.object.vendedor[row] = sl_param.field_ret[1]
		this.object.nombre[row] = sl_param.field_ret[2]
	END IF		
	
end if
end event

event itemchanged;if row = 0 then return

string ls_desc

this.object.cod_usr[row] = gs_user
	
if dwo.name = 'cod_art' then
	
   select nom_articulo
	  into :ls_desc
	  from articulo
	 where cod_Art = :data;
	
	if ls_desc = '' or isnull(ls_Desc) then
		messagebox('Aviso','Codigo de Articulo no existe')
		setnull(ls_Desc)
		this.object.cod_Art[row] = ls_Desc
		return 1
	end if
	
	this.object.nom_articulo[row] = ls_Desc
	
elseif dwo.name = 'vendedor' then
	
	select nombre
	  into :ls_desc
	  from usuario
	 where cod_usr = :data;
	
	if ls_desc = '' or isnull(ls_Desc) then
		messagebox('Aviso','Codigo de Vendedor no existe')
		setnull(ls_Desc)
		this.object.vendedor[row] = ls_Desc
		return 1
	end if
	
	this.object.nombre[row] = ls_Desc
	
end if
end event

event rowfocuschanged;f_select_current_row(this)
end event

