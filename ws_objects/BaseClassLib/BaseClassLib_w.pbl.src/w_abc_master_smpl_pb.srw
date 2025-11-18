$PBExportHeader$w_abc_master_smpl_pb.srw
$PBExportComments$abc simple para una tabla, con botones
forward
global type w_abc_master_smpl_pb from w_abc_master_smpl
end type
type st_2 from statictext within w_abc_master_smpl_pb
end type
type st_3 from statictext within w_abc_master_smpl_pb
end type
type st_4 from statictext within w_abc_master_smpl_pb
end type
type pb_insertar from u_pb_insert within w_abc_master_smpl_pb
end type
type pb_modificar from u_pb_modify within w_abc_master_smpl_pb
end type
type pb_eliminar from u_pb_delete within w_abc_master_smpl_pb
end type
type pb_grabar from u_pb_update within w_abc_master_smpl_pb
end type
type st_5 from statictext within w_abc_master_smpl_pb
end type
end forward

global type w_abc_master_smpl_pb from w_abc_master_smpl
integer width = 2533
integer height = 1836
st_2 st_2
st_3 st_3
st_4 st_4
pb_insertar pb_insertar
pb_modificar pb_modificar
pb_eliminar pb_eliminar
pb_grabar pb_grabar
st_5 st_5
end type
global w_abc_master_smpl_pb w_abc_master_smpl_pb

event resize;// override
end event

on w_abc_master_smpl_pb.create
int iCurrent
call super::create
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_insertar=create pb_insertar
this.pb_modificar=create pb_modificar
this.pb_eliminar=create pb_eliminar
this.pb_grabar=create pb_grabar
this.st_5=create st_5
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.pb_insertar
this.Control[iCurrent+5]=this.pb_modificar
this.Control[iCurrent+6]=this.pb_eliminar
this.Control[iCurrent+7]=this.pb_grabar
this.Control[iCurrent+8]=this.st_5
end on

on w_abc_master_smpl_pb.destroy
call super::destroy
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_insertar)
destroy(this.pb_modificar)
destroy(this.pb_eliminar)
destroy(this.pb_grabar)
destroy(this.st_5)
end on

event ue_open_pre;call super::ue_open_pre;ii_access = 2
end event

event ue_set_access_cb;call super::ue_set_access_cb;Integer	li_x
String	ls_temp

pb_insertar.enabled = FALSE
pb_eliminar.enabled = FALSE
pb_modificar.enabled = FALSE

FOR li_x = 1 to Len(is_niveles)
	ls_temp = Mid(is_niveles, li_x, 1)
	CHOOSE CASE ls_temp
		CASE 'I'
			pb_insertar.enabled = TRUE
		CASE 'E'
			pb_eliminar.enabled = TRUE
		CASE 'M'
			pb_modificar.enabled = TRUE
	END CHOOSE
NEXT

end event

type uo_h from w_abc_master_smpl`uo_h within w_abc_master_smpl_pb
end type

type st_box from w_abc_master_smpl`st_box within w_abc_master_smpl_pb
end type

type st_filter from w_abc_master_smpl`st_filter within w_abc_master_smpl_pb
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_abc_master_smpl_pb
end type

type dw_master from w_abc_master_smpl`dw_master within w_abc_master_smpl_pb
integer width = 1307
integer height = 784
end type

type st_2 from statictext within w_abc_master_smpl_pb
integer x = 201
integer y = 784
integer width = 256
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 268435456
boolean enabled = false
string text = "Borrar"
boolean focusrectangle = false
end type

type st_3 from statictext within w_abc_master_smpl_pb
integer x = 201
integer y = 616
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 268435456
boolean enabled = false
string text = "Modificar"
boolean focusrectangle = false
end type

type st_4 from statictext within w_abc_master_smpl_pb
integer x = 201
integer y = 948
integer width = 247
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 268435456
boolean enabled = false
string text = "Grabar"
boolean focusrectangle = false
end type

type pb_insertar from u_pb_insert within w_abc_master_smpl_pb
integer x = 23
integer y = 420
integer taborder = 20
boolean bringtotop = true
end type

type pb_modificar from u_pb_modify within w_abc_master_smpl_pb
integer x = 23
integer y = 588
integer taborder = 50
boolean bringtotop = true
end type

type pb_eliminar from u_pb_delete within w_abc_master_smpl_pb
integer x = 23
integer y = 760
integer taborder = 40
boolean bringtotop = true
end type

type pb_grabar from u_pb_update within w_abc_master_smpl_pb
integer x = 23
integer y = 928
integer taborder = 30
boolean bringtotop = true
end type

type st_5 from statictext within w_abc_master_smpl_pb
integer x = 187
integer y = 444
integer width = 283
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 268435456
boolean enabled = false
string text = "Nuevo"
boolean focusrectangle = false
end type

