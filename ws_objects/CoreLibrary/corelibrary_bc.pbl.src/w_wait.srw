$PBExportHeader$w_wait.srw
forward
global type w_wait from window
end type
type p_2 from picture within w_wait
end type
type p_1 from picture within w_wait
end type
type st_mensaje from statictext within w_wait
end type
end forward

global type w_wait from window
integer width = 2784
integer height = 304
windowtype windowtype = popup!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
p_2 p_2
p_1 p_1
st_mensaje st_mensaje
end type
global w_wait w_wait

forward prototypes
public subroutine of_mensaje (string as_mensaje)
end prototypes

public subroutine of_mensaje (string as_mensaje);if len(trim(as_mensaje)) > 0 then
	st_mensaje.Text = trim(as_mensaje)
	yield()
end if
end subroutine

on w_wait.create
this.p_2=create p_2
this.p_1=create p_1
this.st_mensaje=create st_mensaje
this.Control[]={this.p_2,&
this.p_1,&
this.st_mensaje}
end on

on w_wait.destroy
destroy(this.p_2)
destroy(this.p_1)
destroy(this.st_mensaje)
end on

type p_2 from picture within w_wait
integer x = 2354
integer width = 402
integer height = 276
string picturename = "C:\SIGRE\resources\PNG\logo_125.png"
boolean focusrectangle = false
end type

type p_1 from picture within w_wait
integer x = 18
integer width = 603
integer height = 276
string picturename = "C:\SIGRE\resources\Gif\Cargando.gif"
boolean focusrectangle = false
end type

type st_mensaje from statictext within w_wait
integer x = 645
integer width = 1673
integer height = 276
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Lucida Console"
long textcolor = 33554432
long backcolor = 16777215
string text = "El sistema esta procesando por favor espere ....."
boolean focusrectangle = false
end type

