$PBExportHeader$w_fi911_imp_mas_voucher.srw
forward
global type w_fi911_imp_mas_voucher from w_prc
end type
type lb_1 from listbox within w_fi911_imp_mas_voucher
end type
type rb_terminal from radiobutton within w_fi911_imp_mas_voucher
end type
type rb_local from radiobutton within w_fi911_imp_mas_voucher
end type
type cb_2 from commandbutton within w_fi911_imp_mas_voucher
end type
type st_origen from statictext within w_fi911_imp_mas_voucher
end type
type st_3 from statictext within w_fi911_imp_mas_voucher
end type
type st_2 from statictext within w_fi911_imp_mas_voucher
end type
type st_1 from statictext within w_fi911_imp_mas_voucher
end type
type sle_3 from singlelineedit within w_fi911_imp_mas_voucher
end type
type sle_2 from singlelineedit within w_fi911_imp_mas_voucher
end type
type sle_origen from singlelineedit within w_fi911_imp_mas_voucher
end type
type cb_1 from commandbutton within w_fi911_imp_mas_voucher
end type
type gb_1 from groupbox within w_fi911_imp_mas_voucher
end type
type gb_2 from groupbox within w_fi911_imp_mas_voucher
end type
end forward

global type w_fi911_imp_mas_voucher from w_prc
integer width = 2697
integer height = 748
string title = "Impresion Masiva Voucher (FI911)"
lb_1 lb_1
rb_terminal rb_terminal
rb_local rb_local
cb_2 cb_2
st_origen st_origen
st_3 st_3
st_2 st_2
st_1 st_1
sle_3 sle_3
sle_2 sle_2
sle_origen sle_origen
cb_1 cb_1
gb_1 gb_1
gb_2 gb_2
end type
global w_fi911_imp_mas_voucher w_fi911_imp_mas_voucher

on w_fi911_imp_mas_voucher.create
int iCurrent
call super::create
this.lb_1=create lb_1
this.rb_terminal=create rb_terminal
this.rb_local=create rb_local
this.cb_2=create cb_2
this.st_origen=create st_origen
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_origen=create sle_origen
this.cb_1=create cb_1
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lb_1
this.Control[iCurrent+2]=this.rb_terminal
this.Control[iCurrent+3]=this.rb_local
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_origen
this.Control[iCurrent+6]=this.st_3
this.Control[iCurrent+7]=this.st_2
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.sle_3
this.Control[iCurrent+10]=this.sle_2
this.Control[iCurrent+11]=this.sle_origen
this.Control[iCurrent+12]=this.cb_1
this.Control[iCurrent+13]=this.gb_1
this.Control[iCurrent+14]=this.gb_2
end on

on w_fi911_imp_mas_voucher.destroy
call super::destroy
destroy(this.lb_1)
destroy(this.rb_terminal)
destroy(this.rb_local)
destroy(this.cb_2)
destroy(this.st_origen)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_origen)
destroy(this.cb_1)
destroy(this.gb_1)
destroy(this.gb_2)
end on

type lb_1 from listbox within w_fi911_imp_mas_voucher
integer x = 1243
integer y = 76
integer width = 631
integer height = 216
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"EPSON LX-300","EPSON FX-2170","EPSON FX-890","LASERJET"}
borderstyle borderstyle = stylelowered!
end type

type rb_terminal from radiobutton within w_fi911_imp_mas_voucher
integer x = 110
integer y = 176
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Terminal Server"
end type

type rb_local from radiobutton within w_fi911_imp_mas_voucher
integer x = 110
integer y = 92
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Local "
end type

type cb_2 from commandbutton within w_fi911_imp_mas_voucher
integer x = 713
integer y = 324
integer width = 96
integer height = 80
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
lstr_seleccionar.s_sql = 'SELECT ORIGEN.COD_ORIGEN AS CODIGO     ,'&
								       +'ORIGEN.NOMBRE     AS DESCRIPCION '&
								       +'FROM ORIGEN '
				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_origen.text = lstr_seleccionar.param1[1]
		st_origen.text = lstr_seleccionar.param2[1]
	END IF	
				
end event

type st_origen from statictext within w_fi911_imp_mas_voucher
integer x = 823
integer y = 324
integer width = 791
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_3 from statictext within w_fi911_imp_mas_voucher
integer x = 27
integer y = 332
integer width = 466
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi911_imp_mas_voucher
integer x = 919
integer y = 468
integer width = 439
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Registro Final :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi911_imp_mas_voucher
integer x = 27
integer y = 468
integer width = 466
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Registro Inicio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_fi911_imp_mas_voucher
integer x = 1385
integer y = 468
integer width = 343
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_fi911_imp_mas_voucher
integer x = 512
integer y = 468
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type sle_origen from singlelineedit within w_fi911_imp_mas_voucher
event ue_enter pbm_keydown
integer x = 512
integer y = 324
integer width = 187
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event ue_enter;Long   ll_count
String ls_origen,ls_desc

if key = KeyEnter! then
	ls_origen = this.text
	
	select count (*) into :ll_count from origen where cod_origen = :ls_origen ;
	
	if ll_count > 0 then
		select nombre into :ls_desc from origen
		 where cod_origen = :ls_origen ;
		
		st_origen.text = ls_desc
		
	else
		Messagebox('Aviso','Origen No Existe')
	end if
end if
end event

type cb_1 from commandbutton within w_fi911_imp_mas_voucher
integer x = 2103
integer y = 24
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Impresión"
end type

event clicked;String ls_origen,ls_flag_ts,ls_print,ls_run,ls_dir
Long   ll_reg_inicio,ll_reg_final,ll_nro_registro
n_cst_impresion lnvo_impresion
dataStore ds_data

//declaracion de objecto
lnvo_impresion = create n_cst_impresion


ls_origen     = sle_origen.text 
ll_reg_inicio = Long(sle_2.text)
ll_reg_final  = Long(sle_3.text)

//nombre de impresora
ls_print = lb_1.SelectedItem()

IF Isnull(ls_print) OR Trim(ls_prinT) = '' THEN
	Messagebox('Aviso','Debe Seleccionar Impresora')
	Return
END IF


IF rb_local.checked THEN
	ls_flag_ts = '0' 	
ELSEIF rb_terminal.checked THEN
	ls_flag_ts = '1' 
END IF

IF Isnull(ls_flag_ts) OR Trim(ls_flag_ts) = '' THEN
	Messagebox('Aviso','Debe Seleccionar tipo de Impresión')
	Return
END IF
	

/*Declaración de Cursor*/
DECLARE cheque CURSOR FOR
 select origen,nro_registro 
   from caja_bancos
  where (flag_estado   = '1'				 ) and
  		  (origen        = :ls_origen     ) and
  		  (nro_registro between :ll_reg_inicio and :ll_reg_final  ) ;
					

/*Abrir Cursor*/		  	
OPEN cheque ;
	DO	/*Recorro Cursor*/	
	 FETCH cheque INTO :ls_origen,:ll_nro_registro ;
	 IF sqlca.sqlcode = 100 THEN EXIT
	 
	 if lb_1.selecteditem( ) <> "LASERJET" then
	 	/*IMPRESION LOCAL O TERMINAL SERVER*/
   	lnvo_impresion.of_voucher ('d_rpt_fomato_chq_voucher_tbl',ls_origen,ll_nro_registro,gs_empresa,ls_flag_ts,ls_print)
	else
		ds_data = CREATE datastore
		ds_data.dataobject = "d_rpt_formato_chq_voucher_preview"
		ds_data.setTransobject( SQLCA)
		ds_data.retrieve(ls_origen,ll_nro_registro)
		ds_data.Object.p_logo.filename = gs_logo
		ds_data.print( )
		destroy ds_data
		
	end if
	 
	 
	LOOP WHILE TRUE
	
CLOSE cheque ; /*Cierra Cursor*/

destroy lnvo_impresion



end event

type gb_1 from groupbox within w_fi911_imp_mas_voucher
integer x = 50
integer y = 20
integer width = 1088
integer height = 252
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresión"
end type

type gb_2 from groupbox within w_fi911_imp_mas_voucher
integer x = 1211
integer y = 20
integer width = 699
integer height = 296
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Selecciona Impresora"
end type

