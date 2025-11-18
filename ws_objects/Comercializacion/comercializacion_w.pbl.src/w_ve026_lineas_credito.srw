$PBExportHeader$w_ve026_lineas_credito.srw
forward
global type w_ve026_lineas_credito from w_abc
end type
type st_1 from statictext within w_ve026_lineas_credito
end type
type pb_buscar from picturebutton within w_ve026_lineas_credito
end type
type uo_search from n_cst_search within w_ve026_lineas_credito
end type
type tab_1 from tab within w_ve026_lineas_credito
end type
type tabpage_1 from userobject within tab_1
end type
type dw_lineas_credito from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_lineas_credito dw_lineas_credito
end type
type tabpage_2 from userobject within tab_1
end type
type dw_consulta_credito from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_consulta_credito dw_consulta_credito
end type
type tab_1 from tab within w_ve026_lineas_credito
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_ve026_lineas_credito
end type
type dw_lista from u_dw_abc within w_ve026_lineas_credito
end type
end forward

global type w_ve026_lineas_credito from w_abc
integer width = 3726
integer height = 2688
string title = "[VE026] Lineas de Credito "
string menuname = "m_mantenimiento_sl"
st_1 st_1
pb_buscar pb_buscar
uo_search uo_search
tab_1 tab_1
dw_master dw_master
dw_lista dw_lista
end type
global w_ve026_lineas_credito w_ve026_lineas_credito

type variables
Integer	ii_dias_credito = 180
u_dw_abc idw_consulta_credito, idw_lineas_credito
end variables

forward prototypes
public subroutine of_asigna_dws ()
public subroutine of_retrieve_lista ()
end prototypes

public subroutine of_asigna_dws ();idw_consulta_credito = tab_1.tabpage_2.dw_consulta_credito
idw_lineas_credito 	= tab_1.tabpage_1.dw_lineas_credito
end subroutine

public subroutine of_retrieve_lista ();dw_lista.Retrieve()

if dw_lista.RowCount() = 0 then
	dw_master.Reset()
	idw_lineas_credito.Reset()
	idw_consulta_credito.Reset()
end if

dw_master.ii_update = 0
idw_lineas_credito.ii_update = 0
idw_consulta_credito.ii_update = 0

dw_master.ResetUpdate()
idw_lineas_credito.ResetUpdate()
idw_consulta_credito.ResetUpdate()

end subroutine

on w_ve026_lineas_credito.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_1=create st_1
this.pb_buscar=create pb_buscar
this.uo_search=create uo_search
this.tab_1=create tab_1
this.dw_master=create dw_master
this.dw_lista=create dw_lista
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.pb_buscar
this.Control[iCurrent+3]=this.uo_search
this.Control[iCurrent+4]=this.tab_1
this.Control[iCurrent+5]=this.dw_master
this.Control[iCurrent+6]=this.dw_lista
end on

on w_ve026_lineas_credito.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.pb_buscar)
destroy(this.uo_search)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.dw_lista)
end on

event resize;call super::resize;of_asigna_dws()

dw_lista.height = newheight - dw_lista.y - 10

dw_master.width  	= newwidth  - dw_master.x - 10
st_1.width  		= newwidth  - st_1.x - 10

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_lineas_credito.width  = tab_1.tabpage_1.width  - idw_lineas_credito.x - 10
idw_lineas_credito.height = tab_1.tabpage_1.height - idw_lineas_credito.y - 10

idw_consulta_credito.width  = tab_1.tabpage_2.width  - idw_consulta_credito.x - 10
idw_consulta_credito.height = tab_1.tabpage_2.height - idw_consulta_credito.y - 10


end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

dw_lista.setTransObject(SQLCA)
dw_master.setTransObject(SQLCA)
idw_consulta_credito.setTransObject(SQLCA)
idw_lineas_credito.setTransObject(SQLCA)

of_retrieve_lista()

idw_1 = dw_master

idw_1.setFocus( )

uo_search.of_set_dw(dw_lista)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
idw_lineas_credito.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	idw_lineas_credito.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF idw_lineas_credito.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_lineas_credito.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = idw_lineas_credito.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_lineas_credito.ii_update = 0
	
	dw_master.il_totdel = 0
	idw_lineas_credito.il_totdel = 0
	
	dw_master.ResetUpdate()
	idw_lineas_credito.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR idw_lineas_credito.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		idw_lineas_credito.ii_update = 0
		
		dw_master.ResetUpdate()
		idw_lineas_credito.ResetUpdate()
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( dw_master ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_lineas_credito ) <> true then	return

if idw_lineas_credito.rowcount() = 0 then 
	messagebox( "Atencion", "No se grabara el documento, falta detalle", StopSign!)
	return
end if


ib_update_check = true

dw_master.of_set_flag_replicacion()
idw_lineas_credito.of_set_flag_replicacion()


end event

event ue_insert;call super::ue_insert;Long  	ll_row
String 	ls_flag_linea_credito
Date		ld_hoy, ld_fec_fin_vig

ld_hoy = Date(gnvo_app.of_fecha_Actual())

IF idw_1 = idw_consulta_credito or idw_1 = dw_master THEN
	
	MessageBox("Error", "No esta permitido ingresar registros en este panel, por favor corrija", StopSign!)
	RETURN

elseif idw_1 = idw_lineas_credito THEN
	
	if dw_master.RowCount() = 0 then
		MessageBox("Error", "No hay registro alguno en el panel dw_mster, por favor corrija", StopSign!)
		return
	end if
	
	//Verifico si tiene linea de credito
	ls_flag_linea_credito = dw_master.object.flag_linea_credito [1]
	
	if ls_flag_linea_credito = '0' then
		MessageBox("Error", "Este proveedor no esta permitido LINEA DE CREDITO, por favor corrija", StopSign!)
		return
	end if
	
	//Verifico que no tenga otra linea pendiente de aprobación
	for ll_row = 1 to idw_1.RowCount()
		if idw_1.object.flag_estado [ll_row] = '3' then
			MessageBox("Error", "Existen LINEAS de CREDITO que estan pendientes de aprobación, por favor corrija", StopSign!)
			return
		elseif idw_1.object.flag_estado [ll_row] = '1' then
			//En caso que este aprobado, hay que verificar la fecha de fin de vigencia
			ld_fec_fin_vig = Date(idw_1.object.fec_fin_vigencia [ll_row])
			
			if ld_fec_fin_vig >= ld_hoy then
				MessageBox("Error", "Existen LINEAS de CREDITO que aun estan vigentes, por favor corrija", StopSign!)
				return
			end if
		end if
	next

END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

type st_1 from statictext within w_ve026_lineas_credito
integer x = 1550
integer width = 2107
integer height = 88
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Datos Generales"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_buscar from picturebutton within w_ve026_lineas_credito
integer x = 1408
integer width = 137
integer height = 96
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\Toolbar\actualiza.png"
end type

event clicked;of_retrieve_lista()
end event

type uo_search from n_cst_search within w_ve026_lineas_credito
integer width = 1376
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

type tab_1 from tab within w_ve026_lineas_credito
integer x = 1554
integer y = 872
integer width = 2313
integer height = 1592
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
alignment alignment = center!
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2277
integer height = 1400
long backcolor = 79741120
string text = "Lineas ~r~nde Crédito"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Toolkit Size Calculator_2!"
long picturemaskcolor = 536870912
dw_lineas_credito dw_lineas_credito
end type

on tabpage_1.create
this.dw_lineas_credito=create dw_lineas_credito
this.Control[]={this.dw_lineas_credito}
end on

on tabpage_1.destroy
destroy(this.dw_lineas_credito)
end on

type dw_lineas_credito from u_dw_abc within tabpage_1
integer width = 2135
integer height = 1240
string dataobject = "d_abc_lineas_credito_tbl"
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_hoy 
Date		ld_fec_fin_vig, ld_fec_ini_vig
Long		ll_dias

ldt_hoy = gnvo_app.of_fecha_actual()

this.object.nro_item 	[al_row] = of_nro_item(this)
this.object.proveedor	[al_row] = dw_master.Object.proveedor[dw_master.getrow()]
this.object.flag_estado	[al_row] = '3'

ld_fec_fin_vig = RelativeDate ( Date(ldt_hoy), ii_dias_credito - 1 )
ld_fec_ini_vig = Date(ldt_hoy)


this.object.fec_registro		[al_row] = ldt_hoy
this.object.fec_ini_vigencia	[al_row] = ld_fec_ini_vig
this.object.fec_fin_vigencia	[al_row] = ld_fec_fin_vig
this.object.cod_usr				[al_row] = gs_user

this.object.cod_moneda			[al_row] = gnvo_app.is_soles
this.object.importe				[al_row] = 0.00

select :ld_fec_fin_vig - :ld_fec_ini_vig
	into :ll_dias
from dual;

this.object.plazo_credito		[al_row] = ll_dias
end event

event itemchanged;call super::itemchanged;
String 	ls_data
date		ld_fec_ini_vig, ld_fec_fin_vig
Long		ll_dias

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'fec_ini_vigencia'
		ld_fec_ini_vig = Date(this.object.fec_ini_vigencia [row])
		
		select trunc(:ld_fec_ini_vig) + :ii_dias_credito - 1
			into :ld_fec_fin_vig
		from dual;
		
		this.object.plazo_credito 		[row] = ii_dias_credito
		this.object.fec_fin_vigencia 	[row] = ld_fec_fin_vig
	
	CASE 'fec_fin_vigencia'
		ld_fec_ini_vig = Date(this.object.fec_ini_vigencia [row])
		ld_fec_fin_vig = Date(this.object.fec_fin_vigencia [row])
		
		select trunc(:ld_fec_fin_vig) - trunc(:ld_fec_ini_vig) + 1 
			into :ll_dias
		from dual;
		
		if ll_dias <= 0 then
			select trunc(:ld_fec_ini_vig + :ii_dias_credito - 1) 
				into :ld_fec_fin_vig
			from dual;
			
			this.object.plazo_credito 		[row] = ii_dias_credito
			this.object.fec_fin_vigencia 	[row] = ld_fec_fin_vig
		
		else
			this.object.plazo_credito 		[row] = ll_dias
		end if
		
		

	CASE 'cod_moneda'
		
		// Verifica que codigo ingresado exista			
		Select descripcion
	     into :ls_data
		  from moneda
		 Where cod_moneda = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.cod_moneda	[row] = gnvo_app.is_null
			MessageBox('Error', 'Código de MONEDA no existe o no esta activo, por favor verifique')
			return 1
		end if

END CHOOSE
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
		
	case "cod_moneda"
		ls_sql = "select cod_moneda as codigo_moneda, " &
				 + "descripcion as descripcion_moneda " &
				 + "from moneda t " &
				 + "where flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if


end choose
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 176
integer width = 2277
integer height = 1400
long backcolor = 79741120
string text = "Consulta de~r~ncreditos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Toolkit Deploy_2!"
long picturemaskcolor = 536870912
dw_consulta_credito dw_consulta_credito
end type

on tabpage_2.create
this.dw_consulta_credito=create dw_consulta_credito
this.Control[]={this.dw_consulta_credito}
end on

on tabpage_2.destroy
destroy(this.dw_consulta_credito)
end on

type dw_consulta_credito from u_dw_abc within tabpage_2
integer width = 2135
integer height = 1240
string dataobject = "d_abc_consula_credito_tbl"
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_master from u_dw_abc within w_ve026_lineas_credito
integer x = 1554
integer y = 96
integer width = 2043
integer height = 768
string dataobject = "d_abc_proveedor_frm"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type dw_lista from u_dw_abc within w_ve026_lineas_credito
integer x = 9
integer y = 100
integer width = 1531
integer height = 2120
string dataobject = "d_lista_proveedor_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event rowfocuschanged;//Overriding
if currentrow <= 0 then return

if currentrow = il_Row then return

il_row = currentrow              // fila corriente

IF this.is_dwform <> 'form' and ii_ss = 1 THEN		        // solo para seleccion individual			
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	RETURN
END IF
end event

event ue_output;call super::ue_output;String ls_proveedor

if al_Row = 0 then return

ls_proveedor = this.object.proveedor  [al_row]

dw_master.Retrieve(ls_proveedor)
idw_consulta_credito.Retrieve(ls_proveedor)
idw_lineas_credito.Retrieve(ls_proveedor)

dw_master.ii_update = 0
idw_consulta_credito.ii_update = 0
idw_lineas_credito.ii_update = 0

dw_master.ResetUpdate()
idw_consulta_credito.ResetUpdate()
idw_lineas_credito.ResetUpdate()
end event

