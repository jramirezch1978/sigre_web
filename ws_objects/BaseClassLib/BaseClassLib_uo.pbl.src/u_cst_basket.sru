$PBExportHeader$u_cst_basket.sru
$PBExportComments$efecto grafico de canasto que se quema
forward
global type u_cst_basket from userobject
end type
type p_1 from picture within u_cst_basket
end type
type p_2 from picture within u_cst_basket
end type
type p_3 from picture within u_cst_basket
end type
type p_4 from picture within u_cst_basket
end type
type p_5 from picture within u_cst_basket
end type
end forward

global type u_cst_basket from userobject
integer width = 311
integer height = 412
boolean border = true
long backcolor = 67108864
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_output ( )
p_1 p_1
p_2 p_2
p_3 p_3
p_4 p_4
p_5 p_5
end type
global u_cst_basket u_cst_basket

type variables
DragObject	idragobject
end variables

forward prototypes
public subroutine of_demora (long al_milisegundos)
public subroutine of_efecto_visual ()
public subroutine of_set_dragobject (dragobject adrag)
end prototypes

event ue_output;// eliminar registro en dw_lista

// end drag
end event

public subroutine of_demora (long al_milisegundos);Long ll_time, ll_x

ll_time = Cpu()

DO UNTIL ll_x > ll_time + al_milisegundos
	ll_x = Cpu()
LOOP

end subroutine

public subroutine of_efecto_visual ();Integer li_x, li_y, li_i
Long    ll_milisegundos
Picture lp_picture[4]

lp_picture[1] = p_1
lp_picture[2] = p_2
lp_picture[3] = p_3
lp_picture[4] = p_4

ll_milisegundos = 100
li_x = p_5.x
li_y = p_5.y
p_5.visible = False

FOR li_i=1 TO 4 STEP 1
	of_demora(ll_milisegundos)
	lp_picture[li_i].Draw(li_x,li_y)
NEXT

FOR li_i=4 TO 1 STEP -1
	of_demora(ll_milisegundos)
	lp_picture[li_i].Draw(li_x,li_y)
NEXT

p_5.visible = True
end subroutine

public subroutine of_set_dragobject (dragobject adrag);idragobject = adrag
end subroutine

on u_cst_basket.create
this.p_1=create p_1
this.p_2=create p_2
this.p_3=create p_3
this.p_4=create p_4
this.p_5=create p_5
this.Control[]={this.p_1,&
this.p_2,&
this.p_3,&
this.p_4,&
this.p_5}
end on

on u_cst_basket.destroy
destroy(this.p_1)
destroy(this.p_2)
destroy(this.p_3)
destroy(this.p_4)
destroy(this.p_5)
end on

type p_1 from picture within u_cst_basket
integer x = 1719
integer y = 36
integer width = 293
integer height = 376
string picturename = "h:\source\bmp\basur1.bmp"
boolean focusrectangle = false
end type

type p_2 from picture within u_cst_basket
integer x = 2066
integer y = 36
integer width = 293
integer height = 376
string picturename = "h:\source\bmp\basur2.bmp"
boolean focusrectangle = false
end type

type p_3 from picture within u_cst_basket
integer x = 2441
integer y = 36
integer width = 293
integer height = 376
string picturename = "h:\source\bmp\basur3.bmp"
boolean focusrectangle = false
end type

type p_4 from picture within u_cst_basket
integer x = 1719
integer y = 452
integer width = 293
integer height = 376
string picturename = "h:\source\bmp\basur4.bmp"
boolean focusrectangle = false
end type

type p_5 from picture within u_cst_basket
integer y = 20
integer width = 293
integer height = 376
string picturename = "h:\source\bmp\basur1.bmp"
boolean focusrectangle = false
end type

event dragdrop;IF Source = idragobject THEN
	of_efecto_visual()
	PARENT.EVENT ue_output()
END IF

end event

