$PBExportHeader$w_cn058_matriz_vta_bien_serv.srw
forward
global type w_cn058_matriz_vta_bien_serv from w_abc
end type
type tab_1 from tab within w_cn058_matriz_vta_bien_serv
end type
type tabpage_1 from userobject within tab_1
end type
type dw_vta_bienes from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_vta_bienes dw_vta_bienes
end type
type tabpage_2 from userobject within tab_1
end type
type dw_vta_servicios from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_vta_servicios dw_vta_servicios
end type
type tab_1 from tab within w_cn058_matriz_vta_bien_serv
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_cn058_matriz_vta_bien_serv from w_abc
integer width = 3483
integer height = 2600
string title = "[CN058] Matrices de Venta de bien y Servicio"
string menuname = "m_abc_master_smpl"
tab_1 tab_1
end type
global w_cn058_matriz_vta_bien_serv w_cn058_matriz_vta_bien_serv

type variables
u_dw_abc	idw_vta_bienes, idw_vta_servicios
end variables

forward prototypes
public subroutine of_asigna_dws ()
end prototypes

public subroutine of_asigna_dws ();idw_vta_servicios = tab_1.tabpage_2.dw_vta_servicios
idw_vta_bienes 	= tab_1.tabpage_1.dw_vta_bienes
end subroutine

on w_cn058_matriz_vta_bien_serv.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_cn058_matriz_vta_bien_serv.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_vta_bienes.SetTransObject(SQLCA)
idw_vta_servicios.SetTransObject(SQLCA)

idw_vta_bienes.Retrieve()
idw_vta_servicios.Retrieve()


idw_vta_bienes.ii_protect = 0
idw_vta_bienes.of_protect()

idw_vta_servicios.ii_protect = 0
idw_vta_servicios.of_protect()

idw_1 = idw_vta_bienes

idw_vta_bienes.setFocus()



end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

idw_vta_bienes.width  = tab_1.tabpage_1.width  - idw_vta_bienes.x - 10
idw_vta_bienes.height = tab_1.tabpage_1.height - idw_vta_bienes.y - 10

idw_vta_servicios.width  = tab_1.tabpage_2.width  - idw_vta_servicios.x - 10
idw_vta_servicios.height = tab_1.tabpage_2.height - idw_vta_servicios.y - 10

end event

event ue_insert;//Override
MessageBox("Error", "No esta permitido Insertar registro en esta ventana", StopSign!)
end event

event ue_delete;//Override
MessageBox("Error", "No esta permitido Eliminar registro en esta ventana", StopSign!)
end event

event ue_modify;call super::ue_modify;idw_vta_bienes.of_protect()
idw_vta_servicios.of_protect()
end event

event ue_update_pre;call super::ue_update_pre;

ib_update_check = False

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_vta_bienes ) <> true then return

// Verifica que campos son requeridos y tengan valores
if gnvo_app.of_row_Processing( idw_vta_servicios ) <> true then return

ib_update_check = true
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
idw_vta_bienes.AcceptText()
idw_vta_servicios.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	idw_vta_bienes.of_create_log()
	idw_vta_servicios.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


IF	idw_vta_bienes.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_vta_bienes.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_vta_bien", ls_msg, StopSign!)
	END IF
END IF

IF idw_vta_servicios.ii_update = 1 AND lbo_ok = TRUE THEN
	IF idw_vta_servicios.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion idw_vta_servicios", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = idw_vta_bienes.of_save_log()
		lbo_ok = idw_vta_servicios.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	idw_vta_bienes.ii_update = 0
	idw_vta_servicios.ii_update = 0
	idw_vta_bienes.il_totdel = 0
	idw_vta_servicios.il_totdel = 0
	
	idw_vta_bienes.ResetUpdate()
	idw_vta_servicios.ResetUpdate()
	
	f_mensaje('Grabación realizada satisfactoriamente', '')
END IF

end event

type tab_1 from tab within w_cn058_matriz_vta_bien_serv
integer width = 3378
integer height = 2352
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
integer y = 112
integer width = 3342
integer height = 2224
long backcolor = 79741120
string text = "Venta de Bienes"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_vta_bienes dw_vta_bienes
end type

on tabpage_1.create
this.dw_vta_bienes=create dw_vta_bienes
this.Control[]={this.dw_vta_bienes}
end on

on tabpage_1.destroy
destroy(this.dw_vta_bienes)
end on

type dw_vta_bienes from u_dw_abc within tabpage_1
integer width = 3072
integer height = 1920
integer taborder = 20
string dataobject = "d_abc_matriz_venta_bienes_tbl"
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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
	case "valor"
		ls_sql = "select m.matriz as matriz, " &
				 + "m.descripcion as desc_matriz " &
				 + "from matriz_cntbl_finan m " &
				 + "where m.flag_estado = '1'" &
				 + "  and m.matriz like 'CC%'" &
				 + "  and m.descripcion not like '%ANTICIPO%'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.valor			[al_row] = ls_codigo
			this.object.desc_matriz	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'valor'
		
		// Verifica que codigo ingresado exista			
		Select desc_matriz
	     into :ls_data
		  from matriz_cntbl_finan m
		 Where m.matriz = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.valor			[row] = gnvo_app.is_null
			this.object.desc_matriz	[row] = gnvo_app.is_null
			MessageBox('Error', 'Matriz contable ingresada no existe o no esta activo, por favor verifique!', StopSign!)
			return 1
		end if

		this.object.desc_matriz			[row] = ls_data


END CHOOSE
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3342
integer height = 2224
long backcolor = 79741120
string text = "Venta de Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_vta_servicios dw_vta_servicios
end type

on tabpage_2.create
this.dw_vta_servicios=create dw_vta_servicios
this.Control[]={this.dw_vta_servicios}
end on

on tabpage_2.destroy
destroy(this.dw_vta_servicios)
end on

type dw_vta_servicios from u_dw_abc within tabpage_2
integer width = 3072
integer height = 1920
string dataobject = "d_abc_matriz_venta_Servicios_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "valor"
		ls_sql = "select m.matriz as matriz, " &
				 + "m.descripcion as desc_matriz " &
				 + "from matriz_cntbl_finan m " &
				 + "where m.flag_estado = '1'" &
				 + "  and m.matriz like 'CC%'" &
				 + "  and m.descripcion not like '%ANTICIPO%'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.valor			[al_row] = ls_codigo
			this.object.desc_matriz	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
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

event itemchanged;call super::itemchanged;String ls_data

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'valor'
		
		// Verifica que codigo ingresado exista			
		Select desc_matriz
	     into :ls_data
		  from matriz_cntbl_finan m
		 Where m.matriz = :data 
		   and flag_estado = '1';
			
		// Verifica que articulo solo sea de reposicion		
		if SQLCA.SQLCode = 100 then
			this.object.valor			[row] = gnvo_app.is_null
			this.object.desc_matriz	[row] = gnvo_app.is_null
			MessageBox('Error', 'Matriz contable ingresada no existe o no esta activo, por favor verifique!', StopSign!)
			return 1
		end if

		this.object.desc_matriz			[row] = ls_data


END CHOOSE
end event

