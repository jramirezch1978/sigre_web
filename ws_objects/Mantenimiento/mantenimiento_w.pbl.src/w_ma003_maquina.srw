$PBExportHeader$w_ma003_maquina.srw
forward
global type w_ma003_maquina from w_abc
end type
type tab_1 from tab within w_ma003_maquina
end type
type tabpage_1 from userobject within tab_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_master dw_master
end type
type tabpage_3 from userobject within tab_1
end type
type dw_dettec from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_dettec dw_dettec
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_5 from userobject within tab_1
end type
type dw_repuestos from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_repuestos dw_repuestos
end type
type tabpage_4 from userobject within tab_1
end type
type dw_doctec from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_doctec dw_doctec
end type
type tab_1 from tab within w_ma003_maquina
tabpage_1 tabpage_1
tabpage_3 tabpage_3
tabpage_2 tabpage_2
tabpage_5 tabpage_5
tabpage_4 tabpage_4
end type
end forward

global type w_ma003_maquina from w_abc
integer width = 3845
integer height = 2380
string title = "Maestro de Maquinas o Equipos (MA003)"
string menuname = "m_abc_master_list"
boolean maxbox = false
boolean resizable = false
boolean ib_log = false
tab_1 tab_1
end type
global w_ma003_maquina w_ma003_maquina

type variables
String is_accion
u_dw_abc				idw_master, idw_detail, idw_dettec, idw_doctec, idw_repuestos
ListView				ilv_iconos
end variables

forward prototypes
public subroutine of_retrieve (string as_cod_maquina)
public subroutine of_open ()
public subroutine of_load_iconos ()
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_retrieve (string as_cod_maquina);Long ll_icono
//of_load_iconos()

idw_master.Retrieve(as_cod_maquina)
idw_detail.Retrieve(as_cod_maquina)
idw_repuestos.Retrieve(as_cod_maquina)

idw_master.ShareData(idw_dettec)
idw_master.ShareData(idw_doctec)


idw_master.ii_protect = 0
idw_master.of_protect()

idw_detail.ii_protect = 0
idw_detail.of_protect()

idw_dettec.ii_protect = 0
idw_dettec.of_protect()

idw_doctec.ii_protect = 0
idw_doctec.of_protect()

idw_repuestos.ii_protect = 0
idw_repuestos.of_protect()

idw_master.ii_update = 0
idw_detail.ii_update = 0
idw_dettec.ii_update = 0
idw_doctec.ii_update = 0
idw_repuestos.ii_update = 0


idw_1 = idw_master
idw_master.Setfocus()
idw_master.TriggerEvent(clicked!)


is_accion = 'fileopen'


end subroutine

public subroutine of_open ();String ls_cod_maquina

SELECT cod_maquina
INTO   :ls_cod_maquina
FROM   maquina
WHERE  rownum = 1 ;

IF Isnull(ls_cod_maquina) OR Trim(ls_cod_maquina) = '' THEN
	Trigger Event ue_insert()
ELSE
	of_retrieve(ls_cod_maquina)
END IF

end subroutine

public subroutine of_load_iconos ();// Verifica estado de acceso
/*Long    ll_j, ll_total_iconos, li_pict
String  ls_icono, ls_titulo

ll_total_iconos = Long(ProfileString(gs_inifile, "ICONOS", "TOTAL", "20"))

ilv_iconos.DeleteLargePictures()
ilv_iconos.DeleteItems()
is_iconos[] 	= is_null[]
is_titulos[]	= is_null[]

For ll_j = 1 to ll_total_iconos
	ls_icono  = ProfileString(gs_inifile, "ICONOS", string(ll_j), "")
	ls_titulo = ProfileString(gs_inifile, "ICONOS", 'Titulo' + string(ll_j), "")
	is_iconos[ll_j] = ls_icono
	is_titulos[ll_j] = ls_titulo
	if Trim(ls_icono) <> '' then
		li_pict = ilv_iconos.AddLargePicture(ls_icono)  	
		ilv_iconos.insertitem (ll_j, ls_titulo, li_pict)
	end if
Next*/
end subroutine

public subroutine of_asigna_dws ();idw_detail 		= tab_1.tabpage_2.dw_detail
idw_master 		= tab_1.tabpage_1.dw_master
idw_dettec 		= tab_1.tabpage_3.dw_dettec
idw_doctec 		= tab_1.tabpage_4.dw_doctec
idw_repuestos	= tab_1.tabpage_5.dw_repuestos
end subroutine

on w_ma003_maquina.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_ma003_maquina.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_master.SetTransObject(sqlca)  // Relacionar el dw con la base de datos
idw_dettec.SetTransObject(sqlca)
idw_detail.SetTransObject(sqlca)
idw_doctec.SetTransObject(sqlca)
idw_repuestos.SetTransObject(sqlca)

idw_master.sharedata(idw_dettec)
idw_master.sharedata(idw_doctec)

idw_1 = idw_master              	// asignar dw corriente

idw_master.of_protect()         	// bloquear modificaciones 

of_position_window(0,0)       	// Posicionar la ventana en forma fija
//ii_help = 101           			// help topic
of_open()

ib_log = TRUE

end event

event ue_retrieve_list;call super::ue_retrieve_list;
//override
// Asigna valores a estructura 
str_parametros sl_param

//of_asignar_dws()

TriggerEvent ('ue_update_request')	

sl_param.dw1    = 'd_lista_maquinas_tbl'
sl_param.titulo = 'Listado de Maquinas y equipos'
sl_param.field_ret_i[1] = 1	//Código de Maq

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF


end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = idw_master  THEN
	
	TriggerEvent ('ue_update_request')		
	
	idw_master.Reset()
	idw_dettec.Reset()
	idw_detail.Reset()
	idw_repuestos.Reset()
	
	
	idw_master.ResetUpdate()
	idw_dettec.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_repuestos.ResetUpdate()
	
	idw_master.ii_update = 0
	idw_dettec.ii_update = 0
	idw_detail.ii_update = 0
	idw_repuestos.ii_update = 0
	
	is_accion = 'new'
	
ELSEIF idw_1 = idw_doctec OR idw_1 = idw_dettec then
	
	MessageBox('Aviso', 'En esta opción no puede insertar registro', StopSign!)
	return
	
END IF
	
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_modify;call super::ue_modify;String 	ls_comand
Integer 	li_protect

idw_master.of_protect()
idw_detail.of_protect()
idw_dettec.of_protect()
idw_doctec.of_protect()

IF is_accion = 'new'	THEN
	idw_master.object.cod_maquina.Protect = '0'
ELSE
	idw_master.object.cod_maquina.Protect = '1'
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_master.ii_update = 1 OR &
	idw_detail.ii_update = 1 OR &
	idw_dettec.ii_update = 1 OR &
	idw_doctec.ii_update = 1 OR &
	idw_repuestos.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		
		idw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_dettec.ii_update = 0
		idw_doctec.ii_update = 0
		idw_repuestos.ii_update = 0
		
		idw_master.ResetUpdate()
		idw_detail.ResetUpdate()
		idw_dettec.ResetUpdate()
		idw_doctec.ResetUpdate()
		idw_repuestos.ResetUpdate()
		
		
	END IF
END IF

end event

event ue_update;Boolean 	lbo_ok = TRUE
String 	ls_msg

idw_master.AcceptText()
idw_detail.AcceptText()
idw_doctec.AcceptText()
idw_dettec.AcceptText()
idw_repuestos.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	idw_master.of_create_log()
	idw_detail.of_create_log()
	idw_doctec.of_create_log()
	idw_dettec.of_create_log()
	idw_repuestos.of_create_log()
END IF

IF	idw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Configuracion", ls_msg, StopSign!)
	END IF
END IF


IF idw_doctec.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_doctec.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Documentación tecnica", ls_msg, StopSign!)
	END IF
END IF


IF idw_dettec.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_dettec.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Datos Tecnica", ls_msg, StopSign!)
	END IF
END IF


IF idw_repuestos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_repuestos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Respuestos", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = idw_master.of_save_log()
		lbo_ok = idw_detail.of_save_log()
		lbo_ok = idw_doctec.of_save_log()
		lbo_ok = idw_dettec.of_save_log()
		lbo_ok = idw_repuestos.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	idw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_doctec.ii_update = 0
	idw_dettec.ii_update = 0
	idw_repuestos.ii_update = 0
	
	idw_master.il_totdel = 0
	idw_detail.il_totdel = 0
	idw_doctec.il_totdel = 0
	idw_dettec.il_totdel = 0
	idw_repuestos.il_totdel = 0
	
	idw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_doctec.ResetUpdate()
	idw_dettec.ResetUpdate()
	idw_repuestos.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF


end event

event ue_update_pre;String ls_cod_maquina
Long   ll_inicio

of_Asigna_dws()

ib_update_check = false

IF is_accion = 'delete'  THEN RETURN

ls_cod_maquina = idw_master.Object.cod_maquina[1]

IF Isnull(ls_cod_maquina) OR Trim(ls_cod_maquina) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Maqina', StopSign!)
	ib_update_check = FALSE
	idw_master.SetColumn('cod_maquina')
	RETURN
END IF

if gnvo_app.of_row_Processing(idw_master) <> true then return
if gnvo_app.of_row_Processing(idw_detail) <> true then return
if gnvo_app.of_row_Processing(idw_dettec) <> true then return
if gnvo_app.of_row_Processing(idw_doctec) <> true then return
if gnvo_app.of_row_Processing(idw_repuestos) <> true then return


FOR ll_inicio = 1 TO idw_detail.Rowcount()
	IF Isnull(idw_detail.object.cod_maquina [ll_inicio]) OR &
		Trim(idw_detail.object.cod_maquina [ll_inicio]) = '' THEN
		
		 idw_detail.object.cod_maquina [ll_inicio] = ls_cod_maquina
		 
	 END IF
NEXT	

FOR ll_inicio = 1 TO idw_repuestos.Rowcount()
	idw_repuestos.object.cod_maquina [ll_inicio] = ls_cod_maquina
NEXT	


if idw_master.GetRow() = 0 then
	ib_update_check = false
	return
end if

idw_master.object.doc_Tecnica[idw_master.GetRow()] = idw_doctec.object.doc_tecnica[idw_doctec.GetRow()]
idw_dettec.object.doc_Tecnica[idw_master.GetRow()] = idw_doctec.object.doc_tecnica[idw_doctec.GetRow()]	

idw_master.of_set_flag_replicacion( )
idw_detail.of_set_flag_replicacion( )
idw_dettec.of_set_flag_replicacion( )
idw_doctec.of_set_flag_replicacion( )
idw_repuestos.of_set_flag_replicacion( )

ib_update_check = true
end event

event ue_delete_pos;call super::ue_delete_pos;IF idw_1 = idw_master THEN
	is_accion = 'delete' 
END IF
end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_master.width  = tab_1.width  - idw_master.x - 50
idw_master.height = tab_1.height - idw_master.y - 150

idw_detail.width  = tab_1.width  - idw_detail.x - 50
idw_detail.height = tab_1.height - idw_detail.y - 150

idw_dettec.width  = tab_1.width  - idw_dettec.x - 50
idw_dettec.height = tab_1.height - idw_dettec.y - 150

idw_doctec.width  = tab_1.width  - idw_doctec.x - 50
idw_doctec.height = tab_1.height - idw_doctec.y - 100

idw_repuestos.width  = tab_1.width  - idw_repuestos.x - 50
idw_repuestos.height = tab_1.height - idw_repuestos.y - 100


idw_doctec.object.doc_tecnica.width = string(idw_doctec.width &
	- Integer(idw_doctec.object.doc_tecnica.X) - 50 )
	
idw_doctec.object.doc_tecnica.height = string(idw_doctec.height &
	- Integer(idw_doctec.object.doc_tecnica.y) - 50 )
		
end event

event open;//Override
of_asigna_dws()

IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

type tab_1 from tab within w_ma003_maquina
event create ( )
event destroy ( )
integer width = 3808
integer height = 2120
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean pictureonright = true
alignment alignment = center!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_3 tabpage_3
tabpage_2 tabpage_2
tabpage_5 tabpage_5
tabpage_4 tabpage_4
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_3=create tabpage_3
this.tabpage_2=create tabpage_2
this.tabpage_5=create tabpage_5
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_3,&
this.tabpage_2,&
this.tabpage_5,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_3)
destroy(this.tabpage_2)
destroy(this.tabpage_5)
destroy(this.tabpage_4)
end on

type tabpage_1 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 3771
integer height = 2000
long backcolor = 79741120
string text = "Datos Generales :"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_master dw_master
end type

on tabpage_1.create
this.dw_master=create dw_master
this.Control[]={this.dw_master}
end on

on tabpage_1.destroy
destroy(this.dw_master)
end on

type dw_master from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer y = 16
integer width = 3694
integer height = 1548
integer taborder = 20
string dataobject = "d_abc_maquina_ff"
boolean vscrollbar = false
end type

event ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
long ll_count
str_seleccionar lstr_seleccionar

datawindowchild idw_child

CHOOSE CASE lower(as_columna)
	CASE 'proveedor'
		ls_sql = 'SELECT PROVEEDOR AS CODIGO, ' &   
				 + 'NOM_PROVEEDOR AS NOMBRE_O_RAZON_SOCIAL, ' &
				 +	'RUC AS RUC ' &
				 + 'FROM PROVEEDOR '
												
		lb_ret = f_lista(ls_sql, ls_codigo,ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor 	[al_row] = ls_data
			this.ii_update = 1
		end if

	CASE 'cod_origen'
		ls_sql = 'SELECT cod_origen AS CODIGO_origen, '&   
				 + 'nombre AS nombre_origen '&
				 +	'FROM ORIGEN ' &
				 + "where flag_estado = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	CASE 'cencos'
		ls_sql = "SELECT CENCOS AS CENTRO_COSTO, "&   
				 + "DESC_CENCOS AS DESCRIPCION "&
				 + "FROM CENTROS_COSTO " &
				 + "WHERE FLAG_ESTADO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos 		[al_row] = ls_codigo
			this.object.desc_cencos [al_row] = ls_data
			this.ii_update = 1
		END IF
	
	case 'agruphor'
		ls_sql = "SELECT AGRUPHOR AS CODIGO_AGRUPHOR, "&   
				 + "DESCR_AGRUPHOR AS DESCRIPCION_AGRUPHOR "&
				 + "FROM MT_AGRUPHOR " &
				 + "WHERE ORIGEN = '" + gs_origen+ "'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.agruphor 		[al_row] = ls_codigo
			this.object.desc_agruphor 	[al_row] = ls_data
			this.ii_update = 1
		END IF

	case 'und'
		ls_sql = "select und as codigo, " &
		       + " desc_unidad as descripcion " &
				 + "from unidad"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		if ls_codigo <> '' then
			this.object.und			[al_row] = ls_codigo
			this.object.desc_unidad	[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'cod_marca'
		
		ls_sql = "select cod_marca as codigo_marca, " &
				 + "nom_marca as descripcion_marca " &
				 + "from marca"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_marca[al_row] = ls_codigo
			this.object.nom_marca[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'color'
		ls_sql = "select color as codigo_color, " &
				 + "descripcion as descripcion_color " &
				 + "from color "
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.color			[al_row] = ls_codigo
			this.object.desc_color	[al_row] = ls_data
			this.ii_update = 1
		end if

END CHOOSE

end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 2			// columnas de lectrua de este dw
ii_dk[1] = 2			// columnas que se pasan al detalle

idw_mst = tab_1.tabpage_1.dw_master
idw_det = tab_1.tabpage_2.dw_detail
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_desc, ls_null

SetNull(ls_null)

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'proveedor'
		SELECT nom_proveedor
			INTO :ls_desc
		FROM proveedor
		WHERE proveedor = :data 
		  and flag_estado = '1';
				
		IF SQLCA.SQLCode = 100 THEN
			This.Object.Proveedor 	 [row] = ls_null
			This.Object.nom_Proveedor[row] = ls_null
			Messagebox('Aviso','Proveedor No existe o no esta activo, Verifique!')
			Return 1
		END IF
		
		this.object.nom_proveedor [row] = ls_desc

	CASE 'cencos'
		SELECT DESC_CENCOS 
			into :ls_desc
		from CENTROS_COSTO 
		WHERE FLAG_ESTADO = '1'
		  and cencos = :data;
												
		IF SQLCA.SQLCode = 100 THEN
			This.Object.cencos 	 	[row] = ls_null
			This.Object.desc_cencos	[row] = ls_null
			Messagebox('Aviso','Codigo de Centro de Costo No existe o no esta activo, Verifique!')
			Return 1
		END IF
		
		this.object.desc_cencos [row] = ls_desc
	
	case 'agruphor'
		
		SELECT DESCR_AGRUPHOR 
			into :ls_desc
		FROM MT_AGRUPHOR 
		WHERE ORIGEN 	= :gs_origen
		  and agruphor = :data;
												
		IF SQLCA.SQLCode = 100 THEN
			This.Object.agruphor 	 	[row] = ls_null
			This.Object.desc_agruhor	[row] = ls_null
			Messagebox('Aviso','Codigo de Centro de Costo No existe o no esta activo, Verifique!')
			Return 1
		END IF
		
		this.object.desc_agruphor [row] = ls_desc
		
	case 'und'
		select desc_unidad 
			into :ls_desc
		from unidad
		where und = :data;

		IF SQLCA.SQLCode = 100 THEN
			This.Object.und 	 		[row] = ls_null
			This.Object.desc_unidad	[row] = ls_null
			Messagebox('Aviso','Unidad No existe, Verifique!')
			Return 1
		END IF
		
		this.object.desc_unidad [row] = ls_desc

				 
	case 'cod_marca'
		
		select nom_marca
			into :ls_desc
		from marca
		where cod_marca = :data;

		IF SQLCA.SQLCode = 100 THEN
			This.Object.cod_marca	[row] = ls_null
			This.Object.desc_marca	[row] = ls_null
			Messagebox('Aviso','Codigo de Marca No existe, Verifique!')
			Return 1
		END IF
		
		this.object.desc_marca [row] = ls_desc
		
	case 'color'
		select descripcion
			into :ls_desc
		from color
		where color = :data;

		IF SQLCA.SQLCode = 100 THEN
			This.Object.color			[row] = ls_null
			This.Object.desc_color	[row] = ls_null
			Messagebox('Aviso','Codigo de color No existe, Verifique!')
			Return 1
		END IF
		
		this.object.desc_color [row] = ls_desc

END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
this.object.cod_origen	[al_row] = gs_origen
end event

event buttonclicked;call super::buttonclicked;string ls_docname, ls_named
integer li_value, li_row

This.AcceptText()
If this.ii_protect = 1 then RETURN

li_row = this.GetRow()

choose case upper(dwo.name)
	case "B_IMAGEN"

		li_value = GetFileOpenName("Select File", &
			 + ls_docname, ls_named, "JPG", &
			 + "JPG Files (*.JPG),*.JPG," &
			 + "BMP Files (*.BMP),*.BMP," &
			 + "GIF Files (*.GIF),*.GIF," )
		
		IF li_value = 1 THEN 
			this.object.file_imagen[li_row] = ls_docname
			this.ii_update = 1
		END IF

	case "B_RESET"
		SetNull(ls_docname)
		this.object.file_imagen[li_row] = ls_docname
		this.ii_update = 1

end choose
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event getfocus;call super::getfocus;idw_mst.il_row = this.getrow()
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3771
integer height = 2000
long backcolor = 79741120
string text = "Datos Tecnicos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_dettec dw_dettec
end type

on tabpage_3.create
this.dw_dettec=create dw_dettec
this.Control[]={this.dw_dettec}
end on

on tabpage_3.destroy
destroy(this.dw_dettec)
end on

type dw_dettec from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer y = 8
integer width = 3621
integer height = 1828
integer taborder = 20
string dataobject = "d_abc_datos_tec_maq_tbl"
boolean vscrollbar = false
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

CHOOSE CASE lower(as_columna)
	CASE 'tipo_llanta_del'
		ls_sql = 'SELECT GRUPO_ART AS CODIGO_GRUPO, ' &   
				 + 'DESC_GRUPO_ART AS DESCRIPCION '&
				 + 'FROM ARTICULO_GRUPO '
												
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_llanta_del[al_row] = ls_codigo
		end if

	CASE 'tipo_llanta_tras'
		ls_sql = 'SELECT GRUPO_ART AS CODIGO_GRUPO, '&   
				 + 'DESC_GRUPO_ART AS DESCRIPCION '&
				 + 'FROM ARTICULO_GRUPO '

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_llanta_tras	[al_row] = ls_codigo
			this.ii_update = 1
		END IF

	CASE 'cod_art'
		ls_sql = 'SELECT COD_ART AS CODIGO, '&   
				 + 'DESC_ART AS DESCRIPCION, '&
				 + 'UND AS UND '&
				 + 'FROM ARTICULO ' &
				 + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art [al_row] = ls_data
			this.ii_update = 1
		END IF
				
	CASE 'combustible'
		ls_sql = 'SELECT COD_ART AS CODIGO, '&   
				 + 'DESC_ART AS DESCRIPCION, '&
				 + 'UND AS UND '&
				 + 'FROM ARTICULO ' &
				 + "WHERE FLAG_ESTADO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.combustible			[al_row] = ls_codigo
			this.object.desc_combustible 	[al_row] = ls_data
			this.ii_update = 1
		END IF				

	CASE 'cod_activo'
		ls_sql = 'SELECT NRO_ACTIVO AS CODIGO_ACTIVO, '&   
				 + 'DESCRIPCION AS DESCR_ACTIVO_FIJO '&
				 + 'FROM ACTIVO_FIJO ' &
				 + "WHERE FLAG_ESTADO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_activo			[al_row] = ls_codigo
			this.object.desc_activo_fijo 	[al_row] = ls_data
			this.ii_update = 1
		END IF				
	
	CASE 'tipo_maquina'
		ls_sql = 'SELECT TIPO_MAQUINA AS MAQUINA_TIPO, '&   
				 + 'DESC_TIPO_MAQ AS DESCRIPCION_TIPO_MAQUINA '&
				 + 'FROM MAQUINA_TIPO ' 
											
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.tipo_maquina	[al_row] = ls_codigo
			this.object.desc_tipo_maq 	[al_row] = ls_data
			this.ii_update = 1
		END IF				
END CHOOSE

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst = tab_1.tabpage_3.dw_dettec
idw_det = tab_1.tabpage_2.dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;this.SetItem(al_row, 'flag_estado','1')
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo, ls_data

THIS.Accepttext()

CHOOSE CASE dwo.name
	CASE 'combustible'
		SELECT desc_art
			INTO :ls_data
		FROM articulo
		WHERE (cod_art = :data) 
		  and FLAG_ESTADO = '1';
				   
		IF IsNull(ls_data) or ls_data = '' THEN
	 		SetNull(ls_codigo)
			This.Object.combustible 		[row] = ls_codigo
			this.object.desc_combustible 	[row] = ls_codigo
			Messagebox('Aviso','Tipo de Combustible No existe , Verifique!', StopSign!)
			Return 1
		END IF
		
		this.object.desc_combustible [row] = ls_data

	CASE 'cod_activo'
		
		SELECT descripcion
			INTO :ls_data
		FROM activo_fijo
		WHERE nro_activo = :data 
		  and FLAG_ESTADO = '1';
				   
		IF IsNull(ls_data) or ls_data = '' THEN
	 		SetNull(ls_codigo)
			This.Object.cod_activo 			[row] = ls_codigo
			this.object.desc_activo_fijo 	[row] = ls_codigo
			Messagebox('Aviso','Codigo de Activo Fijo no existe o no esta activo, Verifique!', StopSign!)
			Return 1
		END IF
		
		this.object.desc_activo_fijo [row] = ls_data
				
	CASE 'tipo_llanta_del'
		SELECT Count(*)
			INTO :ll_count
		FROM articulo_grupo
		WHERE (grupo_art = :data) ;
					 
		IF ll_count = 0 THEN
			SetNull(ls_codigo)
			This.Object.tipo_llanta_del [row] = ls_codigo
			Messagebox('Aviso','Codigo No existe , Verifique!', StopSign!)
			Return 1
		END IF
				
	CASE 'tipo_llanta_tras'
		SELECT Count(*)
			INTO :ll_count
		FROM articulo_grupo
		WHERE (grupo_art = :data) ;
					 
		IF ll_count = 0 THEN
			SetNull(ls_codigo)
			This.Object.tipo_llanta_tras [row] = ls_codigo
			Messagebox('Aviso','Codigo No existe , Verifique!')
			Return 1
		END IF
				  
	CASE 'cod_art'
		SELECT desc_art
			INTO :ls_data
		FROM articulo
		WHERE (cod_art = :data) 
		  and FLAG_ESTADO = '1';
				   
		IF IsNull(ls_data) or ls_data = '' THEN
	 		SetNull(ls_codigo)
			This.Object.cod_art [row] = ls_codigo
			This.object.desc_art[row] = ls_codigo
			Messagebox('Aviso','Articulo No existe , Verifique!', StopSign!)
			Return 1
		END IF
		
		this.object.desc_art [row] = ls_data
			 
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3771
integer height = 2000
long backcolor = 79741120
string text = "Configuración"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_2.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_2.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_2
integer width = 3488
integer height = 944
integer taborder = 20
string dataobject = "d_abc_maq_caract_tec_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = tab_1.tabpage_1.dw_master
idw_det  = tab_1.tabpage_2.dw_detail
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_ctec,ls_desc_ctec
Accepttext()


CHOOSE CASE dwo.name
		 CASE 'cod_caract'
				SELECT Count(*)
				  INTO :ll_count
				  FROM caract_tec
				 WHERE (cod_caract = :data) ;
				 
				 IF ll_count > 0  THEN
					 SELECT desc_caract
				      INTO :ls_desc_ctec
				     FROM caract_tec
				    WHERE (cod_caract = :data) ;
					 
					 This.Object.desc_caract [row] = ls_desc_ctec
				 ELSE
					 Setnull(ls_ctec)
					 This.Object.cod_caract  [row] = ls_ctec
					 This.Object.desc_caract [row] = ''
					 Messagebox('Aviso','Caracteristica Tecnica NO EXISTE Verifique!')
					 Return 1 
				 END IF
		
END CHOOSE

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0,FALSE)
This.SelectRow(currentrow, TRUE)

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_col, ls_sql, ls_return1, ls_return2
str_seleccionar lstr_seleccionar

if this.ii_protect = 1 then return
ls_col = lower(trim(string(dwo.name)))
CHOOSE CASE ls_col
	 CASE 'cod_caract'
			ls_sql = "select cod_caract as codigo, desc_caract as descripcion from caract_tec"
			f_lista(ls_sql, ls_return1, ls_return2, '2')
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			this.object.cod_caract[row] = ls_return1
			this.object.desc_caract[row] = ls_return2
			this.ii_update = 1
END CHOOSE

end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3771
integer height = 2000
long backcolor = 79741120
string text = "Repuestos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_repuestos dw_repuestos
end type

on tabpage_5.create
this.dw_repuestos=create dw_repuestos
this.Control[]={this.dw_repuestos}
end on

on tabpage_5.destroy
destroy(this.dw_repuestos)
end on

type dw_repuestos from u_dw_abc within tabpage_5
integer width = 3488
integer height = 1764
string dataobject = "d_abc_maq_respuestos_tbl"
borderstyle borderstyle = styleraised!
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = tab_1.tabpage_1.dw_master
idw_det  = tab_1.tabpage_2.dw_detail
end event

event itemchanged;call super::itemchanged;String ls_data, ls_und

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		
		// Verifica que codigo ingresado exista			
		Select desc_art, und
	     into :ls_data, :ls_und
		  from articulo
		 Where cod_art = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_art	[row] = gnvo_app.is_null
			this.object.desc_art	[row] = gnvo_app.is_null
			this.object.und		[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Artículo no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_art			[row] = ls_data
		this.object.und				[row] = ls_und


END CHOOSE


end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0,FALSE)
This.SelectRow(currentrow, TRUE)

end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_und
choose case lower(as_columna)
	case "cod_art"
		ls_sql = "select a.cod_art as codigo_articulo, " &
				 + "a.desc_art as descripcion_articulo, " &
				 + "a.und as unidad " &
				 + "  from articulo a " &
				 + " where a.flag_estado = '1'"

		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_und, '1')

		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_Art	[al_row] = ls_data
			this.object.und		[al_row] = ls_und
			this.ii_update = 1
		end if
		
end choose
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.cantidad 			[al_row] = 0.00
this.object.flag_replicacion 	[al_row] = '1'
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3771
integer height = 2000
long backcolor = 79741120
string text = "Documentacion Técnica"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_doctec dw_doctec
end type

on tabpage_4.create
this.dw_doctec=create dw_doctec
this.Control[]={this.dw_doctec}
end on

on tabpage_4.destroy
destroy(this.dw_doctec)
end on

type dw_doctec from u_dw_abc within tabpage_4
integer width = 3735
integer height = 1164
integer taborder = 20
string dataobject = "d_abc_doc_tecnica_maquina"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1

end event

event dwnenter;// Ancestor Script has been Override
//Send(Handle(this),256,9,Long(0,0))
Long ll_row

ll_row = this.getRow()

if ll_Row <= 0 then return

this.AcceptText()

return 1
end event

event itemchanged;call super::itemchanged;this.AcceptText()

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

