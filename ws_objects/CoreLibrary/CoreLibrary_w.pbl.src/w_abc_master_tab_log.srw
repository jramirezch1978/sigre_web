$PBExportHeader$w_abc_master_tab_log.srw
$PBExportComments$abc de una tabla en 5 dw, con botones y grabacion de Log Diario
forward
global type w_abc_master_tab_log from w_abc_master_log
end type
type tab_1 from tab within w_abc_master_tab_log
end type
type tabpage_1 from userobject within tab_1
end type
type dw_1 from datawindow within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_1 dw_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_2 from datawindow within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_2 dw_2
end type
type tabpage_3 from userobject within tab_1
end type
type dw_3 from datawindow within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from datawindow within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tab_1 from tab within w_abc_master_tab_log
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_abc_master_tab_log from w_abc_master_log
integer width = 2409
integer height = 1684
tab_1 tab_1
end type
global w_abc_master_tab_log w_abc_master_tab_log

on w_abc_master_tab_log.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_abc_master_tab_log.destroy
call super::destroy
destroy(this.tab_1)
end on

event resize;call super::resize;// override

dw_master.width = newwidth - dw_master.x

tab_1.width  = newwidth  - tab_1.x
tab_1.height = newheight - tab_1.y
end event

event ue_dw_share;call super::ue_dw_share;// Compartir el dw_master con dws secundarios

Integer li_share_status

li_share_status = dw_master.ShareData (tab_1.tabpage_1.dw_1)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW1",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_2.dw_2)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW2",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_3.dw_3)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW3",exclamation!)
	RETURN
END IF

li_share_status = dw_master.ShareData (tab_1.tabpage_4.dw_4)
IF li_share_status <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con DW4",exclamation!)
	RETURN
END IF


end event

event ue_insert_pos;call super::ue_insert_pos;tab_1.tabpage_1.dw_1.ScrollToRow(al_row)
tab_1.tabpage_2.dw_2.ScrollToRow(al_row)
tab_1.tabpage_3.dw_3.ScrollToRow(al_row)
tab_1.tabpage_4.dw_4.ScrollToRow(al_row)

end event

event ue_open_pre;call super::ue_open_pre;THIS.EVENT ue_dw_share()

// deshabilitar dw de tabs
tab_1.tabpage_1.dw_1.enabled = FALSE
tab_1.tabpage_2.dw_2.enabled = FALSE
tab_1.tabpage_3.dw_3.enabled = FALSE
tab_1.tabpage_4.dw_4.enabled = FALSE
end event

event ue_update_pre;call super::ue_update_pre;//tab_1.tabpage_1.dw_1.AcceptText()
//tab_1.tabpage_2.dw_2.AcceptText()
//tab_1.tabpage_3.dw_3.AcceptText()
//tab_1.tabpage_4.dw_4.AcceptText()

end event

type dw_lista from w_abc_master_log`dw_lista within w_abc_master_tab_log
integer x = 928
integer y = 228
end type

type dw_master from w_abc_master_log`dw_master within w_abc_master_tab_log
integer x = 18
integer y = 4
integer width = 1801
integer height = 600
end type

type cb_buscar from w_abc_master_log`cb_buscar within w_abc_master_tab_log
integer x = 2048
integer y = 28
integer taborder = 100
end type

type p_1 from w_abc_master_log`p_1 within w_abc_master_tab_log
integer x = 1888
integer y = 12
end type

type cb_insertar from w_abc_master_log`cb_insertar within w_abc_master_tab_log
integer x = 2048
integer y = 164
integer taborder = 90
end type

type p_2 from w_abc_master_log`p_2 within w_abc_master_tab_log
integer x = 1865
integer y = 136
end type

type cb_modificar from w_abc_master_log`cb_modificar within w_abc_master_tab_log
integer x = 2048
integer y = 300
integer taborder = 80
end type

type cb_eliminar from w_abc_master_log`cb_eliminar within w_abc_master_tab_log
integer x = 2048
integer y = 436
integer taborder = 70
end type

type cb_grabar from w_abc_master_log`cb_grabar within w_abc_master_tab_log
integer x = 2048
integer y = 572
end type

type cb_cancelar from w_abc_master_log`cb_cancelar within w_abc_master_tab_log
integer x = 2048
integer y = 708
end type

type p_3 from w_abc_master_log`p_3 within w_abc_master_tab_log
integer x = 1870
integer y = 268
end type

type p_4 from w_abc_master_log`p_4 within w_abc_master_tab_log
integer x = 1870
integer y = 396
end type

type p_5 from w_abc_master_log`p_5 within w_abc_master_tab_log
integer x = 1883
integer y = 548
end type

type p_6 from w_abc_master_log`p_6 within w_abc_master_tab_log
integer x = 1893
integer y = 688
end type

type cb_1 from w_abc_master_log`cb_1 within w_abc_master_tab_log
integer x = 2048
integer y = 844
end type

type p_7 from w_abc_master_log`p_7 within w_abc_master_tab_log
integer x = 1883
integer y = 828
end type

type tab_1 from tab within w_abc_master_tab_log
integer x = 14
integer y = 628
integer width = 1801
integer height = 928
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
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
integer x = 18
integer y = 112
integer width = 1765
integer height = 800
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
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

type dw_1 from datawindow within tabpage_1
event dwnenter pbm_dwnprocessenter
integer x = 9
integer y = 12
integer width = 494
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event dberror;messagebox("dberror dw_1",SQLCA.SQLErrText,exclamation!)
end event

event itemchanged;dw_master.ii_update = 1
IF is_funcion = 'M' THEN is_val_nuevo = data
end event

event losefocus;THIS.AcceptText()
end event

event clicked;String	ls_type

is_campo = dwo.Name
IF is_funcion = 'M' AND is_campo <> 'datawindow' AND idw_1.ii_update = 0 THEN
	IF of_is_col_protect(is_campo) = 1 THEN
		MessageBox('Error', 'La columna esta protegida')
	ELSE
		ls_type = THIS.Describe(is_campo + ".ColType")
		CHOOSE CASE ls_type
			CASE 'date'
				is_val_anterior = String(THIS.GetItemDate(row,is_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				is_val_anterior = String(THIS.GetItemDateTime(row,is_campo), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					is_val_anterior = THIS.GetItemString(row,is_campo)
				ELSE
					is_val_anterior = String(THIS.GetItemNumber(row,is_campo))
				END IF
		END CHOOSE
	idw_1.of_column_protect(is_campo)
	END IF
END IF
end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1765
integer height = 800
long backcolor = 79741120
string text = "none"
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

type dw_2 from datawindow within tabpage_2
event dwnenter pbm_dwnprocessenter
integer y = 8
integer width = 494
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event dberror;messagebox("dberror dw_2",SQLCA.SQLErrText,exclamation!)
end event

event itemchanged;dw_master.ii_update = 1
IF is_funcion = 'M' THEN is_val_nuevo = data
end event

event losefocus;THIS.AcceptText()
end event

event clicked;String	ls_type

is_campo = dwo.Name
IF is_funcion = 'M' AND is_campo <> 'datawindow' AND idw_1.ii_update = 0 THEN
	IF of_is_col_protect(is_campo) = 1 THEN
		MessageBox('Error', 'La columna esta protegida')
	ELSE
		ls_type = THIS.Describe(is_campo + ".ColType")
		CHOOSE CASE ls_type
			CASE 'date'
				is_val_anterior = String(THIS.GetItemDate(row,is_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				is_val_anterior = String(THIS.GetItemDateTime(row,is_campo), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					is_val_anterior = THIS.GetItemString(row,is_campo)
				ELSE
					is_val_anterior = String(THIS.GetItemNumber(row,is_campo))
				END IF
		END CHOOSE
	idw_1.of_column_protect(is_campo)
	END IF
END IF
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1765
integer height = 800
long backcolor = 79741120
string text = "none"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from datawindow within tabpage_3
event dwnenter pbm_dwnprocessenter
integer y = 8
integer width = 494
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event dberror;messagebox("dberror dw_3",SQLCA.SQLErrText,exclamation!)
end event

event itemchanged;dw_master.ii_update = 1
IF is_funcion = 'M' THEN is_val_nuevo = data
end event

event losefocus;THIS.AcceptText()
end event

event clicked;String	ls_type

is_campo = dwo.Name
IF is_funcion = 'M' AND is_campo <> 'datawindow' AND idw_1.ii_update = 0 THEN
	IF of_is_col_protect(is_campo) = 1 THEN
		MessageBox('Error', 'La columna esta protegida')
	ELSE
		ls_type = THIS.Describe(is_campo + ".ColType")
		CHOOSE CASE ls_type
			CASE 'date'
				is_val_anterior = String(THIS.GetItemDate(row,is_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				is_val_anterior = String(THIS.GetItemDateTime(row,is_campo), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					is_val_anterior = THIS.GetItemString(row,is_campo)
				ELSE
					is_val_anterior = String(THIS.GetItemNumber(row,is_campo))
				END IF
		END CHOOSE
	idw_1.of_column_protect(is_campo)
	END IF
END IF
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 1765
integer height = 800
long backcolor = 79741120
string text = "none"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from datawindow within tabpage_4
event dwnenter pbm_dwnprocessenter
integer y = 8
integer width = 494
integer height = 360
integer taborder = 30
boolean bringtotop = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event dberror;messagebox("dberror dw_4",SQLCA.SQLErrText,exclamation!)
end event

event itemchanged;dw_master.ii_update = 1
IF is_funcion = 'M' THEN is_val_nuevo = data
end event

event losefocus;THIS.AcceptText()
end event

event clicked;String	ls_type

is_campo = dwo.Name
IF is_funcion = 'M' AND is_campo <> 'datawindow' AND idw_1.ii_update = 0 THEN
	IF of_is_col_protect(is_campo) = 1 THEN
		MessageBox('Error', 'La columna esta protegida')
	ELSE
		ls_type = THIS.Describe(is_campo + ".ColType")
		CHOOSE CASE ls_type
			CASE 'date'
				is_val_anterior = String(THIS.GetItemDate(row,is_campo), 'dd/mm/yyyy')
			CASE 'datetime'
				is_val_anterior = String(THIS.GetItemDateTime(row,is_campo), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					is_val_anterior = THIS.GetItemString(row,is_campo)
				ELSE
					is_val_anterior = String(THIS.GetItemNumber(row,is_campo))
				END IF
		END CHOOSE
	idw_1.of_column_protect(is_campo)
	END IF
END IF
end event

