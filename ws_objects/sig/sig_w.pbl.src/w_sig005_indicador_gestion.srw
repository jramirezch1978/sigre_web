$PBExportHeader$w_sig005_indicador_gestion.srw
forward
global type w_sig005_indicador_gestion from w_abc
end type
type tab_1 from tab within w_sig005_indicador_gestion
end type
type tabpage_1 from userobject within tab_1
end type
type dw_gestion from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_gestion dw_gestion
end type
type tabpage_2 from userobject within tab_1
end type
type st_1 from statictext within tabpage_2
end type
type st_gestion from statictext within tabpage_2
end type
type dw_ano from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
st_1 st_1
st_gestion st_gestion
dw_ano dw_ano
end type
type tabpage_3 from userobject within tab_1
end type
type st_periodo_item from statictext within tabpage_3
end type
type st_periodo_gestion from statictext within tabpage_3
end type
type st_4 from statictext within tabpage_3
end type
type st_3 from statictext within tabpage_3
end type
type st_2 from statictext within tabpage_3
end type
type st_ano from statictext within tabpage_3
end type
type dw_periodo from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
st_periodo_item st_periodo_item
st_periodo_gestion st_periodo_gestion
st_4 st_4
st_3 st_3
st_2 st_2
st_ano st_ano
dw_periodo dw_periodo
end type
type tab_1 from tab within w_sig005_indicador_gestion
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
end type
end forward

global type w_sig005_indicador_gestion from w_abc
integer width = 2853
integer height = 1452
string title = "(SIG005) Mantenimiento Indicadores Gestion"
string menuname = "m_abc_mantenimiento"
long backcolor = 15793151
tab_1 tab_1
end type
global w_sig005_indicador_gestion w_sig005_indicador_gestion

type variables
DataWindow idw_gestion,idw_ano,idw_periodo
end variables

on w_sig005_indicador_gestion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_mantenimiento" then this.MenuID = create m_abc_mantenimiento
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_sig005_indicador_gestion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event open;call super::open;idw_gestion = tab_1.tabpage_1.dw_gestion
idw_ano = tab_1.tabpage_2.dw_ano
idw_periodo = tab_1.tabpage_3.dw_periodo

idw_gestion.SetTransObject(sqlca)
idw_ano.SetTransObject(sqlca)
idw_periodo.SetTransObject(sqlca)

idw_gestion.Retrieve()
idw_gestion.ScrollTorow(1)
idw_gestion.SetFocus()

tab_1.tabpage_1.dw_gestion.of_protect()
tab_1.tabpage_2.dw_ano.of_protect()
tab_1.tabpage_3.dw_periodo.of_protect()

idw_1 = idw_gestion
end event

event ue_insert;call super::ue_insert;idw_1.event ue_insert()
end event

event ue_modify;call super::ue_modify;int li_protect
long ll_nbrow
string ls_gestion,ls_flag

if idw_1 = idw_gestion then
	
	tab_1.tabpage_1.dw_gestion.of_protect()
	
	li_protect = integer(idw_gestion.Object.area.Protect)
	li_protect = integer(idw_gestion.Object.ind_gestion.Protect)

	IF li_protect = 0 THEN
   	idw_gestion.Object.area.Protect = 1
		idw_gestion.Object.ind_gestion.Protect = 1
	END IF
	
end if

if idw_1 = idw_ano then

	tab_1.tabpage_2.dw_ano.of_protect()
	
	li_protect = integer(idw_ano.Object.ano.Protect)

	IF li_protect = 0 THEN
   	idw_ano.Object.ano.Protect = 1
	END IF
	
end if

if idw_1 = idw_periodo then
	
	tab_1.tabpage_3.dw_periodo.of_protect()
	
	li_protect = integer(idw_periodo.Object.mes.Protect)

	IF li_protect = 0 THEN
   	idw_periodo.Object.mes.Protect = 1
	END IF
	
	ll_nbrow = idw_periodo.RowCount()
	
	if ll_nbrow <= 0 then return
	
	ls_gestion = idw_periodo.object.ind_gestion[1]
	
	select flag_fuente_dato into :ls_flag from indicador_gestion where ind_gestion = :ls_gestion;
	
	if ls_flag = 'P' then
		idw_periodo.Object.dato_real1.Protect = 1
		idw_periodo.Object.dato_real2.Protect = 1
		idw_periodo.Object.dato_real3.Protect = 1
	end if
	
end if
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

tab_1.tabpage_1.dw_gestion.AcceptText()
tab_1.tabpage_2.dw_ano.AcceptText()
tab_1.tabpage_3.dw_periodo.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	tab_1.tabpage_1.dw_gestion.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_gestion.Update() = -1 then		// Grabacion del Gestion
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_2.dw_ano.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_ano.Update() = -1 then		// Grabacion del Año
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_3.dw_periodo.ii_update = 1 THEN
	IF tab_1.tabpage_3.dw_periodo.Update() = -1 then		// Grabacion de la Periodo
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_1.tabpage_1.dw_gestion.ii_update = 0
	tab_1.tabpage_2.dw_ano.ii_update = 0
	tab_1.tabpage_3.dw_periodo.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;//Override
long ll_row,ll_foundrow,ll_nbrow
integer i
string ls_cod, ls_desc

ll_row = idw_1.GetRow()

if ll_row <> 0 then
	
	if idw_1 = idw_gestion then
		ls_cod = idw_gestion.object.ind_gestion[ll_row]
		ls_desc = idw_gestion.object.descripcion[ll_row]
	end if
	if idw_1 = idw_ano then
		ls_cod = string(idw_ano.object.ano[ll_row])
//		ls_desc = idw_ano.object.descripcion[ll_row]
	end if
	if idw_1 = idw_periodo then
		ls_cod = string(idw_periodo.object.mes[ll_row])
//		ls_desc = idw_periodo.object.descripcion[ll_row]
	end if
	
	if isnull(ls_cod) or ls_cod = "" then
		messagebox("Aviso","Debe de Ingresar un código válido en el registro previo")	
		ib_update_check = FALSE
		return
	end if
	if idw_1 = idw_gestion then //solamente idw_gestion tiene descripcion valida
	
		if isnull(ls_desc) or ls_desc = "" then
			messagebox("Aviso","Debe de Ingresar una descripción válida en el registro previo")	
			ib_update_check = FALSE
			return
		end if
		
	end if

end if
end event

type tab_1 from tab within w_sig005_indicador_gestion
integer x = 37
integer y = 28
integer width = 2747
integer height = 1220
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
long backcolor = 15793151
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
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

event selectionchanged;string ls_cod,ls_desc
long row

if selectedtab = 1 then
	idw_1 = idw_gestion
end if
if selectedtab = 2 then
	row = idw_gestion.getrow()
	if row = 0 then return
	ls_cod = idw_gestion.object.ind_gestion[row]
	ls_desc = idw_gestion.object.descripcion[row]
	if isnull(ls_cod) or ls_cod = '' then 
		tab_1.selectedtab = 1
		return
	end if
	idw_1 = idw_ano
	tab_1.tabpage_2.st_gestion.text = ls_desc
end if
if selectedtab = 3 then
	row = idw_ano.getrow()
	if row = 0 then return
	ls_cod = string(idw_ano.object.ano[row])
	if isnull(ls_cod) or ls_cod = '' then 
		tab_1.selectedtab = 2
		return
	end if
	string ls_gestion
	integer li_item
	ls_gestion = idw_ano.object.ind_gestion[row]
	li_item = idw_ano.object.item[row]
	idw_1 = idw_periodo
	tab_1.tabpage_3.st_ano.text = string(ls_cod)
	idw_periodo.retrieve(ls_gestion,li_item,integer(ls_cod))
	idw_periodo.TriggerEvent(rowfocuschanged!)
	tab_1.tabpage_3.st_periodo_gestion.text 	= ls_gestion
	tab_1.tabpage_3.st_periodo_item.text		= string(li_item)
	tab_1.tabpage_3.st_ano.text					= ls_cod

end if
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2711
integer height = 1092
long backcolor = 15793151
string text = "Indicador Gestion"
long tabtextcolor = 33554432
long tabbackcolor = 15793151
string picturename = "Compile!"
long picturemaskcolor = 536870912
dw_gestion dw_gestion
end type

on tabpage_1.create
this.dw_gestion=create dw_gestion
this.Control[]={this.dw_gestion}
end on

on tabpage_1.destroy
destroy(this.dw_gestion)
end on

type dw_gestion from u_dw_abc within tabpage_1
integer x = 5
integer y = 32
integer width = 2688
integer height = 1044
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_indicador_gestion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;
if row <> 0 then
	
	str_seleccionar lstr_seleccionar
	
	CHOOSE CASE STRING(dwo.name)
			
		CASE 'area'
			
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT AREA AS CODIGO,DESCRIPCION AS DESCRIPCION '&     	
											 +'FROM AREA_GESTION WHERE FLAG_ESTADO <> '+"0"
		
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			
			IF lstr_seleccionar.s_action = "aceptar" THEN	
				this.object.area[row] = string(lstr_seleccionar.param1[1])
				ii_update = 1
			END IF
			return
			
		CASE 'sistema'
			
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT SISTEMA AS CODIGO,DESCRIPCION AS DESCRIPCION '&     	
											 +'FROM SISTEMA_APLICATIVO WHERE FLAG_ESTADO <> '+"0"
		
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			
			IF lstr_seleccionar.s_action = "aceptar" THEN	
				this.object.sistema[row] = string(lstr_seleccionar.param1[1])
				ii_update = 1
			END IF
			return

	end choose
	
	string ls_cod,ls_desc
	ls_cod = this.object.ind_gestion[row]
	ls_desc = this.object.descripcion[row]
	if isnull(ls_cod) or ls_cod = '' or isnull(ls_desc) or ls_desc = '' then
		tab_1.selectedtab = 1
		return
	end if
	idw_ano.Retrieve(ls_cod)
	tab_1.tabpage_2.st_gestion.text = ls_desc
	tab_1.SelectedTab = 2
	idw_1 = tab_1.tabpage_2.dw_ano
	tab_1.tabpage_2.dw_ano.TriggerEvent(RowFocusChanged!)
	
end if
end event

event itemchanged;call super::itemchanged;long ll_nbrow,ll_foundrow
integer i
string ls_cod,ls_null,ls_desc

setnull(ls_null)

this.AcceptText()

ll_nbrow = this.RowCount()

if ll_nbrow <> 0 then
	
	if dwo.name = 'area' then
		
		if isnull(data) or data = '' then return
		
		select descripcion into :ls_desc from area_gestion where area = :data;
		
		if isnull(ls_desc) or ls_desc = '' then
			messagebox("Aviso","El Área introducida no existe, por favor reintente")
			this.SetITem(row,'area',ls_null)
			this.SetColumn(1)
			this.Scrolltorow(row)
			this.SetFocus()
			return row
		end if
		
	else
	
		ls_cod = this.object.ind_gestion[row]
		
		ll_foundrow = this.Find("ind_gestion = '" + ls_cod + "'", 1, ll_nbrow)
	
		do while ll_foundrow > 0 
			
			ll_foundrow++
	
			IF ll_foundrow > ll_nbrow THEN EXIT
	
			ll_foundrow = this.Find("ind_gestion = '" + ls_cod + "'", ll_foundrow, ll_nbrow)
	
			if ll_foundrow <> 0 then
				messagebox("Aviso","Hay un código repetido en Indicador de Gestion, no se puede proceder")
				this.SetITem(row,'ind_gestion',ls_null)
				this.SetColumn(2)
				this.Scrolltorow(row)
				this.SetFocus() 
				return row
			end if
			
		loop
			
	end if
	
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <> 0 then
	f_select_current_row(this)
	string ls_cod,ls_desc
	ls_cod = this.object.ind_gestion[currentrow]
	ls_desc = this.object.descripcion[currentrow]
	if isnull(ls_cod) or ls_cod = '' or isnull(ls_desc) or ls_desc = '' then
		tab_1.selectedtab = 1
		return
	end if
	idw_ano.SetFocus()
	idw_ano.Retrieve(ls_cod)
	tab_1.tabpage_2.st_gestion.text = ls_desc
end if
end event

event ue_insert;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row
string ls_cod,ls_desc,ls_flag

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	
	if ll_row <> 1 then
		
		ls_cod = this.object.ind_gestion[ll_row - 1]
		ls_desc = this.object.descripcion[ll_row - 1]

		if isnull(ls_cod) or ls_cod = "" then
			messagebox("Aviso","Debe de Ingresar un código válido en el registro previo")	
			this.DeleteRow(ll_row)
			return 0
		end if
		if isnull(ls_desc) or ls_desc = "" then
			messagebox("Aviso","Debe de Ingresar una descripción válida en el registro previo")	
			this.DeleteRow(ll_row)
			return 0
		end if
		
	end if
	
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2711
integer height = 1092
long backcolor = 15793151
string text = "Indicador de Gestion Año"
long tabtextcolor = 33554432
long tabbackcolor = 15793151
string picturename = "DesignMode!"
long picturemaskcolor = 536870912
st_1 st_1
st_gestion st_gestion
dw_ano dw_ano
end type

on tabpage_2.create
this.st_1=create st_1
this.st_gestion=create st_gestion
this.dw_ano=create dw_ano
this.Control[]={this.st_1,&
this.st_gestion,&
this.dw_ano}
end on

on tabpage_2.destroy
destroy(this.st_1)
destroy(this.st_gestion)
destroy(this.dw_ano)
end on

type st_1 from statictext within tabpage_2
integer x = 64
integer y = 36
integer width = 489
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Indicador de Gestión :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_gestion from statictext within tabpage_2
integer x = 567
integer y = 36
integer width = 1641
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
boolean focusrectangle = false
end type

type dw_ano from u_dw_abc within tabpage_2
integer x = 5
integer y = 136
integer width = 2432
integer height = 932
boolean bringtotop = true
string dataobject = "d_indicador_gestion_ano"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;if row <> 0 then

	str_seleccionar lstr_seleccionar
	
	choose case string(dwo.name)
		
		case 'und_obj1'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT UND AS CODIGO,DESC_UNIDAD AS DESCRIPCION '&     	
											 +'FROM UNIDAD'
		
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			
			IF lstr_seleccionar.s_action = "aceptar" THEN	
				this.object.und_obj1[row] = string(lstr_seleccionar.param1[1])
			END If
			return

			
		case 'und_obj2'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT UND AS CODIGO,DESC_UNIDAD AS DESCRIPCION '&     	
											 +'FROM UNIDAD'
		
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			
			IF lstr_seleccionar.s_action = "aceptar" THEN	
				this.object.und_obj2[row] = string(lstr_seleccionar.param1[1])
			END If
			return
			
		case 'und_obj3'
		
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT UND AS CODIGO,DESC_UNIDAD AS DESCRIPCION '&     	
											 +'FROM UNIDAD'
		
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			
			IF lstr_seleccionar.s_action = "aceptar" THEN	
				this.object.und_obj3[row] = string(lstr_seleccionar.param1[1])
			END If
			return
			
	end choose
	
	string ls_cod,ls_desc,ls_ind_gestion
	integer li_item
	ls_cod = string(this.object.ano[row])
	
	if isnull(ls_cod) or ls_cod = '' then
		tab_1.selectedtab = 2
		return
	end if
			
	ls_ind_gestion = this.object.ind_gestion[row]
	li_item			= this.object.item[row]
	idw_periodo.Retrieve(ls_ind_gestion,li_item,integer(ls_cod))
			
	tab_1.tabpage_3.st_ano.text = string(ls_cod)
	tab_1.tabpage_3.st_periodo_gestion.text = string(ls_ind_gestion)
	tab_1.tabpage_3.st_periodo_item.text = string(li_item)
	tab_1.SelectedTab = 3
	idw_1 = tab_1.tabpage_3.dw_periodo
	
	idw_periodo.TriggerEvent(RowFocusChanged!)
		
end if
end event

event itemchanged;call super::itemchanged;/*
long ll_nbrow,ll_foundrow
integer i
string ls_cod,ls_null,ls_desc

setnull(ls_null)
*/

this.AcceptText()

if isnull(this.object.ano[row]) then
	messagebox("Aviso","Debe de ingresar un año valido")
	this.SetColumn(3)
	return row
end if

/*
SE ANULA POR QUE GESTION,ITEM Y AÑO HACEN EL PK
ll_nbrow = this.RowCount()

if ll_nbrow <> 0 then
	
		ls_cod = this.object.ano[row]
		
		ll_foundrow = this.Find("ind_gestion = '" + ls_cod + "'", 1, ll_nbrow)
	
		do while ll_foundrow > 0 
			
			ll_foundrow++
	
			IF ll_foundrow > ll_nbrow THEN EXIT
	
			ll_foundrow = this.Find("ind_gestion = '" + ls_cod + "'", ll_foundrow, ll_nbrow)
	
			if ll_foundrow <> 0 then
				messagebox("Aviso","Hay un código repetido dentro de los nuevos registros")
				this.SetITem(row,"ind_gestion",ls_null)
				this.SetColumn(2)
				this.Scrolltorow(row)
				this.SetFocus() 
				return row
			end if
			
		loop
	
end if
*/
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow <> 0 then

	f_select_current_row(this)
	
	string ls_cod,ls_ind_gestion
	integer li_item
	ls_cod = string(this.object.ano[currentrow])
	
	if isnull(ls_cod) or ls_cod = '' then
		tab_1.selectedtab = 2
		return
	end if
	
	ls_ind_gestion = this.object.ind_gestion[currentrow]
	li_item			= this.object.item[currentrow]
	
	idw_periodo.Retrieve(ls_ind_gestion,li_item,integer(ls_cod))
	
	tab_1.tabpage_3.st_periodo_gestion.text = string(ls_ind_gestion)
	tab_1.tabpage_3.st_periodo_item.text = string(li_item)
	tab_1.tabpage_3.st_ano.text = ls_cod
	
	tab_1.tabpage_3.dw_periodo.TriggerEvent(RowFocusChanged!)
	
else
	
	f_select_current_row(this)
	
end if
end event

event ue_insert;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row
string ls_cod,ls_desc,ls_flag

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	
	if ll_row <> 1 then
		
		ls_cod = string(this.object.ano[ll_row - 1])

		if isnull(ls_cod) or string(ls_cod) = "" then
			messagebox("Aviso","Debe de Ingresar un código válido en el registro previo")	
			this.DeleteRow(ll_row)
			return 0
		end if

	end if
	
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

ll_row = idw_gestion.GetRow()
ls_cod = idw_gestion.object.ind_gestion[ll_row]
ll_row = this.getrow()
this.object.ind_gestion[ll_row] = ls_cod
ll_row = this.RowCount()
this.object.item[ll_row] = ll_row
this.SetColumn(3)


RETURN ll_row
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 2711
integer height = 1092
long backcolor = 15793151
string text = "Indicador de Gestion Periodo"
long tabtextcolor = 33554432
long tabbackcolor = 15793151
string picturename = "SelectAndRun!"
long picturemaskcolor = 536870912
st_periodo_item st_periodo_item
st_periodo_gestion st_periodo_gestion
st_4 st_4
st_3 st_3
st_2 st_2
st_ano st_ano
dw_periodo dw_periodo
end type

on tabpage_3.create
this.st_periodo_item=create st_periodo_item
this.st_periodo_gestion=create st_periodo_gestion
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_ano=create st_ano
this.dw_periodo=create dw_periodo
this.Control[]={this.st_periodo_item,&
this.st_periodo_gestion,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_ano,&
this.dw_periodo}
end on

on tabpage_3.destroy
destroy(this.st_periodo_item)
destroy(this.st_periodo_gestion)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_ano)
destroy(this.dw_periodo)
end on

type st_periodo_item from statictext within tabpage_3
integer x = 1225
integer y = 36
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
alignment alignment = center!
boolean focusrectangle = false
end type

type st_periodo_gestion from statictext within tabpage_3
integer x = 366
integer y = 36
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within tabpage_3
integer x = 878
integer y = 36
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Nº Item :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within tabpage_3
integer x = 14
integer y = 36
integer width = 343
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Ind. Gestion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within tabpage_3
integer x = 1851
integer y = 36
integer width = 402
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
string text = "Ind. Gestion Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_ano from statictext within tabpage_3
integer x = 2263
integer y = 36
integer width = 389
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_periodo from u_dw_abc within tabpage_3
integer x = 5
integer y = 136
integer width = 2688
integer height = 940
boolean bringtotop = true
string dataobject = "d_indicador_gestion_periodo"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event itemchanged;call super::itemchanged;this.AcceptText()
end event

event rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event ue_insert;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row
string ls_cod,ls_desc,ls_flag

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	
	if ll_row <> 1 then
		
		ls_cod = string(this.object.mes[ll_row - 1])

		if isnull(ls_cod) or string(ls_cod) = '' then
			messagebox("Aviso","Debe de Ingresar un código válido en el registro previo")	
			this.DeleteRow(ll_row)
			return 0
		end if

	end if
	
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

this.object.ind_gestion[ll_row] = trim(string(st_periodo_gestion.text))
this.object.item[ll_row] = integer(st_periodo_item.text)
this.object.ano[ll_row] = integer(st_ano.text)
this.SetColumn(4)

select flag_fuente_dato into :ls_flag from indicador_gestion 
where ind_gestion = trim(:st_periodo_gestion.text);

if ls_flag = 'P' then
	this.object.dato_real1.protect = 1
	this.object.dato_real2.protect = 1
	this.object.dato_real3.protect = 1
end if

RETURN ll_row
end event

