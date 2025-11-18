$PBExportHeader$w_abc_master_smpl_pb.srw
$PBExportComments$abc simple para una tabla, con botones
forward
global type w_abc_master_smpl_pb from w_abc_master_smpl
end type
type st_1 from statictext within w_abc_master_smpl_pb
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
end forward

global type w_abc_master_smpl_pb from w_abc_master_smpl
int Width=1874
int Height=912
st_1 st_1
st_2 st_2
st_3 st_3
st_4 st_4
pb_insertar pb_insertar
pb_modificar pb_modificar
pb_eliminar pb_eliminar
pb_grabar pb_grabar
end type
global w_abc_master_smpl_pb w_abc_master_smpl_pb

event resize;// override
end event

on w_abc_master_smpl_pb.create
int iCurrent
call super::create
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.st_4=create st_4
this.pb_insertar=create pb_insertar
this.pb_modificar=create pb_modificar
this.pb_eliminar=create pb_eliminar
this.pb_grabar=create pb_grabar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.st_3
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.pb_insertar
this.Control[iCurrent+6]=this.pb_modificar
this.Control[iCurrent+7]=this.pb_eliminar
this.Control[iCurrent+8]=this.pb_grabar
end on

on w_abc_master_smpl_pb.destroy
call super::destroy
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.pb_insertar)
destroy(this.pb_modificar)
destroy(this.pb_eliminar)
destroy(this.pb_grabar)
end on

event ue_open_pre;call super::ue_open_pre;ii_access = 2
end event

event ue_set_access_cb;call super::ue_set_access_cb;
//Integer	li_x
//String	ls_temp
//
//pb_insertar.enabled = FALSE
//pb_eliminar.enabled = FALSE
//pb_modificar.enabled = FALSE
//
//FOR li_x = 1 to Len(is_niveles)
//	ls_temp = Mid(is_niveles, li_x, 1)
//	CHOOSE CASE ls_temp
//		CASE 'I'
//			pb_insertar.enabled = TRUE
//		CASE 'E'
//			pb_eliminar.enabled = TRUE
//		CASE 'M'
//			pb_modificar.enabled = TRUE
//	END CHOOSE
//NEXT

end event

type dw_master from w_abc_master_smpl`dw_master within w_abc_master_smpl_pb
int Width=1307
int Height=784
boolean BringToTop=true
end type

type st_1 from statictext within w_abc_master_smpl_pb
int X=1536
int Y=92
int Width=247
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Insertar"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_abc_master_smpl_pb
int X=1536
int Y=432
int Width=256
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Borrar"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_abc_master_smpl_pb
int X=1536
int Y=264
int Width=283
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Modificar"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_abc_master_smpl_pb
int X=1536
int Y=596
int Width=247
int Height=76
boolean Enabled=false
boolean BringToTop=true
string Text="Grabar"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=79741120
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type pb_insertar from u_pb_insert within w_abc_master_smpl_pb
int X=1358
int Y=68
int TabOrder=20
boolean BringToTop=true
end type

type pb_modificar from u_pb_modify within w_abc_master_smpl_pb
int X=1358
int Y=236
int TabOrder=50
boolean BringToTop=true
end type

type pb_eliminar from u_pb_delete within w_abc_master_smpl_pb
int X=1358
int Y=408
int TabOrder=40
boolean BringToTop=true
end type

type pb_grabar from u_pb_update within w_abc_master_smpl_pb
int X=1358
int Y=576
int TabOrder=30
boolean BringToTop=true
end type

