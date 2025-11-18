$PBExportHeader$w_ca500_proy_cosecha.srw
forward
global type w_ca500_proy_cosecha from w_cns
end type
type st_etiqueta from statictext within w_ca500_proy_cosecha
end type
type rb_4 from radiobutton within w_ca500_proy_cosecha
end type
type rb_3 from radiobutton within w_ca500_proy_cosecha
end type
type rb_2 from radiobutton within w_ca500_proy_cosecha
end type
type rb_1 from radiobutton within w_ca500_proy_cosecha
end type
type em_ano from editmask within w_ca500_proy_cosecha
end type
type st_1 from statictext within w_ca500_proy_cosecha
end type
type dw_reporte from u_dw_cns within w_ca500_proy_cosecha
end type
type cb_procesar from commandbutton within w_ca500_proy_cosecha
end type
type dw_grafico from datawindow within w_ca500_proy_cosecha
end type
type cb_mapa from commandbutton within w_ca500_proy_cosecha
end type
type cb_resumen from commandbutton within w_ca500_proy_cosecha
end type
type gb_1 from groupbox within w_ca500_proy_cosecha
end type
end forward

global type w_ca500_proy_cosecha from w_cns
integer width = 3328
integer height = 1868
string title = "Proyección de cosecha (CA500)"
string menuname = "m_rpt_simple"
boolean righttoleft = true
st_etiqueta st_etiqueta
rb_4 rb_4
rb_3 rb_3
rb_2 rb_2
rb_1 rb_1
em_ano em_ano
st_1 st_1
dw_reporte dw_reporte
cb_procesar cb_procesar
dw_grafico dw_grafico
cb_mapa cb_mapa
cb_resumen cb_resumen
gb_1 gb_1
end type
global w_ca500_proy_cosecha w_ca500_proy_cosecha

type prototypes
Function ulong GetDC(ulong hwnd) library "user32.dll"

FUNCTION ulong GetPixel(ulong hwnd, long xpos, long ypos) LIBRARY "Gdi32.dll"
FUNCTION ulong SetPixel(ulong hwnd, long xpos, long ypos, ulong pcol) LIBRARY "Gdi32.dll"


end prototypes

type variables
String is_graf_maximizado = 'N', is_ano
Integer	ii_grf_x, ii_grf_y
end variables

forward prototypes
public subroutine uof_set_pixel (picture ap_picture, integer al_x, integer al_y, long al_color)
end prototypes

public subroutine uof_set_pixel (picture ap_picture, integer al_x, integer al_y, long al_color);ULong   lul_GetDc, lul_GetPixel
lul_GetDc = GETDC(Handle(ap_picture))

Integer li_pos_x, li_pos_y
li_pos_x = UNITSTOPIXELS(POINTERX(ap_picture),XUNITSTOPIXELS!)
li_pos_y = UNITSTOPIXELS(POINTERY(ap_picture),YUNITSTOPIXELS!)
li_pos_x = 100
li_pos_y = 100
li_pos_x = al_x
li_pos_y = al_y

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

on w_ca500_proy_cosecha.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.st_etiqueta=create st_etiqueta
this.rb_4=create rb_4
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_1=create rb_1
this.em_ano=create em_ano
this.st_1=create st_1
this.dw_reporte=create dw_reporte
this.cb_procesar=create cb_procesar
this.dw_grafico=create dw_grafico
this.cb_mapa=create cb_mapa
this.cb_resumen=create cb_resumen
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_etiqueta
this.Control[iCurrent+2]=this.rb_4
this.Control[iCurrent+3]=this.rb_3
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_1
this.Control[iCurrent+6]=this.em_ano
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_reporte
this.Control[iCurrent+9]=this.cb_procesar
this.Control[iCurrent+10]=this.dw_grafico
this.Control[iCurrent+11]=this.cb_mapa
this.Control[iCurrent+12]=this.cb_resumen
this.Control[iCurrent+13]=this.gb_1
end on

on w_ca500_proy_cosecha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_etiqueta)
destroy(this.rb_4)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.em_ano)
destroy(this.st_1)
destroy(this.dw_reporte)
destroy(this.cb_procesar)
destroy(this.dw_grafico)
destroy(this.cb_mapa)
destroy(this.cb_resumen)
destroy(this.gb_1)
end on

event resize;call super::resize;if is_graf_maximizado = 'N' Then
   dw_reporte.width  = this.width - 3
   dw_reporte.height = this.height - 700  //600
	dw_grafico.x      = this.width - dw_grafico.width + 3
end if

end event

event ue_open_pre;call super::ue_open_pre;
dw_reporte.SetTransObject(sqlca)
dw_grafico.SetTransObject(sqlca)

idw_1 = dw_reporte

ii_help = 500        				// help topic
//MessageBox(string(ii_help),"HELP")
of_position_window(0,0)

em_ano.text = String( year( today() ) )

end event

type st_etiqueta from statictext within w_ca500_proy_cosecha
boolean visible = false
integer y = 536
integer width = 402
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
string text = "none"
boolean focusrectangle = false
end type

type rb_4 from radiobutton within w_ca500_proy_cosecha
integer x = 599
integer y = 368
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Todos"
end type

type rb_3 from radiobutton within w_ca500_proy_cosecha
integer x = 599
integer y = 288
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Sembradores"
end type

type rb_2 from radiobutton within w_ca500_proy_cosecha
integer x = 599
integer y = 208
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Arrendados"
end type

type rb_1 from radiobutton within w_ca500_proy_cosecha
integer x = 599
integer y = 128
integer width = 430
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Propios"
boolean checked = true
end type

type em_ano from editmask within w_ca500_proy_cosecha
integer x = 192
integer y = 80
integer width = 224
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "####"
end type

type st_1 from statictext within w_ca500_proy_cosecha
integer x = 27
integer y = 92
integer width = 146
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type dw_reporte from u_dw_cns within w_ca500_proy_cosecha
integer y = 604
integer width = 3273
integer height = 1020
integer taborder = 80
boolean bringtotop = true
string dataobject = "d_cons_prog_cosecha"
boolean hscrollbar = true
boolean vscrollbar = true
boolean hsplitscroll = true
end type

event constructor;call super::constructor;ii_ck[1] = 1 
end event

type cb_procesar from commandbutton within w_ca500_proy_cosecha
integer x = 1275
integer y = 100
integer width = 416
integer height = 84
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar"
end type

event clicked;Rollback;
Date 	 ld_fecha_ini, ld_fecha_fin
String ls_tipo, ls_texto

is_ano = em_ano.text

IF Isnull(is_ano) OR Trim(is_ano) = '' THEN
	Messagebox('Aviso','Debe Ingresar Año a Procesar')
	RETURN
END IF

ld_fecha_ini = Date('01/01/'+is_ano)
ld_fecha_fin = Date('31/12/'+is_ano)

IF rb_1.checked THEN			//propio
	ls_tipo = 'P'
	ls_texto = 'Campos Propios'
ELSEIF rb_2.checked THEN	//arrendados
	ls_tipo = 'A'
	ls_texto = 'Campos Arrendados'
ELSEIF rb_3.checked THEN	//sembradores
	ls_tipo = 'S'
	ls_texto = 'Campos de Sembradores'
ELSEIF rb_4.checked THEN	//todos
	ls_tipo = 'T'
	ls_texto = 'Todos los Campos'
ELSE
	Messagebox('Aviso','Tipo de Propiedad No Existe ,Verifique!')
	Return
END IF


DECLARE pb_usp_prog_cosecha PROCEDURE FOR USP_PROG_COSECHA  
        ( :ld_fecha_ini,:ld_fecha_fin,:ls_tipo ) ;
		  
DECLARE pb_usp_prog_cosecha_gra PROCEDURE FOR USP_PROG_COSECHA_GRA ( 'nada' ) ;
Execute pb_usp_prog_cosecha;

if sqlca.sqlcode = -1 Then
	Parent.SetMicroHelp("Store procedure <<<usp_prog_cosecha>>> no funciona!!!")
	MessageBox('Falló Store Procedure', 'Vuelva a intentarlo' + '~n~rusp_prog_cosecha') 
Else
	Parent.SetMicroHelp("Store procedure ok")
   dw_reporte.retrieve(gs_empresa,gs_user)
	dw_reporte.Object.p_logo.filename = gs_logo
	dw_reporte.Object.t_texto.text = ls_texto
	dw_reporte.Object.t_empresa.text = gs_empresa
	dw_reporte.Object.t_user.text = gs_user
End If

Execute pb_usp_prog_cosecha_gra;
if sqlca.sqlcode = -1 Then
	Parent.SetMicroHelp("Store procedure <<<usp_prog_cosecha_gra>>> no funciona!!!")
	MessageBox('Falló Store Procedure', 'Vuelva a intentarlo' + '~n~rusp_prog_cosecha_gra') 
Else
	Parent.SetMicroHelp("Store procedure ok")
   dw_grafico.retrieve()
End If
// Activa los botones
IF UPPER(gs_lpp) <> 'S' THEN cb_mapa.enabled	= True
cb_resumen.enabled	= True

RETURN 1
end event

type dw_grafico from datawindow within w_ca500_proy_cosecha
event ue_mousemove pbm_mousemove
integer x = 1806
integer y = 16
integer width = 1467
integer height = 564
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_cons_prog_cosecha_gra"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_mousemove;	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos + THIS.x 
 		st_etiqueta.y = ypos + THIS.y - 40
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF



end event

event doubleclicked;if is_graf_maximizado = 'N' Then
	ii_grf_x = THIS.x
	ii_grf_y = THIS.y
	THIS.x = dw_reporte.x
	THIS.y = dw_reporte.y
	THIS.width = dw_reporte.width
	THIS.height = dw_reporte.height
   is_graf_maximizado = 'S' 
else
	THIS.x = ii_grf_x
	THIS.y = ii_grf_y
	THIS.width = 1467
	THIS.height = 564
   is_graf_maximizado = 'N' 
End If
end event

type cb_mapa from commandbutton within w_ca500_proy_cosecha
integer x = 1275
integer y = 232
integer width = 416
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Mapa"
end type

event clicked;OpenSheet (w_cons_prog_cosecha_mapa, w_main, 0, Original!)

end event

type cb_resumen from commandbutton within w_ca500_proy_cosecha
integer x = 1275
integer y = 352
integer width = 416
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Resumen"
end type

event clicked;OpenSheet (w_cons_prog_cosecha_res, w_main, 0, Original!)
end event

type gb_1 from groupbox within w_ca500_proy_cosecha
integer x = 571
integer y = 48
integer width = 571
integer height = 416
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Propiedad del Campo"
end type

