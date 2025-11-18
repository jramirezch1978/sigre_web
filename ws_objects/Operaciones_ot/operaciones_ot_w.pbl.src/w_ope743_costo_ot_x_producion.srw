$PBExportHeader$w_ope743_costo_ot_x_producion.srw
forward
global type w_ope743_costo_ot_x_producion from w_rpt
end type
type cbx_tcv from checkbox within w_ope743_costo_ot_x_producion
end type
type cbx_tcf from checkbox within w_ope743_costo_ot_x_producion
end type
type rb_2 from radiobutton within w_ope743_costo_ot_x_producion
end type
type rb_1 from radiobutton within w_ope743_costo_ot_x_producion
end type
type st_6 from statictext within w_ope743_costo_ot_x_producion
end type
type pb_1 from picturebutton within w_ope743_costo_ot_x_producion
end type
type st_5 from statictext within w_ope743_costo_ot_x_producion
end type
type st_4 from statictext within w_ope743_costo_ot_x_producion
end type
type em_preal from editmask within w_ope743_costo_ot_x_producion
end type
type em_pproy from editmask within w_ope743_costo_ot_x_producion
end type
type sle_desc_unidad from singlelineedit within w_ope743_costo_ot_x_producion
end type
type cb_3 from commandbutton within w_ope743_costo_ot_x_producion
end type
type st_3 from statictext within w_ope743_costo_ot_x_producion
end type
type sle_und from singlelineedit within w_ope743_costo_ot_x_producion
end type
type cbx_1 from checkbox within w_ope743_costo_ot_x_producion
end type
type sle_2 from singlelineedit within w_ope743_costo_ot_x_producion
end type
type st_2 from statictext within w_ope743_costo_ot_x_producion
end type
type dw_prod from u_dw_rpt within w_ope743_costo_ot_x_producion
end type
type st_1 from statictext within w_ope743_costo_ot_x_producion
end type
type cb_1 from commandbutton within w_ope743_costo_ot_x_producion
end type
type sle_1 from singlelineedit within w_ope743_costo_ot_x_producion
end type
type cb_2 from commandbutton within w_ope743_costo_ot_x_producion
end type
type dw_report from u_dw_rpt within w_ope743_costo_ot_x_producion
end type
type dw_grf from u_dw_grf within w_ope743_costo_ot_x_producion
end type
type gb_1 from groupbox within w_ope743_costo_ot_x_producion
end type
type dw_estructura from datawindow within w_ope743_costo_ot_x_producion
end type
end forward

global type w_ope743_costo_ot_x_producion from w_rpt
integer width = 4201
integer height = 2724
string title = "Totales de Costos de OT (OPE743)"
string menuname = "m_rpt_smpl"
long backcolor = 12632256
event ue_retrieve_prod ( decimal adc_prod_real,  decimal adc_prod_proy )
cbx_tcv cbx_tcv
cbx_tcf cbx_tcf
rb_2 rb_2
rb_1 rb_1
st_6 st_6
pb_1 pb_1
st_5 st_5
st_4 st_4
em_preal em_preal
em_pproy em_pproy
sle_desc_unidad sle_desc_unidad
cb_3 cb_3
st_3 st_3
sle_und sle_und
cbx_1 cbx_1
sle_2 sle_2
st_2 st_2
dw_prod dw_prod
st_1 st_1
cb_1 cb_1
sle_1 sle_1
cb_2 cb_2
dw_report dw_report
dw_grf dw_grf
gb_1 gb_1
dw_estructura dw_estructura
end type
global w_ope743_costo_ot_x_producion w_ope743_costo_ot_x_producion

forward prototypes
public subroutine of_totales_x_conversion_und (ref decimal adc_prod_real, ref decimal adc_prod_proy)
public function boolean of_totales_conv_sel (ref decimal adc_prod_real_item, ref decimal adc_prod_proy_item, string as_unidad)
public function boolean of_verifica (ref decimal adc_prod_real, ref decimal adc_prod_proy, ref string as_titulo)
end prototypes

event ue_retrieve_prod(decimal adc_prod_real, decimal adc_prod_proy);messagebox('adc_prod_real',adc_prod_real)
messagebox('adc_prod_proy',adc_prod_proy)
end event

public subroutine of_totales_x_conversion_und (ref decimal adc_prod_real, ref decimal adc_prod_proy);String ls_cod_und,ls_desc_unidad,ls_unidad
Long   ll_inicio
Decimal {4} ldc_prod_real_item,ldc_prod_proy_item
Decimal {6} ldc_factor_conv				


		
ls_cod_und 		= sle_und.text
ls_desc_unidad	= sle_desc_unidad.text
		
if Isnull(ls_cod_und) or Trim(ls_cod_und) = '' then
	Messagebox('Aviso','Debe Ingresar un codigo de Unidad para visualizar las Unidades Producidas')
	sle_und.SetFocus()
	cbx_1.checked = FALSE
	Return
end if


Messagebox('Aviso','Las Unidades Producidas se Visualizaran en '+ ls_desc_unidad )
		
for ll_inicio = 1 to dw_prod.Rowcount( ) 
	 ldc_prod_real_item = dw_prod.object.cant_real [ll_inicio]
	 ldc_prod_proy_item = dw_prod.object.cant_proy [ll_inicio]
	 ls_unidad			  = dw_prod.object.und		  [ll_inicio]
			 
	 if ls_unidad <> ls_cod_und then
		 select factor_conv into :ldc_factor_conv
		   from unidad_conv 
		  where (und_ingr = :ls_unidad  ) and
				  (und_conv = :ls_cod_und ) ;
	 else
		 ldc_factor_conv = 1
	 end if		  
					  
	 if Isnull(ldc_factor_conv) or ldc_factor_conv = 0 then
		 Messagebox('Aviso','No Existe Factor de Conversion de '+ls_unidad +' A '+ ls_cod_und)
		 sle_und.SetFocus()
		 cbx_1.checked = FALSE
		 Return
	 end if	
			

	 IF Isnull(ldc_prod_real_item) then ldc_prod_real_item = 0.000
	 IF Isnull(ldc_prod_proy_item) then ldc_prod_proy_item = 0.000

			 
	 //convertir producion proyectada
	 ldc_prod_real_item = Round(ldc_prod_real_item * ldc_factor_conv,4) 			 			 
	 //convertir producion real
	 ldc_prod_proy_item = Round(ldc_prod_proy_item * ldc_factor_conv,4)
			 
	 adc_prod_real = adc_prod_real + ldc_prod_real_item
	 adc_prod_proy = adc_prod_proy + ldc_prod_proy_item
			 
			 
next
		
end subroutine

public function boolean of_totales_conv_sel (ref decimal adc_prod_real_item, ref decimal adc_prod_proy_item, string as_unidad);String      ls_cod_und,ls_desc_unidad
Long        ll_inicio
Boolean		lb_ret = TRUE
Decimal {6} ldc_factor_conv				



		
ls_cod_und 		= sle_und.text
ls_desc_unidad	= sle_desc_unidad.text


IF Isnull(adc_prod_real_item) then adc_prod_real_item = 0.000
IF Isnull(adc_prod_proy_item) then adc_prod_proy_item = 0.000		
		
if Isnull(ls_cod_und) or Trim(ls_cod_und) = '' then
	Messagebox('Aviso','Debe Ingresar un codigo de Unidad para visualizar las Unidades Producidas')
	sle_und.SetFocus()
	cbx_1.checked = FALSE
	lb_ret = FALSE
	GOTO SALIDA
end if



if as_unidad <> ls_cod_und then
   select factor_conv into :ldc_factor_conv
	  from unidad_conv 
	 where (und_ingr = :as_unidad  ) and
	  	    (und_conv = :ls_cod_und ) ;
else
	 ldc_factor_conv = 1
end if		  
					  
 if Isnull(ldc_factor_conv) or ldc_factor_conv = 0 then
	 Messagebox('Aviso','No Existe Factor de Conversion de '+as_unidad +' A '+ ls_cod_und)
	 sle_und.SetFocus()
	 lb_ret = FALSE
	 GOTO SALIDA
 end if	
			


			 
//convertir producion proyectada
adc_prod_real_item = Round(adc_prod_real_item * ldc_factor_conv,4) 			 			 
//convertir producion real
adc_prod_proy_item = Round(adc_prod_proy_item * ldc_factor_conv,4)
			 

			 
SALIDA:

Return lb_ret		
end function

public function boolean of_verifica (ref decimal adc_prod_real, ref decimal adc_prod_proy, ref string as_titulo);Long    ll_inicio
String  ls_flag,ls_unidad
Decimal {4} ldc_prod_real_item ,ldc_prod_proy_item
Boolean		lb_flag = TRUE


adc_prod_real = 0.0000
adc_prod_proy = 0.0000
as_titulo	  = ''

dw_prod.accepttext()

for ll_inicio = 1 to dw_prod.rowcount( )
	 ls_flag = dw_prod.object.flag_informacion	 [ll_inicio]

	 ldc_prod_real_item = dw_prod.object.cant_real [ll_inicio]
	 ldc_prod_proy_item = dw_prod.object.cant_proy [ll_inicio]
	 ls_unidad			  = dw_prod.object.und		  [ll_inicio]
	 
	 if ls_flag = '1' then //acumula y convierte
	 	 if of_totales_conv_sel (ldc_prod_real_item,ldc_prod_proy_item,ls_unidad) =  TRUE then
		    //acumula
		 	 adc_prod_real = adc_prod_real + ldc_prod_real_item
	 		 adc_prod_proy = adc_prod_proy + ldc_prod_proy_item
			 as_titulo	  = 'ARTICULOS SELECCIONADOS'
			 lb_flag = TRUE
		 else
			 adc_prod_real = 0.0000
			 adc_prod_proy = 0.0000
			 as_titulo	  = ''
			 lb_flag = FALSE
			 EXIT
		 end if	
			
	 end if
	 
	 
	 
next






Return lb_flag

end function

on w_ope743_costo_ot_x_producion.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cbx_tcv=create cbx_tcv
this.cbx_tcf=create cbx_tcf
this.rb_2=create rb_2
this.rb_1=create rb_1
this.st_6=create st_6
this.pb_1=create pb_1
this.st_5=create st_5
this.st_4=create st_4
this.em_preal=create em_preal
this.em_pproy=create em_pproy
this.sle_desc_unidad=create sle_desc_unidad
this.cb_3=create cb_3
this.st_3=create st_3
this.sle_und=create sle_und
this.cbx_1=create cbx_1
this.sle_2=create sle_2
this.st_2=create st_2
this.dw_prod=create dw_prod
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_1=create sle_1
this.cb_2=create cb_2
this.dw_report=create dw_report
this.dw_grf=create dw_grf
this.gb_1=create gb_1
this.dw_estructura=create dw_estructura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_tcv
this.Control[iCurrent+2]=this.cbx_tcf
this.Control[iCurrent+3]=this.rb_2
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.st_6
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_4
this.Control[iCurrent+9]=this.em_preal
this.Control[iCurrent+10]=this.em_pproy
this.Control[iCurrent+11]=this.sle_desc_unidad
this.Control[iCurrent+12]=this.cb_3
this.Control[iCurrent+13]=this.st_3
this.Control[iCurrent+14]=this.sle_und
this.Control[iCurrent+15]=this.cbx_1
this.Control[iCurrent+16]=this.sle_2
this.Control[iCurrent+17]=this.st_2
this.Control[iCurrent+18]=this.dw_prod
this.Control[iCurrent+19]=this.st_1
this.Control[iCurrent+20]=this.cb_1
this.Control[iCurrent+21]=this.sle_1
this.Control[iCurrent+22]=this.cb_2
this.Control[iCurrent+23]=this.dw_report
this.Control[iCurrent+24]=this.dw_grf
this.Control[iCurrent+25]=this.gb_1
this.Control[iCurrent+26]=this.dw_estructura
end on

on w_ope743_costo_ot_x_producion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_tcv)
destroy(this.cbx_tcf)
destroy(this.rb_2)
destroy(this.rb_1)
destroy(this.st_6)
destroy(this.pb_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.em_preal)
destroy(this.em_pproy)
destroy(this.sle_desc_unidad)
destroy(this.cb_3)
destroy(this.st_3)
destroy(this.sle_und)
destroy(this.cbx_1)
destroy(this.sle_2)
destroy(this.st_2)
destroy(this.dw_prod)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.dw_report)
destroy(this.dw_grf)
destroy(this.gb_1)
destroy(this.dw_estructura)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
dw_grf.SetTransObject(sqlca)
dw_prod.SetTransObject(sqlca)

ib_preview = FALSE
idw_1.ii_zoom_actual = 95
THIS.Event ue_preview()


//producion
//dw_prod.Modify("DataWindow.Print.Preview=Yes")
//dw_prod.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))



idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

//ingresos por producion
dw_prod.object.p_logo.filename = gs_logo
dw_prod.object.t_nombre.text = gs_empresa
dw_prod.object.t_user.text = gs_user

end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type cbx_tcv from checkbox within w_ope743_costo_ot_x_producion
integer x = 1659
integer y = 100
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "T.Costo Variable"
boolean checked = true
end type

type cbx_tcf from checkbox within w_ope743_costo_ot_x_producion
integer x = 1659
integer y = 16
integer width = 526
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "T.Costo Fijo"
boolean checked = true
end type

type rb_2 from radiobutton within w_ope743_costo_ot_x_producion
integer x = 1129
integer y = 100
integer width = 453
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Estructura"
end type

type rb_1 from radiobutton within w_ope743_costo_ot_x_producion
integer x = 1129
integer y = 16
integer width = 453
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "OT Normal"
boolean checked = true
end type

type st_6 from statictext within w_ope743_costo_ot_x_producion
integer x = 2898
integer y = 1492
integer width = 923
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Estructura de Orden de Trabajo"
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_ope743_costo_ot_x_producion
integer x = 2469
integer y = 1476
integer width = 411
integer height = 220
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Gif\orga.gif"
alignment htextalign = left!
end type

event clicked;String ls_nro_ot

ls_nro_ot = sle_1.text

dw_estructura.retrieve(ls_nro_ot)
dw_estructura.visible = True

end event

type st_5 from statictext within w_ope743_costo_ot_x_producion
integer x = 2542
integer y = 2256
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "Produción Real :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_ope743_costo_ot_x_producion
integer x = 2542
integer y = 2168
integer width = 549
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "Produción Proyectada :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_preal from editmask within w_ope743_costo_ot_x_producion
integer x = 3099
integer y = 2240
integer width = 512
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 65535
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.0000"
end type

type em_pproy from editmask within w_ope743_costo_ot_x_producion
integer x = 3099
integer y = 2148
integer width = 512
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 65535
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,###.0000"
end type

type sle_desc_unidad from singlelineedit within w_ope743_costo_ot_x_producion
integer x = 3387
integer y = 1988
integer width = 590
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_ope743_costo_ot_x_producion
integer x = 3986
integer y = 1980
integer width = 96
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar




			
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT UNIDAD.UND         AS CODIGO, '&
										 +'UNIDAD.DESC_UNIDAD AS DESCRIPCION '&
										 +'FROM UNIDAD '

										  
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_und.text         = lstr_seleccionar.param1[1]
	sle_desc_unidad.text = lstr_seleccionar.param2[1]
END IF

end event

type st_3 from statictext within w_ope743_costo_ot_x_producion
integer x = 2437
integer y = 1996
integer width = 731
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "Unidad a Visualizar Información :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_und from singlelineedit within w_ope743_costo_ot_x_producion
event ue_tecla pbm_keydown
integer x = 3177
integer y = 1988
integer width = 197
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 3
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;String ls_und,ls_desc_und
Long   ll_count

IF key = KeyEnter! THEN
	ls_und = this.text
	
	select count(*) into :ll_count from unidad 
	 where (und = :ls_und) ;
	 
	 
	if ll_count = 0 then
		Messagebox('Aviso','Unidad No existe , Verifique!')	
		
	else
		
		select desc_unidad into :ls_desc_und from unidad 
		 where (und = :ls_und) ;
		 
		sle_desc_unidad.text = ls_desc_und
	end if
	
END IF
end event

type cbx_1 from checkbox within w_ope743_costo_ot_x_producion
integer x = 2446
integer y = 1852
integer width = 1504
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "Recuperación de Totales de Articulos Producidos"
end type

event clicked;String  ls_nom_art
Long    ll_count,ll_inicio
Integer li_opcion
Decimal {4} ldc_prod_real,ldc_prod_proy,ldc_prod_real_item,ldc_prod_proy_item 




//inicializacion de variables
ldc_prod_real = 0.000
ldc_prod_proy = 0.000
ls_nom_art	  = ''


IF cbx_1.checked THEN
	//desmarca todos los seleccionados
	for ll_inicio = 1 to dw_prod.rowcount( )
		 dw_prod.object.flag_informacion [ll_inicio] = '0'
	next
	
	//VERIFICAR QUE NO EXISTAN UNIDADES DIFERENTES
	select Count(*) into :ll_count
     from tt_ope_prod_art tt_op,articulo art
    where ( tt_op.cod_art = art.cod_art )    
 group by art.und ;
	
	if ll_count > 1 then
				
		//CARGAR INFORMACION DE COSTOS DE OT
		ls_nom_art = 'Por Todos Los Articulos Producidos '

		of_totales_x_conversion_und (ldc_prod_real,ldc_prod_proy)
		
				
	else
		//CARGAR INFORMACION DE COSTOS DE OT
		ls_nom_art = 'Por Todos Los Articulos Producidos '

		////recuperar producion real y proyectada
		IF dw_prod.Rowcount() > 0 THEN
			ldc_prod_real = dw_prod.object.total_real [1]
			ldc_prod_proy = dw_prod.object.total_proy [1]
		
			IF Isnull(ldc_prod_real) then ldc_prod_real = 0.000
			IF Isnull(ldc_prod_proy) then ldc_prod_proy = 0.000
			IF Isnull(ls_nom_art)	 then ls_nom_art    = ''
		ELSE
			ls_nom_art = ''
	
		END IF				
		
	end if

	dw_report.retrieve(ldc_prod_proy,ldc_prod_real)
	dw_report.object.t_titulo.text = ls_nom_art	
	
	//colocar unidades producidas
	em_pproy.text = string(ldc_prod_proy)
	em_preal.text = string(ldc_prod_real)
ELSE
//	solo seleccionados
	em_pproy.text = string(0.00)
	em_preal.text = string(0.00)
	dw_report.retrieve(ldc_prod_proy,ldc_prod_real)
	dw_report.object.t_titulo.text = ls_nom_art		
END IF	




end event

type sle_2 from singlelineedit within w_ope743_costo_ot_x_producion
boolean visible = false
integer x = 4599
integer y = 1492
integer width = 571
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_ope743_costo_ot_x_producion
boolean visible = false
integer x = 4594
integer y = 1364
integer width = 1335
integer height = 104
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
string text = "Ratio Por Produción  ($ / Unidad Producida ):"
boolean focusrectangle = false
end type

type dw_prod from u_dw_rpt within w_ope743_costo_ot_x_producion
event ue_seleccion ( long al_row,  string data )
integer x = 27
integer y = 1468
integer width = 2386
integer height = 972
integer taborder = 30
string dataobject = "d_abc_ingresos_producion_tbl"
boolean vscrollbar = true
end type

event ue_seleccion(long al_row, string data);Decimal {4} ldc_prod_real,ldc_prod_proy
String      ls_titulo

if of_verifica(ldc_prod_real,ldc_prod_proy,ls_titulo) = FALSE then
	if data = '1' then
		this.object.flag_informacion [al_row] = '0'
	end if	
end if

dw_report.retrieve(ldc_prod_proy,ldc_prod_real)
dw_report.object.t_titulo.text = ls_titulo


em_pproy.text = string(ldc_prod_proy)
em_preal.text = string(ldc_prod_real)

end event

event rowfocuschanged;call super::rowfocuschanged;String  ls_nom_art
Decimal {4} ldc_prod_real,ldc_prod_proy

IF currentrow = 0 THEN RETURN

This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)





end event

event clicked;call super::clicked;idw_1 = this
IF row = 0 THEN RETURN

This.SelectRow(0, False)
This.SelectRow(row, True)



end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;Decimal {4} ldc_prod_real,ldc_prod_proy


Accepttext()

choose case dwo.name
		 case 'flag_informacion'
			
				if cbx_1.checked then
					messagebox('Aviso','Desmarque ocpion de todos los articulos')
					Return 2
				else
					post event ue_seleccion(row,data)	
				end if
				

				
end choose

end event

type st_1 from statictext within w_ope743_costo_ot_x_producion
integer x = 32
integer y = 56
integer width = 283
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nro Orden :"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_ope743_costo_ot_x_producion
integer x = 754
integer y = 36
integer width = 114
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT ORIGEN         AS CODIGO_ORIGEN       ,'&
								+' NRO_OT         AS NRO_ORDEN_TRABAJO 		  ,'&
						  	   +'ADMINISTRACION AS ADMINISTRACION	   		  ,'&
								+'TIPO           AS TIPO_OT				 		  ,'&
								+'CENCOS_SOLIC   AS CC_SOLICITANTE	 			  ,'&
								+'DESC_CC_SOLICITANTE  AS DESC_CC_SOLICITANTE  ,'&
								+'CENCOS_RESP    AS CC_RESPONSABLE	 			  ,'&
								+'DESC_CC_RESPONSABLE  AS DESC_CC_RESPONSABLE  ,'&
								+'USUARIO        AS CODIGO_USUARIO	 			  ,'&
								+'CODIGO_RESPONSABLE   AS CODIGO_RESPONSABLE   ,'&
								+'NOMBRE_RESPONSABLE   AS NOMBRES_RESPONSABLES ,'&
							  	+'FECHA_INICIO         AS FECHA_INICIO 		  ,'&		
								+'TITULO_ORDEN_TRABAJO AS TITULO_ORDEN_TRABAJO  '&
								+'FROM VW_OPE_CONSULTA_ORDEN_TRABAJO '

				
OpenWithParm(w_seleccionar_op,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_1.text = lstr_seleccionar.param2[1]
	END IF


end event

type sle_1 from singlelineedit within w_ope743_costo_ot_x_producion
integer x = 370
integer y = 36
integer width = 370
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_ope743_costo_ot_x_producion
integer x = 3735
integer y = 20
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err,ls_nro_ot,ls_nom_art,ls_opcion
Decimal {4} ldc_prod_real,ldc_prod_proy
Long	 ll_row_det	

ls_nro_ot = sle_1.text

//tipo de ot
if rb_1.checked then
	ls_opcion = 'N'
elseif rb_2.checked then
	ls_opcion = 'E'	
end if

//TIPO DE COSTO
if cbx_tcv.checked then
	insert into tt_ope_tcosto
	(flag_costo_tipo)
	values
	('V');
end if

if cbx_tcf.checked then
	insert into tt_ope_tcosto
	(flag_costo_tipo)
	values
	('F');	
end if	


DECLARE PB_USP_OPE_COSTO_REAL_X_OT PROCEDURE FOR USP_OPE_COSTO_REAL_X_OT
(:ls_nro_ot,:ls_opcion);
EXECUTE PB_USP_OPE_COSTO_REAL_X_OT ;


IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	MessageBox('SQL error', ls_msj_err)
END IF


CLOSE PB_USP_OPE_COSTO_REAL_X_OT ;

//RECUPERACION INFORMACION

dw_prod.retrieve(ls_nro_ot)

//inicializa recuperacion de totales
cbx_1.checked = false

IF Isnull(ldc_prod_real) then ldc_prod_real = 0.000
IF Isnull(ldc_prod_proy) then ldc_prod_proy = 0.000
IF Isnull(ls_nom_art)	 then ls_nom_art    = ''

//
dw_report.retrieve(ldc_prod_proy,ldc_prod_real,ls_nom_art)
dw_grf.retrieve()
//
dw_report.object.t_titulo.text = ls_nom_art


delete from tt_ope_tcosto ;
end event

type dw_report from u_dw_rpt within w_ope743_costo_ot_x_producion
integer x = 27
integer y = 184
integer width = 2386
integer height = 1260
string dataobject = "d_abc_costo_total_ot_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;Long	      ll_row_det
Decimal {4} ldc_prod_real,ldc_prod_proy
Decimal {2} ldc_participacion
String      ls_item,ls_nom_art
Integer 		li_opcion

IF row = 0 THEN RETURN

str_cns_pop lstr_1

This.accepttext ()

//detalle de producion
ldc_prod_real = 0.000
ldc_prod_proy = 0.000
ls_nom_art	  = ''

IF dw_prod.rowcount() > 0 THEN
	
	ll_row_det = dw_prod.getrow()

	IF cbx_1.checked THEN
		//TOTALES
		ls_nom_art	  = 'Todos Los Articulos Producidos'
		ldc_prod_proy = Dec(em_pproy.text)
		ldc_prod_real = Dec(em_preal.text)
		
	ELSE		
		ls_nom_art	  = 'Todos Los Articulos Seleccionados'
		ldc_prod_proy = Dec(em_pproy.text)
		ldc_prod_real = Dec(em_preal.text)
		
	END IF
	
	
	
END IF



CHOOSE CASE dwo.Name
		
		 CASE 'costo_proy'  //PROYECTADOS
			
				ls_item = this.object.item [row]
				
			
				if ls_item = '01' then
					lstr_1.DataObject = 'd_abc_det_art_proy_ot_tbl'
					lstr_1.Width = 4460
					lstr_1.Height= 2000
					
					IF ldc_prod_proy = 0 THEN
						lstr_1.title = 'Lista de Articulos Proyectados '
					ELSE
						lstr_1.title = 'Lista de Articulos Proyectados por Producion Proyectada de '+ls_nom_art
					END IF
					lstr_1.tipo_cascada = 'R'
					lstr_1.arg [1] = 'AP'
					lstr_1.arg [2] = String(ldc_prod_proy)
					of_new_sheet(lstr_1)
					
			   elseif ls_item = '02' then //SERVICIOS DE TERCEROS
				   lstr_1.DataObject = 'd_abc_costo_proy_x_labor_tbl'
					lstr_1.Width = 3550
					lstr_1.Height= 1300
					lstr_1.title = 'Lista de Servicios Proyectadas'
					lstr_1.tipo_cascada = 'R'
					lstr_1.arg [1] = 'LS'
					of_new_sheet(lstr_1)
					
				elseif ls_item = '03' then //labor
					lstr_1.DataObject = 'd_abc_costo_proy_x_labor_prop_tbl'
					lstr_1.Width = 4000
					lstr_1.Height= 1300
					lstr_1.title = 'Lista de Labores Proyectadas'
					lstr_1.tipo_cascada = 'R'					
					lstr_1.arg [1] = 'LP'
					of_new_sheet(lstr_1)
					
				elseif ls_item = '07' then //distribucion de ot
					lstr_1.DataObject = 'd_abc_distrib_ot_est_tbl'
					lstr_1.Width = 2350
					lstr_1.Height= 1300
					lstr_1.title = 'Distribucion de ot C. Estimado'
					lstr_1.tipo_cascada = 'R'						
					lstr_1.arg [1] = ''
					of_new_sheet(lstr_1)
	
				end if
				
		 CASE 'costo_real' //REALES
			
				ls_item 				= this.object.item 	  [row]
				ldc_participacion = this.object.part_arg [row]
				
				if ls_item = '01' then
					li_opcion = Messagebox('Reporte','Reporte lo Visualizara Agrupado Por Operaciones ?',Question!,YesNo!,1)
					
					if li_opcion = 1 then
						lstr_1.DataObject = 'd_abc_det_art_real_ot_tbl'	
						lstr_1.Width = 4450
						lstr_1.Height= 2000
						
					else
						lstr_1.DataObject = 'd_abc_det_art_real_ot_x_art_tbl'						
						lstr_1.Width      = 3450
						lstr_1.Height     = 2000
						lstr_1.NextCol    = 'cod_art'
						
					end if
					
//					

					
					
					IF ldc_prod_real = 0 THEN
						lstr_1.title = 'Lista de Articulos Reales '
					ELSE
						lstr_1.title = 'Lista de Articulos Reales por Producion Real de '+ls_nom_art					
					END IF


					lstr_1.tipo_cascada = 'R'
					lstr_1.arg [1] = 'AR'
					lstr_1.arg [2] = String(ldc_prod_real)
					lstr_1.arg [3] = String(ldc_participacion)
					
					of_new_sheet(lstr_1)
					
			   elseif ls_item = '02' then //SERVICIOS REALES
				   lstr_1.DataObject = 'd_abc_costo_real_x_servicio_tbl'
					lstr_1.Width = 4500
					lstr_1.Height= 1300
					lstr_1.title = 'Lista de Servicios Reales'
					lstr_1.tipo_cascada = 'R'
					lstr_1.arg [1] = 'SR'
					of_new_sheet(lstr_1)
					
				elseif ls_item = '03' then //labor
					lstr_1.DataObject = 'd_abc_costo_real_x_labor_tbl'
					lstr_1.Width = 4050
					lstr_1.Height= 1300
					lstr_1.title = 'Lista de Labores Reales'
					lstr_1.tipo_cascada = 'R'					
					lstr_1.arg [1] = 'LR'
					of_new_sheet(lstr_1)

				elseif ls_item = '04' then //trabajo por destajo
					lstr_1.DataObject = 'd_abc_ot_costo_trab_destajo_tbl'
					lstr_1.Width = 4500
					lstr_1.Height= 1300
					lstr_1.title = 'Trabajo por Destajo'
					lstr_1.tipo_cascada = 'R'						
					lstr_1.arg [1] = ''
					of_new_sheet(lstr_1)

				elseif ls_item = '05' then //herramientas
					lstr_1.DataObject = 'd_abc_ot_det_costo_herramienta_tbl'
					lstr_1.Width = 2900
					lstr_1.Height= 1300
					lstr_1.title = 'Herramientas'
					lstr_1.arg [1] = ''
					of_new_sheet(lstr_1)

				elseif ls_item = '06' then //Otros gastos
					lstr_1.DataObject = 'd_abc_ogastos_costos_tbl'
					lstr_1.Width = 1400
					lstr_1.Height= 1300
					lstr_1.title = 'Otros Gatos'
					lstr_1.arg [1] = ''
					of_new_sheet(lstr_1)


				elseif ls_item = '07' then //distribucion de ot
					lstr_1.DataObject = 'd_abc_distrib_ot_eje_tbl'
					lstr_1.Width = 1650
					lstr_1.Height= 1300
					lstr_1.title = 'Distribucion de ot C.Ejecutado'
					lstr_1.arg [1] = ''
					of_new_sheet(lstr_1)
					
					
				end if				
			
END CHOOSE


end event

event clicked;call super::clicked;idw_1 = this
This.SelectRow(0, False)
This.SelectRow(row, True)
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type dw_grf from u_dw_grf within w_ope743_costo_ot_x_producion
integer x = 2450
integer y = 184
integer width = 1682
integer height = 1260
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_costos_ot_grp"
boolean livescroll = false
end type

type gb_1 from groupbox within w_ope743_costo_ot_x_producion
integer x = 2441
integer y = 2076
integer width = 1687
integer height = 276
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 134217728
string text = "Totales Seleccionados"
end type

type dw_estructura from datawindow within w_ope743_costo_ot_x_producion
boolean visible = false
integer x = 1696
integer y = 1112
integer width = 2217
integer height = 960
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "Estructura de Orden Trabajo"
string dataobject = "d_abc_estructura_ot_tbl"
boolean controlmenu = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

