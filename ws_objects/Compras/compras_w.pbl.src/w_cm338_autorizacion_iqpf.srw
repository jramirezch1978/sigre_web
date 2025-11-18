$PBExportHeader$w_cm338_autorizacion_iqpf.srw
forward
global type w_cm338_autorizacion_iqpf from w_abc
end type
type tab_1 from tab within w_cm338_autorizacion_iqpf
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_autorizacion_responsable from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_autorizacion_responsable dw_autorizacion_responsable
end type
type tabpage_3 from userobject within tab_1
end type
type dw_autorizacion_transporte from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_autorizacion_transporte dw_autorizacion_transporte
end type
type tab_1 from tab within w_cm338_autorizacion_iqpf
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
type cb_1 from commandbutton within w_cm338_autorizacion_iqpf
end type
type sle_nro from singlelineedit within w_cm338_autorizacion_iqpf
end type
type st_nro from statictext within w_cm338_autorizacion_iqpf
end type
type dw_master from u_dw_abc within w_cm338_autorizacion_iqpf
end type
end forward

global type w_cm338_autorizacion_iqpf from w_abc
integer width = 3881
integer height = 2840
string title = "Atorización IQPF (CM338)"
string menuname = "m_mtto_imp_mail"
tab_1 tab_1
cb_1 cb_1
sle_nro sle_nro
st_nro st_nro
dw_master dw_master
end type
global w_cm338_autorizacion_iqpf w_cm338_autorizacion_iqpf

type variables
String      		is_tabla, is_colname[], is_coltype[]

String 	is_tabla_dw1, is_colname_dw1[], is_coltype_dw1[], &
			is_tabla_dw2, is_colname_dw2[], is_coltype_dw2[], &
			is_tabla_dw3, is_colname_dw3[], is_coltype_dw3[], &
			is_tabla_dw4, is_colname_dw4[], is_coltype_dw4[]
			
			
n_cst_log_diario	in_log
u_dw_abc idw_detail, idw_autorizacion_responsable, idw_autorizacion_transporte
end variables

forward prototypes
public subroutine of_asigna_dws ()
public subroutine of_retrieve (string as_cod_formulario)
public function integer of_nro_item (datawindow adw_pr)
end prototypes

public subroutine of_asigna_dws ();idw_detail		 	 			  = tab_1.tabpage_1.dw_detail
idw_autorizacion_responsable = tab_1.tabpage_2.dw_autorizacion_responsable
idw_autorizacion_transporte  = tab_1.tabpage_3.dw_autorizacion_transporte
end subroutine

public subroutine of_retrieve (string as_cod_formulario);long		ll_nro_item, ll_row

dw_master.Retrieve(as_cod_formulario)

dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect()

if dw_master.RowCount() = 0 then return

idw_detail.Retrieve(as_cod_formulario)

idw_detail.ii_update = 0
idw_detail.ii_protect = 0
idw_detail.of_protect()

if idw_detail.RowCount() = 0 then return

idw_autorizacion_responsable.Retrieve(as_cod_formulario)
idw_autorizacion_responsable.ii_update = 0
idw_autorizacion_responsable.ii_protect = 0
idw_autorizacion_responsable.of_protect()

idw_autorizacion_transporte.Retrieve(as_cod_formulario)
idw_autorizacion_transporte.ii_update = 0
idw_autorizacion_transporte.ii_protect = 0
idw_autorizacion_transporte.of_protect()

dw_master.object.p_logo.filename = gs_logo

is_action = 'open'

end subroutine

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x 		= 1 to adw_pr.RowCount()
	IF li_item 	< adw_pr.object.nro_item[li_x] THEN
		li_item 	= adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

on w_cm338_autorizacion_iqpf.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_imp_mail" then this.MenuID = create m_mtto_imp_mail
this.tab_1=create tab_1
this.cb_1=create cb_1
this.sle_nro=create sle_nro
this.st_nro=create st_nro
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.st_nro
this.Control[iCurrent+5]=this.dw_master
end on

on w_cm338_autorizacion_iqpf.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.sle_nro)
destroy(this.st_nro)
destroy(this.dw_master)
end on

event resize;call super::resize;of_asigna_dws()

dw_master.width  = newwidth  - dw_master.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_detail.width   = tab_1.width  - idw_detail.x - 60
idw_detail.height  = tab_1.height  - idw_detail.y - 190

idw_autorizacion_responsable.width   = tab_1.width  - idw_autorizacion_responsable.x - 60
idw_autorizacion_responsable.height  = tab_1.height  - idw_autorizacion_responsable.y - 190

idw_autorizacion_transporte.width   = tab_1.width  - idw_autorizacion_transporte.x - 60
idw_autorizacion_transporte.height  = tab_1.height  - idw_autorizacion_transporte.y - 190

end event

event ue_insert;call super::ue_insert;Long  	ll_row
String 	ls_flag	

if idw_1 = dw_master then
	if dw_master.ii_update = 1 then
		MessageBox('Aviso', 'No puede insertar un Formulario sin antes grabar')
		return
	end if
	dw_master.Reset()
	
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_modify;call super::ue_modify;idw_1.of_protect()

if is_action <> 'new' then is_action = 'edit'
end event

event ue_open_pre;call super::ue_open_pre;ib_log 		= TRUE
idw_1 = dw_master             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master
is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_autorizacion_responsable.SetTransObject(sqlca)
idw_autorizacion_transporte.SetTransObject(sqlca)


dw_master.of_protect()         		// bloquear modificaciones 
idw_detail.of_protect()
idw_autorizacion_responsable.of_protect()
idw_autorizacion_transporte.of_protect()

is_tabla_dw1 = dw_master.Object.Datawindow.Table.UpdateTable
is_tabla_dw2 = idw_detail.Object.Datawindow.Table.UpdateTable
is_tabla_dw3 = idw_autorizacion_responsable.Object.Datawindow.Table.UpdateTable
is_tabla_dw4 = idw_autorizacion_transporte.Object.Datawindow.Table.UpdateTable


end event

event ue_print;call super::ue_print;OpenWithParm(w_print_opt, dw_master)

If Message.DoubleParm = -1 Then Return

dw_master.Print(True)

end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = idw_1.of_ScrollRow(as_value)

RETURN ll_rc
end event

event ue_update;Boolean 	lbo_ok = TRUE
String	ls_plantilla

dw_master.AcceptText()
idw_detail.AcceptText()
idw_autorizacion_responsable.AcceptText()
idw_autorizacion_transporte.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	Datastore	lds_log_dw1, lds_log_dw2, lds_log_dw3, &
					lds_log_dw4
					
	lds_log_dw1 = Create DataStore
	lds_log_dw2 = Create DataStore
	lds_log_dw3 = Create DataStore
	lds_log_dw4 = Create DataStore
	
	lds_log_dw1.DataObject = 'd_log_diario_tbl'
	lds_log_dw2.DataObject = 'd_log_diario_tbl'
	lds_log_dw3.DataObject = 'd_log_diario_tbl'
	lds_log_dw4.DataObject = 'd_log_diario_tbl'

	lds_log_dw1.SetTransObject(SQLCA)
	lds_log_dw2.SetTransObject(SQLCA)
	lds_log_dw3.SetTransObject(SQLCA)
	lds_log_dw4.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_dw1, is_colname_dw1, is_coltype_dw1, gs_user, is_tabla_dw1)
	in_log.of_create_log(idw_detail, lds_log_dw2, is_colname_dw2, is_coltype_dw2, gs_user, is_tabla_dw2)
	in_log.of_create_log(idw_autorizacion_responsable, lds_log_dw3, is_colname_dw3, is_coltype_dw3, gs_user, is_tabla_dw3)
	in_log.of_create_log(idw_autorizacion_transporte, lds_log_dw4, is_colname_dw4, is_coltype_dw4, gs_user, is_tabla_dw4)
	
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
string ls_f
integer li_i, i

for i = 1 to idw_detail.rowcount( )
	 ls_f = idw_detail.object.nro_formulario [i]
	 li_i = idw_detail.object.nro_item [i]
	 messagebox('as', ls_f + string(li_i))
next

IF	idw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_detail.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_det","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_autorizacion_responsable.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_autorizacion_responsable.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_art","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_autorizacion_transporte.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_autorizacion_transporte.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion dw_plant_ot_adm","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_dw1.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw2.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw3.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
		IF lbo_ok and lds_log_dw4.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	
	DESTROY lds_log_dw1
	DESTROY lds_log_dw2
	DESTROY lds_log_dw3
	DESTROY lds_log_dw4

END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_autorizacion_responsable.ii_update = 0
	idw_autorizacion_transporte.ii_update = 0
	is_action = 'open'
END IF
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 OR idw_detail.ii_update = 1 OR idw_autorizacion_responsable.ii_update = 1 OR idw_autorizacion_transporte.ii_update  = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_detail.ii_update = 0
		idw_autorizacion_responsable.ii_update = 0
		idw_autorizacion_transporte.ii_update = 0
	END IF
END IF
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_dw1, is_coltype_dw1)
	in_log.of_dw_map(idw_detail, is_colname_dw2, is_coltype_dw2)
	in_log.of_dw_map(idw_autorizacion_responsable, is_colname_dw3, is_coltype_dw3)
	in_log.of_dw_map(idw_autorizacion_transporte, is_colname_dw4, is_coltype_dw4)
END IF
end event

event ue_close_pre();call super::ue_close_pre;IF ib_log THEN
	DESTROY n_cst_log_diario
END IF

end event

event close;call super::close;Destroy in_log
end event

event ue_duplicar;call super::ue_duplicar;

idw_1.Event ue_duplicar()

end event

event open;//Overriding
of_asigna_dws()
IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

dw_master.AcceptText()
idw_detail.AcceptText()
idw_autorizacion_responsable.AcceptText()
idw_autorizacion_transporte.AcceptText()

If dw_master.RowCount() = 0 then return

if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
end if

if f_row_Processing( idw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
end if

if f_row_Processing( idw_autorizacion_transporte, "tabular") <> true then	
	ib_update_check = False	
	return
end if
end event

event ue_list_open;call super::ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'd_abc_autoricaciones_iqpf_tbl'
sl_param.titulo = 'Formularios IQPF'
sl_param.field_ret_i[1] = 1	//Nro_Formulario

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

type tab_1 from tab within w_cm338_autorizacion_iqpf
integer x = 18
integer y = 1248
integer width = 3410
integer height = 1376
integer taborder = 20
integer textsize = -8
integer weight = 700
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
integer width = 3374
integer height = 1256
long backcolor = 79741120
string text = "Autorización IQPF"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer x = 37
integer y = 32
integer width = 3282
integer height = 1196
integer taborder = 20
string dataobject = "d_abc_autorizacion_iqpf_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_art"

		ls_sql = "SELECT A.COD_ART AS CODIGO_ARTUCILO, " &
				  + "A.NOM_ARTICULO AS NOMBRE_ARTICULO " &
				  + "FROM ARTICULO A " &
				  + "WHERE A.FLAG_IQPF = '0' AND A.FLAG_ESTADO = '1'"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_art	[al_row] = ls_codigo
			this.object.desc_art	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

end choose
end event

event constructor;call super::constructor;                       //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master
//idw_det  =  			tab_1.tabpage_1.dw_detail
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_formulario
Long		ll_item, ll_row

ll_row = dw_master.GetRow()

ls_nro_formulario = dw_master.object.nro_formulario [ll_row]

if ls_nro_formulario = '' or isnull(ls_nro_formulario) then
	Messagebox('Aviso', 'El Nro. del Formulario no ha sido definido, ¡Verifique!')
	this.reset( )
	dw_master.event getfocus( )
	return
end if 


this.object.nro_formulario	[al_row] = ls_nro_formulario
this.object.nro_item	      [al_row] = of_nro_item(this)
this.object.ampliaciones	[al_row] = 0
this.object.cantidad    	[al_row] = 0

end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

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

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_art"
		
		select nom_articulo
		 into :ls_data
		 from articulo
		where cod_art = :data
		  and flag_estado = '1'
		  and flag_iqpf = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Artìculo no existe, no está activo o no es tipo IQPF", StopSign!)
			this.object.cod_art	[row] = ls_null
			this.object.desc_art	[row] = ls_null
			return 1
		end if

		this.object.desc_art	[row] = ls_data
		
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3374
integer height = 1256
long backcolor = 79741120
string text = "Autorización IQPF Responsable"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_autorizacion_responsable dw_autorizacion_responsable
end type

on tabpage_2.create
this.dw_autorizacion_responsable=create dw_autorizacion_responsable
this.Control[]={this.dw_autorizacion_responsable}
end on

on tabpage_2.destroy
destroy(this.dw_autorizacion_responsable)
end on

type dw_autorizacion_responsable from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 24
integer width = 3282
integer height = 1196
integer taborder = 30
string dataobject = "d_abc_autor_iqpf_responsable_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "proveedor"
		ls_sql = "SELECT proveedor AS codigo_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor " &
				  + "FROM proveedor WHERE flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.proveedor	[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master
//idw_det  =  			tab_1.tabpage_1.dw_detail
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_formulario
Long		ll_item, ll_row

ll_row = dw_master.GetRow()

ls_nro_formulario = dw_master.object.nro_formulario [ll_row]

if ls_nro_formulario = '' or isnull(ls_nro_formulario) then
	Messagebox('Aviso', 'El Nro. del Formulario no ha sido definido, ¡Verifique!')
	this.reset( )
	dw_master.event getfocus( )
	return
end if 

this.object.nro_formulario	[al_row] = ls_nro_formulario
this.object.nro_item	      [al_row] = of_nro_item(this)


end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3374
integer height = 1256
long backcolor = 79741120
string text = "Autorización IQPF Transporte"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_autorizacion_transporte dw_autorizacion_transporte
end type

on tabpage_3.create
this.dw_autorizacion_transporte=create dw_autorizacion_transporte
this.Control[]={this.dw_autorizacion_transporte}
end on

on tabpage_3.destroy
destroy(this.dw_autorizacion_transporte)
end on

type dw_autorizacion_transporte from u_dw_abc within tabpage_3
integer x = 23
integer y = 24
integer width = 3282
integer height = 1196
string dataobject = "d_abc_autor_iqpf_transporte_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master
//idw_det  =  			tab_1.tabpage_1.dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_formulario
Long		ll_item, ll_row

ll_row = dw_master.GetRow()

ls_nro_formulario = dw_master.object.nro_formulario [ll_row]

if ls_nro_formulario = '' or isnull(ls_nro_formulario) then
	Messagebox('Aviso', 'El Nro. del Formulario no ha sido definido, ¡Verifique!')
	this.reset( )
	dw_master.event getfocus( )
	return
end if 

this.object.nro_formulario	[al_row] = ls_nro_formulario
this.object.nro_item	      [al_row] = of_nro_item(this)

end event

type cb_1 from commandbutton within w_cm338_autorizacion_iqpf
integer x = 1166
integer y = 40
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_nro_formulario

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro_formulario = Trim(sle_nro.text)

of_retrieve(ls_nro_formulario)
end event

type sle_nro from singlelineedit within w_cm338_autorizacion_iqpf
integer x = 503
integer y = 44
integer width = 654
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type st_nro from statictext within w_cm338_autorizacion_iqpf
integer x = 32
integer y = 28
integer width = 448
integer height = 132
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nùmero Autorización:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cm338_autorizacion_iqpf
event ue_display ( string as_columna,  long al_row )
integer x = 27
integer y = 192
integer width = 3406
integer height = 1012
boolean bringtotop = true
string dataobject = "d_abc_autorizacion_iqpf_ff"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "almacen"
		ls_sql = "SELECT ALMACEN AS CODIGO_ALMACEN, " &
				  + "desc_almacen AS DESCRIPCION_ALMACEN " &
				  + "FROM ALMACEN " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.almacen	[al_row] = ls_codigo
			this.object.desc_almacen	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
//		
//	case "ot_adm"
//		ls_sql = "SELECT ot_adm AS CODIGO_ot_adm, " &
//				  + "descripcion AS DESCRIPCION_ot_adm " &
//				  + "FROM ot_administracion " 
//					 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.ot_adm		[al_row] = ls_codigo
//			this.object.desc_ot_adm	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//		return		
//
//	case "centro_benef"
//		ls_sql = "SELECT centro_benef AS centro_beneficio, " &
//				  + "desc_centro AS DESCRIPCION_centro " &
//				  + "FROM centro_beneficio " &
//				  + "where flag_estado = '1'" &
//					 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.centro_benef	[al_row] = ls_codigo
//			this.object.desc_centro		[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//		return		
//
//	case "cod_uso_mp"
//		ls_sql = "SELECT cod_uso AS cod_uso_mp, " &
//				  + "descripcion AS DESCRIPCION_uso " &
//				  + "FROM tg_usos_materia_prima " &
//				  + "where flag_estado = '1'" &
//					 
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.cod_uso_mp	[al_row] = ls_codigo
//			this.object.desc_uso_mp	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//		return		
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'// = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
idw_mst  = 			dw_master
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "almacen"
		
		select desc_almacen
			into :ls_data
		from almacen
		where almacen = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de almacén no existe o no está activo", StopSign!)
			this.object.almacen	[row] = ls_null
			this.object.desc_almacen	[row] = ls_null
			return 1
		end if

		this.object.desc_almacen	[row] = ls_data
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

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

event ue_insert_pre;call super::ue_insert_pre;String ls_usuario_nombre
this.object.fecha_registro 		[al_row] = f_fecha_Actual()
this.object.fecha_emision 		[al_row] = f_fecha_Actual()
this.object.fecha_vencimiento [al_row] = f_fecha_Actual()
this.object.cod_usr  	 [al_row] = gs_user
this.object.p_logo.filename 			   = gs_logo

Select nombre
  into :ls_usuario_nombre
  From usuario
 where cod_usr =:gs_user;

this.object.usuario_nombre [al_row] = ls_usuario_nombre

is_action = 'new'
end event

