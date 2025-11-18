$PBExportHeader$w_cn901_traslada_asientos.srw
forward
global type w_cn901_traslada_asientos from w_prc
end type
type sle_nro_asiento from singlelineedit within w_cn901_traslada_asientos
end type
type st_3 from statictext within w_cn901_traslada_asientos
end type
type cbx_1 from checkbox within w_cn901_traslada_asientos
end type
type st_7 from statictext within w_cn901_traslada_asientos
end type
type sle_origen from singlelineedit within w_cn901_traslada_asientos
end type
type st_4 from statictext within w_cn901_traslada_asientos
end type
type sle_libro from singlelineedit within w_cn901_traslada_asientos
end type
type st_5 from statictext within w_cn901_traslada_asientos
end type
type sle_mes from singlelineedit within w_cn901_traslada_asientos
end type
type sle_year from singlelineedit within w_cn901_traslada_asientos
end type
type cb_cancelar from commandbutton within w_cn901_traslada_asientos
end type
type cb_generar from commandbutton within w_cn901_traslada_asientos
end type
type st_2 from statictext within w_cn901_traslada_asientos
end type
type st_1 from statictext within w_cn901_traslada_asientos
end type
type gb_1 from groupbox within w_cn901_traslada_asientos
end type
end forward

global type w_cn901_traslada_asientos from w_prc
integer width = 1829
integer height = 1504
string title = "[CN901] Importacion de pre asientos como asientos contables"
string menuname = "m_prc"
boolean maxbox = false
boolean resizable = false
boolean center = true
event ue_nro_asiento ( )
sle_nro_asiento sle_nro_asiento
st_3 st_3
cbx_1 cbx_1
st_7 st_7
sle_origen sle_origen
st_4 st_4
sle_libro sle_libro
st_5 st_5
sle_mes sle_mes
sle_year sle_year
cb_cancelar cb_cancelar
cb_generar cb_generar
st_2 st_2
st_1 st_1
gb_1 gb_1
end type
global w_cn901_traslada_asientos w_cn901_traslada_asientos

type variables
Long		il_nro_asiento
end variables

event ue_nro_asiento();string 	ls_origen, ls_nro_libro
integer	li_year, li_mes

if gs_empresa = 'CANTABRIA' then
	sle_nro_Asiento.text = '1'
else

	li_year 	= Integer(sle_year.text)
	li_mes	= Integer(sle_mes.text)
	ls_origen = sle_origen.text
	ls_nro_libro = sle_libro.text
	
	select nro_asiento
		into :il_nro_Asiento
	from cntbl_libro_mes
	where origen 		= :ls_origen
	  and nro_libro 	= :ls_nro_libro
	  and ano		 	= :li_year
	  and mes			= :li_mes;
	
	If IsNull(il_nro_asiento) then il_nro_asiento = 1


	sle_nro_Asiento.text = string(il_nro_asiento)
	
end if
end event

on w_cn901_traslada_asientos.create
int iCurrent
call super::create
if this.MenuName = "m_prc" then this.MenuID = create m_prc
this.sle_nro_asiento=create sle_nro_asiento
this.st_3=create st_3
this.cbx_1=create cbx_1
this.st_7=create st_7
this.sle_origen=create sle_origen
this.st_4=create st_4
this.sle_libro=create sle_libro
this.st_5=create st_5
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.cb_cancelar=create cb_cancelar
this.cb_generar=create cb_generar
this.st_2=create st_2
this.st_1=create st_1
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_nro_asiento
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.cbx_1
this.Control[iCurrent+4]=this.st_7
this.Control[iCurrent+5]=this.sle_origen
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.sle_libro
this.Control[iCurrent+8]=this.st_5
this.Control[iCurrent+9]=this.sle_mes
this.Control[iCurrent+10]=this.sle_year
this.Control[iCurrent+11]=this.cb_cancelar
this.Control[iCurrent+12]=this.cb_generar
this.Control[iCurrent+13]=this.st_2
this.Control[iCurrent+14]=this.st_1
this.Control[iCurrent+15]=this.gb_1
end on

on w_cn901_traslada_asientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_nro_asiento)
destroy(this.st_3)
destroy(this.cbx_1)
destroy(this.st_7)
destroy(this.sle_origen)
destroy(this.st_4)
destroy(this.sle_libro)
destroy(this.st_5)
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.cb_cancelar)
destroy(this.cb_generar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.gb_1)
end on

event open;call super::open;String ls_ano, ls_mes
ls_ano = string( year( Date(gnvo_app.of_fecha_actual()) ) )
ls_mes = string( month( Date(gnvo_app.of_fecha_actual()) ) -1 )
					
sle_year.text 		= ls_ano
sle_mes.text 		= ls_mes
sle_origen.text 	= gs_origen

sle_nro_asiento.text = '1'
end event

type sle_nro_asiento from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 832
integer width = 187
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_cn901_traslada_asientos
integer x = 325
integer y = 836
integer width = 585
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Voucher empiece por :"
alignment alignment = right!
boolean focusrectangle = false
end type

type cbx_1 from checkbox within w_cn901_traslada_asientos
integer x = 544
integer y = 556
integer width = 366
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Elegir Mes"
boolean checked = true
boolean lefttext = true
end type

event clicked;if this.checked then
	sle_mes.enabled = true
else
	sle_mes.enabled = false
end if
end event

type st_7 from statictext within w_cn901_traslada_asientos
integer x = 544
integer y = 740
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_origen from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 740
integer width = 187
integer height = 72
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;parent.event ue_nro_asiento()
end event

type st_4 from statictext within w_cn901_traslada_asientos
integer x = 544
integer y = 648
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Libro"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_libro from singlelineedit within w_cn901_traslada_asientos
event dobleclick pbm_lbuttondblclk
integer x = 928
integer y = 648
integer width = 187
integer height = 72
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_year, ls_mes

ls_year 	= sle_year.text
ls_mes 	= String(Integer(sle_mes.text), '00')

if cbx_1.checked then
	ls_sql = "SELECT distinct trim(to_char(cl.nro_libro, '00')) AS CODIGO, " &
		 	 + "cl.desc_libro AS DESCRIPCION " &
		 	 + "FROM cntbl_libro cl, " &
		 	 + "     cntbl_pre_asiento ca " & 
		 	 + "where cl.nro_libro = ca.nro_libro " &
		 	 + "  and ca.flag_estado = '1' " &
			 + "  and to_number(to_char(ca.fec_cntbl, 'yyyy')) = " + ls_year + " " &
		  	 + "  and to_number(to_char(ca.fec_cntbl, 'mm'))   = " + ls_mes + " " &
		 	 + "ORDER BY 1 " 
		 

else
	ls_sql = "SELECT distinct trim(to_char(cl.nro_libro, '00')) AS CODIGO, " &
		 	 + "cl.desc_libro AS DESCRIPCION " &
		 	 + "FROM cntbl_libro cl, " &
		 	 + "     cntbl_pre_asiento ca " & 
		 	 + "where cl.nro_libro = ca.nro_libro " &
		 	 + "  and ca.flag_estado = '1' " &
			 + "  and to_number(to_char(ca.fec_cntbl, 'yyyy')) = " + ls_year + " " &
		 	 + "ORDER BY 1 " 

end if




if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data,'1')  then
	this.text   = ls_codigo
	parent.event ue_nro_asiento()
end if



end event

event modified;parent.event ue_nro_asiento()
end event

type st_5 from statictext within w_cn901_traslada_asientos
integer x = 293
integer y = 236
integer width = 1211
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "COMO ASIENTOS CONTABLES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 556
integer width = 187
integer height = 72
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

event modified;parent.event ue_nro_asiento()
end event

type sle_year from singlelineedit within w_cn901_traslada_asientos
integer x = 928
integer y = 464
integer width = 187
integer height = 72
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

event modified;parent.event ue_nro_asiento()
end event

type cb_cancelar from commandbutton within w_cn901_traslada_asientos
integer x = 891
integer y = 1032
integer width = 425
integer height = 212
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
end type

event clicked;CLOSE (PARENT)
end event

type cb_generar from commandbutton within w_cn901_traslada_asientos
integer x = 434
integer y = 1032
integer width = 425
integer height = 212
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar"
end type

event clicked;String 	ls_origen, ls_usuario, ls_mensaje
Long 		ll_count
Integer	li_year, li_mes, li_nro_libro, li_nro_asiento
DateTime	ldt_inicio, ldt_fin
Decimal	ldc_tiempo

try 
	SetPointer(HourGlass!)
	
	//Capturo tiempo de inicio
	ldt_inicio = gnvo_app.of_fecha_actual()
	
	cb_generar.enabled  = false
	cb_cancelar.enabled = false
	sle_year.enabled     = false
	sle_mes.enabled     = false
	sle_libro.enabled	  = false
	
	li_year 			= Integer(sle_year.text)
	li_nro_libro 	= Integer(sle_libro.text)
	ls_origen 		= sle_origen.text
	ls_usuario 		= gs_user
	li_nro_asiento	= Integer(sle_nro_asiento.text)
	
	//Obtengo el mes
	if cbx_1.checked then
		li_mes		= Integer(sle_mes.text)
		
		//Valido si existen los pre-asientos
		select count(*)
		  into :ll_count
		  from cntbl_pre_asiento t
		where t.origen 	= :ls_origen
		  and t.nro_libro = :li_nro_libro
		  and to_number(to_char(t.fec_cntbl, 'yyyy')) 	= :li_year
		  and to_number(to_char(t.fec_cntbl, 'mm')) 		= :li_mes;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("No existen pre asiento generados para los parametros ingresados" &
										+ "~r~nOrigen: " + ls_origen &
										+ "~r~Nro Libro: " + string(li_nro_libro, '00') &
										+ "~r~nAño: " + string(li_year, '0000') &
										+ "~r~nMes: " + string(li_mes, '00'))
			return
		end if

	else
		li_mes		= -1

		//Valido si existen los pre-asientos
		select count(*)
		  into :ll_count
		  from cntbl_pre_asiento t
		where t.origen 	= :ls_origen
		  and t.nro_libro = :li_nro_libro
		  and to_number(to_char(t.fec_cntbl, 'yyyy')) 	= :li_year;
		
		if ll_count = 0 then
			gnvo_app.of_mensaje_error("No existen pre asiento generados para los parametros ingresados" &
										+ "~r~nOrigen: " + ls_origen &
										+ "~r~Nro Libro: " + string(li_nro_libro, '00') &
										+ "~r~nAño: " + string(li_year, '0000'))
			return
		end if

	end if

	
	
	if li_nro_asiento <> il_nro_Asiento then
		if li_mes = -1 then
			//Si ha marcado todos los meses entonces actualizo el numerador a todos los meses 
			update cntbl_libro_mes
				set nro_asiento = 1
			where origen 		= :ls_origen
			  and nro_libro 	= :li_nro_libro
			  and ano			= :li_year;
		else
			//actualizo el numerador en solo un mes
			update cntbl_libro_mes
				set nro_asiento = 1
			where origen 		= :ls_origen
			  and nro_libro 	= :li_nro_libro
			  and ano			= :li_year
			  and mes			= :li_mes;
			
		end if
		
		if gnvo_app.of_ExistsError(SQLCA, 'Update cntbl_libro_mes') then return
		
		commit;
	end if
	
	// Verifica si existe libro contable
	SELECT count(*) 
		INTO :ll_count
	FROM cntbl_libro
	WHERE nro_libro = :li_nro_libro ;
	
	if ll_count = 0 then
		MessageBox('Aviso', "Libro contable " + string(li_nro_libro, '00') + " no existe. Por favor verifique!")
		return
	end if
	

	//	CREATE OR REPLACE PROCEDURE usp_cntbl_traslado_asientos (
	//       ani_year          in cntbl_asiento.ano%type, 
	//       ani_mes           in cntbl_asiento.mes%type,
	//       ani_nro_libro     in cntbl_libro.nro_libro%TYPE, 
	//       asi_origen        in cntbl_asiento.origen%type,
	//       as_usuario        in usuario.cod_usr%TYPE 
	//	) is	

	DECLARE USP_CNTBL_TRASLADO_ASIENTOS PROCEDURE FOR 
		USP_CNTBL_TRASLADO_ASIENTOS( 	:li_year, 
												:li_mes, 
												:li_nro_libro, 
												:ls_origen, 
												:ls_usuario ) ;
	EXECUTE USP_CNTBL_TRASLADO_ASIENTOS ;

	if SQLCA.SQLCode = -1 then
	  ls_mensaje = sqlca.sqlerrtext
	  rollback ;
	  MessageBox("Error en USP_CNTBL_TRASLADO_ASIENTOS", ls_mensaje, StopSign!)
	  return
	end if
	
	CLOSE USP_CNTBL_TRASLADO_ASIENTOS ;
	
	//Capturo tiempo final
	ldt_fin = gnvo_app.of_fecha_actual( )
	
	//Obtengo la diferencia obtenida
	select (:ldt_fin - :ldt_inicio) * 24 * 60 * 60
		into :ldc_tiempo
	from dual;
	
	MessageBox ('Atención', "Proceso ha sido ejecutado satisfactoriamente en " &
									+ gnvo_app.utilitario.of_time_to_string(ldc_tiempo) + ".")

	
finally
	cb_generar.enabled  = true
	cb_cancelar.enabled = true
	sle_year.enabled     = true
	sle_libro.enabled	  = true
	
	if cbx_1.checked then
		sle_mes.enabled = true
	else
		sle_mes.enabled = false
	end if
	
	SetPointer(Arrow!)
end try

end event

type st_2 from statictext within w_cn901_traslada_asientos
integer x = 544
integer y = 464
integer width = 366
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cn901_traslada_asientos
integer x = 105
integer y = 92
integer width = 1586
integer height = 96
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long backcolor = 12632256
string text = "IMPORTACION DE PRE ASIENTOS CONTABLES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn901_traslada_asientos
integer y = 356
integer width = 1797
integer height = 968
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Periodo Contable "
borderstyle borderstyle = styleraised!
end type

