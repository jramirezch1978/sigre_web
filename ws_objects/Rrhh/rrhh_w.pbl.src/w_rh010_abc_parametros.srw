$PBExportHeader$w_rh010_abc_parametros.srw
forward
global type w_rh010_abc_parametros from w_abc_master_smpl
end type
type tab_1 from tab within w_rh010_abc_parametros
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tab_1 from tab within w_rh010_abc_parametros
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_rh010_abc_parametros from w_abc_master_smpl
integer width = 3410
integer height = 1936
string title = "(RH010) Parámetros de Recursos Humanos"
string menuname = "m_master_simple"
tab_1 tab_1
end type
global w_rh010_abc_parametros w_rh010_abc_parametros

type variables
integer ii_count
end variables

on w_rh010_abc_parametros.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_rh010_abc_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
end on

event ue_open_pre;//Override
THIS.EVENT POST ue_set_access()					// setear los niveles de acceso IEMC
THIS.EVENT POST ue_set_access_cb()				// setear los niveles de acceso IEMC
THIS.EVENT Post ue_open_pos()
im_1 = CREATE m_rButton   


idw_1 = tab_1.tabpage_2.dw_2             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

idw_1 = tab_1.tabpage_1.dw_1             // asignar dw corriente
idw_1.SetTransObject(SQLCA)
idw_1.of_protect()         	// bloquear modificaciones al dw_master

//is_tabla = tab_1.tabpage_1.dw_1.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

tab_1.tabpage_1.dw_1.retrieve()
tab_1.tabpage_2.dw_2.retrieve()

long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

select *
into :ii_count
from rrhhparam ;

end event

event ue_insert;call super::ue_insert;if ii_count = 1 then 
	if idw_1 = tab_1.tabpage_1.dw_1 then
		tab_1.tabpage_1.dw_1.deleterow(0) 
		//Para indicarle que no se ha realizado un cambio en la Base DE Datos
		tab_1.tabpage_1.dw_1.ii_update=0
		messagebox("Sistema de Seguridad","Solo se debe existir un registro")
	else
		tab_1.tabpage_2.dw_2.deleterow(0) 
		//Para indicarle que no se ha realizado un cambio en la Base DE Datos
		tab_1.tabpage_2.dw_2.ii_update=0
		messagebox("Sistema de Seguridad","Solo se debe existir un registro")
	end if
		
end if 

end event

event ue_modify;//Override
if idw_1 = tab_1.tabpage_1.dw_1 then
	
	tab_1.tabpage_1.dw_1.of_protect()
else
	
	tab_1.tabpage_2.dw_2.of_protect()
	
end if
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;tab_1.tabpage_1.dw_1.of_set_flag_replicacion( )
end event

event ue_update;//Override

Boolean  lbo_ok = TRUE
String	ls_msg

tab_1.tabpage_1.dw_1.AcceptText()
tab_1.tabpage_2.dw_2.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	tab_1.tabpage_1.dw_1.of_create_log()
	tab_1.tabpage_2.dw_2.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)

IF	tab_1.tabpage_1.dw_1.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_1.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	tab_1.tabpage_2.dw_2.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_2.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		tab_1.tabpage_1.dw_1.of_save_log()
		tab_1.tabpage_2.dw_2.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_1.tabpage_1.dw_1.ii_update = 0
	tab_1.tabpage_1.dw_1.il_totdel = 0
	tab_1.tabpage_2.dw_2.ii_update = 0
	tab_1.tabpage_2.dw_2.il_totdel = 0
END IF

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh010_abc_parametros
boolean visible = false
integer x = 2939
integer y = 1468
integer width = 256
integer height = 212
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::clicked;// Override
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1

end event

type tab_1 from tab within w_rh010_abc_parametros
integer x = 14
integer y = 24
integer width = 3237
integer height = 1700
integer taborder = 10
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
integer y = 104
integer width = 3200
integer height = 1580
long backcolor = 79741120
string text = "Parametros 1"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_1 dw_1
end type

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_abc within tabpage_1
integer width = 3173
integer height = 1540
string dataobject = "d_parametros_ff"
end type

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;//override
idw_1 = this
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3200
integer height = 1580
long backcolor = 79741120
string text = "Parametros 2"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tabpage_2
integer width = 3173
integer height = 1540
string dataobject = "d_parametros_2_ff"
end type

event clicked;//override
idw_1 = this
end event

event constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

