$PBExportHeader$w_lectura_masiva.srw
forward
global type w_lectura_masiva from w_abc
end type
type rb_general from radiobutton within w_lectura_masiva
end type
type rb_parvitrina from radiobutton within w_lectura_masiva
end type
type rb_vitrina from radiobutton within w_lectura_masiva
end type
type st_tipo_lectura from statictext within w_lectura_masiva
end type
type st_fecha from statictext within w_lectura_masiva
end type
type st_conteo from statictext within w_lectura_masiva
end type
type st_almacen from statictext within w_lectura_masiva
end type
type st_cu from singlelineedit within w_lectura_masiva
end type
type st_5 from statictext within w_lectura_masiva
end type
type p_foto from picture within w_lectura_masiva
end type
type st_total from statictext within w_lectura_masiva
end type
type pb_fltro from picturebutton within w_lectura_masiva
end type
type st_2 from statictext within w_lectura_masiva
end type
type sle_ubicacion from singlelineedit within w_lectura_masiva
end type
type sle_codigo from singlelineedit within w_lectura_masiva
end type
type st_1 from statictext within w_lectura_masiva
end type
type cb_1 from commandbutton within w_lectura_masiva
end type
type cb_aceptar from commandbutton within w_lectura_masiva
end type
type cb_2 from commandbutton within w_lectura_masiva
end type
type gb_1 from groupbox within w_lectura_masiva
end type
type st_descripcion from multilineedit within w_lectura_masiva
end type
end forward

global type w_lectura_masiva from w_abc
integer width = 2784
integer height = 3440
string title = "Lectura Masiva de Códigos"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
windowstate windowstate = maximized!
boolean center = false
event ue_filtro ( )
rb_general rb_general
rb_parvitrina rb_parvitrina
rb_vitrina rb_vitrina
st_tipo_lectura st_tipo_lectura
st_fecha st_fecha
st_conteo st_conteo
st_almacen st_almacen
st_cu st_cu
st_5 st_5
p_foto p_foto
st_total st_total
pb_fltro pb_fltro
st_2 st_2
sle_ubicacion sle_ubicacion
sle_codigo sle_codigo
st_1 st_1
cb_1 cb_1
cb_aceptar cb_aceptar
cb_2 cb_2
gb_1 gb_1
st_descripcion st_descripcion
end type
global w_lectura_masiva w_lectura_masiva

type variables
str_parametros istr_param
end variables

event ue_filtro();u_dw_abc 	ldw_master
String		ls_ubicacion, ls_filtro, ls_almacen
Integer		li_longitud, ll_i,ln_total_ub, ll_nro_conteo
date  ld_fec_conteo
try
	//Valido la ubicación
	if trim(sle_ubicacion.text) = '' then
		ll_i = MessageBox('Error', 'Debe Ingresar la ubicación del artículo. Por favor verfique!' ,Exclamation!,  OKCancel!,2)
		if ll_i =0 then
			ll_i = MessageBox('Error', 'Debe Ingresar la ubicación del artículo. Por favor verfique!',  Exclamation!,  OKCancel!,2)		
		end if
		sle_ubicacion.SetFocus()
		return
	end if

	//Obtengo los datos enviados 
	ldw_master 		= istr_param.dw_m

	//Obtengo el código ingresado
	ls_ubicacion 	= trim(sle_ubicacion.text)
	
	//Refresco la información en pantalla
	istr_param.w1.dynamic event ue_refresh()
	
	//Genero el filtro 
	li_longitud = len(trim(ls_ubicacion))
	ls_filtro = "UPPER( LEFT(ubicacion, " + String(li_longitud) + "))=upper('" + trim(ls_ubicacion)  + "')"
	
	//Aplico el filtro
	ldw_master.setFilter(ls_filtro)
	ldw_master.Filter()
	
	ls_almacen 		= istr_param.string1
	ll_nro_conteo 	= istr_param.integer1
	ld_fec_conteo 	= istr_param.date1
	
	
	if rb_general.checked = true then
	//Obtengo los datos enviados 
	select sum(SLDO_CONTEO1)
					into :ln_total_ub
					from inventario_conteo
					where almacen				= :ls_almacen
						  and trunc(fec_conteo)	= trunc(:ld_fec_conteo)
						  and nro_conteo			= :ll_nro_conteo
						  and ubicacion			= :ls_ubicacion;
						  
				else
	select sum(SLDO_CONTEO1)
					into :ln_total_ub
					from inventario_conteo_vitrina
					where almacen				= :ls_almacen
						  and trunc(fec_conteo)	= trunc(:ld_fec_conteo)
						  and nro_conteo			= :ll_nro_conteo
						  and ubicacion			= :ls_ubicacion;
					
					
				end if
				
					st_total.text = string(ln_total_ub)
					
					
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al procesar código')
	
end try


end event

on w_lectura_masiva.create
int iCurrent
call super::create
this.rb_general=create rb_general
this.rb_parvitrina=create rb_parvitrina
this.rb_vitrina=create rb_vitrina
this.st_tipo_lectura=create st_tipo_lectura
this.st_fecha=create st_fecha
this.st_conteo=create st_conteo
this.st_almacen=create st_almacen
this.st_cu=create st_cu
this.st_5=create st_5
this.p_foto=create p_foto
this.st_total=create st_total
this.pb_fltro=create pb_fltro
this.st_2=create st_2
this.sle_ubicacion=create sle_ubicacion
this.sle_codigo=create sle_codigo
this.st_1=create st_1
this.cb_1=create cb_1
this.cb_aceptar=create cb_aceptar
this.cb_2=create cb_2
this.gb_1=create gb_1
this.st_descripcion=create st_descripcion
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_general
this.Control[iCurrent+2]=this.rb_parvitrina
this.Control[iCurrent+3]=this.rb_vitrina
this.Control[iCurrent+4]=this.st_tipo_lectura
this.Control[iCurrent+5]=this.st_fecha
this.Control[iCurrent+6]=this.st_conteo
this.Control[iCurrent+7]=this.st_almacen
this.Control[iCurrent+8]=this.st_cu
this.Control[iCurrent+9]=this.st_5
this.Control[iCurrent+10]=this.p_foto
this.Control[iCurrent+11]=this.st_total
this.Control[iCurrent+12]=this.pb_fltro
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.sle_ubicacion
this.Control[iCurrent+15]=this.sle_codigo
this.Control[iCurrent+16]=this.st_1
this.Control[iCurrent+17]=this.cb_1
this.Control[iCurrent+18]=this.cb_aceptar
this.Control[iCurrent+19]=this.cb_2
this.Control[iCurrent+20]=this.gb_1
this.Control[iCurrent+21]=this.st_descripcion
end on

on w_lectura_masiva.destroy
call super::destroy
destroy(this.rb_general)
destroy(this.rb_parvitrina)
destroy(this.rb_vitrina)
destroy(this.st_tipo_lectura)
destroy(this.st_fecha)
destroy(this.st_conteo)
destroy(this.st_almacen)
destroy(this.st_cu)
destroy(this.st_5)
destroy(this.p_foto)
destroy(this.st_total)
destroy(this.pb_fltro)
destroy(this.st_2)
destroy(this.sle_ubicacion)
destroy(this.sle_codigo)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.cb_aceptar)
destroy(this.cb_2)
destroy(this.gb_1)
destroy(this.st_descripcion)
end on

event ue_cancelar;call super::ue_cancelar;str_parametros lstr_param

lstr_param.b_return = false

CloseWithReturn(this, lstr_param)
end event

event ue_aceptar;call super::ue_aceptar;u_dw_abc 	ldw_master
Blob		lbl_imagen
Long			ll_row, ll_count, ll_nro_conteo, ln_existe, ll_i,ln_total_ub
String		ls_almacen, ls_codigo, ls_cod_art, ls_cod_usr, ls_mensaje, ls_ubicacion,ls_cu, ls_descripcion, ls_cu_real, ls_sku
Decimal		ldc_saldo, ldc_saldo_und2, ldc_saldo_conteo1
Date			ld_fec_conteo
try
	
	//Valido el código
	if trim(sle_codigo.text) = '' then
		//MessageBox('Error', 'Debe Ingresar un código de artículo válido', StopSign!)
		return
	end if
	
	if trim(sle_ubicacion.text) = '' then
		ll_i = MessageBox('Error', 'Debe Ingresar la ubicación del artículo. Por favor verfique!' ,Exclamation!,  OKCancel!,2)
		do while ll_i = 2 		
				ll_i = MessageBox('Error', 'Debe Ingresar la ubicación del artículo. Por favor verfique!',  Exclamation!,  OKCancel!,2)		
		loop
			sle_ubicacion.SetFocus()
		return
	end if

	//Obtengo los datos enviados 
	ldw_master 		= istr_param.dw_m
	ls_almacen 		= istr_param.string1
	ll_nro_conteo 	= istr_param.integer1
	ld_fec_conteo 	= istr_param.date1

	//Obtengo el código ingresado
	ls_codigo 		= trim(sle_codigo.text)
	ls_ubicacion 	= trim(sle_ubicacion.text)
	
	//solo lee con cu
	if len(trim(ls_codigo) ) < 13 then
		
		ll_i = MessageBox('Error', 'Debe ingresar codigo Cu!' ,Exclamation!,  OKCancel!,2)
		do while ll_i = 2 		
				ll_i = MessageBox('Error', 'Debe ingresar codigo Cu!',  Exclamation!,  OKCancel!,2)		
		loop
			sle_codigo.SetFocus()
		return
	end if
		
	
	ls_cu =trim(sle_codigo.text) 
	
	
	//verifica si esta leido en percha el cu
	if rb_vitrina.checked = true then
		
					select count (1)
					into :ln_existe 
					from inventario_conteo_vitrina
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13)) ;
					
					if ln_existe>=1 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
					
					//verifica q no este leido en percha
					select count (1)
					into :ln_existe 
					from inventario_conteo
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13)) ;
					
					if ln_existe>=1 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' existe en lectura general. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' existe en lectura general. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
	end if				
	
	if rb_general.checked = true then
		
					select count (1)
					into :ln_existe 
					from inventario_conteo
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13)) ;
					
					if ln_existe>=1 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
		
		
				select count (1)
					into :ln_existe 
					from inventario_conteo_vitrina
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13)) ;
					
					if ln_existe>=1 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' existe en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' existe en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
					
	end if	
	///////
				
			
	//busco par en vitrina
	if rb_parvitrina.checked = true then
		
					select count (1)
					into :ln_existe 
					from inventario_conteo_vitrina
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13));
					
					if ln_existe=0 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' no existe en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' no existe en vitrina. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
					
					select count (1)
					into :ln_existe 
					from inventario_conteo
					where almacen = :ls_almacen
						and TRUNC(fec_conteo) = TRUNC(:ld_fec_conteo)
						and nro_conteo=:ll_nro_conteo
						and codigo_cu = upper(substr(:ls_cu,1,13)) ;
					
					if ln_existe>=1 then
						 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido. Por favor verifique!',Exclamation!,  OKCancel!,2)
						 
						do while ll_i = 2 		
							 ll_i =MessageBox('Error', 'Código ingresado ' + ls_cu  + ' repetido. Por favor verifique!',Exclamation!,  OKCancel!,2)			
						loop
							
						return 
					end if
			
	end if
	
	
	
	//busco datos articulo
	  select und.cod_Art, a.desc_art, tg.codigo_cu, a.cod_sku
	  into :ls_cod_art, :ls_descripcion, :ls_cu_real, :ls_sku
	  from tg_parte_empaque_und tg, zc_parte_ingreso_und und, zc_parte_ingreso pi , articulo a 
	  where tg.codigo_cu = upper(substr(:ls_cu,1,13))
	  and und.regkey= tg.regkey
	  and pi.nro_parte = und.nro_parte
	  and a.cod_art = und.cod_art
	  and pi.flag_estado <> '0';


 	if gnvo_app.of_get_parametro('ALMACEN_SHOW_FOTOGRAFIA', '0') = '1' then
						
					selectBLOB imagen_blob
						into :lbl_imagen
					from vw_articulo
					where cod_art = :ls_cod_art;					
					
					IF SQLCA.SQLCode < 0 THEN
						ls_mensaje = SQLCA.SQLErrText
						ROLLBACK;
						MessageBox('Aviso', "Ha ocurrido un error al consultar la vista VW_ARTICULO. Mensaje: " + ls_mensaje + ". Por favor verifique!", StopSign!)
						return 
					END IF
					
					if ISNull(lbl_imagen) then
						MessageBox('Aviso', "No existe imagen. Por favor verifique!", StopSign!)					
						return 
					end if			
				//if gnvo_app.logistica.of_show_imagen(lbl_imagen) then 
	
	
				if rb_vitrina.checked = true then
		
								insert into inventario_conteo_vitrina(
									cod_art, fec_conteo, almacen, nro_conteo, fec_registro, 
									SLDO_TOTAL, SLDO_CONTEO1, SLDO_TOTAL_UND2, SLDO_CONTEO1_UND2,
									SLDO_CONTEO2, SLDO_CONTEO2_UND2, 
									NRO_LOTE,
									COD_USR,
									codigo_cu,
									ubicacion)
								values(
									:ls_cod_art, :ld_Fec_conteo, :ls_almacen, :ll_nro_conteo, sysdate,
									:ldc_saldo, 1, :ldc_saldo_und2, 0,
									0, 0,
									'NO TIENE',
									:gs_user,
									:ls_cu_real,
									:ls_ubicacion);
								
								if SQLCA.SQLCOde < 0 then
									ls_mensaje = SQLCA.SQLErrText
									ROLLBACK;
									MessageBox('Error', 'Ha ocurrido un error al insertar el registro en la tabla INVENTARIO_CONTEO. Mensaje: ' + ls_mensaje, StopSign!)
									return
								end if
								
								select sum(SLDO_CONTEO1)
								into :ln_total_ub
								from inventario_conteo_vitrina
								where almacen				= :ls_almacen
									  and trunc(fec_conteo)	= trunc(:ld_fec_conteo)
									  and nro_conteo			= :ll_nro_conteo
									  and ubicacion			= :ls_ubicacion;
									  
								st_total.text = string(ln_total_ub)
								
				else
		
								//Inserto el registro en inventario x conteo
								insert into inventario_conteo(
									cod_art, fec_conteo, almacen, nro_conteo, fec_registro, 
									SLDO_TOTAL, SLDO_CONTEO1, SLDO_TOTAL_UND2, SLDO_CONTEO1_UND2,
									SLDO_CONTEO2, SLDO_CONTEO2_UND2, 
									NRO_LOTE,
									COD_USR,
									codigo_cu,
									ubicacion)
								values(
									:ls_cod_art, :ld_Fec_conteo, :ls_almacen, :ll_nro_conteo, sysdate,
									:ldc_saldo, 1, :ldc_saldo_und2, 0,
									0, 0,
									'NO TIENE',
									:gs_user,
									:ls_cu_real,
									:ls_ubicacion);
								
								if SQLCA.SQLCOde < 0 then
									ls_mensaje = SQLCA.SQLErrText
									ROLLBACK;
									MessageBox('Error', 'Ha ocurrido un error al insertar el registro en la tabla INVENTARIO_CONTEO. Mensaje: ' + ls_mensaje, StopSign!)
									return
								end if
								
								select sum(SLDO_CONTEO1)
								into :ln_total_ub
								from inventario_conteo
								where almacen				= :ls_almacen
									  and trunc(fec_conteo)	= trunc(:ld_fec_conteo)
									  and nro_conteo			= :ll_nro_conteo
									  and ubicacion			= :ls_ubicacion;
									  
								st_total.text = string(ln_total_ub)
				end if			
				
				
				
				p_foto.SetRedraw(FALSE)
				p_foto.SetPicture(lbl_imagen)
				p_foto.SetRedraw(TRUE)
			
				st_cu.text =ls_cu_real
				st_descripcion.text = ls_descripcion + '              SKU: ' + ls_sku
				//end if
	else
		//Inserto el registro en inventario x conteo
			insert into inventario_conteo(
				cod_art, fec_conteo, almacen, nro_conteo, fec_registro, 
				SLDO_TOTAL, SLDO_CONTEO1, SLDO_TOTAL_UND2, SLDO_CONTEO1_UND2,
				SLDO_CONTEO2, SLDO_CONTEO2_UND2, 
				NRO_LOTE,
				COD_USR,
				codigo_cu,
				ubicacion)
			values(
				:ls_cod_art, :ld_Fec_conteo, :ls_almacen, :ll_nro_conteo, sysdate,
				:ldc_saldo, 1, :ldc_saldo_und2, 0,
				0, 0,
				'NO TIENE',
				:gs_user,
				upper(substr(:ls_cu,1,13)),
				:ls_ubicacion);
			
			if SQLCA.SQLCOde < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MessageBox('Error', 'Ha ocurrido un error al insertar el registro en la tabla INVENTARIO_CONTEO. Mensaje: ' + ls_mensaje, StopSign!)
				return
			end if				
	end if
	
			
	/*else
		// Si el código de articulo existe, valido que no sea otro el usuario que lo ha ingresado
		if not IsNull(ls_cod_usr) and trim(ls_cod_usr) <> '' and trim(ls_cod_usr) <> trim(gs_user) then
			ROLLBACK;
			MessageBox('Error', 'El registro ya ha sido ingresado por el usuario ' + ls_cod_usr + '. Por favor verifique!', StopSign!)
			return
		end if
		
		//Incremento el contador
		ldc_Saldo_conteo1 ++
		
		//Actualizo los datos
		update inventario_conteo ic
		   set 	ic.SLDO_CONTEO1 	= :ldc_Saldo_conteo1,
					ic.cod_usr			= :gs_user,
					ic.ubicacion		= :ls_ubicacion,
					ic.fec_registro	= sysdate
		where almacen				= :ls_almacen
		  and trunc(fec_conteo)	= trunc(:ld_fec_conteo)
		  and nro_conteo			= :ll_nro_conteo
		  and cod_art				= :ls_cod_art
		  and ubicacion			= :ls_ubicacion;
					
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al actualizar el registro en la tabla INVENTARIO_CONTEO. Mensaje: ' + ls_mensaje, StopSign!)
			return
		end if
	end if
	*/
	//Aplico los cambios
	commit;
	
	//Refresco la información en pantalla
	istr_param.w1.dynamic event ue_refresh()
	
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al procesar código')
	
finally
	
	if trim(sle_ubicacion.text) = '' then
		sle_ubicacion.SetFocus()
		return
	end if
	
	sle_codigo.text = ''
	sle_codigo.setFocus()

end try


end event

event ue_open_pre;call super::ue_open_pre;istr_param = Message.PowerObjectParm

String		ls_ubicacion, ls_filtro, ls_almacen, ls_descripcion
Integer		li_longitud, ll_i,ln_total_ub, ll_nro_conteo
date ld_fec_conteo
	//Obtengo los datos enviados 
	ls_almacen 		= istr_param.string1
	ll_nro_conteo 	= istr_param.integer1
	ld_fec_conteo 	= istr_param.date1
	
	select desc_almacen
	into :ls_descripcion
	from almacen where almacen = :ls_almacen;
	
	st_almacen.text = ls_descripcion
	st_conteo.text = string (ll_nro_conteo)
	st_fecha.text = string (ld_fec_conteo)

sle_ubicacion.setFocuS()
end event

type rb_general from radiobutton within w_lectura_masiva
integer x = 1819
integer y = 324
integer width = 622
integer height = 156
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "GENERAL"
boolean checked = true
end type

event clicked;if rb_general.checked = true then
	st_tipo_lectura.text = 'GENERAL'
END IF

if rb_VITRINA.checked = true then
	st_tipo_lectura.text = 'VITRINA'
END IF

if rb_PARVITRINA.checked = true then
	st_tipo_lectura.text = 'PAR VITRINA'
END IF
end event

type rb_parvitrina from radiobutton within w_lectura_masiva
integer x = 2053
integer y = 456
integer width = 832
integer height = 172
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "PAR VITRINA"
end type

event clicked;if rb_general.checked = true then
	st_tipo_lectura.text = 'GENERAL'
END IF

if rb_VITRINA.checked = true then
	st_tipo_lectura.text = 'VITRINA'
END IF

if rb_PARVITRINA.checked = true then
	st_tipo_lectura.text = 'PAR VITRINA'
END IF
end event

type rb_vitrina from radiobutton within w_lectura_masiva
integer x = 1531
integer y = 448
integer width = 494
integer height = 172
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "VITRINA"
end type

event clicked;if rb_general.checked = true then
	st_tipo_lectura.text = 'GENERAL'
END IF

if rb_VITRINA.checked = true then
	st_tipo_lectura.text = 'VITRINA'
END IF

if rb_PARVITRINA.checked = true then
	st_tipo_lectura.text = 'PAR VITRINA'
END IF
end event

type st_tipo_lectura from statictext within w_lectura_masiva
integer x = 41
integer y = 368
integer width = 1467
integer height = 132
integer textsize = -22
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217856
long backcolor = 65535
string text = "GENERAL"
boolean focusrectangle = false
end type

type st_fecha from statictext within w_lectura_masiva
integer x = 32
integer y = 28
integer width = 699
integer height = 104
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "01/01/2019"
boolean focusrectangle = false
end type

type st_conteo from statictext within w_lectura_masiva
integer x = 837
integer y = 32
integer width = 293
integer height = 100
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "N"
boolean focusrectangle = false
end type

type st_almacen from statictext within w_lectura_masiva
integer x = 32
integer y = 168
integer width = 1733
integer height = 140
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "ALMACEN"
boolean focusrectangle = false
end type

type st_cu from singlelineedit within w_lectura_masiva
integer x = 311
integer y = 2456
integer width = 1600
integer height = 224
integer taborder = 40
integer textsize = -28
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean border = false
end type

type st_5 from statictext within w_lectura_masiva
integer x = 96
integer y = 2476
integer width = 210
integer height = 108
integer textsize = -20
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "CU"
boolean focusrectangle = false
end type

type p_foto from picture within w_lectura_masiva
integer x = 165
integer y = 1288
integer width = 1938
integer height = 1140
boolean focusrectangle = false
end type

type st_total from statictext within w_lectura_masiva
integer x = 1765
integer y = 664
integer width = 800
integer height = 224
integer textsize = -36
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217856
long backcolor = 67108864
string text = "0"
alignment alignment = center!
boolean focusrectangle = false
end type

type pb_fltro from picturebutton within w_lectura_masiva
integer x = 1349
integer y = 648
integer width = 256
integer height = 192
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\PNG\filtro.png"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Filtra los registros por la ubicación"
end type

event clicked;setPointer(HourGlass!)
parent.event dynamic ue_filtro()
setPointer(Arrow!)
end event

type st_2 from statictext within w_lectura_masiva
integer x = 37
integer y = 564
integer width = 1563
integer height = 76
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicacion"
boolean focusrectangle = false
end type

type sle_ubicacion from singlelineedit within w_lectura_masiva
integer x = 37
integer y = 648
integer width = 1307
integer height = 188
integer taborder = 20
integer textsize = -26
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

type sle_codigo from singlelineedit within w_lectura_masiva
integer x = 37
integer y = 956
integer width = 1582
integer height = 196
integer taborder = 20
integer textsize = -22
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event modified;setPointer(HourGlass!)


IF TRIM(THIS.TExt) = 'LECVITRINA' THEN
	RB_VITRINA.checked =true
	rb_parvitrina.checked =false
	rb_general.checked = false
	st_tipo_lectura.text = 'VITRINA'	
	sle_codigo.text = ''
	return
END IF

IF TRIM(THIS.TExt) = 'LECGENERAL' THEN
	RB_VITRINA.checked =false
	rb_parvitrina.checked =false
	rb_general.checked = true
	st_tipo_lectura.text = 'GENERAL'	
	sle_codigo.text = ''
	return
END IF


IF TRIM(THIS.TExt) = 'LECPARVITRINA' THEN
	RB_VITRINA.checked =false
	rb_parvitrina.checked =true
	rb_general.checked = false
	st_tipo_lectura.text = 'PAR VITRINA'	
	sle_codigo.text = ''
	return
END IF



parent.event ue_aceptar()
setPointer(Arrow!)
end event

type st_1 from statictext within w_lectura_masiva
integer x = 37
integer y = 852
integer width = 1207
integer height = 104
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Codigo CU"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_lectura_masiva
integer x = 1842
integer y = 28
integer width = 782
integer height = 240
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_cancelar()
SetPointer(Arrow!)
end event

type cb_aceptar from commandbutton within w_lectura_masiva
boolean visible = false
integer x = 1774
integer y = 1820
integer width = 517
integer height = 132
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_aceptar()
SetPointer(Arrow!)
end event

type cb_2 from commandbutton within w_lectura_masiva
boolean visible = false
integer x = 2313
integer y = 1820
integer width = 517
integer height = 132
integer taborder = 10
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;SetPointer(HourGlass!)
parent.event ue_cancelar()
SetPointer(Arrow!)
end event

type gb_1 from groupbox within w_lectura_masiva
integer y = 1188
integer width = 2693
integer height = 2108
integer taborder = 30
integer textsize = -16
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Ultimo Leido"
end type

type st_descripcion from multilineedit within w_lectura_masiva
integer x = 82
integer y = 2720
integer width = 2473
integer height = 468
integer taborder = 50
boolean bringtotop = true
integer textsize = -18
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
boolean border = false
end type

