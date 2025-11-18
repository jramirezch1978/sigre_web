$PBExportHeader$w_cons_prog_cosecha_mapa.srw
forward
global type w_cons_prog_cosecha_mapa from w_cns
end type
type rb_1 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_2 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_3 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_4 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_5 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_6 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_7 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_8 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_9 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_10 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_11 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_12 from radiobutton within w_cons_prog_cosecha_mapa
end type
type rb_13 from radiobutton within w_cons_prog_cosecha_mapa
end type
type p_1 from picture within w_cons_prog_cosecha_mapa
end type
end forward

global type w_cons_prog_cosecha_mapa from w_cns
integer width = 3026
integer height = 1692
string title = "Mapa de la programación de cosecha"
string menuname = "m_rpt_simple"
boolean maxbox = false
boolean resizable = false
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
rb_4 rb_4
rb_5 rb_5
rb_6 rb_6
rb_7 rb_7
rb_8 rb_8
rb_9 rb_9
rb_10 rb_10
rb_11 rb_11
rb_12 rb_12
rb_13 rb_13
p_1 p_1
end type
global w_cons_prog_cosecha_mapa w_cons_prog_cosecha_mapa

type prototypes
Function ulong GetDC(ulong hwnd) library "user32.dll"

FUNCTION ulong GetPixel(ulong hwnd, long xpos, long ypos) LIBRARY "Gdi32.dll"
FUNCTION ulong SetPixel(ulong hwnd, long xpos, long ypos, ulong pcol) LIBRARY "Gdi32.dll"


end prototypes

type variables
String is_PictureName 
end variables

forward prototypes
public subroutine uof_set_pixel (picture ap_picture, integer ai_x, integer ai_y, long al_color)
public subroutine uof_carga (integer an_mes)
end prototypes

public subroutine uof_set_pixel (picture ap_picture, integer ai_x, integer ai_y, long al_color);ULong   lul_GetDc, lul_GetPixel
lul_GetDc = GETDC(Handle(ap_picture))

Integer li_pos_x, li_pos_y
li_pos_x = UNITSTOPIXELS(POINTERX(ap_picture),XUNITSTOPIXELS!)
li_pos_y = UNITSTOPIXELS(POINTERY(ap_picture),YUNITSTOPIXELS!)
li_pos_x = 100
li_pos_y = 100
li_pos_x = ai_x
li_pos_y = ai_y

Integer li_desplaza_x, li_desplaza_y
//// puntos en cruz
For li_desplaza_x = -3 to 3
	 For li_desplaza_y = -3 to 3
        SetPixel(lul_GetDc, li_pos_x+li_desplaza_x, li_pos_y+li_desplaza_y, al_color)  
    Next
Next
// punto original 
SetPixel(lul_GetDc, li_pos_x, li_pos_y, 0)  // This call will set the pixel at lx, ly to black.					

end subroutine

public subroutine uof_carga (integer an_mes);//p_1.PictureName = 'c:\fotos\campos\mapa.bmp'
w_ca500_proy_cosecha.SetMicroHelp('Espere ... se está cargando el mapa ... esto tarda aproximadamente 35 segundos ...' )
p_1.PictureName = is_picturename
w_ca500_proy_cosecha.SetMicroHelp('Mapa cargado' )
// Mostrando la cosecha por meses
string ls_cod_campo, ls_ubicacion
Integer li_mes, li_x, li_y
Long ln_reg, ln_color
For ln_reg=1 to 	w_ca500_proy_cosecha.dw_reporte.RowCount()
	 ls_cod_campo = w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'cod_campo' )
	 li_mes       = integer(	w_ca500_proy_cosecha.dw_reporte.GetItemString( ln_reg, 'mes' ))
	 if an_mes = 0 or an_mes = li_mes Then
   	 Select ubicacion into :ls_ubicacion from campo     where cod_campo = :ls_cod_campo ;
	    Select x, y      into :li_x, :li_y  from ubicacion_campos where ubicacion = :ls_ubicacion ;
   	 Choose case li_mes
	    case 1
          //ln_color = rgb(128, 128,   0)
			 ln_color = rgb(255, 255, 255)
   	 case 2
          ln_color = rgb(255, 255,   0)
			 ln_color = rgb(255, 255, 255)
   	 case 3
          //ln_color = rgb(  0, 128, 128)
			 ln_color = rgb(255, 255, 255)
   	 case 4							
          //ln_color = rgb(  0, 255, 255)
			 ln_color = rgb(255, 255, 255)
   	 case 5
          //ln_color = rgb(128,   0, 128)
			 ln_color = rgb(255, 255, 255)
   	 case 6
          //ln_color = rgb(255,   0, 255)
			 ln_color = rgb(255, 255, 255)
   	 case 7
          //ln_color = rgb(  0,   0, 128)
			 ln_color = rgb(255, 255, 255)
   	 case 8
          //ln_color = rgb(  0,   0, 255)
			 ln_color = rgb(255, 255, 255)
   	 case 9
          //ln_color = rgb(  0, 128,   0)
			 ln_color = rgb(255, 255, 255)
   	 case 10
          //ln_color = rgb(  0, 255,   0)
			 ln_color = rgb(255, 255, 255)
   	 case 11
          //ln_color = rgb(128,   0,   0)
			 ln_color = rgb(255, 255, 255)
   	 case 12
          //ln_color = rgb(255,   0,   0)
			 ln_color = rgb(255, 255, 255)
   	 End Choose
       uof_set_pixel ( p_1, li_x, li_y, ln_color )
	 End If
Next	

end subroutine

on w_cons_prog_cosecha_mapa.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.rb_4=create rb_4
this.rb_5=create rb_5
this.rb_6=create rb_6
this.rb_7=create rb_7
this.rb_8=create rb_8
this.rb_9=create rb_9
this.rb_10=create rb_10
this.rb_11=create rb_11
this.rb_12=create rb_12
this.rb_13=create rb_13
this.p_1=create p_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_2
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_4
this.Control[iCurrent+5]=this.rb_5
this.Control[iCurrent+6]=this.rb_6
this.Control[iCurrent+7]=this.rb_7
this.Control[iCurrent+8]=this.rb_8
this.Control[iCurrent+9]=this.rb_9
this.Control[iCurrent+10]=this.rb_10
this.Control[iCurrent+11]=this.rb_11
this.Control[iCurrent+12]=this.rb_12
this.Control[iCurrent+13]=this.rb_13
this.Control[iCurrent+14]=this.p_1
end on

on w_cons_prog_cosecha_mapa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.rb_4)
destroy(this.rb_5)
destroy(this.rb_6)
destroy(this.rb_7)
destroy(this.rb_8)
destroy(this.rb_9)
destroy(this.rb_10)
destroy(this.rb_11)
destroy(this.rb_12)
destroy(this.rb_13)
destroy(this.p_1)
end on

event open;call super::open;This.x = 90
This.y = 120
rb_1.TextColor = rgb(128, 128,   0)
rb_2.TextColor = rgb(255, 255,   0)
rb_3.TextColor = rgb(  0, 128, 128)
rb_4.TextColor = rgb(  0, 255, 255)
rb_5.TextColor = rgb(128,   0, 128)
rb_6.TextColor = rgb(255,   0, 255)
rb_7.TextColor = rgb(  0,   0, 128)
rb_8.TextColor = rgb(  0,   0, 255)
rb_9.TextColor = rgb(  0, 128,   0)
rb_10.TextColor = rgb(  0, 255,   0)
rb_11.TextColor = rgb(128,   0,   0)
rb_12.TextColor = rgb(255,   0,   0)
rb_13.post event clicked()
uof_carga(0)

Select imagen_mapa
   into :is_picturename
   from prod_param
  where reckey=1;
  
p_1.PictureName = is_picturename
  
end event

type rb_1 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 361
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ene"
boolean lefttext = true
end type

event clicked;uof_carga(1)
end event

type rb_2 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 585
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Feb"
boolean lefttext = true
end type

event clicked;uof_carga(2)
end event

type rb_3 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 809
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mar"
boolean lefttext = true
end type

event clicked;uof_carga(3)
end event

type rb_4 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 1033
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Abr"
boolean lefttext = true
end type

event clicked;uof_carga(4)
end event

type rb_5 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 1257
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "May"
boolean lefttext = true
end type

event clicked;uof_carga(5)
end event

type rb_6 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 1481
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Jun"
boolean lefttext = true
end type

event clicked;uof_carga(6)
end event

type rb_7 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 1705
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Jul"
boolean lefttext = true
end type

event clicked;uof_carga(7)
end event

type rb_8 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 1929
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ago"
boolean lefttext = true
end type

event clicked;uof_carga(8)
end event

type rb_9 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 2153
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Set"
boolean lefttext = true
end type

event clicked;uof_carga(9)
end event

type rb_10 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 2377
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Oct"
boolean lefttext = true
end type

event clicked;uof_carga(10)
end event

type rb_11 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 2601
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nov"
boolean lefttext = true
end type

event clicked;uof_carga(11)
end event

type rb_12 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 2825
integer y = 28
integer width = 174
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dic"
boolean lefttext = true
end type

event clicked;uof_carga(12)
end event

type rb_13 from radiobutton within w_cons_prog_cosecha_mapa
integer x = 27
integer y = 28
integer width = 274
integer height = 76
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

event clicked;uof_carga(0)
end event

type p_1 from picture within w_cons_prog_cosecha_mapa
integer x = 14
integer y = 120
integer width = 2985
integer height = 1380
boolean bringtotop = true
string picturename = "i:\fotos\campos\mapa.bmp"
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

