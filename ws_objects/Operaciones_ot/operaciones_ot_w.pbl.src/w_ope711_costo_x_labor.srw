$PBExportHeader$w_ope711_costo_x_labor.srw
forward
global type w_ope711_costo_x_labor from w_report_smpl
end type
type cb_1 from commandbutton within w_ope711_costo_x_labor
end type
type uo_1 from u_ingreso_rango_fechas within w_ope711_costo_x_labor
end type
type cb_2 from commandbutton within w_ope711_costo_x_labor
end type
type sle_1 from singlelineedit within w_ope711_costo_x_labor
end type
type st_1 from statictext within w_ope711_costo_x_labor
end type
type sle_2 from singlelineedit within w_ope711_costo_x_labor
end type
type gb_1 from groupbox within w_ope711_costo_x_labor
end type
end forward

global type w_ope711_costo_x_labor from w_report_smpl
integer width = 3214
integer height = 1548
string title = "Costo x Maquina $ (OPE711)"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
cb_1 cb_1
uo_1 uo_1
cb_2 cb_2
sle_1 sle_1
st_1 st_1
sle_2 sle_2
gb_1 gb_1
end type
global w_ope711_costo_x_labor w_ope711_costo_x_labor

on w_ope711_costo_x_labor.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.cb_1=create cb_1
this.uo_1=create uo_1
this.cb_2=create cb_2
this.sle_1=create sle_1
this.st_1=create st_1
this.sle_2=create sle_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.cb_2
this.Control[iCurrent+4]=this.sle_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_2
this.Control[iCurrent+7]=this.gb_1
end on

on w_ope711_costo_x_labor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.cb_2)
destroy(this.sle_1)
destroy(this.st_1)
destroy(this.sle_2)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True
end event

type dw_report from w_report_smpl`dw_report within w_ope711_costo_x_labor
integer x = 37
integer y = 416
integer width = 3109
integer height = 896
string dataobject = "d_rpt_ope_costo_x_labor_tbl"
end type

type cb_1 from commandbutton within w_ope711_costo_x_labor
integer x = 2743
integer y = 224
integer width = 402
integer height = 112
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Date   ld_fecha_inicio,ld_fecha_final
String ls_msj_err,ls_cod_maquina,ls_desc_maq
Long   ll_count


//verificación de fechas
ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

//codigo de maquina
ls_cod_maquina	 = Trim(sle_1.text)

select count(*) into :ll_count
  from maquina 
 where (cod_maquina = :ls_cod_maquina ) ;
 
IF ll_count = 0 THEN
	Messagebox('Aviso','Codigo de Maquina No Existe ,Verifique!')
	sle_2.text = ''
	Return
ELSE
	select desc_maq into :ls_desc_maq from maquina where (cod_maquina = :ls_cod_maquina);
	
	sle_2.text = ls_desc_maq
END IF
 
 

DECLARE PB_usp_ope_rpt_costo_x_labor  PROCEDURE FOR usp_ope_rpt_costo_x_labor 
(:ld_fecha_inicio,:ld_fecha_final,:ls_cod_maquina);
EXECUTE PB_usp_ope_rpt_costo_x_labor  ;

IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	Messagebox('Error',ls_msj_err)
	Return
END IF

CLOSE PB_usp_ope_rpt_costo_x_labor ;


ib_preview = FALSE
idw_1.ii_zoom_actual = 100
Parent.Event ue_preview()

idw_1.Retrieve(ld_fecha_inicio,ld_fecha_final,ls_cod_maquina,ls_desc_maq)
Rollback ;

end event

type uo_1 from u_ingreso_rango_fechas within w_ope711_costo_x_labor
integer x = 73
integer y = 128
integer taborder = 40
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final


end event

type cb_2 from commandbutton within w_ope711_costo_x_labor
integer x = 695
integer y = 256
integer width = 110
integer height = 88
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;
str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 's'
lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO ,'&
									    +'MAQUINA.DESC_MAQ    AS DESCRIPCION_MAQUINA '&
										 +'FROM MAQUINA'

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_1.text = lstr_seleccionar.param1[1]
	sle_2.text = lstr_seleccionar.param2[1]
END IF
				
end event

type sle_1 from singlelineedit within w_ope711_costo_x_labor
event ue_enter pbm_keydown
integer x = 366
integer y = 256
integer width = 293
integer height = 88
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_enter;IF key = KeyEnter! THEN
	String ls_cod_maquina,ls_desc_maq
	Long   ll_count
	
	ls_cod_maquina = Trim(This.text)
	
	select count(*) into :ll_count from maquina where cod_maquina = :ls_cod_maquina ;
	
	IF ll_count = 0 THEN
		Messagebox('Aviso','Codigo de Maquina No Existe , Verifique!')
		sle_2.text = ''
		Return 
	ELSE
		select desc_maq into :ls_desc_maq from maquina where cod_maquina = :ls_cod_maquina ;
		
		sle_2.text = ls_desc_maq
		
	END IF
	
END IF
end event

type st_1 from statictext within w_ope711_costo_x_labor
integer x = 73
integer y = 288
integer width = 270
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Maquina :"
boolean focusrectangle = false
end type

type sle_2 from singlelineedit within w_ope711_costo_x_labor
integer x = 841
integer y = 256
integer width = 1061
integer height = 88
integer taborder = 60
boolean bringtotop = true
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

type gb_1 from groupbox within w_ope711_costo_x_labor
integer x = 37
integer y = 64
integer width = 1938
integer height = 320
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ingrese Fechas y Maquina :"
end type

