$PBExportHeader$w_pr020_prod_grupo_beneficio.srw
forward
global type w_pr020_prod_grupo_beneficio from w_abc_master
end type
type st_cb from statictext within w_pr020_prod_grupo_beneficio
end type
type tab_1 from tab within w_pr020_prod_grupo_beneficio
end type
type tabpage_1 from userobject within tab_1
end type
type uo_search1 from n_cst_search within tabpage_1
end type
type dw_articulo from u_dw_abc within tabpage_1
end type
type st_a from statictext within tabpage_1
end type
type tabpage_1 from userobject within tab_1
uo_search1 uo_search1
dw_articulo dw_articulo
st_a st_a
end type
type tabpage_2 from userobject within tab_1
end type
type uo_search2 from n_cst_search within tabpage_2
end type
type dw_sub_producto from u_dw_abc within tabpage_2
end type
type st_s from statictext within tabpage_2
end type
type tabpage_2 from userobject within tab_1
uo_search2 uo_search2
dw_sub_producto dw_sub_producto
st_s st_s
end type
type tabpage_3 from userobject within tab_1
end type
type uo_search3 from n_cst_search within tabpage_3
end type
type dw_cencos from u_dw_abc within tabpage_3
end type
type st_c from statictext within tabpage_3
end type
type tabpage_3 from userobject within tab_1
uo_search3 uo_search3
dw_cencos dw_cencos
st_c st_c
end type
type tab_1 from tab within w_pr020_prod_grupo_beneficio
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_pr020_prod_grupo_beneficio from w_abc_master
integer width = 4425
integer height = 3120
string title = "[PR020] Maestro de Centros de Beneficio"
string menuname = "m_mantto_consulta"
st_cb st_cb
tab_1 tab_1
end type
global w_pr020_prod_grupo_beneficio w_pr020_prod_grupo_beneficio

type variables
u_dw_abc			idw_articulo, idw_cencos, idw_sub_producto
StaticText		ist_a, ist_c, ist_s
n_cst_search	iuo_search1, iuo_search2, iuo_search3
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_articulo 		= tab_1.tabpage_1.dw_articulo
idw_sub_producto	= tab_1.tabpage_2.dw_sub_producto
idw_cencos			= tab_1.tabpage_3.dw_cencos

ist_a 		= tab_1.tabpage_1.st_a
ist_s			= tab_1.tabpage_2.st_s
ist_c			= tab_1.tabpage_3.st_c

iuo_search1	= tab_1.tabpage_1.uo_search1
iuo_search2	= tab_1.tabpage_2.uo_search2
iuo_search3	= tab_1.tabpage_3.uo_search3
end subroutine

on w_pr020_prod_grupo_beneficio.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_cb=create st_cb
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_cb
this.Control[iCurrent+2]=this.tab_1
end on

on w_pr020_prod_grupo_beneficio.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_cb)
destroy(this.tab_1)
end on

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String   ls_cod_cert

dw_master.AcceptText()
idw_articulo.AcceptText()
idw_cencos.AcceptText()
idw_sub_producto.Accepttext( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Para el log diario
IF ib_log THEN
	dw_master.of_create_log()
	idw_articulo.of_create_log()
	idw_cencos.of_create_log()
	idw_sub_producto.of_create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF


IF	idw_articulo.ii_update = 1 THEN
	IF idw_articulo.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Articulo')
	END IF
END IF

IF	idw_cencos.ii_update = 1 THEN
	IF idw_cencos.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Cencos')
	END IF
END IF

IF	idw_sub_producto.ii_update = 1 THEN
	IF idw_sub_producto.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar El Sub Producto')
	END IF
END IF

//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		idw_articulo.of_save_log()
		idw_cencos.of_save_log()
		idw_sub_producto.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
		
	dw_master.ii_update = 0
	idw_articulo.ii_update = 0
	idw_cencos.ii_update = 0
	idw_sub_producto.ii_update = 0
	
		
	dw_master.ii_protect = 0
	idw_articulo.ii_protect = 0
	idw_cencos.ii_protect = 0
	idw_sub_producto.ii_protect = 0
	
	
	dw_master.of_protect( )
	idw_articulo.of_protect()
	idw_cencos.of_protect()
	idw_sub_producto.of_protect()
			
	is_action = 'open'
	
	f_mensaje("Cambios Guardados satisfactoriamente", "")
	
END IF
	

end event

event ue_open_pre;call super::ue_open_pre;
long 		ll_row
string 	ls_cod_centro
ib_log = TRUE

of_Asigna_dws()        		

idw_1.Retrieve()

// bloquear modificaciones 
idw_articulo.SetTransObject(sqlca)
idw_articulo.ii_protect = 0
idw_articulo.of_protect()

idw_cencos.SetTransObject(sqlca)
idw_cencos.ii_protect = 0
idw_cencos.of_protect()

idw_sub_producto.SetTransObject(sqlca)
idw_sub_producto.ii_protect = 0
idw_sub_producto.of_protect()

iuo_search1.of_set_dw(idw_articulo)
iuo_search2.of_set_dw(idw_sub_producto)
iuo_search3.of_set_dw(idw_cencos)

end event

event resize;//Override
of_Asigna_dws()  

dw_master.width  = newwidth  - dw_master.x - 10
st_cb.x = dw_master.X
st_cb.width = dw_master.width

tab_1.width  = newwidth - tab_1.x - 10
tab_1.height = newheight  - tab_1.y - 10


idw_articulo.width  	= tab_1.tabpage_1.width  - idw_articulo.x - 10
idw_articulo.height 	= tab_1.tabpage_1.height  - idw_articulo.y - 10
ist_a.x 					= idw_articulo.x
ist_a.width 			= idw_articulo.width
iuo_search1.width		= idw_articulo.width
iuo_search1.event ue_resize(sizetype, iuo_search1.width, newheight)

idw_sub_producto.width  = tab_1.tabpage_2.width  - idw_sub_producto.x - 10
idw_sub_producto.height = tab_1.tabpage_2.height  - idw_sub_producto.y - 10
ist_s.x 						= idw_sub_producto.x
ist_s.width 				= idw_sub_producto.width
iuo_search2.width			= idw_sub_producto.width
iuo_search2.event ue_resize(sizetype, iuo_search2.width, newheight)

idw_cencos.width  = tab_1.tabpage_3.width  - idw_cencos.x - 10
idw_cencos.height = tab_1.tabpage_3.height  - idw_cencos.y - 10
ist_c.x 				= idw_cencos.x
ist_c.width 		= idw_cencos.width
iuo_search3.width	= idw_cencos.width
iuo_search3.event ue_resize(sizetype, iuo_search3.width, newheight)



end event

type dw_master from w_abc_master`dw_master within w_pr020_prod_grupo_beneficio
event ue_display ( string as_columna,  long al_row )
integer y = 80
integer width = 4050
integer height = 1396
string dataobject = "d_abc_prod_centro_beneficio_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta		[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "COD_ORIGEN"

		ls_sql = "SELECT COD_ORIGEN AS CODIGO, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM ORIGEN " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.object.nombre		   [al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'md'			// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 					// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

idw_det  =   idw_articulo
//idw_det  =   dw_cencos
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "cod_planta"
		
		ls_codigo = this.object.cod_planta[row]

		SetNull(ls_data)
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Planta no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_planta	  	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_codigo
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
		case "cod_origen"
		
//		ls_codigo = this.object.cod_origen[row]

//		SetNull(ls_data)
		select nombre
			into :ls_data
		from origen
		where cod_origen = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Origen no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_origen	  	[row] = ls_codigo
			this.object.nombre		[row] = ls_codigo
			return 1
		end if

		this.object.nombre		[row] = ls_data
	
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'
this.object.cod_usr				[al_row] = gs_user


end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado		[this.GetRow()] = '1'
this.object.flag_ventas		[this.GetRow()] = '1'
this.object.flag_estructura[this.GetRow()] = '1'
this.object.flag_fondo		[this.GetRow()] = '1'
Return 1
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_articulo.retrieve( aa_id[1])
idw_cencos.retrieve( aa_id[1])
idw_sub_producto.retrieve( aa_id[1])

end event

type st_cb from statictext within w_pr020_prod_grupo_beneficio
integer width = 4041
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "DETALLE DEL CENTRO BENEFICIO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tab_1 from tab within w_pr020_prod_grupo_beneficio
event create ( )
event destroy ( )
integer y = 1480
integer width = 4270
integer height = 1416
integer taborder = 20
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
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4233
integer height = 1296
long backcolor = 79741120
string text = "ARTICULOS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_search1 uo_search1
dw_articulo dw_articulo
st_a st_a
end type

on tabpage_1.create
this.uo_search1=create uo_search1
this.dw_articulo=create dw_articulo
this.st_a=create st_a
this.Control[]={this.uo_search1,&
this.dw_articulo,&
this.st_a}
end on

on tabpage_1.destroy
destroy(this.uo_search1)
destroy(this.dw_articulo)
destroy(this.st_a)
end on

type uo_search1 from n_cst_search within tabpage_1
integer y = 80
integer taborder = 50
end type

on uo_search1.destroy
call n_cst_search::destroy
end on

type dw_articulo from u_dw_abc within tabpage_1
integer y = 172
integer width = 2917
integer height = 888
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_prod_centro_benef_art_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 				dw_master
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "cod_art"
		
		SetNull(ls_data)
		select desc_art
			into :ls_data
		from articulo
		where cod_art = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Articulo no existe o no esta activo", StopSign!)
			SetNull(data)
			this.object.cod_art	  	[row] = data
			this.object.desc_art		[row] = data
			return 1
		end if

		this.object.desc_art			[row] = ls_data

end choose
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master, ll_detail
string 	ls_nro_parte, ls_grupo

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox('Modulo de Produccion','Primero debe de definri un Centro Feneficio')
	return
end if


end event

event ue_display;string 	ls_codigo, ls_Data, ls_und, ls_sql
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "COD_ART"

		ls_sql = "SELECT COD_ART AS CODIGO_ART, " &
				  + "DESC_ART AS DESCRIPCION, " &
				  + "und as unidad " &
				  + "FROM ARTICULO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, '2') then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.desc_art		[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			this.ii_update = 1
		end if					
end choose
end event

type st_a from statictext within tabpage_1
integer width = 2190
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "ARTICULO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4233
integer height = 1296
long backcolor = 79741120
string text = "SUB PRODUCTOS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_search2 uo_search2
dw_sub_producto dw_sub_producto
st_s st_s
end type

on tabpage_2.create
this.uo_search2=create uo_search2
this.dw_sub_producto=create dw_sub_producto
this.st_s=create st_s
this.Control[]={this.uo_search2,&
this.dw_sub_producto,&
this.st_s}
end on

on tabpage_2.destroy
destroy(this.uo_search2)
destroy(this.dw_sub_producto)
destroy(this.st_s)
end on

type uo_search2 from n_cst_search within tabpage_2
integer y = 80
integer taborder = 60
end type

on uo_search2.destroy
call n_cst_search::destroy
end on

type dw_sub_producto from u_dw_abc within tabpage_2
integer y = 172
integer width = 2939
integer height = 952
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_abc_prod_centro_benef_sub_p_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 				dw_master
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "cod_art"
		
		SetNull(ls_data)
		select desc_art
			into :ls_data
		from articulo
		where cod_art = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Articulo no existe o no esta activo", StopSign!)
			SetNull(data)
			this.object.cod_art	  	[row] = data
			this.object.desc_art		[row] = data
			return 1
		end if

		this.object.desc_art			[row] = ls_data

end choose
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master, ll_detail
string 	ls_nro_parte, ls_grupo

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox('Modulo de Produccion','Primero debe de definri un Centro Feneficio')
	return
end if


end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
 	case "COD_ART"

		ls_sql = "SELECT COD_ART AS CODIGO_ART, " &
				  + "DESC_ART AS DESCRIPCION " &
				  + "FROM ARTICULO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art		[al_row] = ls_codigo
			this.object.desc_art		   [al_row] = ls_data
			this.ii_update = 1
		end if
			
end choose
end event

type st_s from statictext within tabpage_2
integer y = 4
integer width = 2190
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "SUB - PRODUCTO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type tabpage_3 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 4233
integer height = 1296
long backcolor = 79741120
string text = "CENTROS DE COSTOS"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
uo_search3 uo_search3
dw_cencos dw_cencos
st_c st_c
end type

on tabpage_3.create
this.uo_search3=create uo_search3
this.dw_cencos=create dw_cencos
this.st_c=create st_c
this.Control[]={this.uo_search3,&
this.dw_cencos,&
this.st_c}
end on

on tabpage_3.destroy
destroy(this.uo_search3)
destroy(this.dw_cencos)
destroy(this.st_c)
end on

type uo_search3 from n_cst_search within tabpage_3
integer y = 80
integer taborder = 60
end type

on uo_search3.destroy
call n_cst_search::destroy
end on

type dw_cencos from u_dw_abc within tabpage_3
integer y = 164
integer width = 3109
integer height = 1020
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_abc_prod_centro_benef_cencos_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	         // columnas que recibimos del master

idw_mst  = 				dw_master
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 				= THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	
	case "cencos"
		
		SetNull(ls_data)
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Articulo no existe o no esta activo", StopSign!)
			SetNull(data)
			this.object.cencos	  	[row] = data
			this.object.desc_cencos		[row] = data
			return 1
		end if

		this.object.desc_cencos			[row] = ls_data

end choose
end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master, ll_detail
string 	ls_nro_parte, ls_grupo

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox('Modulo de Produccion','Primero debe de definri un Centro Feneficio')
	return
end if



end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//sg_parametros sl_param

choose case upper(as_columna)
		
		case "CENCOS"

		ls_sql = "SELECT CENCOS AS CODIGO_CENCOS, " &
				  + "DESC_CENCOS AS DESCRIPCION " &
				  + "FROM CENTROS_COSTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos			[al_row] = ls_codigo
			this.object.desc_cencos		[al_row] = ls_data
			this.ii_update = 1
		end if					
end choose
end event

type st_c from statictext within tabpage_3
integer width = 2295
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 16711680
string text = "CENTROS DE COSTO"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

