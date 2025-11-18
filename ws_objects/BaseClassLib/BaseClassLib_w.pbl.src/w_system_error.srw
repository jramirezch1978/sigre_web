$PBExportHeader$w_system_error.srw
forward
global type w_system_error from window
end type
type ole_skin from olecustomcontrol within w_system_error
end type
type cb_3 from commandbutton within w_system_error
end type
type cb_1 from commandbutton within w_system_error
end type
type p_1 from picture within w_system_error
end type
type st_7 from statictext within w_system_error
end type
type st_no from statictext within w_system_error
end type
type st_6 from statictext within w_system_error
end type
type st_nw from statictext within w_system_error
end type
type st_ne from statictext within w_system_error
end type
type st_le from statictext within w_system_error
end type
type st_nue from statictext within w_system_error
end type
type st_te from statictext within w_system_error
end type
type st_5 from statictext within w_system_error
end type
type st_4 from statictext within w_system_error
end type
type st_3 from statictext within w_system_error
end type
type st_2 from statictext within w_system_error
end type
type st_1 from statictext within w_system_error
end type
end forward

global type w_system_error from window
integer width = 2473
integer height = 1464
boolean titlebar = true
string title = "Ventana de Errores "
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
ole_skin ole_skin
cb_3 cb_3
cb_1 cb_1
p_1 p_1
st_7 st_7
st_no st_no
st_6 st_6
st_nw st_nw
st_ne st_ne
st_le st_le
st_nue st_nue
st_te st_te
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_system_error w_system_error

type variables
n_cst_errorlogging invo_log
end variables

forward prototypes
public subroutine of_activa_skin ()
end prototypes

public subroutine of_activa_skin ();String ls_mensaje

IF LEN(Trim(gnvo_app.is_skin)) > 0 and gnvo_app.ib_skin THEN
	Long hWnd
	hWnd=Handle(W_main)
	IF FileExists(gnvo_app.is_skin) then
		ole_skin.object.LoadSkin(gnvo_app.is_skin)
		OLE_Skin.object.ApplySkin (hWnd)
	end if
END IF
end subroutine

on w_system_error.create
this.ole_skin=create ole_skin
this.cb_3=create cb_3
this.cb_1=create cb_1
this.p_1=create p_1
this.st_7=create st_7
this.st_no=create st_no
this.st_6=create st_6
this.st_nw=create st_nw
this.st_ne=create st_ne
this.st_le=create st_le
this.st_nue=create st_nue
this.st_te=create st_te
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.ole_skin,&
this.cb_3,&
this.cb_1,&
this.p_1,&
this.st_7,&
this.st_no,&
this.st_6,&
this.st_nw,&
this.st_ne,&
this.st_le,&
this.st_nue,&
this.st_te,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_system_error.destroy
destroy(this.ole_skin)
destroy(this.cb_3)
destroy(this.cb_1)
destroy(this.p_1)
destroy(this.st_7)
destroy(this.st_no)
destroy(this.st_6)
destroy(this.st_nw)
destroy(this.st_ne)
destroy(this.st_le)
destroy(this.st_nue)
destroy(this.st_te)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

event open;String ls_msj_err,ls_linea_err,ls_nro_err,ls_desc_err

invo_log = create n_cst_errorlogging

st_nw.text  = error.windowmenu     //nombre de ventana
st_no.text  = error.object		     //nombre de objeto
st_ne.text  = error.objectevent    //nombre de evento
st_le.text  = String(error.line)   //linea de error
st_nue.text = String(error.number) //numero de error
st_te.text  = error.text		     //texto de error


ls_linea_err = String(error.line)
ls_nro_err	 = String(error.number)
ls_desc_err	 = Mid(error.text,1,300)

invo_log.of_errorlog("Ha ocurrido un error interno: ~r~n" + &
			"Ventana: " + error.windowmenu + "~r~n" + &
			"Objecto: " + error.object + "~r~n" + &
			"Evento: " + error.objectevent + "~r~n" + &
			"Línea de Error: " + string(error.line) + "~r~n" + &
			"Número de Error: " + string(error.number) + "~r~n" + &
			"texto de Error: " + error.text)


//Aplico los skin
if gnvo_app.ib_skin then
	this.of_activa_skin( )
end if
end event

event close;destroy n_cst_errorlogging
end event

type ole_skin from olecustomcontrol within w_system_error
event skinevent ( oleobject source,  string eventname )
event render ( oleobject source,  oleobject screenbuffer,  long positionx,  long positiony )
event skintimer ( oleobject source,  long sourcehwnd,  long passedtime )
event click ( oleobject source )
event dblclick ( oleobject source )
event mousedown ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mouseup ( oleobject source,  integer button,  long ocx_x,  long ocx_y )
event mousein ( oleobject source )
event mouseout ( oleobject source )
event mousemove ( oleobject source,  long ocx_x,  long ocx_y )
event scroll ( oleobject source,  long newpos )
event scrolltrack ( oleobject source,  long newpos )
integer x = 1970
integer y = 1132
integer width = 146
integer height = 128
integer taborder = 10
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
string binarykey = "w_system_error.win"
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
end type

type cb_3 from commandbutton within w_system_error
integer x = 1211
integer y = 1184
integer width = 645
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Terminar aplicación"
boolean cancel = true
end type

event clicked;close(parent)
end event

type cb_1 from commandbutton within w_system_error
integer x = 489
integer y = 1188
integer width = 581
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Continuar aplicación"
boolean default = true
end type

event clicked;close(parent)
end event

type p_1 from picture within w_system_error
integer x = 73
integer y = 992
integer width = 110
integer height = 96
string picturename = "Custom084!"
boolean focusrectangle = false
end type

type st_7 from statictext within w_system_error
integer x = 329
integer y = 1024
integer width = 768
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Comunicarse con Sistemas"
boolean focusrectangle = false
end type

type st_no from statictext within w_system_error
integer x = 731
integer y = 160
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_6 from statictext within w_system_error
integer x = 73
integer y = 160
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Nombre de Objeto :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_nw from statictext within w_system_error
integer x = 731
integer y = 32
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_ne from statictext within w_system_error
integer x = 731
integer y = 288
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_le from statictext within w_system_error
integer x = 731
integer y = 416
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_nue from statictext within w_system_error
integer x = 731
integer y = 544
integer width = 1170
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_te from statictext within w_system_error
integer x = 731
integer y = 672
integer width = 1609
integer height = 280
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean focusrectangle = false
end type

type st_5 from statictext within w_system_error
integer x = 73
integer y = 672
integer width = 576
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Texto Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_system_error
integer x = 73
integer y = 544
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero de Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_system_error
integer x = 73
integer y = 416
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Linea de Error :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_system_error
integer x = 73
integer y = 288
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre de Evento :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_system_error
integer x = 73
integer y = 32
integer width = 576
integer height = 96
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre de Ventana :"
alignment alignment = right!
boolean focusrectangle = false
end type


Start of PowerBuilder Binary Data Section : Do NOT Edit
0Bw_system_error.bin 
2300000e00e011cfd0e11ab1a1000000000000000000000000000000000003003e0009fffe000000060000000000000000000000010000000100000000000010000000000200000001fffffffe0000000000000000fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffefffffffe0000000400000005fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff006f00520074006f004500200074006e00790072000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000050016ffffffffffffffff0000000100000000000000000000000000000000000000000000000000000000d58c6df001c8d9b400000003000004800000000000500003004f0042005800430054005300450052004d0041000000000000000000000000000000000000000000000000000000000000000000000000000000000102001affffffff00000002ffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000000000021c00000000004200500043004f00530058004f00540041005200450047000000000000000000000000000000000000000000000000000000000000000000000000000000000001001affffffffffffffff000000030944d16c4389d0f485a02a98b39e5a5900000000d58c6df001c8d9b4d58c6df001c8d9b4000000000000000000000000006f00430074006e006e00650073007400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001020012ffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000090000021c000000000000000100000002000000030000000400000005000000060000000700000008fffffffe0000000a0000000b0000000c0000000d0000000e0000000f0000001000000011fffffffeffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
26ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d00730062007200740061005400000067000000040000000000000000006900740067006e0073005c0072006500650076000000720074000000e40006020c010700000001000000020000000a0000001a005f006d007300620072007400750041006800740072006f000400000000000000240000006d00000062005f007400730044007200730065007200630070006900690074006e006f000400000000000000240000006d00000062005f0074007300410072007000700069006c0061006300690074006e006f0004000000000000000e0000006d0000006e005f007500480000006500000008000000040000000000000018005f006d00610042006b0063006f0043006f006c00000072000000070000000318ffffff6d00000046005f0072006f00430065006c006f0072006f00070000000300000000000000001a0000006d00000050005f006e0061006c0065006f0043006f006c00000072000000070000000322ece9d86d00000050005f006e0061006c00650065005400740078006f0043006f006c00000072000000070000000300000000000000001e005f006d00410062007000700079006c006f0043006f006c0073007200060000000200000000000000000024005f006d005300620069006b0043006e0069006c006e00650041007400650072000000610000000600000002000200010000000000030000000000000000000000010000000200000002000000160000006d00000062005f00740073004e0072006d006100000065000000040000000000000014005f006d007300620072007400610054000000670000000400000000000000000077007700640069006800740020002c006e00690065007400650067002000720065006e00680077006900650068006700200074002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d00620073005f007a0069005d006500730000006f00680020007700200028006f0062006c006f006100650020006e006800730077006f0020002c006f006c0067006e00730020006100740075007400200073002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d00620073005f006f006800770077006e0069006f0064005d0077007300000073007900650074006b006d0079006500280020006b002000790065006f006300650064006b0020007900650020002c006e007500690073006e006700640065006f006c0067006e006b002000790065006c00660067006100200073002000290072002000740065007200750073006e006c0020006e006f002000670070005b006d00620073005f007300790065006b006400790077006f005d006e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1Bw_system_error.bin 
End of PowerBuilder Binary Data Section : No Source Expected After This Point
