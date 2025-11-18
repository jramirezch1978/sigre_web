$PBExportHeader$w_fi907_pdb.srw
forward
global type w_fi907_pdb from w_prc
end type
type cb_export_xls from commandbutton within w_fi907_pdb
end type
type rb_5 from radiobutton within w_fi907_pdb
end type
type rb_4 from radiobutton within w_fi907_pdb
end type
type rb_1 from radiobutton within w_fi907_pdb
end type
type cb_1 from commandbutton within w_fi907_pdb
end type
type cb_2 from commandbutton within w_fi907_pdb
end type
type st_3 from statictext within w_fi907_pdb
end type
type sle_1 from singlelineedit within w_fi907_pdb
end type
type dw_1 from u_dw_cns within w_fi907_pdb
end type
type st_1 from statictext within w_fi907_pdb
end type
type st_2 from statictext within w_fi907_pdb
end type
type rb_cntas_pagar from radiobutton within w_fi907_pdb
end type
type rb_3 from radiobutton within w_fi907_pdb
end type
type em_ano from editmask within w_fi907_pdb
end type
type ddlb_mes from dropdownlistbox within w_fi907_pdb
end type
type gb_1 from groupbox within w_fi907_pdb
end type
end forward

global type w_fi907_pdb from w_prc
integer width = 4251
integer height = 2136
string title = "Generacion de PDB (FI907)"
string menuname = "m_proceso_salida"
cb_export_xls cb_export_xls
rb_5 rb_5
rb_4 rb_4
rb_1 rb_1
cb_1 cb_1
cb_2 cb_2
st_3 st_3
sle_1 sle_1
dw_1 dw_1
st_1 st_1
st_2 st_2
rb_cntas_pagar rb_cntas_pagar
rb_3 rb_3
em_ano em_ano
ddlb_mes ddlb_mes
gb_1 gb_1
end type
global w_fi907_pdb w_fi907_pdb

type variables
u_ds_base  ids_export
end variables

event open;call super::open;dw_1.settransobject(sqlca)

cb_2.enabled = FALSE

ids_export = create u_ds_base
ids_export.dataobject = 'd_xls_forma_pago_tbl'
ids_export.settransobject( SQLCA )
end event

on w_fi907_pdb.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.cb_export_xls=create cb_export_xls
this.rb_5=create rb_5
this.rb_4=create rb_4
this.rb_1=create rb_1
this.cb_1=create cb_1
this.cb_2=create cb_2
this.st_3=create st_3
this.sle_1=create sle_1
this.dw_1=create dw_1
this.st_1=create st_1
this.st_2=create st_2
this.rb_cntas_pagar=create rb_cntas_pagar
this.rb_3=create rb_3
this.em_ano=create em_ano
this.ddlb_mes=create ddlb_mes
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_export_xls
this.Control[iCurrent+2]=this.rb_5
this.Control[iCurrent+3]=this.rb_4
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.cb_1
this.Control[iCurrent+6]=this.cb_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_1
this.Control[iCurrent+9]=this.dw_1
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.rb_cntas_pagar
this.Control[iCurrent+13]=this.rb_3
this.Control[iCurrent+14]=this.em_ano
this.Control[iCurrent+15]=this.ddlb_mes
this.Control[iCurrent+16]=this.gb_1
end on

on w_fi907_pdb.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_export_xls)
destroy(this.rb_5)
destroy(this.rb_4)
destroy(this.rb_1)
destroy(this.cb_1)
destroy(this.cb_2)
destroy(this.st_3)
destroy(this.sle_1)
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.rb_cntas_pagar)
destroy(this.rb_3)
destroy(this.em_ano)
destroy(this.ddlb_mes)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_1.width  = newwidth - dw_1.x
dw_1.height = newheight - dw_1.y
end event

event close;call super::close;destroy ids_export
end event

type cb_export_xls from commandbutton within w_fi907_pdb
integer x = 3456
integer y = 28
integer width = 421
integer height = 112
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Excel"
end type

event clicked;String  ls_nomb_arch ,ls_path,ls_ruc,ls_ano,ls_mes
Integer li_filenum


select ruc into :ls_ruc from empresa e where e.cod_empresa = (select cod_empresa from genparam where reckey = '1') ;

ls_ano = trim(em_ano.text)
ls_mes = trim(LEFT(ddlb_mes.text,2))
ls_path='\sigre_exe\PDB' //NOMBRE DE DIRECTORIO

if rb_5.checked then
	ls_nomb_arch = 'F'+ls_ruc+ls_ano+ls_mes+'.xls'
else
	return
end if

//Sino existe el directorio entoces lo creo sin problemas
If not DirectoryExists ( ls_path ) Then
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio PDB')
		RETURN
	end if	

End If



if dw_1.SaveAs(ls_path+ "\"+ls_nomb_arch,Excel!, TRUE) = -1 then
	Messagebox('Error','A ocurrido un error al momento de generar el archivo de texto. Nombre del Archivo PDB: '+ls_path + "\" + ls_nomb_arch, StopSign!)
else
	Messagebox('Aviso','Se Genero Archivo EXCEL satifactoriamente. Nombre del Archivo: '+ls_path + "\" + ls_nomb_arch, Information!)
end if



end event

type rb_5 from radiobutton within w_fi907_pdb
integer x = 3305
integer y = 236
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formas de Pago"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	cb_Export_xls.enabled = false
	dw_1.reset()
end if
	
end event

type rb_4 from radiobutton within w_fi907_pdb
integer x = 2752
integer y = 240
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia DUA"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	cb_Export_xls.enabled = false
	dw_1.reset()
end if
	
end event

type rb_1 from radiobutton within w_fi907_pdb
integer x = 1787
integer y = 244
integer width = 960
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia Comprobante de Ventas"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	cb_Export_xls.enabled = false
	dw_1.reset()
end if
	
end event

type cb_1 from commandbutton within w_fi907_pdb
integer x = 2464
integer y = 32
integer width = 402
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String ls_msj_err,ls_cadena
Long   ll_ano ,ll_mes,ll_count


//LIMPIAR DW
dw_1.reset()
sle_1.text = '0'


ll_ano = long(trim(em_ano.text))
ll_mes = long(trim(LEFT(ddlb_mes.text,2)))

ls_cadena = trim(em_ano.text)+trim(LEFT(ddlb_mes.text,2))

if Isnull(ll_ano) or ll_ano = 0 then
	Messagebox('Aviso','Debe Ingresar algun Año Valido ,Verifique!')
	Return
end if

if Isnull(ll_mes) or ll_mes = 0 then
	Messagebox('Aviso','Debe Ingresar algun Mes Valido ,Verifique!')
	Return
end if

if rb_5.checked then
	dw_1.dataobject = 'd_pdb_forma_pago_tbl'
	dw_1.SetTransObject(SQLCA)
else
	dw_1.dataobject = 'd_abc_coa_tbl'
	dw_1.SetTransObject(SQLCA)
end if


IF rb_cntas_pagar.checked then
	
	DECLARE USP_FIN_PDB PROCEDURE FOR 
		USP_FIN_PDB	(:ll_ano, :ll_mes);
		
	EXECUTE USP_FIN_PDB ;

	IF SQLCA.SQLCode = -1 THEN
   	ls_msj_err = SQLCA.SQLErrText
		ROLLBACK;
	   MessageBox('ERROR SQL', 'Ha ocurrido un error al ejecutar el procedimiento USP_FIN_PDB: ' + ls_msj_err, StopSign!)
		return
	END IF

	CLOSE USP_FIN_PDB ;
	
	
	
ELSEIF rb_3.checked then

	DECLARE PB_USP_FIN_PDB_TCAMBIO PROCEDURE FOR USP_FIN_PDB_TCAMBIO
	(:ls_cadena);
	EXECUTE PB_USP_FIN_PDB_TCAMBIO ;

	IF SQLCA.SQLCode = -1 THEN
   	ls_msj_err = SQLCA.SQLErrText
	   MessageBox('SQL error', ls_msj_err)
	END IF

	CLOSE PB_USP_FIN_PDB_TCAMBIO ;	

ELSEIF rb_1.checked THEN
	
	DECLARE USP_FIN_PDB_VENTA PROCEDURE FOR 
		USP_FIN_PDB_VENTA(:ll_ano, :ll_mes);
		
	EXECUTE USP_FIN_PDB_VENTA ;
	
	IF SQLCA.SQLCode = -1 THEN
		ls_msj_err = SQLCA.SQLErrText
		rollback;
		MessageBox('SQL error', "Error al ejecutar el procedure USP_FIN_PDB_VENTA: " + ls_msj_err)
	END IF
	
	CLOSE USP_FIN_PDB_VENTA ;

ELSEIF rb_4.checked THEN
	
	DECLARE USP_FIN_PDB_DUA PROCEDURE FOR 
		USP_FIN_PDB_DUA(:ll_ano, :ll_mes);
		
	EXECUTE USP_FIN_PDB_DUA ;

	IF SQLCA.SQLCode = -1 THEN
   	ls_msj_err = SQLCA.SQLErrText
		rollback;
	   MessageBox('SQL error', "Error al ejecutar el procedimiento USP_FIN_PDB_DUA: " + ls_msj_err)
		return
	END IF

	CLOSE USP_FIN_PDB_DUA ;
	
ELSEIF rb_5.checked THEN
	
	dw_1.Retrieve(ll_ano, ll_mes)
	ids_export.Retrieve(ll_ano, ll_mes)
	
END IF	

if not rb_5.checked then
	dw_1.retrieve()
end if

if dw_1.RowCount( ) > 0 then
	cb_2.enabled = true
	if rb_5.checked then
		cb_export_xls.enabled = true
	end if
else
	cb_2.enabled = false
	cb_export_xls.enabled = false
end if



ll_count = dw_1.rowcount()
sle_1.text = Trim(String(ll_count))
cb_2.enabled = TRUE
end event

type cb_2 from commandbutton within w_fi907_pdb
integer x = 2875
integer y = 32
integer width = 571
integer height = 112
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Genera Archivo TXT"
end type

event clicked;String  ls_nomb_arch ,ls_path,ls_ruc,ls_ano,ls_mes
Integer li_filenum

try 
	ls_ruc = gnvo_app.empresa.is_ruc
	
	ls_ano = trim(em_ano.text)
	ls_mes = trim(LEFT(ddlb_mes.text,2))
	//ls_path='i:\sigre_exe\PDB' //NOMBRE DE DIRECTORIO
	
	//NOMBRE DE DIRECTORIO
	ls_path = gnvo_app.of_get_parametro("PATH_SIGRE_PDB", 'i:\SIGRE_EXE\PDB\')
	
	if rb_cntas_pagar.checked then
		ls_nomb_arch = 'C'+ls_ruc+ls_ano+ls_mes+'.txt'
	elseif rb_3.checked then
		ls_nomb_arch = ls_ruc+'.tc'
	elseif rb_1.checked then
		ls_nomb_arch = 'V'+ls_ruc+ls_ano+ls_mes+'.txt'
	elseif rb_4.checked then
		ls_nomb_arch = ls_ruc+ls_ano+ls_mes+'.dua'
	elseif rb_5.checked then
		ls_nomb_arch = 'F'+ls_ruc+ls_ano+ls_mes+'.txt'
	end if
	
	//Sino existe el directorio entoces lo creo sin problemas
	If not DirectoryExists ( ls_path ) Then
		//CREACION DE CARPETA
		if gnvo_app.utilitario.of_CreateDirectory ( ls_path ) then
	
			li_filenum = ChangeDirectory( ls_path )
		
			if li_filenum = -1 then
				Messagebox('Aviso','No se puede hacer un cambio al directorio ' + ls_path, StopSign!)
				RETURN
			end if	
		end if	
	End If
	
	if right(ls_path, 1) = "\" then
		ls_path = mid(ls_path, 1, len(ls_path) - 1)
	end if
	
	
	
	if dw_1.SaveAs(ls_path+ "\"+ls_nomb_arch,TEXT!, FALSE) = -1 then
		Messagebox('Error','A ocurrido un error al momento de generar el archivo de texto. Nombre del Archivo PDB: '+ls_path + "\" + ls_nomb_arch, StopSign!)
	else
		Messagebox('Aviso','Se Genero Archivo PDB satifactoriamente. Nombre del Archivo PDB: '+ls_path + "\" + ls_nomb_arch, Information!)
	end if



catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al procesar PDB')
	
finally
	/*statementBlock*/
end try


end event

type st_3 from statictext within w_fi907_pdb
integer x = 1422
integer y = 60
integer width = 526
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Total de Registros :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_fi907_pdb
integer x = 1970
integer y = 48
integer width = 370
integer height = 80
integer taborder = 70
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

type dw_1 from u_dw_cns within w_fi907_pdb
integer y = 348
integer width = 3803
integer height = 1272
integer taborder = 40
string dataobject = "d_abc_coa_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor; is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


 ii_ck[1] = 1         // columnas de lectrua de este dw

	
end event

type st_1 from statictext within w_fi907_pdb
integer y = 64
integer width = 215
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi907_pdb
integer x = 562
integer y = 72
integer width = 224
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
alignment alignment = right!
boolean focusrectangle = false
end type

type rb_cntas_pagar from radiobutton within w_fi907_pdb
integer x = 46
integer y = 240
integer width = 910
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia Comprobante de Pago"
boolean checked = true
end type

event clicked;if this.checked then
	cb_2.enabled = false
	cb_Export_xls.enabled = false
	dw_1.reset()
end if
	
end event

type rb_3 from radiobutton within w_fi907_pdb
integer x = 960
integer y = 240
integer width = 823
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia de Tipo de Cambio"
end type

event clicked;if this.checked then
	cb_2.enabled = false
	cb_Export_xls.enabled = false
	dw_1.reset()
end if
	
end event

type em_ano from editmask within w_fi907_pdb
integer x = 233
integer y = 60
integer width = 174
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "yyyy"
end type

type ddlb_mes from dropdownlistbox within w_fi907_pdb
integer x = 823
integer y = 52
integer width = 517
integer height = 856
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
string item[] = {"01 - Enero","02 - Febrero","03 - Marzo","04 - Abril","05 - Mayo","06 - Junio","07 - Julio","08 - Agosto","09 - Setiembre","10 - Octubre","11 - Noviembre","12 - Diciembre"}
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_fi907_pdb
integer x = 5
integer y = 172
integer width = 3886
integer height = 164
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Transferencia a PDB"
end type

