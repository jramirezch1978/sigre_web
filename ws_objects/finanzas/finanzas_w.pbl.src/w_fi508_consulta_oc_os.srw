$PBExportHeader$w_fi508_consulta_oc_os.srw
forward
global type w_fi508_consulta_oc_os from w_cns
end type
type sle_2 from u_sle_codigo within w_fi508_consulta_oc_os
end type
type st_2 from statictext within w_fi508_consulta_oc_os
end type
type st_1 from statictext within w_fi508_consulta_oc_os
end type
type rb_2 from radiobutton within w_fi508_consulta_oc_os
end type
type rb_1 from radiobutton within w_fi508_consulta_oc_os
end type
type cb_1 from commandbutton within w_fi508_consulta_oc_os
end type
type sle_1 from singlelineedit within w_fi508_consulta_oc_os
end type
type dw_master from u_dw_cns within w_fi508_consulta_oc_os
end type
end forward

global type w_fi508_consulta_oc_os from w_cns
integer width = 2747
integer height = 1144
string title = "Consulta de OC,OS X Facturación (FI508)"
string menuname = "m_consulta"
sle_2 sle_2
st_2 st_2
st_1 st_1
rb_2 rb_2
rb_1 rb_1
cb_1 cb_1
sle_1 sle_1
dw_master dw_master
end type
global w_fi508_consulta_oc_os w_fi508_consulta_oc_os

on w_fi508_consulta_oc_os.create
int iCurrent
call super::create
if this.MenuName = "m_consulta" then this.MenuID = create m_consulta
this.sle_2=create sle_2
this.st_2=create st_2
this.st_1=create st_1
this.rb_2=create rb_2
this.rb_1=create rb_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_2
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.dw_master
end on

on w_fi508_consulta_oc_os.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.dw_master)
end on

event ue_open_pre();call super::ue_open_pre;dw_master.SetTransObject(sqlca)

idw_1 = dw_master              // asignar dw corriente
// ii_help = 101           // help topic
of_position_window(0,0)        // Posicionar la ventana en forma fija
end event

type sle_2 from u_sle_codigo within w_fi508_consulta_oc_os
integer x = 759
integer y = 28
integer width = 411
integer height = 68
integer taborder = 20
integer textsize = -8
end type

event constructor;call super::constructor;ii_prefijo = 2
ii_total = 10
ibl_mayuscula = true
end event

type st_2 from statictext within w_fi508_consulta_oc_os
integer x = 489
integer y = 32
integer width = 219
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Doc :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi508_consulta_oc_os
integer x = 37
integer y = 32
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
boolean focusrectangle = false
end type

type rb_2 from radiobutton within w_fi508_consulta_oc_os
integer x = 1815
integer y = 32
integer width = 425
integer height = 56
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Servicio"
end type

type rb_1 from radiobutton within w_fi508_consulta_oc_os
integer x = 1257
integer y = 32
integer width = 430
integer height = 56
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden Compra"
boolean checked = true
end type

type cb_1 from commandbutton within w_fi508_consulta_oc_os
integer x = 2322
integer y = 12
integer width = 343
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_tipo_doc,ls_nro_doc,ls_origen

ls_origen  = sle_1.text 
ls_nro_doc = sle_2.text 

IF rb_1.checked THEN
	SELECT doc_oc into :ls_tipo_doc from logparam where reckey = '1' ;
ELSE
	SELECT doc_os into :ls_tipo_doc from logparam where reckey = '1' ;
END IF

dw_master.retrieve(ls_tipo_doc,ls_nro_doc,ls_origen)
end event

type sle_1 from singlelineedit within w_fi508_consulta_oc_os
integer x = 251
integer y = 28
integer width = 210
integer height = 68
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

type dw_master from u_dw_cns within w_fi508_consulta_oc_os
integer x = 27
integer y = 136
integer width = 2647
integer height = 796
integer taborder = 40
string dataobject = "d_cns_oc_os_x_factura_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


 ii_ck[1] = 1         // columnas de lectrua de este dw

end event

