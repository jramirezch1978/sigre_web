$PBExportHeader$w_asi303_asigna_turno_semana.srw
forward
global type w_asi303_asigna_turno_semana from w_abc
end type
type cb_6 from commandbutton within w_asi303_asigna_turno_semana
end type
type cbx_seccion from checkbox within w_asi303_asigna_turno_semana
end type
type cbx_area from checkbox within w_asi303_asigna_turno_semana
end type
type cbx_ttrab from checkbox within w_asi303_asigna_turno_semana
end type
type cbx_origen from checkbox within w_asi303_asigna_turno_semana
end type
type cb_5 from commandbutton within w_asi303_asigna_turno_semana
end type
type cb_4 from commandbutton within w_asi303_asigna_turno_semana
end type
type em_origen from editmask within w_asi303_asigna_turno_semana
end type
type em_ttrab from editmask within w_asi303_asigna_turno_semana
end type
type st_4 from statictext within w_asi303_asigna_turno_semana
end type
type sle_seccion from singlelineedit within w_asi303_asigna_turno_semana
end type
type st_3 from statictext within w_asi303_asigna_turno_semana
end type
type sle_area from singlelineedit within w_asi303_asigna_turno_semana
end type
type cbx_2 from checkbox within w_asi303_asigna_turno_semana
end type
type cbx_1 from checkbox within w_asi303_asigna_turno_semana
end type
type cb_3 from commandbutton within w_asi303_asigna_turno_semana
end type
type em_area from editmask within w_asi303_asigna_turno_semana
end type
type cb_2 from commandbutton within w_asi303_asigna_turno_semana
end type
type sle_origen from singlelineedit within w_asi303_asigna_turno_semana
end type
type st_1 from statictext within w_asi303_asigna_turno_semana
end type
type st_2 from statictext within w_asi303_asigna_turno_semana
end type
type sle_ttrab from singlelineedit within w_asi303_asigna_turno_semana
end type
type em_seccion from editmask within w_asi303_asigna_turno_semana
end type
type cb_1 from commandbutton within w_asi303_asigna_turno_semana
end type
type dw_master from u_dw_abc within w_asi303_asigna_turno_semana
end type
type uo_1 from u_ingreso_rango_fechas within w_asi303_asigna_turno_semana
end type
type dw_1 from datawindow within w_asi303_asigna_turno_semana
end type
type gb_1 from groupbox within w_asi303_asigna_turno_semana
end type
type gb_2 from groupbox within w_asi303_asigna_turno_semana
end type
type gb_3 from groupbox within w_asi303_asigna_turno_semana
end type
type gb_4 from groupbox within w_asi303_asigna_turno_semana
end type
end forward

global type w_asi303_asigna_turno_semana from w_abc
integer width = 2839
integer height = 2532
string title = "Asignacion de Horarios por Plantilla Semanal (ASI303)"
string menuname = "m_proceso"
cb_6 cb_6
cbx_seccion cbx_seccion
cbx_area cbx_area
cbx_ttrab cbx_ttrab
cbx_origen cbx_origen
cb_5 cb_5
cb_4 cb_4
em_origen em_origen
em_ttrab em_ttrab
st_4 st_4
sle_seccion sle_seccion
st_3 st_3
sle_area sle_area
cbx_2 cbx_2
cbx_1 cbx_1
cb_3 cb_3
em_area em_area
cb_2 cb_2
sle_origen sle_origen
st_1 st_1
st_2 st_2
sle_ttrab sle_ttrab
em_seccion em_seccion
cb_1 cb_1
dw_master dw_master
uo_1 uo_1
dw_1 dw_1
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
end type
global w_asi303_asigna_turno_semana w_asi303_asigna_turno_semana

on w_asi303_asigna_turno_semana.create
int iCurrent
call super::create
if this.MenuName = "m_proceso" then this.MenuID = create m_proceso
this.cb_6=create cb_6
this.cbx_seccion=create cbx_seccion
this.cbx_area=create cbx_area
this.cbx_ttrab=create cbx_ttrab
this.cbx_origen=create cbx_origen
this.cb_5=create cb_5
this.cb_4=create cb_4
this.em_origen=create em_origen
this.em_ttrab=create em_ttrab
this.st_4=create st_4
this.sle_seccion=create sle_seccion
this.st_3=create st_3
this.sle_area=create sle_area
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.cb_3=create cb_3
this.em_area=create em_area
this.cb_2=create cb_2
this.sle_origen=create sle_origen
this.st_1=create st_1
this.st_2=create st_2
this.sle_ttrab=create sle_ttrab
this.em_seccion=create em_seccion
this.cb_1=create cb_1
this.dw_master=create dw_master
this.uo_1=create uo_1
this.dw_1=create dw_1
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_6
this.Control[iCurrent+2]=this.cbx_seccion
this.Control[iCurrent+3]=this.cbx_area
this.Control[iCurrent+4]=this.cbx_ttrab
this.Control[iCurrent+5]=this.cbx_origen
this.Control[iCurrent+6]=this.cb_5
this.Control[iCurrent+7]=this.cb_4
this.Control[iCurrent+8]=this.em_origen
this.Control[iCurrent+9]=this.em_ttrab
this.Control[iCurrent+10]=this.st_4
this.Control[iCurrent+11]=this.sle_seccion
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.sle_area
this.Control[iCurrent+14]=this.cbx_2
this.Control[iCurrent+15]=this.cbx_1
this.Control[iCurrent+16]=this.cb_3
this.Control[iCurrent+17]=this.em_area
this.Control[iCurrent+18]=this.cb_2
this.Control[iCurrent+19]=this.sle_origen
this.Control[iCurrent+20]=this.st_1
this.Control[iCurrent+21]=this.st_2
this.Control[iCurrent+22]=this.sle_ttrab
this.Control[iCurrent+23]=this.em_seccion
this.Control[iCurrent+24]=this.cb_1
this.Control[iCurrent+25]=this.dw_master
this.Control[iCurrent+26]=this.uo_1
this.Control[iCurrent+27]=this.dw_1
this.Control[iCurrent+28]=this.gb_1
this.Control[iCurrent+29]=this.gb_2
this.Control[iCurrent+30]=this.gb_3
this.Control[iCurrent+31]=this.gb_4
end on

on w_asi303_asigna_turno_semana.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_6)
destroy(this.cbx_seccion)
destroy(this.cbx_area)
destroy(this.cbx_ttrab)
destroy(this.cbx_origen)
destroy(this.cb_5)
destroy(this.cb_4)
destroy(this.em_origen)
destroy(this.em_ttrab)
destroy(this.st_4)
destroy(this.sle_seccion)
destroy(this.st_3)
destroy(this.sle_area)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.cb_3)
destroy(this.em_area)
destroy(this.cb_2)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_ttrab)
destroy(this.em_seccion)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.uo_1)
destroy(this.dw_1)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos

idw_1 = dw_master              				// asignar dw corriente
//idw_query = dw_master								// ventana para query


         		// bloquear modificaciones 


of_position_window(0,0)       			// Posicionar la ventana en forma fija

end event

type cb_6 from commandbutton within w_asi303_asigna_turno_semana
integer x = 1975
integer y = 32
integer width = 814
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesar Horarios Asignados"
end type

event clicked;String  ls_msj_err,ls_cod_trabajador,ls_flag_marca
Long    ll_inicio
Date    ld_fecha_inicio,ld_fecha_final
Boolean lb_ret = TRUE

dw_1.Accepttext()
dw_master.Accepttext()


ld_fecha_inicio = uo_1.of_get_fecha1()
ld_fecha_final  = uo_1.of_get_fecha2()

//actualiza dw temporal

if dw_1.Update() = -1 then //fallo tabal temporal
	Messagebox('Aviso','Fallo Actualizacion de Tabla Temporal')
	Return
end if



//llena tabla temporal
DECLARE PB_usp_rrhh_dias_trans PROCEDURE FOR usp_rrhh_dias_trans
(:ld_fecha_inicio,:ld_fecha_final);
EXECUTE PB_usp_rrhh_dias_trans ;



IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	lb_ret = FALSE
   GOTO SALIDA
END IF


For ll_inicio = 1 to dw_master.rowcount ()
	 ls_cod_trabajador = dw_master.object.cod_trabajador [ll_inicio]
	 ls_flag_marca		 = dw_master.object.flag_marca     [ll_inicio]

	 
	 if ls_flag_marca = '1' then
		 //actualiza informacion
		 delete from rrhh_asignacion_turnos
	  	  where (cod_trabajador = :ls_cod_trabajador               ) and
	  		     (fecha				in (select fecha from tt_rrhh_dias)) ;
	
	    IF SQLCA.SQLCode = -1 THEN 
       	 ls_msj_err = SQLCA.SQLErrText
		  	 lb_ret = FALSE
		  	 GOTO SALIDA
	 	 END IF
	 
	 	 Insert Into rrhh_asignacion_turnos
	 	 (cod_trabajador,fecha,turno)
	 	 select :ls_cod_trabajador,fecha,decode(to_char(fecha,'d'),'1',d1,'2',d2,'3',d3,'4',d4,'5',d5,'6',d6,'7',d7 )
	      from tt_rrhh_dias,tt_asis_semana 
        where decode(to_char(fecha,'d'),'1',d1,'2',d2,'3',d3,'4',d4,'5',d5,'6',d6,'7',d7 ) is not null ;



	
	  	 IF SQLCA.SQLCode = -1 THEN 
       	 ls_msj_err = SQLCA.SQLErrText
		  	 lb_ret = FALSE
		  	 GOTO SALIDA
	 	 END IF
	 
	 end if
	 
Next

SALIDA:

IF lb_ret THEN
	Commit ;
	Messagebox('Aviso','Proceso se Culmino Satisfactoriamente')
ELSE
	Rollback ;
	Messagebox('Aviso',ls_msj_err)
END IF	

Commit ;

CLOSE PB_usp_rrhh_dias_trans ;


end event

type cbx_seccion from checkbox within w_asi303_asigna_turno_semana
integer x = 1920
integer y = 948
integer width = 288
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_seccion.enabled = FALSE
else	
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_seccion.enabled = true
end if
end event

type cbx_area from checkbox within w_asi303_asigna_turno_semana
integer x = 1920
integer y = 856
integer width = 288
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_area.text = ''
	em_area.text  = ''
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_area.enabled    = FALSE
	sle_seccion.enabled = FALSE
	cbx_seccion.enabled = FALSE
	cbx_seccion.checked = TRUE
else	
	sle_area.text = ''
	em_area.text  = ''
	sle_seccion.text = ''
	em_seccion.text  = ''
	sle_area.enabled    = true
	sle_seccion.enabled = true
	cbx_seccion.enabled = true
	cbx_seccion.checked = FALSE
end if
end event

type cbx_ttrab from checkbox within w_asi303_asigna_turno_semana
integer x = 1920
integer y = 764
integer width = 288
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_ttrab.text = ''
	em_ttrab.text  = ''
	sle_ttrab.enabled = FALSE
else	
	sle_ttrab.text = ''
	em_ttrab.text  = ''
	sle_ttrab.enabled = true
end if
end event

type cbx_origen from checkbox within w_asi303_asigna_turno_semana
integer x = 1920
integer y = 672
integer width = 288
integer height = 56
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Todos"
end type

event clicked;if this.checked then
	sle_origen.text = ''
	sle_origen.enabled = FALSE
else	
	sle_origen.text = ''
	sle_origen.enabled = true
end if
end event

type cb_5 from commandbutton within w_asi303_asigna_turno_semana
integer x = 594
integer y = 752
integer width = 73
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_ttrab.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_seleccion_tiptra_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_ttrab.text    = sl_param.field_ret[1]
		em_ttrab.text = sl_param.field_ret[2]
	END IF
end if	

end event

type cb_4 from commandbutton within w_asi303_asigna_turno_semana
integer x = 594
integer y = 944
integer width = 73
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_seccion.checked = false then
	// Abre ventana de ayuda 
	String ls_area
	str_parametros sl_param


	ls_area = sle_area.text

	sl_param.dw1 = "d_abc_seccion_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.tipo	  = '1S'
	sl_param.string1 = ls_area
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_seccion.text    = sl_param.field_ret[1]
		em_seccion.text = sl_param.field_ret[2]
	END IF
end if	

end event

type em_origen from editmask within w_asi303_asigna_turno_semana
integer x = 686
integer y = 660
integer width = 1211
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type em_ttrab from editmask within w_asi303_asigna_turno_semana
integer x = 686
integer y = 752
integer width = 1211
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type st_4 from statictext within w_asi303_asigna_turno_semana
integer x = 91
integer y = 940
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Sección :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_seccion from singlelineedit within w_asi303_asigna_turno_semana
integer x = 352
integer y = 936
integer width = 233
integer height = 84
integer taborder = 50
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_asi303_asigna_turno_semana
integer x = 101
integer y = 764
integer width = 215
integer height = 80
boolean bringtotop = true
integer textsize = -7
integer weight = 700
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

type sle_area from singlelineedit within w_asi303_asigna_turno_semana
integer x = 352
integer y = 844
integer width = 233
integer height = 84
integer taborder = 50
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
borderstyle borderstyle = stylelowered!
end type

type cbx_2 from checkbox within w_asi303_asigna_turno_semana
integer x = 1975
integer y = 1304
integer width = 558
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Desmarcar Todos"
end type

event clicked;Long ll_inicio

if this.checked then
	cbx_1.checked = false
	For ll_inicio = 1 to dw_master.Rowcount()
	    dw_master.object.flag_marca [ll_inicio] = '0'
	Next	
end if	
end event

type cbx_1 from checkbox within w_asi303_asigna_turno_semana
integer x = 1975
integer y = 1188
integer width = 558
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Marcar Todos"
end type

event clicked;Long ll_inicio

if this.checked then
	cbx_2.checked = false
	For ll_inicio = 1 to dw_master.Rowcount()
		 dw_master.object.flag_marca [ll_inicio] = '1'
	Next	
end if	
end event

type cb_3 from commandbutton within w_asi303_asigna_turno_semana
integer x = 594
integer y = 848
integer width = 73
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_area.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_abc_area_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_tiptra, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_area.text    = sl_param.field_ret[1]
		em_area.text = sl_param.field_ret[2]
	END IF
end if	

end event

type em_area from editmask within w_asi303_asigna_turno_semana
integer x = 686
integer y = 844
integer width = 1211
integer height = 80
integer taborder = 60
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_2 from commandbutton within w_asi303_asigna_turno_semana
integer x = 594
integer y = 656
integer width = 73
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;if cbx_origen.checked = false then
	// Abre ventana de ayuda 

	str_parametros sl_param

	sl_param.dw1 = "d_seleccion_origen_tbl"
	sl_param.titulo = "Seleccionar Búsqueda"
	sl_param.field_ret_i[1] = 1
	sl_param.field_ret_i[2] = 2

	OpenWithParm( w_search_origen, sl_param)		
	sl_param = MESSAGE.POWEROBJECTPARM
	IF sl_param.titulo <> 'n' THEN
		sle_origen.text     = sl_param.field_ret[1]
		em_origen.text = sl_param.field_ret[2]
	END IF
	
end if
end event

type sle_origen from singlelineedit within w_asi303_asigna_turno_semana
integer x = 352
integer y = 660
integer width = 233
integer height = 84
integer taborder = 50
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_asi303_asigna_turno_semana
integer x = 101
integer y = 668
integer width = 215
integer height = 80
boolean bringtotop = true
integer textsize = -7
integer weight = 700
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

type st_2 from statictext within w_asi303_asigna_turno_semana
integer x = 91
integer y = 848
integer width = 215
integer height = 72
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 79741120
string text = "Area :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_ttrab from singlelineedit within w_asi303_asigna_turno_semana
integer x = 352
integer y = 752
integer width = 233
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type em_seccion from editmask within w_asi303_asigna_turno_semana
integer x = 686
integer y = 936
integer width = 1211
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -7
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217752
boolean displayonly = true
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
end type

type cb_1 from commandbutton within w_asi303_asigna_turno_semana
integer x = 2272
integer y = 668
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Buscar"
end type

event clicked;String ls_area,ls_origen,ls_seccion,ls_ttrab
Long   ll_count

ls_area    = sle_area.text
ls_seccion = sle_seccion.text
ls_origen  = sle_origen.text
ls_ttrab	  = sle_ttrab.text



IF Isnull(ls_area) or trim(ls_area) = '' THEN
	if cbx_area.checked then
		ls_area = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Area del Trabajador')
		Return
	end if
ELSE
	select Count(*) into :ll_count from area 
    where (cod_area = :ls_area) ;
	 
	if ll_count = 0 then
		Messagebox('Aviso','Area No existe ,Verifique!')
		Return
	end if

	
END IF	

IF Isnull(ls_seccion) or trim(ls_seccion) = '' THEN
	if cbx_seccion.checked then
		ls_seccion = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para la Seccion del Trabajador')
		Return

	end if
ELSE
//	messabeox
	select Count(*) into :ll_count from seccion s 
    where (s.cod_area    = :ls_area    ) and
          (s.cod_seccion = :ls_seccion ) and
          (s.flag_estado = '1'         ) ;
 
	if ll_count = 0 then
		Messagebox('Aviso','Seccion No existe ,Verifique!')
		Return
	end if
END IF	


IF Isnull(ls_origen) or trim(ls_origen) = '' THEN
	if cbx_origen.checked then
		ls_origen = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Origen del Trabajador')
		Return
		
	end if
ELSE
	select Count(*) into :ll_count from origen 
	 where (cod_origen  = :ls_origen ) and 
   	    (flag_estado = '1'        ) ;

			 
	if ll_count = 0 then
		Messagebox('Aviso','Origen No existe ,Verifique!')
		Return
	end if
			 
END IF

IF Isnull(ls_ttrab) or trim(ls_ttrab) = '' THEN
	if cbx_ttrab.checked then
		ls_ttrab = '%'
	else
		//debe colocar un dato
		Messagebox('Aviso','Debe Colocar un Dato para el Tipo de Trabajador')
		Return
	end if
ELSE
	Select Count(*) into :ll_count from tipo_trabajador
	 where (tipo_trabajador = :ls_ttrab ) and
	 		 (flag_estado		= '1'			);
			  
   
	if ll_count = 0 then
		Messagebox('Aviso','Tipo de Trabajador No existe ,Verifique!')
		Return
	end if
	
END IF



dw_master.Retrieve(ls_origen,ls_ttrab,ls_area,ls_seccion)
end event

type dw_master from u_dw_abc within w_asi303_asigna_turno_semana
integer x = 59
integer y = 1144
integer width = 1819
integer height = 804
integer taborder = 20
string dataobject = "d_maestro_personal_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,

is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1		// columnas de lectrua de este dw


idw_mst = dw_master

end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

type uo_1 from u_ingreso_rango_fechas within w_asi303_asigna_turno_semana
integer x = 105
integer y = 116
integer taborder = 30
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date('01/01/1900'), date('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type dw_1 from datawindow within w_asi303_asigna_turno_semana
integer x = 78
integer y = 360
integer width = 1842
integer height = 164
integer taborder = 10
string title = "none"
string dataobject = "d_abc_horario_semana_tbl"
boolean border = false
boolean livescroll = true
end type

event constructor;Settransobject(sqlca)
InsertRow(0)
end event

event itemerror;Return 1
end event

event itemchanged;Long ll_count 

Accepttext()

//verificar que turno exista
select Count(*) into :ll_count 
  from rrhh_turno_asistencia
 where (turno = :data) ;

 
if ll_count = 0 then
	Messagebox('Aviso','Turno No Existe ,Verifique!')
	Return 1
end if

end event

event doubleclicked;String ls_name

IF Getrow() = 0 THEN Return


Str_seleccionar lstr_seleccionar


ls_name = dwo.name

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT RRHH_TURNO_ASISTENCIA.TURNO AS CODIGO ,'&
								   	 +'RRHH_TURNO_ASISTENCIA.HORA_ENTRADA AS HORA_ENTRADA,'&
										 +'RRHH_TURNO_ASISTENCIA.HORA_SALIDA AS HORA_SALIDA '&
					   				 +'FROM RRHH_TURNO_ASISTENCIA '

				
OpenWithParm(w_seleccionar,lstr_seleccionar)
			
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
	IF lstr_seleccionar.s_action = "aceptar" THEN
		Setitem(row,ls_name,lstr_seleccionar.param1[1])
	END IF
				
				

end event

type gb_1 from groupbox within w_asi303_asigna_turno_semana
integer x = 64
integer y = 40
integer width = 1408
integer height = 212
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_asi303_asigna_turno_semana
integer x = 64
integer y = 284
integer width = 1925
integer height = 288
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Semana"
end type

type gb_3 from groupbox within w_asi303_asigna_turno_semana
integer x = 32
integer y = 1076
integer width = 1906
integer height = 924
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Trabajadores"
end type

type gb_4 from groupbox within w_asi303_asigna_turno_semana
integer x = 50
integer y = 600
integer width = 2619
integer height = 444
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Datos"
end type

