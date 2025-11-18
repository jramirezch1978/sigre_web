$PBExportHeader$w_rpt_preview.srw
forward
global type w_rpt_preview from w_report_smpl
end type
end forward

global type w_rpt_preview from w_report_smpl
integer width = 2811
integer height = 1940
string title = ""
string menuname = "m_impresion"
end type
global w_rpt_preview w_rpt_preview

type variables

end variables

on w_rpt_preview.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rpt_preview.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;istr_rep = message.powerobjectparm

idw_1 = dw_report
idw_1.Visible = False

this.Event ue_preview()
This.Event ue_retrieve()

end event

event ue_retrieve;call super::ue_retrieve;String ls_cad1, ls_cad2

this.title = istr_rep.titulo
dw_report.dataobject = istr_rep.dw1
dw_report.SetTransObject(sqlca)

CHOOSE CASE istr_rep.tipo 
		case '1S'
			dw_report.retrieve(istr_rep.string1)
		case '1L'
			dw_report.retrieve(istr_rep.long1)
		case '1L1A'			
			dw_report.retrieve(istr_rep.long1, istr_rep.field_ret)
		case '1L1S'
			dw_report.retrieve(istr_rep.long1, istr_rep.string1)
		case '2S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2)
		case '3S'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.string3)
		case '1S2S1D'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.date1)
		case '1S1D'
			dw_report.retrieve(istr_rep.string1, istr_rep.date1)
		case '1S1D2D'
			dw_report.retrieve(istr_rep.string1, istr_rep.date1, istr_rep.date2)
		case '1S2S1D2D'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.date1, istr_rep.date2)
		case '1S1L2L3L'
			dw_report.retrieve(istr_rep.string1, istr_rep.long1, istr_rep.long2, istr_rep.long3)
		case '1S2S1L2L3L'
			dw_report.retrieve(istr_rep.string1, istr_rep.string2, istr_rep.long1, istr_rep.long2, istr_rep.long3)
		case else
			dw_report.retrieve()
	END CHOOSE


//dw_report.Retrieve(ls_Cad1, ls_cad2 )
ib_preview = false
this.event ue_preview()
dw_report.Visible = True

idw_1.object.p_logo.FileName 	= gs_logo
idw_1.object.t_empresa.text	= gs_empresa
idw_1.object.t_usuario.text	= gs_user
idw_1.object.t_objeto.text		= this.Classname( )

if istr_rep.opcion = 1 then
	// Opción para ponerle los subtitulos 1 y 2
	idw_1.object.subtitulo_1.text = istr_rep.subtitulo1
	
elseif istr_rep.opcion = 2 then
	
	// Opción para ponerle los subtitulos 1 y 2
	idw_1.object.subtitulo_1.text = istr_rep.subtitulo1
	idw_1.object.subtitulo_2.text = istr_rep.subtitulo2
	
elseif istr_rep.opcion = 3 then
	
	// Opción para ponerle los subtitulos 1, 2 y 3
	idw_1.object.subtitulo_1.text = istr_rep.subtitulo1
	idw_1.object.subtitulo_2.text = istr_rep.subtitulo2
	idw_1.object.subtitulo_3.text = istr_rep.subtitulo3

end if

idw_1.ii_zoom_actual = 100
idw_1.modify('datawindow.print.preview.zoom = ' + String(idw_1.ii_zoom_actual))
end event

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()

end event

type dw_report from w_report_smpl`dw_report within w_rpt_preview
integer width = 1755
integer height = 1552
end type

event dw_report::doubleclicked;call super::doubleclicked;string		ls_grupo_art, ls_desc_grupo_art, &
				ls_origen, ls_nom_origen, ls_nave, &
				ls_nom_nave
Long			ll_mes1, ll_mes2, ll_year				
sg_parametros 	lstr_param
w_rpt_preview lw_1

if this.dataobject = 'd_rpt_cg_cc7_tbl' then
	ls_desc_grupo_art = this.object.desc_grupo_art	[row]
	ls_nom_origen		= this.object.origen_nombre	[row]
	
	select grupo_art
		into :ls_grupo_art
	from articulo_grupo
	where desc_grupo_art = :ls_desc_grupo_art;
	
	select cod_origen
		into :ls_origen
	from origen
	where nombre = :ls_nom_origen;
	
	lstr_param.string1 = ls_origen
	lstr_param.string2 = ls_grupo_art
	lstr_param.date1	 = istr_rep.date1
	lstr_param.tipo	 = '1S2S1D'
	lstr_param.dw1		 = 'd_rpt_cg_cc7_detalle_tbl'
	lstr_param.subtitulo1 = 'ORIGEN: ' + ls_nom_origen
	lstr_param.subtitulo2 = 'GRUPO: ' + ls_desc_grupo_art
	lstr_param.opcion	 = 2
	
	OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
	
elseif this.dataobject = 'd_rpt_cg_cc1_tbl' then
	
	if dwo.name = 'mes' or dwo.name = 'periodo' or &
		dwo.name = 'anual' or dwo.name = 'presup' then
		ls_desc_grupo_art = this.object.desc_grupo_art	[row]
		ls_nom_origen		= this.object.origen				[row]
		
		select grupo_art
			into :ls_grupo_art
		from articulo_grupo
		where desc_grupo_art = :ls_desc_grupo_art;
		
		select cod_origen
			into :ls_origen
		from origen
		where nombre = :ls_nom_origen;
	end if
	
	choose case dwo.name
		case 'periodo'
			
			lstr_param.string1 = ls_origen
			lstr_param.string2 = ls_grupo_art
			lstr_param.date1	 = istr_rep.date1
			lstr_param.date2	 = istr_rep.date2
			lstr_param.tipo	 = '1S2S1D2D'
			lstr_param.dw1		 = 'd_rpt_cg_cc1_detalle1_tbl'
			lstr_param.titulo		 = 'DETALLE DE PRODUCCIÓN POR PLANTA x PERIODO'			
			lstr_param.subtitulo1 = 'ORIGEN: ' + ls_nom_origen
			lstr_param.subtitulo2 = 'GRUPO: ' + ls_desc_grupo_art
			lstr_param.subtitulo3 = 'PERIODO DEL: ' + string(istr_rep.date1, 'dd/mm/yyyy') &
				+ ' AL ' + string(istr_rep.date2, 'dd/mm/yyyy')
			lstr_param.opcion	 = 3
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
			
		case 'mes'

			lstr_param.string1 = ls_origen
			lstr_param.string2 = ls_grupo_art
			lstr_param.date1	 = istr_rep.date2
			lstr_param.tipo	 = '1S2S1D'
			lstr_param.dw1		 = 'd_rpt_cg_cc1_detalle2_tbl'
			lstr_param.titulo		 = 'DETALLE DE PRODUCCIÓN POR PLANTA x MES'			
			lstr_param.subtitulo1 = 'ORIGEN: ' + ls_nom_origen
			lstr_param.subtitulo2 = 'GRUPO: ' + ls_desc_grupo_art
			lstr_param.subtitulo3 = 'MES: ' + string(istr_rep.date2, 'mm/yyyy') 
			lstr_param.opcion	 = 3
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )

		case 'anual'

			lstr_param.string1 = ls_origen
			lstr_param.string2 = ls_grupo_art
			lstr_param.date1	 = istr_rep.date2
			lstr_param.tipo	 = '1S2S1D'
			lstr_param.dw1		 = 'd_rpt_cg_cc1_detalle3_tbl'
			lstr_param.titulo		 = 'DETALLE DE PRODUCCIÓN POR PLANTA x ANUAL'			
			lstr_param.subtitulo1 = 'ORIGEN: ' + ls_nom_origen
			lstr_param.subtitulo2 = 'GRUPO: ' + ls_desc_grupo_art
			lstr_param.subtitulo3 = 'AÑO: ' + string(istr_rep.date2, 'yyyy') 
			lstr_param.opcion	 = 3
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
		
		case 'presup'
			ll_year = Long(string(istr_rep.date2, 'yyyy'))
			if istr_rep.prorrateo = '0' then
				// no se prorratea
				ll_mes1 = 1
				ll_mes2 = 12
				lstr_param.string1 = ls_origen
				lstr_param.string2 = ls_grupo_art
				lstr_param.long1	 = ll_mes1
				lstr_param.long2	 = ll_mes2
				lstr_param.long3	 = ll_year
				lstr_param.tipo	 = '1S2S1L2L3L'
				lstr_param.titulo	 = 'DETALLE DE PRODUCCIÓN POR PLANTA PROYECTADO'			
				lstr_param.dw1		 = 'd_rpt_cg_cc1_detalle4_tbl'
				lstr_param.subtitulo1 = 'ORIGEN: ' + ls_nom_origen
				lstr_param.subtitulo2 = 'GRUPO: ' + ls_desc_grupo_art
				lstr_param.subtitulo3 = 'PRESUPUESTADO DEL AÑO: ' + string(istr_rep.date2, 'yyyy') 
				lstr_param.opcion	 = 3				
			end if
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
			
	end choose
	
elseif this.dataobject = 'd_rpt_cg_cc2_tbl' then
	
	ls_nave = this.object.nave[row]
	ls_nom_nave = this.object.nomb_nave[row]
	
	
	choose case dwo.name
		case 'periodo'
			
			lstr_param.string1 = ls_nave
			lstr_param.date1	 = istr_rep.date1
			lstr_param.date2	 = istr_rep.date2
			lstr_param.tipo	 = '1S1D2D'
			lstr_param.titulo	 = 'DETALLE DE CAPTURA DE PESCA X PERIODO'			
			lstr_param.dw1		 = 'd_rpt_cg_cc2_detalle1_tbl'
			lstr_param.subtitulo1 = 'EMBARCACIÓN: ' + ls_nom_nave
			lstr_param.subtitulo2 = 'PERIODO DEL: ' + string(istr_rep.date1, 'dd/mm/yyyy') &
				+ ' AL ' + string(istr_rep.date2, 'dd/mm/yyyy')
			lstr_param.opcion	 = 2		
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
		
		
		case 'mes'
			
			lstr_param.string1 = ls_nave
			lstr_param.date1	 = istr_rep.date2
			lstr_param.tipo	 = '1S1D'
			lstr_param.titulo	 = 'DETALLE DE CAPTURA DE PESCA X MES'			
			lstr_param.dw1		 = 'd_rpt_cg_cc2_detalle2_tbl'
			lstr_param.subtitulo1 = 'EMBARCACIÓN: ' + ls_nom_nave
			lstr_param.subtitulo2 = 'MES DEL: ' + string(istr_rep.date2, 'mm/yyyy') 
			lstr_param.opcion	 = 2		
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
			
		case 'anual'
			
			lstr_param.string1 = ls_nave
			lstr_param.date1	 = istr_rep.date2
			lstr_param.tipo	 = '1S1D'
			lstr_param.titulo	 = 'DETALLE DE CAPTURA DE PESCA X AÑO'			
			lstr_param.dw1		 = 'd_rpt_cg_cc2_detalle3_tbl'
			lstr_param.subtitulo1 = 'EMBARCACIÓN: ' + ls_nom_nave
			lstr_param.subtitulo2 = 'AÑO: ' + string(istr_rep.date2, 'yyyy') 
			lstr_param.opcion	 = 2		
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )

		case 'presup'
			ll_year = Long(string(istr_rep.date2, 'yyyy'))
			if istr_rep.prorrateo = '0' then
				// no se prorratea
				ll_mes1 = 1
				ll_mes2 = 12
				lstr_param.string1 = ls_nave
				lstr_param.long1	 = ll_mes1
				lstr_param.long2	 = ll_mes2
				lstr_param.long3	 = ll_year
				lstr_param.tipo	 = '1S1L2L3L'
				lstr_param.titulo	 = 'DETALLE DE CAPTURA DE PESCA PROYECTADO'			
				lstr_param.dw1		 = 'd_rpt_cg_cc2_detalle4_tbl'
				lstr_param.subtitulo1 = 'EMBARCACIÓN: ' + ls_nom_nave
				lstr_param.subtitulo2 = 'PRESUPUESTADO DEL AÑO: ' + string(istr_rep.date2, 'yyyy') 
				lstr_param.opcion	 = 2		
			end if
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
			
		case 'costo_var'
			lstr_param.string1 = ls_nave
			lstr_param.tipo	 = '1S'
			lstr_param.titulo	 = 'DETALLE DE COSTO VARIABLE X EMBARCACIÓN'			
			lstr_param.dw1		 = 'd_rpt_cg_cc2_detalle5_tbl'
			lstr_param.subtitulo1 = 'EMBARCACIÓN: ' + ls_nom_nave
			lstr_param.subtitulo2 = 'PERIODO DEL: ' + string(istr_rep.date1, 'dd/mm/yyyy') &
				+ ' AL ' + string(istr_rep.date2, 'dd/mm/yyyy')
			lstr_param.opcion	 = 2		
			
			OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )

			
	end choose

elseif this.dataobject = 'd_rpt_cg_cc5_tbl' then
	ls_desc_grupo_art = this.object.desc_grupo_art	[row]
	
	select grupo_art
		into :ls_grupo_art
	from articulo_grupo
	where desc_grupo_art = :ls_desc_grupo_art;
	
	lstr_param.string1 = ls_grupo_art
	lstr_param.date1	 = istr_rep.date2
	lstr_param.tipo	 = '1S1D'
	lstr_param.dw1		 = 'd_rpt_cg_cc5_detalle1_tbl'
	lstr_param.subtitulo1 = 'GRUPO: ' + ls_desc_grupo_art
	lstr_param.subtitulo2 = 'FECHA TOPE: ' + string(istr_rep.date2, 'dd/mm/yyyy')
	lstr_param.opcion	 = 2
	
	OpenSheetWithParm(lw_1, lstr_param, w_main, 0, Layered! )
	
end if
end event

