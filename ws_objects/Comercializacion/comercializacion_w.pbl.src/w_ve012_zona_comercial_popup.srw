$PBExportHeader$w_ve012_zona_comercial_popup.srw
forward
global type w_ve012_zona_comercial_popup from w_abc_master
end type
type cb_guardar from commandbutton within w_ve012_zona_comercial_popup
end type
end forward

global type w_ve012_zona_comercial_popup from w_abc_master
integer width = 1577
integer height = 516
string title = "(VE012) Insercion"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_guardar cb_guardar
end type
global w_ve012_zona_comercial_popup w_ve012_zona_comercial_popup

type variables
long il_nivel
end variables

on w_ve012_zona_comercial_popup.create
int iCurrent
call super::create
this.cb_guardar=create cb_guardar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_guardar
end on

on w_ve012_zona_comercial_popup.destroy
call super::destroy
destroy(this.cb_guardar)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true
end event

event open;//Override
str_parametros sgt_parametros
string ls_mensaje, ls_pais, ls_dpto, ls_prov, ls_cod

//asignando texto a variable
sgt_parametros = message.POWEROBJECTPARM

ls_mensaje = trim(sgt_parametros.dw_master)
il_nivel	  = sgt_parametros.long1

ls_pais	  = trim(sgt_parametros.string1)
ls_dpto	  = trim(sgt_parametros.string2)
ls_prov	  = trim(sgt_parametros.string3)

//displayando texto enviado en el MLE
dw_master.dataobject = trim(ls_mensaje)

dw_master.SEttransobject(sqlca)

dw_master.Insertrow( 0 )

dw_master.SetFocus()

choose case il_nivel
		
	case 3 //distrito
		
		dw_master.object.cod_pais[1] = ls_pais
		dw_master.object.cod_dpto[1] = ls_dpto
		dw_master.object.cod_prov[1] = ls_prov
		
		select to_char('0000'||to_number(max(nvl(cod_distr,0)) + 1))
		  into :ls_cod
		  from distrito
		 where cod_pais = :ls_pais
		   and cod_dpto = :ls_dpto
			and cod_prov = :ls_prov;
		  
		ls_cod = right(ls_cod,4)
		
		if ls_cod = '0000' then ls_cod = '0001'
		
		dw_master.object.cod_distr[1] = ls_cod
		
	case 2 //provincia
		
		dw_master.object.cod_pais[1] = ls_pais
		dw_master.object.cod_dpto[1] = ls_dpto
		
		select to_char('000'||to_number(max(nvl(cod_prov,0)) + 1))
		  into :ls_cod
		  from provincia_condado
		 where cod_pais = :ls_pais
		   and cod_dpto = :ls_dpto;
		  
		ls_cod = right(ls_cod,3)
		
		if ls_cod = '000' then ls_cod = '001'
		
		dw_master.object.cod_prov[1] = ls_cod
		
	case 1 //departamento
		
		dw_master.object.cod_pais[1] = ls_pais
		
		select to_char('000'||to_number(max(nvl(cod_dpto,0)) + 1))
		  into :ls_cod
		  from departamento_estado
		 where cod_pais = :ls_pais;
		  
		ls_cod = right(ls_cod,3)
		
		if ls_cod = '000' then ls_cod = '001'
		
		dw_master.object.cod_dpto[1] = ls_cod

	case else
		
		return
		
end choose
end event

event resize;//Override
end event

type dw_master from w_abc_master`dw_master within w_ve012_zona_comercial_popup
integer x = 37
integer y = 32
integer width = 1467
integer height = 228
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		  		// 'm' = master sin detalle (default), 'd' =  detalle,
                       		// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  		// tabular, form (default)

ii_ss = 1 				  		// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1				   // columnas de lectrua de este dw

idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

type cb_guardar from commandbutton within w_ve012_zona_comercial_popup
integer x = 1175
integer y = 288
integer width = 329
integer height = 100
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Guardar"
boolean default = true
end type

event clicked;parent.event ue_update()

str_parametros sgt_parametros

choose case il_nivel
		
	case 3 //insercion de distrito
		
		sgt_parametros.string1 = dw_master.object.cod_distr[1]
		sgt_parametros.string2 = dw_master.object.desc_distrito[1]
		
	case 2 //insercion de provincia
		
		sgt_parametros.string1 = dw_master.object.cod_prov[1]
		sgt_parametros.string2 = dw_master.object.desc_prov[1]
		
	case 1 //insercion de departamento
		
		sgt_parametros.string1 = dw_master.object.cod_dpto[1]
		sgt_parametros.string2 = dw_master.object.desc_dpto[1]

	case else
		
		return
		
end choose

closewithreturn(parent,sgt_parametros)
end event

