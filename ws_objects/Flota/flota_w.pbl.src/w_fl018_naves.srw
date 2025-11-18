$PBExportHeader$w_fl018_naves.srw
forward
global type w_fl018_naves from w_abc
end type
type tab_1 from tab within w_fl018_naves
end type
type tabpage_1 from userobject within tab_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_master dw_master
end type
type tabpage_2 from userobject within tab_1
end type
type dw_sanipes from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_sanipes dw_sanipes
end type
type tabpage_3 from userobject within tab_1
end type
type dw_especies from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_especies dw_especies
end type
type tabpage_4 from userobject within tab_1
end type
type dw_pesca from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_pesca dw_pesca
end type
type tab_1 from tab within w_fl018_naves
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_fl018_naves from w_abc
integer width = 3360
integer height = 2324
string title = "Maestro de Naves (FL018)"
string menuname = "m_mto_smpl_cslta"
boolean maxbox = false
boolean resizable = false
tab_1 tab_1
end type
global w_fl018_naves w_fl018_naves

type variables
boolean 	ib_flota_propia
u_dw_abc	idw_master, idw_sanipes, idw_especies, idw_pesca

end variables

forward prototypes
public subroutine of_asignar_dws ()
end prototypes

public subroutine of_asignar_dws ();idw_master 		= tab_1.tabpage_1.dw_master
idw_sanipes 	= tab_1.tabpage_2.dw_sanipes
idw_especies	= tab_1.tabpage_3.dw_especies
idw_pesca		= tab_1.tabpage_4.dw_pesca
end subroutine

on w_fl018_naves.create
int iCurrent
call super::create
if this.MenuName = "m_mto_smpl_cslta" then this.MenuID = create m_mto_smpl_cslta
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_fl018_naves.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event resize;call super::resize;of_asignar_dws()
tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_master.width  = tab_1.tabpage_1.width  - idw_master.x - 10
idw_master.height = tab_1.tabpage_1.height - idw_master.y - 10

idw_sanipes.width  = tab_1.tabpage_2.width  - idw_sanipes.x - 10
idw_sanipes.height = tab_1.tabpage_2.height - idw_sanipes.y - 10

idw_especies.width  = tab_1.tabpage_3.width  - idw_especies.x - 10
idw_especies.height = tab_1.tabpage_3.height - idw_especies.y - 10

idw_pesca.width  = tab_1.tabpage_4.width  - idw_pesca.x - 10
idw_pesca.height = tab_1.tabpage_4.height - idw_pesca.y - 10
end event

event ue_open_pre;call super::ue_open_pre;of_asignar_dws()
//idw_query = dw_master
idw_1 = idw_master
ii_pregunta_delete = 1

idw_master.SetTransObject(SQLCA)
idw_sanipes.SetTransObject(SQLCA)
idw_pesca.SetTransObject(SQLCA)

idw_1.setFocus()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

if ib_log then
	idw_master.of_create_log()
	idw_sanipes.of_Create_log()
	idw_especies.of_Create_log()
	idw_pesca.of_Create_log()
end if

IF	idw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error","Error al grabar en datawindows dw_master",exclamation!)
	END IF
END IF

IF	idw_sanipes.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_sanipes.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error","Error al grabar en datawindows dw_sanipes",exclamation!)
	END IF
END IF

IF	idw_especies.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_especies.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error","Error al grabar en datawindows dw_especies",exclamation!)
	END IF
END IF

IF	idw_pesca.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_pesca.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error","Error al grabar en datawindows dw_pesca",exclamation!)
	END IF
END IF

if lbo_ok and ib_log then
	lbo_ok = idw_master.of_save_log()
	lbo_ok = idw_sanipes.of_save_log()
	lbo_ok = idw_especies.of_save_log()
	lbo_ok = idw_pesca.of_save_log()
end if

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	idw_master.ii_update = 0
	idw_master.ResetUpdate()
	
	idw_sanipes.ii_update = 0
	idw_sanipes.ResetUpdate()
	
	idw_especies.ii_update = 0
	idw_especies.ResetUpdate()
	
	idw_pesca.ii_update = 0
	idw_pesca.ResetUpdate()
	
	f_mensaje("Cambios guardardos satisfactoriamente", "")
	
END IF



end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF idw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Informacion", "Existen Actualizaciones Pendientes, desea garbarlas?", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_master.ii_update = 0
		idw_master.ib_insert_mode = false
		idw_master.REsetUpdate()
	END IF
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_inicio
string ls_tipo_flota
str_parametros sl_param

sl_param.dw1    = 'ds_naves_grid'
sl_param.titulo = 'Naves'
sl_param.field_ret_i[1] = 1	//Codigo Nave
sl_param.field_ret_i[2] = 2	//Nombre Nave

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	idw_master.Retrieve(sl_param.field_ret[1])
	if idw_master.RowCount() > 0 then
		//obtengo los datos de SANIPES
		idw_sanipes.Retrieve(sl_param.field_ret[1])
		idw_especies.Retrieve(sl_param.field_ret[1])
		idw_pesca.Retrieve(sl_param.field_ret[1])
		
		ls_tipo_flota = idw_master.object.tipo_flota[1]
		if ls_tipo_flota = "P" then
			ib_flota_propia = true
		else
			ib_flota_propia = false
		end if
		
		idw_master.ii_protect = 0
		idw_master.of_protect()
		
		idw_sanipes.ii_protect = 0
		idw_sanipes.of_protect()
		
		idw_especies.ii_protect = 0
		idw_especies.of_protect()
		
		idw_pesca.ii_protect = 0
		idw_pesca.of_protect()
		
	else
		idw_sanipes.Reset()
		idw_master.Reset()
		idw_especies.Reset()
		idw_pesca.Reset()
		
		idw_master.ResetUpdate()
		idw_sanipes.ResetUpdate()
		idw_especies.ResetUpdate()
		idw_pesca.ResetUpdate()
		
		idw_master.ii_update = 0
		idw_sanipes.ii_update = 0
		idw_especies.ii_update = 0
		idw_pesca.ii_update = 0
		
		MessageBox('ERROR', 'NO HAY DATOS QUE RECUPERAR DE LA NAVE', StopSign!)
		return
	end if
	
	tab_1.tabPage_1.setFocus()
	idw_master.setFocus()
END IF
end event

event ue_update_pre;call super::ue_update_pre;string  ls_nave, ls_tipo_flota, ls_cencos, ls_proveedor
string  ls_activo
integer li_row
dwItemStatus ldi_status

li_row = idw_master.RowCount()

if li_row = 0 then
	return 
end if

for li_row = 1 to idw_master.Rowcount()
	ls_nave = idw_master.object.nomb_nave[li_row] 

	if IsNull(ls_nave) or ls_nave = '' then
		MessageBox('Error en Ingreso', 'LA NAVE DEBE TENER UN NOMBRE' )
		ib_update_check = FALSE
		idw_master.SetRow(li_row)
		return
	end if
	
	ls_tipo_flota	= idw_master.object.tipo_flota[li_row] 
	ls_cencos		= trim(idw_master.object.cencos[li_row])
	ls_activo 		= idw_master.object.codigo_activo[li_row] 
	ls_proveedor	= idw_master.object.proveedor[li_row] 


	if IsNull(ls_tipo_flota) or ls_tipo_flota = '' then
		MessageBox('Error en Ingreso', 'LA NAVE DEBE TENER UN TIPO DE FLOTA' )
		ib_update_check = FALSE
		idw_master.SetRow(li_row)
		return
	end if

	if IsNull(ls_proveedor) or ls_proveedor = '' then
		MessageBox('Error en Ingreso', 'LA NAVE DEBE TENER CODIGO DE PROVEEDOR' )
		ib_update_check = FALSE
		idw_master.SetRow(li_row)
		return
	end if

	if len(ls_cencos) > 0 and ls_tipo_flota = 'T' then
		MessageBox('Error en Ingreso', 'UNA NAVE DE TERCEROS NO DEBE TENER CENTRO DE COSTOS' )
		ib_update_check = FALSE
		idw_master.SetRow(li_row)
		return
	end if

	if len(ls_activo) > 0 and ls_tipo_flota <> 'P' then
		MessageBox('Error en Ingreso', 'SOLO LA FLOTA PROPIA PUEDE TENER CODIGO DE ACTIVO' )
		ib_update_check = FALSE
		idw_master.SetRow(li_row)
		return
	end if
	
	if idw_master.ib_insert_mode	 then
		
		ls_nave = f_get_cod_nave(gs_origen)

		idw_master.object.nave[li_row] = ls_nave
		
		idw_master.ib_insert_mode = False

	end if

next

if gnvo_app.of_row_Processing( idw_sanipes ) <> true then return
if gnvo_app.of_row_Processing( idw_especies ) <> true then return

idw_master.of_set_flag_replicacion()


end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

end event

type tab_1 from tab within w_fl018_naves
integer width = 3310
integer height = 2132
integer taborder = 20
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
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3273
integer height = 2004
long backcolor = 79741120
string text = "Datos Generales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Inherit_2!"
long picturemaskcolor = 536870912
string powertiptext = "Datos Generales de la embarcación"
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
event dropdown pbm_dwndropdown
integer width = 3195
integer height = 1944
integer taborder = 30
string dataobject = "d_naves_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event buttonclicked;call super::buttonclicked;string ls_docname, ls_named
integer li_value, li_row

This.AcceptText()
li_row = this.GetRow()

choose case upper(dwo.name)
	case "B_BROWSE"

		li_value = GetFileOpenName("Select File", &
			 + ls_docname, ls_named, "JPG", &
			 + "JPG Files (*.JPG),*.JPG," &
			 + "BMP Files (*.BMP),*.BMP," &
			 + "GIF Files (*.GIF),*.GIF," )
		
		IF li_value = 1 THEN 
			this.object.Imagen[li_row] = ls_docname
		END IF

	case "B_RESET"
		SetNull(ls_docname)
		this.object.Imagen[li_row] = ls_docname

end choose

end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
is_dwform = 'form'
end event

event doubleclicked;call super::doubleclicked;string ls_codigo, ls_data, ls_sql, ls_tipo_flota
long ll_row, ll_count
integer li_i
str_seleccionar lstr_seleccionar

this.AcceptText()

If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

ll_row = this.GetRow()

this.event dynamic ue_display( upper(dwo.name), ll_row )

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_imagen, ls_null
long 		ll_count
string 	ls_tipo_flota

SetNull(ls_null)

this.AcceptText()

choose case upper(dwo.name)
	case "TIPO_FLOTA"
		ls_codigo = upper(this.object.tipo_flota[row])
		IF ls_codigo = "P" then
			ib_flota_propia = True
		elseif ls_codigo = "T" then
			ib_flota_propia = false
		end if
		

	case "CENCOS"
		
		ls_tipo_flota = upper(this.object.tipo_flota[row])
		
		if ls_tipo_flota = "T" then
			MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO')
			this.object.cencos 		[row] = ls_null
			this.object.desc_cencos [row] = ls_null
			return 1
		end if
		
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :data
		  and flag_estado = '1';
		
		if SQLCA.SQlCode = 100 then
			Messagebox('Error', "CODIGO DE CENTRO DE COSTOS NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cencos 		[row] = ls_null
			this.object.desc_cencos [row] = ls_null
			return 1
		end if
		
		select count(*)
			into :ll_count
		from tg_naves
		where cencos = :data;
		
		if ll_count > 0 then
			Messagebox('Error', "CENTRO DE COSTO YA FUE ASIGNADO A OTRA NAVE", StopSign!)
			this.object.cencos 		[row] = ls_null
			this.object.desc_cencos [row] = ls_null
			return 1
		end if

		this.object.desc_cencos[row] = ls_data


	case "CENCOS_ADM"
		
		ls_tipo_flota = upper(this.object.tipo_flota[row])
		
		if ls_tipo_flota = "T" then
			MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO ADMNISTRATIVO')
			this.object.cencos_adm 		 [row] = ls_null
			this.object.desc_cencos_adm [row] = ls_null
			return 1
		end if
		
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :data
		  and flag_estado = '1';
		
		IF SQLCA.SQlCode = 100 THEN
			Messagebox('Error', "CODIGO DE CENTRO DE COSTOS NO EXISTE", StopSign!)
			this.object.cencos_adm 		 [row] = ls_null
			this.object.desc_cencos_adm [row] = ls_null
			return 1
		end if
		
		select count(*)
			into :ll_count
		from tg_naves
		where cencos_adm = :data;
		
		if ll_count > 0 then
			Messagebox('Error', "CENTRO DE COSTO YA FUE ASIGNADO A OTRA NAVE", StopSign!)
			this.object.cencos_adm 		 [row] = ls_null
			this.object.desc_cencos_adm [row] = ls_null
			return 1
		end if

		this.object.desc_cencos_adm [row] = ls_data

	case "CODIGO_ACTIVO"
	
		ls_tipo_flota = upper(this.object.tipo_flota[row])

		if ls_tipo_flota <> "P" then
			MessageBox('Error', 'SOLO LA FLOTA PROPIA PUEDE TENER CODIGO DE ACTIVO')
			this.object.codigo_activo		[row] = ls_null
			this.object.desc_activo_fijo	[row] = ls_null
			return 1
		end if
		
		select descripcion
			into :ls_data
		from activo_fijo
		where nro_activo = :data;
		
		IF SQLCA.SQLCode = 100 THEN
			Messagebox('Error', "CODIGO DE ACTIVO NO EXISTE", StopSign!)
			this.object.codigo_activo		[row] = ls_null
			this.object.desc_activo_fijo	[row] = ls_null
			return 1
		END IF
		
		select count(*)
			into :ll_count
		from tg_naves
		where codigo_activo = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "CODIGO DE ACTIVO YA FUE ASIGNADO A OTRA NAVE", StopSign!)
			this.object.codigo_activo		[row] = ls_null
			this.object.desc_activo_fijo	[row] = ls_null
			return 1
		end if

		this.object.desc_activo_fijo[row] = ls_data

	case "PROVEEDOR"
		
		select NOM_PROVEEDOR
			into :ls_data
		from PROVEEDOR
		where PROVEEDOR = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "CODIGO DE PROVEEDOR NO EXISTE", StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if
		
		select count(*)
			into :ll_count
		from tg_naves
		where proveedor = :data;
		
		if ll_count > 0 then
			Messagebox('Error', "CODIGO DE RELACION YA FUE ASIGNADO A OTRA NAVE", StopSign!)
			this.object.proveedor		[row] = ls_null
			this.object.nom_proveedor	[row] = ls_null
			return 1
		end if

		this.object.nom_proveedor[row] = ls_data

	case "CENTRO_BENEF"
		select desc_centro
			into :ls_data
		from centro_beneficio
		where centro_benef = :data
		  and flag_estado = '1';
		
		if SQLCA.SQlCode = 100 then
			Messagebox('Error', "CODIGO DE CENTRO DE BENEFICIO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.centro_benef [row] = ls_null
			this.object.desc_centro	 [row] = ls_null
			return 1
		end if

		this.object.desc_centro[row] = ls_data

end choose

end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert;long ll_row

integer li_row
string ls_origen, ls_nave
long ll_ultnro


If ib_insert_mode then
	If MessageBox('Grabar', "ANTES DE INSERTAR UN NUEVO REGISTRO DEBE GRABAR" &
			+ "~r~n DESEA GRABAR?", StopSign!, YesNo!,1) = 1 then
		il_row = 0
		event ue_update()
		ib_insert_mode = False
		ii_update = 0
	else
		return -1
	End if	
end if

this.reset()
ll_row = THIS.InsertRow(0)				// insertar registro maestro

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
	RETURN ll_row
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	ib_insert_mode = True

	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
END IF



RETURN ll_row


end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nom_origen

select nombre
	into :ls_nom_origen
from origen
where cod_origen = :gs_origen;

this.object.flag_estado		[al_row] = '1'
this.object.origen			[al_row] = gs_origen
this.object.nomb_origen		[al_row] = ls_nom_origen

// Por defecto la Nave es de terceros
this.object.tipo_flota		[al_row] 	= 'T'
this.object.flag_supnep		[al_row] 	= '1'

this.object.porc_partic 		[al_row] = 0.00
this.object.porc_partic_cons 	[al_row] = 0.00

this.object.flag_registro_issf 	[al_row] = '0'
this.object.flag_euro_1 			[al_row] = '0'
this.object.cuba			 			[al_row] = '0'
this.object.flag_ajuste_movilidad[al_row] = '0'




//Indico que no es Propia
ib_flota_propia = False

end event

event ue_display;string 	ls_codigo, ls_data, ls_sql, ls_tipo_flota
long 		ll_count
integer 	li_i
boolean	lb_ret
str_seleccionar lstr_seleccionar

try 
	choose case upper(as_columna)
			
		case "PROVEEDOR"
			
			ls_sql = "SELECT PROVEEDOR AS CODIGO, " &
					 + "NOM_PROVEEDOR AS DESCRIPCION " &
					 + "FROM PROVEEDOR"	
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
	
			if ls_codigo <> "" then
				if gnvo_app.of_get_parametro( "FLOTA_UNIQUE_PROV_NAVE", "0") = "1" then
					select count(*)
						into :ll_count
					from tg_naves
					where proveedor = :ls_codigo;
					
					if ll_count > 0 then
						Messagebox('Error', "CODIGO DE PROVEEDOR YA ESTA ASIGNADO A OTRA EMBARCACION", StopSign!)
						SetNull(ls_codigo)
						this.object.nom_proveedor	[al_row] = ls_codigo		
						this.object.proveedor		[al_row] = ls_codigo
						this.SetColumn("proveedor")
						return 
					end if
				end if
				this.object.nom_proveedor	[al_row] = ls_data		
				this.object.proveedor		[al_row] = ls_codigo
				this.ii_update = 1
			end if
	
		case "CENTRO_BENEF"
			
			ls_sql = "SELECT CENTRO_benef AS centro_beneficio, " &
					 + "desc_centro AS DESCRIPCION_centro_benef " &
					 + "FROM centro_beneficio " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.centro_benef	[al_row] = ls_codigo		
				this.object.desc_centro		[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "CENCOS"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO')
				return 
			end if
			
			ls_sql = "SELECT CENCOS AS CODIGO, " &
					 + "DESC_CENCOS AS DESCRIPCION " &
					 + "FROM CENTROS_COSTO " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.cencos		[al_row] = ls_codigo 
				this.object.desc_cencos	[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "CENCOS_ADM"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO ADMINISTRATIVO')
				return 
			end if
			
			ls_sql = "SELECT CENCOS AS CODIGO, " &
					 + "DESC_CENCOS AS DESCRIPCION " &
					 + "FROM CENTROS_COSTO " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.cencos_ADM			[al_row] = ls_codigo 
				this.object.desc_cencos_ADM	[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "CODIGO_ACTIVO"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota <> "P" then
				MessageBox('Error', 'SOLO LA FLOTA PROPIA TIENE UN CODIGO DE ACTIVO')
				return
			end if
			
			ls_sql = "SELECT NRO_ACTIVO AS CODIGO, " &
					 + "DESCRIPCION AS DESCRIP_ACTIVO " &
					 + "FROM ACTIVO_FIJO " 
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then		
				select count(*)
					into :ll_count
				from tg_naves
				where codigo_activo = :ls_codigo;
				
				if ll_count > 0 then
					Messagebox('Error', "CODIGO DE ACTIVO YA FUE ASIGNADO A OTRA NAVE", StopSign!)
					SetNull(ls_codigo)
					this.object.codigo_activo		[al_row] = ls_codigo
					this.object.desc_activo_fijo	[al_row] = ls_codigo
					this.SetColumn("codigo_activo")
					return 
				end if
		
				this.object.codigo_activo		[al_row] = ls_codigo
				this.object.desc_activo_fijo	[al_row] = ls_data
				this.ii_update = 1
			end if

		case "CENTRO_BENEF"
			
			ls_sql = "SELECT CENTRO_benef AS centro_beneficio, " &
					 + "desc_centro AS DESCRIPCION_centro_benef " &
					 + "FROM centro_beneficio " &
					 + "where flag_estado = '1'"
					 
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.centro_benef	[al_row] = ls_codigo		
				this.object.desc_centro		[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "CENCOS"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO')
				return 
			end if
			
			ls_sql = "SELECT CENCOS AS CODIGO, " &
					 + "DESC_CENCOS AS DESCRIPCION " &
					 + "FROM CENTROS_COSTO " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.cencos		[al_row] = ls_codigo 
				this.object.desc_cencos	[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "CENCOS_ADM"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				MessageBox('Error', 'UNA NAVE DE TERCEROS NO PUEDE TENER CENTRO DE COSTO ADMINISTRATIVO')
				return 
			end if
			
			ls_sql = "SELECT CENCOS AS CODIGO, " &
					 + "DESC_CENCOS AS DESCRIPCION " &
					 + "FROM CENTROS_COSTO " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.cencos_ADM			[al_row] = ls_codigo 
				this.object.desc_cencos_ADM	[al_row] = ls_data
				this.ii_update = 1
			end if

		case "ALMACEN_MAT"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				gnvo_app.of_message_error('UNA NAVE DE TERCEROS NO PUEDE TENER ALMACEN DE MATERIALES')
				return 
			end if
			
			ls_sql = "select almacen as almacen, " &
					 + "desc_almacen as descripcion_almacen " &
					 + "from almacen " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.almacen_mat			[al_row] = ls_codigo 
				this.object.desc_almacen_mat	[al_row] = ls_data
				this.ii_update = 1
			end if
	
		case "ALMACEN_MP"
			ls_tipo_flota = upper(this.object.tipo_flota[al_row])
			
			if ls_tipo_flota = "T" then
				gnvo_app.of_message_error('UNA NAVE DE TERCEROS NO PUEDE TENER ALMACEN DE MATERIALES')
				return 
			end if
			
			ls_sql = "select almacen as almacen, " &
					 + "desc_almacen as descripcion_almacen " &
					 + "from almacen " &
					 + "WHERE FLAG_ESTADO = '1' "
			
			lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
	
			if ls_codigo <> "" then
				this.object.almacen_mp			[al_row] = ls_codigo 
				this.object.desc_almacen_mp	[al_row] = ls_data
				this.ii_update = 1
			end if
			
	
	end choose

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "")
end try


end event

type tabpage_2 from userobject within tab_1
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 3273
integer height = 2004
long backcolor = 79741120
string text = "Datos Sanipes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CheckIn_2!"
long picturemaskcolor = 536870912
string powertiptext = "Datos de Sanipes de la embarcacion"
dw_sanipes dw_sanipes
end type

on tabpage_2.create
this.dw_sanipes=create dw_sanipes
this.Control[]={this.dw_sanipes}
end on

on tabpage_2.destroy
destroy(this.dw_sanipes)
end on

type dw_sanipes from u_dw_abc within tabpage_2
integer width = 3182
integer height = 1736
integer taborder = 30
string dataobject = "d_abc_naves_sanipes_tbl"
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 		[al_row] = of_nro_item(this)
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr 			[al_row] = gs_user
this.object.nave	 			[al_row] = idw_master.object.nave [idw_master.getRow()]

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
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "activ_emb"
		ls_sql = "select distinct " &
				 + " 		  substr(t.activ_emb, 1, 2) as codigo " &
				 + "		  T.ACTIV_EMB as actividad " &
			    + "from TG_NAVES_SANIPES t"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.activ_emb	[al_row] = ls_Data
			this.ii_update = 1
		end if
		
end choose
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3273
integer height = 2004
long backcolor = 79741120
string text = "Especies permitidas"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "ArrangeTables!"
long picturemaskcolor = 536870912
dw_especies dw_especies
end type

on tabpage_3.create
this.dw_especies=create dw_especies
this.Control[]={this.dw_especies}
end on

on tabpage_3.destroy
destroy(this.dw_especies)
end on

type dw_especies from u_dw_abc within tabpage_3
integer width = 3122
integer height = 1784
string dataobject = "d_abc_naves_especies_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_master.getRow() = 0 then return

this.object.nave	 			[al_row] = idw_master.object.nave [idw_master.getRow()]
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr 			[al_row] = gs_user
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "especie"
		ls_sql = "select te.especie as especie, " &
				 + "te.descr_especie as descripcion_especie " &
				 + "from tg_especies te " &
				 + "where te.flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.especie			[al_row] = ls_codigo
			this.object.desc_especie	[al_row] = ls_Data
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'especie'
		
		// Verifica que codigo ingresado exista			
		Select descr_especie
	     into :ls_data
		  from tg_especies
		 Where especie = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.especie		[row] = gnvo_app.is_null
			this.object.desc_especie[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Especie no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_especie	[row] = ls_data


END CHOOSE
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3273
integer height = 2004
long backcolor = 79741120
string text = "Limite de Pesca x Dia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pesca dw_pesca
end type

on tabpage_4.create
this.dw_pesca=create dw_pesca
this.Control[]={this.dw_pesca}
end on

on tabpage_4.destroy
destroy(this.dw_pesca)
end on

type dw_pesca from u_dw_abc within tabpage_4
integer width = 3122
integer height = 1784
string dataobject = "d_abc_naves_pesca_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'especie'
		
		// Verifica que codigo ingresado exista			
		Select descr_especie
	     into :ls_data
		  from tg_especies
		 Where especie = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.especie		[row] = gnvo_app.is_null
			this.object.desc_especie[row] = gnvo_app.is_null
			MessageBox('Error', 'Codigo de Especie no existe o no esta activo, por favor verifique')
			return 1
		end if

		this.object.desc_especie	[row] = ls_data


END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;if idw_master.getRow() = 0 then return

this.object.nave	 			[al_row] = idw_master.object.nave [idw_master.getRow()]
this.object.fec_registro 	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr 			[al_row] = gs_user
this.object.limite_pesca	[al_row] = 0.00
this.object.nro_dias			[al_row] = 0.00
end event

