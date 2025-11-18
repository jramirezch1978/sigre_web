$PBExportHeader$w_fi912_gen_pdt_3550.srw
forward
global type w_fi912_gen_pdt_3550 from w_prc
end type
type dw_1 from datawindow within w_fi912_gen_pdt_3550
end type
type sle_3 from singlelineedit within w_fi912_gen_pdt_3550
end type
type sle_2 from singlelineedit within w_fi912_gen_pdt_3550
end type
type cb_2 from commandbutton within w_fi912_gen_pdt_3550
end type
type st_2 from statictext within w_fi912_gen_pdt_3550
end type
type st_1 from statictext within w_fi912_gen_pdt_3550
end type
type sle_1 from singlelineedit within w_fi912_gen_pdt_3550
end type
type cb_1 from commandbutton within w_fi912_gen_pdt_3550
end type
type gb_1 from groupbox within w_fi912_gen_pdt_3550
end type
end forward

global type w_fi912_gen_pdt_3550 from w_prc
integer width = 2487
integer height = 580
string title = "PDT 3550 (FI912)"
string menuname = "m_proceso_salida"
dw_1 dw_1
sle_3 sle_3
sle_2 sle_2
cb_2 cb_2
st_2 st_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
gb_1 gb_1
end type
global w_fi912_gen_pdt_3550 w_fi912_gen_pdt_3550

on w_fi912_gen_pdt_3550.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.dw_1=create dw_1
this.sle_3=create sle_3
this.sle_2=create sle_2
this.cb_2=create cb_2
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.sle_3
this.Control[iCurrent+3]=this.sle_2
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.sle_1
this.Control[iCurrent+8]=this.cb_1
this.Control[iCurrent+9]=this.gb_1
end on

on w_fi912_gen_pdt_3550.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_1)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.cb_2)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
destroy(this.gb_1)
end on

type dw_1 from datawindow within w_fi912_gen_pdt_3550
boolean visible = false
integer x = 613
integer y = 740
integer width = 686
integer height = 400
integer taborder = 50
string dataobject = "d_abc_pdt_3550_tbl"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;Settransobject(sqlca)
end event

type sle_3 from singlelineedit within w_fi912_gen_pdt_3550
integer x = 361
integer y = 228
integer width = 402
integer height = 88
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_fi912_gen_pdt_3550
integer x = 896
integer y = 228
integer width = 1458
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 65535
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_fi912_gen_pdt_3550
integer x = 782
integer y = 232
integer width = 96
integer height = 88
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT EMPRESA.COD_EMPRESA AS CODIGO , '&
				   					 +'EMPRESA.NOMBRE AS DESCRIPCION,'&
                               +'EMPRESA.RUC AS NRO_RUC '				   &
	 				   				 +'FROM EMPRESA '&
										

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_3.text = lstr_seleccionar.param1[1]
		sle_2.text = lstr_seleccionar.param2[1]

	END IF
end event

type st_2 from statictext within w_fi912_gen_pdt_3550
integer x = 73
integer y = 244
integer width = 261
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Empresa :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_fi912_gen_pdt_3550
integer x = 73
integer y = 116
integer width = 261
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Periodo :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi912_gen_pdt_3550
integer x = 357
integer y = 104
integer width = 320
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_fi912_gen_pdt_3550
integer x = 832
integer y = 88
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long    ll_periodo
String  ls_empresa, ls_nomb_arch, ls_path, ls_mensaje
Integer li_filenum

try 
	
	ll_periodo = Long(sle_1.text)
	ls_empresa = sle_3.text
	
	if ll_periodo <= 0 or Isnull(ll_periodo) then
		Messagebox('Aviso','Debe Ingresar Periodo a Procesar', StopSign!)
		Return
	end if
	
	if Isnull(ls_empresa) or Trim(ls_empresa) = '' then
		Messagebox('Aviso','Debe Ingresar Alguna Empresa', StopSign!)
		Return
	end if	
	
	
	
	//ejecuta proceso
	
	DECLARE USP_FIN_PDT3550 PROCEDURE FOR 
		USP_FIN_PDT3550(:ll_periodo);
		
	EXECUTE USP_FIN_PDT3550 ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox("Error", "Error al ejecutar el procedimiento USP_FIN_PDT3550. Mensaje : " &
							+ ls_mensaje, StopSign!)
	END IF
	
	close USP_FIN_PDT3550;
	
	dw_1.Retrieve()
	
	
	
	//grabar archivo texto
	
	//ls_path='/' //NOMBRE DE DIRECTORIO
	ls_path = gnvo_app.of_get_parametro("PATH_SIGRE_PDB", 'i:\SIGRE_EXE\PDT3550\')
	
	ls_nomb_arch = ls_path + 'C' + gnvo_app.empresa.is_ruc + Trim(String(ll_periodo)) + '.txt'
	
	If not DirectoryExists ( ls_path ) Then
	
		//CREACION DE CARPETA
		CreateDirectory ( ls_path )
	
		li_filenum = ChangeDirectory( ls_path )
		
		if li_filenum = -1 then
			Messagebox('Aviso','Fallo Creacion de Directorio Directorio para PDT3550. Path: ' + ls_path, StopSign!)
			RETURN
		end if	
	
	End If
	
	
	
	dw_1.SaveAs(ls_nomb_arch, TEXT!, FALSE)
	
	
	Messagebox('Aviso','Se Genero Archivo PDT 3550. Archivo: '+ls_nomb_arch)

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, 'Error al procesar PDT3550')
	
finally
	/*statementBlock*/
end try


end event

type gb_1 from groupbox within w_fi912_gen_pdt_3550
integer x = 37
integer y = 28
integer width = 2363
integer height = 340
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "PDT 3550"
end type

