$PBExportHeader$w_login.srw
forward
global type w_login from window
end type
type p_1 from picture within w_login
end type
type phl_1 from picturehyperlink within w_login
end type
type p_5 from picture within w_login
end type
type p_3 from picture within w_login
end type
type p_2 from picture within w_login
end type
end forward

global type w_login from window
integer width = 2885
integer height = 2028
boolean border = false
windowtype windowtype = popup!
string icon = "AppIcon!"
boolean center = true
windowanimationstyle openanimation = bottomroll!
integer animationtime = 500
p_1 p_1
phl_1 phl_1
p_5 p_5
p_3 p_3
p_2 p_2
end type
global w_login w_login

on w_login.create
this.p_1=create p_1
this.phl_1=create phl_1
this.p_5=create p_5
this.p_3=create p_3
this.p_2=create p_2
this.Control[]={this.p_1,&
this.phl_1,&
this.p_5,&
this.p_3,&
this.p_2}
end on

on w_login.destroy
destroy(this.p_1)
destroy(this.phl_1)
destroy(this.p_5)
destroy(this.p_3)
destroy(this.p_2)
end on

type p_1 from picture within w_login
integer width = 2894
integer height = 120
boolean originalsize = true
string picturename = "C:\Documents and Settings\rramirez\Mis documentos\src-sigre\resources\JPG\Imagen1.png"
boolean focusrectangle = false
end type

type phl_1 from picturehyperlink within w_login
integer x = 987
integer y = 1656
integer width = 818
integer height = 352
string pointer = "HyperLink!"
string picturename = "C:\Documents and Settings\rramirez\Mis documentos\src-sigre\resources\JPG\Opción 03 - copia.png"
boolean focusrectangle = false
string url = "http://www.npssac.com.pe/"
end type

type p_5 from picture within w_login
integer x = 105
integer y = 1592
integer width = 809
integer height = 416
string picturename = "C:\Documents and Settings\rramirez\Mis documentos\src-sigre\resources\JPG\Opción 03.png"
boolean focusrectangle = false
end type

type p_3 from picture within w_login
integer y = 1572
integer width = 2894
integer height = 460
boolean originalsize = true
string picturename = "C:\Documents and Settings\rramirez\Mis documentos\src-sigre\resources\JPG\Imagen3.png"
boolean focusrectangle = false
end type

type p_2 from picture within w_login
integer y = 124
integer width = 2885
integer height = 1500
boolean bringtotop = true
string picturename = "C:\Documents and Settings\rramirez\Mis documentos\src-sigre\resources\JPG\Imagen5.png"
boolean focusrectangle = false
end type

