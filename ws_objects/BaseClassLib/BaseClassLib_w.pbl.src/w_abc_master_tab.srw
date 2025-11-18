$PBExportHeader$w_abc_master_tab.srw
$PBExportComments$Mantenimiento de una tabla con 5  dws
forward
global type w_abc_master_tab from w_abc_master
end type
type tab_1 from tab within w_abc_master_tab
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
type tabpage_3 from userobject within tab_1
end type
type dw_3 from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_3 dw_3
end type
type tabpage_4 from userobject within tab_1
end type
type dw_4 from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_4 dw_4
end type
type tab_1 from tab within w_abc_master_tab
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
end forward

global type w_abc_master_tab from w_abc_master
integer width = 2775
integer height = 1880
tab_1 tab_1
end type
global w_abc_master_tab w_abc_master_tab

type variables
Integer ii_protect = 1
end variables

forward prototypes
public subroutine of_protect (datawindow adw_1)
end prototypes

public subroutine of_protect (datawindow adw_1);
end subroutine

on w_abc_master_tab.create
int iCurrent
call super::create
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
end on

on w_abc_master_tab.destroy
call super::destroy
destroy(this.tab_1)
end on

event resize;call super::resize;
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

uo_h.of_set_title( this.title )
end event

event ue_modify;call super::ue_modify;// habilitar deshabilitar dw de tabs
IF dw_master.ii_protect = 1 THEN
	tab_1.tabpage_1.dw_1.enabled = FALSE
	tab_1.tabpage_2.dw_2.enabled = FALSE
	tab_1.tabpage_3.dw_3.enabled = FALSE
	tab_1.tabpage_4.dw_4.enabled = FALSE
ELSE	
	tab_1.tabpage_1.dw_1.enabled = TRUE
	tab_1.tabpage_2.dw_2.enabled = TRUE
	tab_1.tabpage_3.dw_3.enabled = TRUE
	tab_1.tabpage_4.dw_4.enabled = TRUE
END IF
end event

event ue_update_pre;call super::ue_update_pre;//tab_1.tabpage_1.dw_1.AcceptText()
//tab_1.tabpage_2.dw_2.AcceptText()
//tab_1.tabpage_3.dw_3.AcceptText()
//tab_1.tabpage_4.dw_4.AcceptText()


end event

type ole_skin from w_abc_master`ole_skin within w_abc_master_tab
end type

type uo_h from w_abc_master`uo_h within w_abc_master_tab
end type

type st_box from w_abc_master`st_box within w_abc_master_tab
end type

type phl_logonps from w_abc_master`phl_logonps within w_abc_master_tab
end type

type p_mundi from w_abc_master`p_mundi within w_abc_master_tab
end type

type p_logo from w_abc_master`p_logo within w_abc_master_tab
end type

type st_filter from w_abc_master`st_filter within w_abc_master_tab
boolean visible = false
integer x = 585
boolean enabled = false
end type

type uo_filter from w_abc_master`uo_filter within w_abc_master_tab
boolean visible = false
boolean enabled = false
end type

type dw_master from w_abc_master`dw_master within w_abc_master_tab
integer x = 503
integer y = 276
integer width = 1417
integer height = 328
end type

type tab_1 from tab within w_abc_master_tab
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 503
integer y = 616
integer width = 1381
integer height = 864
integer taborder = 20
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

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post Dynamic ue_PopM(ai_x, ai_y)
end event

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
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 18
integer y = 112
integer width = 1344
integer height = 736
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
dw_1 dw_1
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_1.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on tabpage_1.destroy
destroy(this.dw_1)
end on

type dw_1 from u_dw_abc within tabpage_1
integer y = 8
integer taborder = 20
end type

event itemchanged;call super::itemchanged;dw_master.ii_update = 1
end event

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;Integer	li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_ck)
	ii_ck[li_x] = dw_master.ii_ck[li_x]
NEXT

end event

type tabpage_2 from userobject within tab_1
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 18
integer y = 112
integer width = 1344
integer height = 736
long backcolor = 79741120
string text = "none"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_2 dw_2
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_2.create
this.dw_2=create dw_2
this.Control[]={this.dw_2}
end on

on tabpage_2.destroy
destroy(this.dw_2)
end on

type dw_2 from u_dw_abc within tabpage_2
integer y = 8
integer taborder = 30
end type

event itemchanged;call super::itemchanged;dw_master.ii_update = 1
end event

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_ck)
	ii_ck[li_x] = dw_master.ii_ck[li_x]
NEXT

end event

type tabpage_3 from userobject within tab_1
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 18
integer y = 112
integer width = 1344
integer height = 736
long backcolor = 79741120
string text = "none"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_3 dw_3
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_3.create
this.dw_3=create dw_3
this.Control[]={this.dw_3}
end on

on tabpage_3.destroy
destroy(this.dw_3)
end on

type dw_3 from u_dw_abc within tabpage_3
integer y = 8
integer taborder = 30
end type

event itemchanged;call super::itemchanged;dw_master.ii_update = 1
end event

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_ck)
	ii_ck[li_x] = dw_master.ii_ck[li_x]
NEXT

end event

type tabpage_4 from userobject within tab_1
event ue_popm ( integer ai_x,  integer ai_y )
integer x = 18
integer y = 112
integer width = 1344
integer height = 736
long backcolor = 79741120
string text = "none"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_4 dw_4
end type

event ue_popm(integer ai_x, integer ai_y);Parent.Event Post ue_popm(ai_x, ai_y)
end event

on tabpage_4.create
this.dw_4=create dw_4
this.Control[]={this.dw_4}
end on

on tabpage_4.destroy
destroy(this.dw_4)
end on

type dw_4 from u_dw_abc within tabpage_4
integer y = 8
integer taborder = 30
end type

event itemchanged;call super::itemchanged;dw_master.ii_update = 1
end event

event clicked;call super::clicked;idw_1 = THIS
end event

event constructor;Integer li_x

FOR li_x = 1 TO UpperBound(dw_master.ii_ck)
	ii_ck[li_x] = dw_master.ii_ck[li_x]
NEXT

end event

