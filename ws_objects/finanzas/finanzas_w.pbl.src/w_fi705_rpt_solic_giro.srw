$PBExportHeader$w_fi705_rpt_solic_giro.srw
forward
global type w_fi705_rpt_solic_giro from w_rpt
end type
type rb_1 from radiobutton within w_fi705_rpt_solic_giro
end type
type rb_correo from radiobutton within w_fi705_rpt_solic_giro
end type
type cbx_usuario from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_crelacion from checkbox within w_fi705_rpt_solic_giro
end type
type cb_3 from commandbutton within w_fi705_rpt_solic_giro
end type
type st_usuario from statictext within w_fi705_rpt_solic_giro
end type
type em_aprob from editmask within w_fi705_rpt_solic_giro
end type
type st_3 from statictext within w_fi705_rpt_solic_giro
end type
type st_1 from statictext within w_fi705_rpt_solic_giro
end type
type sle_1 from singlelineedit within w_fi705_rpt_solic_giro
end type
type cb_2 from commandbutton within w_fi705_rpt_solic_giro
end type
type cbx_lqt from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_lqp from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_pag from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_apr from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_gen from checkbox within w_fi705_rpt_solic_giro
end type
type cbx_anu from checkbox within w_fi705_rpt_solic_giro
end type
type uo_1 from u_ingreso_rango_fechas within w_fi705_rpt_solic_giro
end type
type st_crel from statictext within w_fi705_rpt_solic_giro
end type
type cb_crel from commandbutton within w_fi705_rpt_solic_giro
end type
type st_4 from statictext within w_fi705_rpt_solic_giro
end type
type em_crel from editmask within w_fi705_rpt_solic_giro
end type
type rb_fondo_fijo from radiobutton within w_fi705_rpt_solic_giro
end type
type rb_sol_giro from radiobutton within w_fi705_rpt_solic_giro
end type
type em_origen from editmask within w_fi705_rpt_solic_giro
end type
type st_2 from statictext within w_fi705_rpt_solic_giro
end type
type dw_reporte from u_dw_rpt within w_fi705_rpt_solic_giro
end type
type cb_1 from commandbutton within w_fi705_rpt_solic_giro
end type
type gb_2 from groupbox within w_fi705_rpt_solic_giro
end type
type gb_1 from groupbox within w_fi705_rpt_solic_giro
end type
type gb_3 from groupbox within w_fi705_rpt_solic_giro
end type
end forward

global type w_fi705_rpt_solic_giro from w_rpt
integer width = 3694
integer height = 2388
string title = "Reporte Documentos Emitidos (FI705)"
string menuname = "m_reporte"
long backcolor = 67108864
rb_1 rb_1
rb_correo rb_correo
cbx_usuario cbx_usuario
cbx_crelacion cbx_crelacion
cb_3 cb_3
st_usuario st_usuario
em_aprob em_aprob
st_3 st_3
st_1 st_1
sle_1 sle_1
cb_2 cb_2
cbx_lqt cbx_lqt
cbx_lqp cbx_lqp
cbx_pag cbx_pag
cbx_apr cbx_apr
cbx_gen cbx_gen
cbx_anu cbx_anu
uo_1 uo_1
st_crel st_crel
cb_crel cb_crel
st_4 st_4
em_crel em_crel
rb_fondo_fijo rb_fondo_fijo
rb_sol_giro rb_sol_giro
em_origen em_origen
st_2 st_2
dw_reporte dw_reporte
cb_1 cb_1
gb_2 gb_2
gb_1 gb_1
gb_3 gb_3
end type
global w_fi705_rpt_solic_giro w_fi705_rpt_solic_giro

type variables

end variables

forward prototypes
public function boolean of_validacion_rpt ()
end prototypes

public function boolean of_validacion_rpt ();RETURN TRUE
end function

on w_fi705_rpt_solic_giro.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.rb_1=create rb_1
this.rb_correo=create rb_correo
this.cbx_usuario=create cbx_usuario
this.cbx_crelacion=create cbx_crelacion
this.cb_3=create cb_3
this.st_usuario=create st_usuario
this.em_aprob=create em_aprob
this.st_3=create st_3
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_2=create cb_2
this.cbx_lqt=create cbx_lqt
this.cbx_lqp=create cbx_lqp
this.cbx_pag=create cbx_pag
this.cbx_apr=create cbx_apr
this.cbx_gen=create cbx_gen
this.cbx_anu=create cbx_anu
this.uo_1=create uo_1
this.st_crel=create st_crel
this.cb_crel=create cb_crel
this.st_4=create st_4
this.em_crel=create em_crel
this.rb_fondo_fijo=create rb_fondo_fijo
this.rb_sol_giro=create rb_sol_giro
this.em_origen=create em_origen
this.st_2=create st_2
this.dw_reporte=create dw_reporte
this.cb_1=create cb_1
this.gb_2=create gb_2
this.gb_1=create gb_1
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_1
this.Control[iCurrent+2]=this.rb_correo
this.Control[iCurrent+3]=this.cbx_usuario
this.Control[iCurrent+4]=this.cbx_crelacion
this.Control[iCurrent+5]=this.cb_3
this.Control[iCurrent+6]=this.st_usuario
this.Control[iCurrent+7]=this.em_aprob
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_1
this.Control[iCurrent+11]=this.cb_2
this.Control[iCurrent+12]=this.cbx_lqt
this.Control[iCurrent+13]=this.cbx_lqp
this.Control[iCurrent+14]=this.cbx_pag
this.Control[iCurrent+15]=this.cbx_apr
this.Control[iCurrent+16]=this.cbx_gen
this.Control[iCurrent+17]=this.cbx_anu
this.Control[iCurrent+18]=this.uo_1
this.Control[iCurrent+19]=this.st_crel
this.Control[iCurrent+20]=this.cb_crel
this.Control[iCurrent+21]=this.st_4
this.Control[iCurrent+22]=this.em_crel
this.Control[iCurrent+23]=this.rb_fondo_fijo
this.Control[iCurrent+24]=this.rb_sol_giro
this.Control[iCurrent+25]=this.em_origen
this.Control[iCurrent+26]=this.st_2
this.Control[iCurrent+27]=this.dw_reporte
this.Control[iCurrent+28]=this.cb_1
this.Control[iCurrent+29]=this.gb_2
this.Control[iCurrent+30]=this.gb_1
this.Control[iCurrent+31]=this.gb_3
end on

on w_fi705_rpt_solic_giro.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_1)
destroy(this.rb_correo)
destroy(this.cbx_usuario)
destroy(this.cbx_crelacion)
destroy(this.cb_3)
destroy(this.st_usuario)
destroy(this.em_aprob)
destroy(this.st_3)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_2)
destroy(this.cbx_lqt)
destroy(this.cbx_lqp)
destroy(this.cbx_pag)
destroy(this.cbx_apr)
destroy(this.cbx_gen)
destroy(this.cbx_anu)
destroy(this.uo_1)
destroy(this.st_crel)
destroy(this.cb_crel)
destroy(this.st_4)
destroy(this.em_crel)
destroy(this.rb_fondo_fijo)
destroy(this.rb_sol_giro)
destroy(this.em_origen)
destroy(this.st_2)
destroy(this.dw_reporte)
destroy(this.cb_1)
destroy(this.gb_2)
destroy(this.gb_1)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;string ls_origen, ls_tipo,ls_usuario,ls_prov
String ls_cadena[],ls_cad_usuario[]
Date   ldt_desde, ldt_hasta
Long ll_count,ll_linea


ls_origen = Upper(em_origen.text)
ldt_desde = uo_1.of_get_fecha1()
ldt_hasta = uo_1.of_get_fecha2()



//elimina informacion temporal
delete from tt_fin_proveedor ;
delete from tt_fin_usuario	  ;


if rb_sol_giro.checked = false and rb_fondo_fijo.checked = false then
	Messagebox( "Aviso", "Debe indicar el tipo de reporte")
	return
else
   if rb_sol_giro.checked = true	then
	 ls_tipo = 'G'   
     dw_reporte.object.t_tipo.text   = 'Solicitud de Giro'
end if	 
   if rb_fondo_fijo.checked = true then
	 ls_tipo = 'F'   
     dw_reporte.object.t_tipo.text   = 'Fondo Fijo'
   end if	 
end if




if cbx_crelacion.checked then
	//todos...
	Insert into tt_fin_proveedor
	(cod_proveedor)
	select vw_fin_crelacion_x_solgiro.cod_relacion
     from vw_fin_crelacion_x_solgiro ;
	  
	IF SQLCA.SQLCode = -1 THEN 
      MessageBox('SQL error', SQLCA.SQLErrText)
		Return
	END IF
	
else
	ls_prov = Trim(em_crel.text)

	if Isnull(ls_prov) OR Trim(ls_prov) = '' then
		Messagebox('Aviso','Debe Ingresar Un Codigo de Relacion')
		Return	
	end if

	
	Insert into tt_fin_proveedor
	(cod_proveedor)
	Values
	(:ls_prov) ;
	
	IF SQLCA.SQLCode = -1 THEN 
      MessageBox('SQL error', SQLCA.SQLErrText)
		Return
	END IF

end if

ll_linea = 0

if cbx_usuario.checked then
	/*Armar Cadena de Usuarios*/
	DECLARE c_usuario CURSOR FOR  
 	select cod_usr from usuario ;
  
	OPEN c_usuario ;
	DO
	// Lee datos de cursor
	FETCH c_usuario into :ls_usuario ;
	
	IF SQLCA.SQLCODE = 100 THEN EXIT
    	ll_linea = ll_linea + 1	
	   ls_cad_usuario[ll_linea] = ls_usuario 
	  // Continua proceso
	LOOP WHILE TRUE
   CLOSE c_usuario ;
	
	ll_linea = ll_linea + 1	
	
	ls_cad_usuario [ll_linea] = 'X'
	
else
	ls_cad_usuario[1]  = trim(em_aprob.text)
	
	if Isnull(ls_usuario) OR Trim(ls_usuario) = '' then
		Messagebox('Aviso','Debe Ingresar Un Codigo de Usuario')
		Return	
	end if
	
	Insert Into tt_fin_usuario
	(cod_usr)
	Values
	(:ls_usuario) ;
	
	IF SQLCA.SQLCode = -1 THEN 
      MessageBox('SQL error', SQLCA.SQLErrText)
		Return
	END IF
	
	
end if









if cbx_anu.checked then
	ls_cadena [1] = '0'
end if	
	
if cbx_gen.checked then
	ls_cadena [upperbound(ls_cadena) + 1]= '1'
end if

if cbx_apr.checked then
	ls_cadena [upperbound(ls_cadena) + 1]= '2'
end if

if cbx_pag.checked then
	ls_cadena [upperbound(ls_cadena) + 1]= '3'
end if

if cbx_lqp.checked then
	ls_cadena [upperbound(ls_cadena) + 1]= '4'
end if

if cbx_lqt.checked then
	ls_cadena [upperbound(ls_cadena) + 1]= '5'
end if




dw_reporte.SetTransObject(SQLCA)
dw_reporte.object.p_logo.filename = gs_logo
dw_reporte.object.t_empresa.text  = gs_empresa
dw_reporte.object.t_user.text     = gs_user
dw_reporte.object.t_texto.text    = 'Del ' + string( ldt_desde, 'dd/mm/yyyy') + ' al ' + string( ldt_hasta, 'dd/mm/yyyy')

dw_reporte.retrieve( ls_origen, ldt_desde, ldt_hasta,ls_tipo,ls_cadena,ls_cad_usuario)

end event

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_reporte
idw_1.Visible = true
idw_1.SetTransObject(sqlca)

idw_1.ii_zoom_actual = 100
Event ue_preview()
//This.Event ue_retrieve()

// ii_help = 101           // help topic


end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event open;call super::open;
this.em_origen.text = gs_origen

end event

event resize;call super::resize;dw_reporte.width = newwidth - dw_reporte.x
dw_reporte.height = newheight - dw_reporte.y
end event

event ue_mail_send;String		ls_ini_file, ls_file, ls_name, ls_address, ls_subject, &
            ls_note, ls_path, ls_type, ls_format,LS_PRINT
Double	ldb_rc
n_cst_email	lnv_mail
n_cst_api	lnv_api

lnv_mail = CREATE n_cst_email
lnv_api  = CREATE n_cst_api

ls_subject = THIS.Title
ls_path = 'c:\report.'
ls_file = 'report.'

// Consulta de formato del archivo
OpenWithParm(w_saveas_opt, THIS)
ldb_rc = Message.DoubleParm
IF ldb_rc = -1 Then 	RETURN

// Creacion del Archivo
CHOOSE CASE ldb_rc
	CASE 1
		ls_type = 'html'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, HTMLTable!, True)
	CASE 2
		ls_type = 'xls'
		ls_path = ls_path + ls_type
		idw_1.SaveAs(ls_path, Excel5!, True)
	CASE 3
//		ls_type = 'pdf'
//		ls_path = ls_path + ls_type
//		idw_1.SaveAs(ls_path, PDF!, True)
		
		ls_path	= ls_path + ls_type
		ls_print = sle_1.text

		idw_1.Object.DataWindow.Export.PDF.Method = Distill!
		idw_1.Object.DataWindow.Printer           = ls_print
		idw_1.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
		idw_1.saveAs(ls_file, PDF!, true)
		
END CHOOSE




ls_address = 'titanium@cgaip.com.pe'

ls_file = ls_file + ls_type
lnv_mail.of_logon()
lnv_mail.of_send_mail(ls_name, ls_address, ls_subject, ls_note, ls_file, ls_path)
lnv_mail.of_logoff()
//lnv_api.of_file_delete(ls_path)

DESTROY lnv_mail
DESTROY lnv_api
end event

type rb_1 from radiobutton within w_fi705_rpt_solic_giro
integer x = 2327
integer y = 528
integer width = 608
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Envio Terminal"
end type

type rb_correo from radiobutton within w_fi705_rpt_solic_giro
integer x = 2327
integer y = 432
integer width = 608
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Envio Local"
boolean checked = true
end type

type cbx_usuario from checkbox within w_fi705_rpt_solic_giro
integer x = 1929
integer y = 408
integer width = 293
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217728
string text = "Todos"
end type

event clicked;IF THIS.CHECKED THEN
	em_aprob.text = ''
	st_usuario.text = ''
END IF
end event

type cbx_crelacion from checkbox within w_fi705_rpt_solic_giro
integer x = 1929
integer y = 288
integer width = 288
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217728
string text = "Todos"
end type

event clicked;IF THIS.CHECKED THEN
	em_crel.text = ''
	st_crel.text = ''
END IF
end event

type cb_3 from commandbutton within w_fi705_rpt_solic_giro
integer x = 736
integer y = 404
integer width = 87
integer height = 68
integer taborder = 80
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
lstr_seleccionar.s_sql = 'SELECT USUARIO.COD_USR AS CODIGO ,'&
									    +'USUARIO.NOMBRE AS DESCRIPCION '&
										 +'FROM USUARIO'

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	IF UpperBound(lstr_seleccionar.param1) = 1 THEN
		em_aprob.text   = lstr_seleccionar.param1[1]
		st_usuario.text = lstr_seleccionar.param2[1]
	END IF
END IF
				
end event

type st_usuario from statictext within w_fi705_rpt_solic_giro
integer x = 832
integer y = 396
integer width = 1074
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type em_aprob from editmask within w_fi705_rpt_solic_giro
integer x = 421
integer y = 388
integer width = 297
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

type st_3 from statictext within w_fi705_rpt_solic_giro
integer x = 46
integer y = 400
integer width = 334
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Aprobador :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi705_rpt_solic_giro
integer x = 3232
integer y = 300
integer width = 375
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 134217728
string text = "Print PDF"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi705_rpt_solic_giro
integer x = 3232
integer y = 380
integer width = 375
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Adobe PDF"
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_fi705_rpt_solic_giro
integer x = 3255
integer y = 176
integer width = 343
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Envio Email"
end type

event clicked;String ls_print,ls_file

if rb_correo.checked then
	Parent.triggerevent('ue_mail_send')
else
	ls_file	= 'c:\informe_tit.pdf'
	ls_print = sle_1.text

	dw_reporte.Object.DataWindow.Export.PDF.Method = Distill!
	dw_reporte.Object.DataWindow.Printer           = ls_print
	dw_reporte.Object.DataWindow.Export.PDF.Distill.CustomPostScript="Yes"
	dw_reporte.saveAs(ls_file, PDF!, true) 

	open(w_ope315_envio_email)
end if	
end event

type cbx_lqt from checkbox within w_fi705_rpt_solic_giro
integer x = 2743
integer y = 244
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Liq.Total"
boolean checked = true
end type

type cbx_lqp from checkbox within w_fi705_rpt_solic_giro
integer x = 2743
integer y = 152
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Liq. Parcial"
boolean checked = true
end type

type cbx_pag from checkbox within w_fi705_rpt_solic_giro
integer x = 2743
integer y = 64
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Pagada"
boolean checked = true
end type

type cbx_apr from checkbox within w_fi705_rpt_solic_giro
integer x = 2327
integer y = 244
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Aprobada"
boolean checked = true
end type

type cbx_gen from checkbox within w_fi705_rpt_solic_giro
integer x = 2327
integer y = 152
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Generada"
boolean checked = true
end type

type cbx_anu from checkbox within w_fi705_rpt_solic_giro
integer x = 2327
integer y = 64
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Anulado"
boolean checked = true
end type

type uo_1 from u_ingreso_rango_fechas within w_fi705_rpt_solic_giro
integer x = 96
integer y = 92
integer taborder = 60
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;//******* VALIDACION DE FECHAS **********//
uo_1.of_set_label('Desde:','Hasta:') //para setear la fecha inicial
uo_1.of_set_fecha(date('01'+'/'+string(month(today()),'00')+'/'+string(year(today()))), today()) // para seatear el titulo del boton
uo_1.of_set_rango_inicio(date('01/01/1900')) // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999')) // rango final
end event

type st_crel from statictext within w_fi705_rpt_solic_giro
integer x = 832
integer y = 288
integer width = 1074
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_crel from commandbutton within w_fi705_rpt_solic_giro
integer x = 736
integer y = 296
integer width = 87
integer height = 68
integer taborder = 50
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
lstr_seleccionar.s_sql = 'SELECT vw_fin_crelacion_x_solgiro.COD_RELACION AS CODIGO ,'&
									    +'vw_fin_crelacion_x_solgiro.NOMBRE AS DESCRIPCION '&
										 +'FROM vw_fin_crelacion_x_solgiro'

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
IF lstr_seleccionar.s_action = "aceptar" THEN
	em_crel.text = lstr_seleccionar.param1[1]
	st_crel.text = lstr_seleccionar.param2[1]
END IF

				
end event

type st_4 from statictext within w_fi705_rpt_solic_giro
integer x = 46
integer y = 304
integer width = 334
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "C. de Rel. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_crel from editmask within w_fi705_rpt_solic_giro
integer x = 421
integer y = 288
integer width = 297
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string minmax = "~~"
end type

type rb_fondo_fijo from radiobutton within w_fi705_rpt_solic_giro
integer x = 942
integer y = 544
integer width = 462
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fondo Fijo"
boolean lefttext = true
end type

type rb_sol_giro from radiobutton within w_fi705_rpt_solic_giro
integer x = 119
integer y = 544
integer width = 567
integer height = 72
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Solicitud de Giro  "
boolean lefttext = true
end type

type em_origen from editmask within w_fi705_rpt_solic_giro
integer x = 421
integer y = 196
integer width = 297
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "XX"
end type

type st_2 from statictext within w_fi705_rpt_solic_giro
integer x = 46
integer y = 208
integer width = 334
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_reporte from u_dw_rpt within w_fi705_rpt_solic_giro
integer x = 14
integer y = 672
integer width = 3589
integer height = 1344
integer taborder = 0
string dataobject = "d_rpt_solic_giro_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type cb_1 from commandbutton within w_fi705_rpt_solic_giro
integer x = 3255
integer y = 40
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Recuperar"
end type

event clicked;Event ue_retrieve()
end event

type gb_2 from groupbox within w_fi705_rpt_solic_giro
integer x = 2286
integer width = 946
integer height = 328
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Estado Doc."
end type

type gb_1 from groupbox within w_fi705_rpt_solic_giro
integer x = 14
integer width = 2235
integer height = 644
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

type gb_3 from groupbox within w_fi705_rpt_solic_giro
integer x = 2272
integer y = 352
integer width = 946
integer height = 288
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Correo"
end type

