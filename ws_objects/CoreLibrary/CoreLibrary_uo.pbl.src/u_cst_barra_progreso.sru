$PBExportHeader$u_cst_barra_progreso.sru
$PBExportComments$efecto grafico de barra de progreso
forward
global type u_cst_barra_progreso from UserObject
end type
type st_1 from statictext within u_cst_barra_progreso
end type
type rc_1 from rectangle within u_cst_barra_progreso
end type
end forward

global type u_cst_barra_progreso from UserObject
int Width=1321
int Height=88
boolean Border=true
long BackColor=16777215
long PictureMaskColor=25166016
long TabTextColor=33554432
long TabBackColor=79741120
st_1 st_1
rc_1 rc_1
end type
global u_cst_barra_progreso u_cst_barra_progreso

type variables
boolean    ib_reverse
end variables

forward prototypes
public subroutine of_avance (decimal adc_valor)
public subroutine of_inicializar ()
end prototypes

public subroutine of_avance (decimal adc_valor);long	ll_color

// expandir la barra
rc_1.width = (adc_valor / 100.0) * THIS.width
rc_1.visible = true

st_1.text = String (adc_valor / 100.0, "##0%")   // texto del %

// invertir el color del texto cuando la barra lo toque
IF (ib_reverse = FALSE AND rc_1.width >= st_1.x) THEN
	ib_reverse = TRUE
	ll_color = st_1.textcolor
	st_1.TextColor = st_1.BackColor
	st_1.BackColor = ll_color
END IF
end subroutine

public subroutine of_inicializar ();// Poner la barra en blanco y el texto en azul

ib_reverse = FALSE
st_1.TextColor = RGB (0, 0, 255)
st_1.BackColor = RGB (255, 255, 255)	

end subroutine

on u_cst_barra_progreso.create
this.st_1=create st_1
this.rc_1=create rc_1
this.Control[]={this.st_1,&
this.rc_1}
end on

on u_cst_barra_progreso.destroy
destroy(this.st_1)
destroy(this.rc_1)
end on

type st_1 from statictext within u_cst_barra_progreso
int X=599
int Y=4
int Width=137
int Height=64
string Text="0%"
Alignment Alignment=Right!
boolean FocusRectangle=false
long TextColor=16711680
long BackColor=16777215
long BorderColor=16711680
int TextSize=-9
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type rc_1 from rectangle within u_cst_barra_progreso
int Width=32
int Height=144
boolean Visible=false
boolean Enabled=false
int LineThickness=4
long LineColor=16711680
long FillColor=16711680
end type

