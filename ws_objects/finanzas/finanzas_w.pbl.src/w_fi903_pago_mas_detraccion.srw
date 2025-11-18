$PBExportHeader$w_fi903_pago_mas_detraccion.srw
forward
global type w_fi903_pago_mas_detraccion from w_prc
end type
type rb_medio from radiobutton within w_fi903_pago_mas_detraccion
end type
type rb_internet from radiobutton within w_fi903_pago_mas_detraccion
end type
type cbx_1 from checkbox within w_fi903_pago_mas_detraccion
end type
type sle_envio from singlelineedit within w_fi903_pago_mas_detraccion
end type
type st_1 from statictext within w_fi903_pago_mas_detraccion
end type
type sle_5 from singlelineedit within w_fi903_pago_mas_detraccion
end type
type cb_4 from commandbutton within w_fi903_pago_mas_detraccion
end type
type dw_1 from datawindow within w_fi903_pago_mas_detraccion
end type
type sle_obs from singlelineedit within w_fi903_pago_mas_detraccion
end type
type st_3 from statictext within w_fi903_pago_mas_detraccion
end type
type st_2 from statictext within w_fi903_pago_mas_detraccion
end type
type sle_3 from singlelineedit within w_fi903_pago_mas_detraccion
end type
type sle_2 from singlelineedit within w_fi903_pago_mas_detraccion
end type
type sle_1 from singlelineedit within w_fi903_pago_mas_detraccion
end type
type cb_3 from commandbutton within w_fi903_pago_mas_detraccion
end type
type cb_2 from commandbutton within w_fi903_pago_mas_detraccion
end type
type cb_1 from commandbutton within w_fi903_pago_mas_detraccion
end type
end forward

global type w_fi903_pago_mas_detraccion from w_prc
integer width = 3488
integer height = 2016
string title = "[FI903] Pago Masivo Detracción"
string menuname = "m_proceso_salida"
rb_medio rb_medio
rb_internet rb_internet
cbx_1 cbx_1
sle_envio sle_envio
st_1 st_1
sle_5 sle_5
cb_4 cb_4
dw_1 dw_1
sle_obs sle_obs
st_3 st_3
st_2 st_2
sle_3 sle_3
sle_2 sle_2
sle_1 sle_1
cb_3 cb_3
cb_2 cb_2
cb_1 cb_1
end type
global w_fi903_pago_mas_detraccion w_fi903_pago_mas_detraccion

forward prototypes
public subroutine of_delete (string as_archivo)
end prototypes

public subroutine of_delete (string as_archivo); FileDelete(as_archivo)
end subroutine

on w_fi903_pago_mas_detraccion.create
int iCurrent
call super::create
if this.MenuName = "m_proceso_salida" then this.MenuID = create m_proceso_salida
this.rb_medio=create rb_medio
this.rb_internet=create rb_internet
this.cbx_1=create cbx_1
this.sle_envio=create sle_envio
this.st_1=create st_1
this.sle_5=create sle_5
this.cb_4=create cb_4
this.dw_1=create dw_1
this.sle_obs=create sle_obs
this.st_3=create st_3
this.st_2=create st_2
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_1=create sle_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_medio
this.Control[iCurrent+2]=this.rb_internet
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.sle_envio
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.sle_5
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.dw_1
this.Control[iCurrent+9]=this.sle_obs
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.sle_3
this.Control[iCurrent+13]=this.sle_2
this.Control[iCurrent+14]=this.sle_1
this.Control[iCurrent+15]=this.cb_3
this.Control[iCurrent+16]=this.cb_2
this.Control[iCurrent+17]=this.cb_1
end on

on w_fi903_pago_mas_detraccion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_medio)
destroy(this.rb_internet)
destroy(this.cbx_1)
destroy(this.sle_envio)
destroy(this.st_1)
destroy(this.sle_5)
destroy(this.cb_4)
destroy(this.dw_1)
destroy(this.sle_obs)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event resize;call super::resize;dw_1.width  = newwidth  - dw_1.x - 10
dw_1.height = newheight - dw_1.y - 10
end event

event open;call super::open;
end event

type rb_medio from radiobutton within w_fi903_pago_mas_detraccion
integer x = 782
integer y = 436
integer width = 1065
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Envio Por Medio Magnetico (Diskette)"
boolean checked = true
end type

type rb_internet from radiobutton within w_fi903_pago_mas_detraccion
integer x = 32
integer y = 436
integer width = 704
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Envio por Internet"
end type

type cbx_1 from checkbox within w_fi903_pago_mas_detraccion
integer x = 1426
integer y = 336
integer width = 416
integer height = 72
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Busca Envio "
boolean lefttext = true
end type

event clicked;if cbx_1.checked then
	sle_envio.enabled = TRUE
else
	sle_envio.enabled = FALSE
end if
end event

type sle_envio from singlelineedit within w_fi903_pago_mas_detraccion
integer x = 425
integer y = 324
integer width = 343
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15793151
boolean enabled = false
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_fi903_pago_mas_detraccion
integer x = 137
integer y = 332
integer width = 279
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Envio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_5 from singlelineedit within w_fi903_pago_mas_detraccion
integer x = 425
integer y = 232
integer width = 2405
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_fi903_pago_mas_detraccion
integer x = 1367
integer y = 144
integer width = 475
integer height = 88
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Grabar Archivo"
end type

event clicked;String ls_archivo,ls_ruc,ls_empresa,ls_ano,ls_envio,ls_extension, ls_path, ls_file
Integer li_ret, li_filenum


ls_ano = string(gnvo_app.of_fecha_Actual(), 'yy')
ls_empresa = trim(sle_3.text)
ls_envio	  = f_llena_caracteres('0',trim(sle_envio.text),4)


//*RECUPERA NRO DE RUC DE EMPRESA*//
select Trim(substr(ruc,1,11)) into :ls_ruc from empresa where cod_empresa = :ls_empresa ;

if Isnull(ls_ruc) then ls_ruc = ''

if Trim(ls_envio) = '' or Isnull(ls_envio) then
	Messagebox('Aviso','No Tiene Nro de Envio,Verifique!')
	Return
end if

if ls_ruc = ''  then
	Messagebox('Aviso','Empresa No tiene RUC ,Verifique!')
	Return
end if


IF rb_internet.checked then
	ls_extension = '.TXT'
ELSEIF rb_medio.checked then
   ls_extension = '.txt'
end if


ls_path = "i:\SIGRE_EXE\TXT\"
ls_file = "D" + ls_ruc + ls_ano + ls_envio + ls_extension



If not DirectoryExists ( ls_path ) Then
	//CREACION DE CARPETA
	CreateDirectory ( ls_path )

	li_filenum = ChangeDirectory( ls_path )

	if li_filenum = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio para Detraccion: ' + ls_path)
		RETURN
	end if	

End If

ls_archivo = ls_path + ls_file

if FileExists(ls_archivo) then
	if MessageBox('Error', 'Desea Eliminar el archivo ' + ls_archivo, Information!, YesNo!, 2) = 2 then return
	FileDelete(ls_archivo)	
end if

if dw_1.SaveAs(ls_archivo,TEXT!, FALSE) = -1 then
	Messagebox('Error',"A ocurrido un error al momento de generar el archivo de texto: " + +ls_archivo, StopSign!)
else
	Messagebox('Aviso',"Se Genero el Archivo " + ls_archivo + "satifactoriamente.", Information!)
end if


end event

type dw_1 from datawindow within w_fi903_pago_mas_detraccion
integer y = 616
integer width = 1824
integer height = 1088
integer taborder = 80
string title = "none"
string dataobject = "d_detraccion"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;settransobject(sqlca)

end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event clicked;if row = 0 then return
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)

end event

type sle_obs from singlelineedit within w_fi903_pago_mas_detraccion
integer y = 524
integer width = 1819
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 15793151
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_fi903_pago_mas_detraccion
integer x = 5
integer y = 52
integer width = 411
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Reg. Tesoreria :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_fi903_pago_mas_detraccion
integer x = 137
integer y = 148
integer width = 279
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

type sle_3 from singlelineedit within w_fi903_pago_mas_detraccion
integer x = 425
integer y = 136
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
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

type sle_2 from singlelineedit within w_fi903_pago_mas_detraccion
integer x = 626
integer y = 40
integer width = 343
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_1 from singlelineedit within w_fi903_pago_mas_detraccion
integer x = 425
integer y = 40
integer width = 178
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_3 from commandbutton within w_fi903_pago_mas_detraccion
integer x = 1367
integer y = 36
integer width = 475
integer height = 88
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;String 	ls_cod_origen,ls_empresa,ls_nro_envio, ls_opcion, &
			ls_mensaje, ls_nro_registro
Long   	ll_nro_envio,ll_count


ls_cod_origen   = sle_1.text
ls_nro_registro = trim(sle_2.text)
ls_empresa		 = sle_3.text

if rb_internet.checked then
	ls_opcion = '1'
elseif rb_medio.checked then
	ls_opcion = '2'
end if


//LIMPIAR DW
dw_1.reset()


IF Isnull(ls_cod_origen) OR Trim(ls_cod_origen) = '' THEN
	Messagebox('Aviso','Debe Colocar Origen')
	Return
END IF

IF Isnull(ls_empresa) OR Trim(ls_empresa) = '' THEN
	Messagebox('Aviso','Debe Colocar Empresa')
	Return
END IF



IF Isnull(ls_nro_registro) THEN
	Messagebox('Aviso','Debe Ingresar Nro de Registro')
	Return
END IF



sle_obs.text   = ''
//elimina informacion
delete from tt_fin_exp_file ;

if gnvo_app.of_existserror(SQLCA, 'DELETE tt_fin_exp_file') then
	rollback;
	return
end if

/*GENERA NRO DE ENVIO*/
IF cbx_1.Checked = FALSE THEN
	//verifica existe documentos detraccion
	select count(*) 
	  into :ll_count
     from caja_bancos 		cb,
	  		 caja_bancos_det 	cbd
    where cb.origen			= cbd.origen
	   and cb.nro_registro	= cbd.nro_registro
	   and cb.origen       	= :ls_cod_origen   
	   and instr(:ls_nro_registro, trim(to_char(cbd.nro_registro))) > 0
		and cbd.tipo_doc	  in ('DTRP', 'DTRC') 
		and cb.flag_estado	<> '0';
			 
	if ll_count = 0 then
		Messagebox('Aviso','El registro indicado no esta activo, no existe o no Existen Detracciones para Enviar ,Verifique!...')
		Return
	end if


	//VERIFICACION QUE DETRACCION NO HA SIDO ENVIADA...
	select count(*)
		into :ll_count
	from (
		select distinct cbd.COD_RELACION, cbd.TIPO_DOC, cbd.NRO_DOC
		 from detraccion_envio 	de,
				caja_bancos_det	cbd
		where de.cod_origen 		= cbd.origen
		  and de.cod_relacion	= cbd.cod_relacion
		  and de.tipo_doc			= cbd.tipo_doc
		  and de.nro_doc			= cbd.nro_doc
		  and cbd.origen			= :ls_cod_origen
		  and instr(:ls_nro_registro, trim(to_char(cbd.nro_registro))) > 0
	);
	
	IF ll_count > 0 THEN
		if Messagebox('Aviso',"Se han detectado " + string(ll_count) + " Documentos que ya han sido considerados en otro Envio, desea otro reproceso?", Information!, Yesno!, 2) = 2 then return
	END IF
	
	//genera correlativo de envio
	select ult_nro 
		into :ll_nro_envio 
	from num_detraccion_envio 
	where reckey = '1' for update ;
	
	ls_nro_envio = f_llena_caracteres('0',Trim(String(ll_nro_envio)),4)

	update num_detraccion_envio 
		set ult_nro = :ll_nro_envio + 1 
	where reckey = '1' ;
	
	
	//inserta registros para enviar
	Insert Into detraccion_envio(NRO_ENVIO, COD_ORIGEN, COD_RELACION, TIPO_DOC, NRO_DOC, ITEM  )
	select distinct :ls_nro_envio, origen, cod_relacion, tipo_doc, nro_doc, rownum
     from caja_bancos_det 
 	 where origen       = :ls_cod_origen   
	   and instr(:ls_nro_registro, trim(to_char(nro_registro))) > 0
		and tipo_doc	  in ('DTRP', 'DTRC');  

	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = "Error al insertar en detracción envío: " &
						+ SQLCA.SQLErrText	
		Rollback ;
	   MessageBox('SQL error', ls_mensaje)
		Return
	end if
	
	COMMIT ;
	

	sle_envio.text = ls_nro_envio
	sle_obs.text   = 'Se proceso Envio Nº '+Trim(ls_nro_envio)
	
ELSE
	ls_nro_envio = Trim(sle_envio.text)
END IF


IF Isnull(ls_nro_envio) OR Trim(ls_nro_envio) = '' THEN
	Messagebox('Aviso','Debe Colocar Nro de Envio')
	Return
END IF



DECLARE usp_fin_gen_arch_txt_detrac PROCEDURE FOR 
	usp_fin_gen_arch_txt_detrac(:ls_cod_origen ,
									    :ls_nro_registro ,
										 :ls_empresa ,
										 :ls_nro_envio,
										 :ls_opcion );
EXECUTE usp_fin_gen_arch_txt_detrac ;



IF SQLCA.SQLCode = -1 THEN 
	ls_mensaje = "Error en procedimiento usp_fin_gen_arch_txt_detrac: " &
				  + SQLCA.SQLErrText
	ROLLBACK;
	MessageBox("SQL error", ls_mensaje)
	return
END IF


CLOSE usp_fin_gen_arch_txt_detrac ;

commit;

/*recuperar nro de envio*/
dw_1.retrieve()


end event

type cb_2 from commandbutton within w_fi903_pago_mas_detraccion
integer x = 1019
integer y = 140
integer width = 128
integer height = 76
integer taborder = 40
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
lstr_seleccionar.s_sql = 'SELECT EMPRESA.COD_EMPRESA AS CODIGO      ,'&
										 +'EMPRESA.NOMBRE  	  AS DESCRIPCION ,'&
										 +'EMPRESA.RUC			  AS RUC        '&
								  +'FROM EMPRESA '

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
				
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		sle_3.text = lstr_seleccionar.param1  [1]
		sle_5.text = mid(lstr_seleccionar.param2  [1],1,50)
	END IF


end event

type cb_1 from commandbutton within w_fi903_pago_mas_detraccion
integer x = 1019
integer y = 44
integer width = 128
integer height = 76
integer taborder = 90
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;String ls_sql, ls_codigo, ls_data

ls_sql ='SELECT distinct CB.ORIGEN        AS CODIGO_ORIGEN ,'&
		 + 'CB.NRO_REGISTRO  AS NRO_CAJA	    ,'&
		 + 'CB.FECHA_EMISION AS FECHA_CAJA	  '&
		 +'FROM CAJA_BANCOS CB, ' &
		 + "CAJA_BANCOS_DET CBD " &
		 + "WHERE CB.NRO_REGISTRO = CBD.NRO_REGISTRO " &
		 + "  AND CB.FLAG_ESTADO <> '0'" &
		 + "  AND CBD.TIPO_DOC   in ('DTRP', 'DTRC') " &
		 + "order by cb.fecha_emision desc"
				 
f_lista(ls_sql, ls_codigo, ls_data, "1")
		
if ls_codigo <> "" then
	sle_1.text = ls_codigo
	sle_2.text = ls_data
end if
			

end event

