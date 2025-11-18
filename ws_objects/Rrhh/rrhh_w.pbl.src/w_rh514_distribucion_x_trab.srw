$PBExportHeader$w_rh514_distribucion_x_trab.srw
forward
global type w_rh514_distribucion_x_trab from w_prc
end type
type sle_mes from singlelineedit within w_rh514_distribucion_x_trab
end type
type sle_year from singlelineedit within w_rh514_distribucion_x_trab
end type
type cb_1 from commandbutton within w_rh514_distribucion_x_trab
end type
type cbx_all_ot_adm from checkbox within w_rh514_distribucion_x_trab
end type
type cb_seleccionar from commandbutton within w_rh514_distribucion_x_trab
end type
type st_6 from statictext within w_rh514_distribucion_x_trab
end type
type st_5 from statictext within w_rh514_distribucion_x_trab
end type
type st_1 from statictext within w_rh514_distribucion_x_trab
end type
type em_desc_ttrab from editmask within w_rh514_distribucion_x_trab
end type
type em_ttrab from editmask within w_rh514_distribucion_x_trab
end type
type cb_3 from commandbutton within w_rh514_distribucion_x_trab
end type
type cb_generar from commandbutton within w_rh514_distribucion_x_trab
end type
type cb_2 from commandbutton within w_rh514_distribucion_x_trab
end type
type em_origen from editmask within w_rh514_distribucion_x_trab
end type
type em_descripcion from editmask within w_rh514_distribucion_x_trab
end type
type gb_2 from groupbox within w_rh514_distribucion_x_trab
end type
end forward

global type w_rh514_distribucion_x_trab from w_prc
integer width = 2135
integer height = 728
string title = "(RH514) Distribución x Trabajador"
boolean maxbox = false
boolean center = true
sle_mes sle_mes
sle_year sle_year
cb_1 cb_1
cbx_all_ot_adm cbx_all_ot_adm
cb_seleccionar cb_seleccionar
st_6 st_6
st_5 st_5
st_1 st_1
em_desc_ttrab em_desc_ttrab
em_ttrab em_ttrab
cb_3 cb_3
cb_generar cb_generar
cb_2 cb_2
em_origen em_origen
em_descripcion em_descripcion
gb_2 gb_2
end type
global w_rh514_distribucion_x_trab w_rh514_distribucion_x_trab

type variables
u_ds_base  ids_datos
end variables

on w_rh514_distribucion_x_trab.create
int iCurrent
call super::create
this.sle_mes=create sle_mes
this.sle_year=create sle_year
this.cb_1=create cb_1
this.cbx_all_ot_adm=create cbx_all_ot_adm
this.cb_seleccionar=create cb_seleccionar
this.st_6=create st_6
this.st_5=create st_5
this.st_1=create st_1
this.em_desc_ttrab=create em_desc_ttrab
this.em_ttrab=create em_ttrab
this.cb_3=create cb_3
this.cb_generar=create cb_generar
this.cb_2=create cb_2
this.em_origen=create em_origen
this.em_descripcion=create em_descripcion
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_mes
this.Control[iCurrent+2]=this.sle_year
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.cbx_all_ot_adm
this.Control[iCurrent+5]=this.cb_seleccionar
this.Control[iCurrent+6]=this.st_6
this.Control[iCurrent+7]=this.st_5
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.em_desc_ttrab
this.Control[iCurrent+10]=this.em_ttrab
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.cb_generar
this.Control[iCurrent+13]=this.cb_2
this.Control[iCurrent+14]=this.em_origen
this.Control[iCurrent+15]=this.em_descripcion
this.Control[iCurrent+16]=this.gb_2
end on

on w_rh514_distribucion_x_trab.destroy
call super::destroy
destroy(this.sle_mes)
destroy(this.sle_year)
destroy(this.cb_1)
destroy(this.cbx_all_ot_adm)
destroy(this.cb_seleccionar)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_1)
destroy(this.em_desc_ttrab)
destroy(this.em_ttrab)
destroy(this.cb_3)
destroy(this.cb_generar)
destroy(this.cb_2)
destroy(this.em_origen)
destroy(this.em_descripcion)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;sle_year.text = string(gnvo_app.of_Fecha_actual(), 'yyyy')
sle_mes.text = string(gnvo_app.of_Fecha_actual(), 'mm')
end event

type sle_mes from singlelineedit within w_rh514_distribucion_x_trab
integer x = 512
integer y = 324
integer width = 155
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type sle_year from singlelineedit within w_rh514_distribucion_x_trab
integer x = 270
integer y = 324
integer width = 229
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_rh514_distribucion_x_trab
integer x = 864
integer y = 432
integer width = 613
integer height = 136
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "=>>> Enviar al Historico"
end type

event clicked;//Envia al historico

if MessageBox('AViso', 'Desea enviar al historico la distribución contable', Exclamation!, YesNo!, 2) = 2 then return

String 	ls_origen, ls_ttrab ,ls_msj ,ls_flag
Long   	ll_count
integer	li_year, li_mes

ls_origen   = String(em_origen.text)
ls_ttrab		= String(em_ttrab.text)
li_year		= Integer(sle_year.text)
li_mes		= Integer(sle_mes.text)

//create or replace procedure USP_RH_HIST_DISTRIB_CNTBL(
//       asi_origen       in origen.cod_origen%TYPE,
//       asi_tipo_trabaj  in tipo_trabajador.tipo_trabajador%TYPE,
//       ani_year         in number,
//       ani_mes          in number,
//       asi_usr          in usuario.cod_usr%TYPE
//) is
DECLARE USP_RH_HIST_DISTRIB_CNTBL PROCEDURE FOR 
		USP_RH_HIST_DISTRIB_CNTBL( :ls_origen, 
										  	:ls_ttrab,
											:li_year,
											:li_mes,
											:gs_user 		) ;
EXECUTE USP_RH_HIST_DISTRIB_CNTBL ;

IF SQLCA.SQLCode = -1 THEN 
   ls_msj = SQLCA.SQLErrText
   Rollback ;
   MessageBox('Error en USP_RH_HIST_DISTRIB_CNTBL', ls_msj)
	return
end if

Commit ;

Close USP_RH_HIST_DISTRIB_CNTBL;

MessageBox('Atención','Proceso ha Concluído Satisfactoriamente', Exclamation!)

SetPointer(Arrow!)
end event

type cbx_all_ot_adm from checkbox within w_rh514_distribucion_x_trab
integer x = 901
integer y = 316
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Incluir todos los OT_ADM"
boolean checked = true
end type

event clicked;if this.checked then
	cb_seleccionar.enabled =false
else
	cb_seleccionar.enabled = true
end if
end event

type cb_seleccionar from commandbutton within w_rh514_distribucion_x_trab
integer x = 1600
integer y = 296
integer width = 448
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Seleccionar"
end type

event clicked;String ls_flag,ls_tipo
Long   ll_count


//elimino informacion de tabla temporal
delete from tt_ope_ot_adm ;


ls_tipo = em_ttrab.text

if isnull(ls_tipo) or trim(ls_tipo)='' then
	Messagebox('Aviso','Tipo de Trabajador No Existe,Verifique!')
	Return
end if


select count(*) into :ll_count from tipo_trabajador
 where tipo_trabajador = :ls_tipo ;


if ll_count = 0 then
	Messagebox('Aviso','Tipo de Trabajador No Existe,Verifique!')
	Return
end if	




select flag_tabla_origen into :ls_flag 
  from tipo_trabajador where tipo_trabajador = :ls_tipo ;



if ls_flag = 'A' then  //parte diario de asistencia
	open(w_help_response)	
else
	Messagebox('Aviso','Tipo de Trabajador no Necesita Seleccionar Administracion')
end if


end event

type st_6 from statictext within w_rh514_distribucion_x_trab
integer x = 23
integer y = 204
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "T.Trab. :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_5 from statictext within w_rh514_distribucion_x_trab
integer x = 23
integer y = 112
integer width = 229
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Origen :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_rh514_distribucion_x_trab
integer x = 37
integer y = 328
integer width = 251
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Periodo:"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_desc_ttrab from editmask within w_rh514_distribucion_x_trab
integer x = 585
integer y = 208
integer width = 1467
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_ttrab from editmask within w_rh514_distribucion_x_trab
integer x = 265
integer y = 208
integer width = 192
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_3 from commandbutton within w_rh514_distribucion_x_trab
integer x = 480
integer y = 208
integer width = 87
integer height = 76
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

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_tiptra_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_ttrab.text = sl_param.field_ret[1]
	em_desc_ttrab.text = sl_param.field_ret[2]
END IF

end event

type cb_generar from commandbutton within w_rh514_distribucion_x_trab
integer x = 485
integer y = 432
integer width = 361
integer height = 136
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Generar"
end type

event clicked;String 	ls_origen, ls_ttrab ,ls_msj ,ls_flag
Long   	ll_count
Integer	li_year, li_mes

ls_origen   = String(em_origen.text)
ls_ttrab		= String(em_ttrab.text)
li_year		= Integer(sle_year.text)
li_mes		= Integer(sle_mes.text)

try 
	SetPointer(HourGlass!)

	//verificar exista origen
	select count(*) into :ll_count from origen where cod_origen = :ls_origen;
	
	if ll_count = 0 then
		
		Messagebox('Aviso','Origen No Existe Verifique!', StopSign!)
		em_origen.text = ''
		em_descripcion.text = ''
		em_origen.setFocus( )
		Return
	end if	
	
	//verificar exista tipo de trabajador
	select count(*) 
	  into :ll_count 
	  from  tipo_trabajador 
	where tipo_trabajador = :ls_ttrab ;
	
	if ll_count = 0 then
		Messagebox('Aviso','Tipo de Trabajador No Existe Verifique!', StopSign!)
		em_ttrab.text = ''
		em_desc_ttrab.text = ''
		em_ttrab.setfocus( )
		Return
	end if
	
	// Si ha seleccionado todos los ot_adm simplemente marco todos
	insert into tt_ope_ot_adm(ot_adm)
	select ot_adm
	from ot_administracion;
	
	if SQLCA.SQLCode = -1 then
		ls_msj = SQLCA.SQLErrtext
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar en tabla tt_ope_ot_adm. Mensaje: ' + ls_msj, StopSign!)
		return
	end if
	
	commit;
	
	
	select flag_tabla_origen 
		into :ls_flag 
	from tipo_trabajador 
	where tipo_trabajador = :ls_ttrab ;
		
	if ls_flag = 'A' then
		select count(*) into :ll_count from tt_ope_ot_adm ;	
	
		if ll_count = 0 then
			Messagebox('Aviso','Debe Seleccionar Alguna Administracion ,Verifique!')
			Return
		end if
	else
		//elimino informacion de tabla temporal
		delete from tt_ope_ot_adm ;
		commit;
	end if
			
	//	create or replace procedure usp_rh_dist_horas_x_trab(
	//       ani_year        in number,
	//       ani_mes         in number,
	//       asi_usuario     in usuario.cod_usr%type                 ,
	//       asi_origen      in origen.cod_origen%type               ,
	//       asi_tipo_trab   in tipo_trabajador.tipo_trabajador%type 
	//	) is
	DECLARE usp_rh_dist_horas_x_trab PROCEDURE FOR 
			usp_rh_dist_horas_x_trab( :li_year, 
											  :li_mes,
											  :gs_user, 
											  :ls_origen, 
											  :ls_ttrab ) ;
	EXECUTE usp_rh_dist_horas_x_trab ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_msj = SQLCA.SQLErrText
		Rollback ;
		MessageBox('Error en usp_rh_dist_horas_x_trab', ls_msj)
		return
	end if
	
	Commit ;
	
	Close usp_rh_dist_horas_x_trab;
	
	MessageBox('Atención','Proceso ha Concluído Satisfactoriamente', Exclamation!)
	
finally
	//elimino informacion de tabla temporal
	delete from tt_ope_ot_adm ;
	commit;

	SetPointer(Arrow!)
end try



end event

type cb_2 from commandbutton within w_rh514_distribucion_x_trab
integer x = 475
integer y = 100
integer width = 87
integer height = 76
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_seleccion_origen_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2

OpenWithParm( w_search_origen, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	em_origen.text      = sl_param.field_ret[1]
	em_descripcion.text = sl_param.field_ret[2]
END IF

end event

type em_origen from editmask within w_rh514_distribucion_x_trab
integer x = 265
integer y = 100
integer width = 192
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_descripcion from editmask within w_rh514_distribucion_x_trab
integer x = 585
integer y = 100
integer width = 1467
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type gb_2 from groupbox within w_rh514_distribucion_x_trab
integer y = 20
integer width = 2080
integer height = 576
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
string text = "Ingrese Datos"
end type

