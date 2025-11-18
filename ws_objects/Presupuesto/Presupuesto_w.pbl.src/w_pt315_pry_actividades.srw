$PBExportHeader$w_pt315_pry_actividades.srw
forward
global type w_pt315_pry_actividades from w_abc
end type
type cb_2 from commandbutton within w_pt315_pry_actividades
end type
type cb_1 from commandbutton within w_pt315_pry_actividades
end type
type tab_main from tab within w_pt315_pry_actividades
end type
type tabpage_pactv from userobject within tab_main
end type
type tab_actv from tab within tabpage_pactv
end type
type tabpage_actvsec from userobject within tab_actv
end type
type dw_sec from u_dw_abc within tabpage_actvsec
end type
type tabpage_actvsec from userobject within tab_actv
dw_sec dw_sec
end type
type tabpage_actvlst from userobject within tab_actv
end type
type dw_actvlst from u_dw_abc within tabpage_actvlst
end type
type dw_seccion from datawindow within tabpage_actvlst
end type
type tabpage_actvlst from userobject within tab_actv
dw_actvlst dw_actvlst
dw_seccion dw_seccion
end type
type tabpage_actvdef from userobject within tab_actv
end type
type tab_actvcst from tab within tabpage_actvdef
end type
type tabpage_rec from userobject within tab_actvcst
end type
type dw_actrec from u_dw_abc within tabpage_rec
end type
type tabpage_rec from userobject within tab_actvcst
dw_actrec dw_actrec
end type
type tabpage_mat from userobject within tab_actvcst
end type
type dw_actmat from u_dw_abc within tabpage_mat
end type
type tabpage_mat from userobject within tab_actvcst
dw_actmat dw_actmat
end type
type tabpage_serv from userobject within tab_actvcst
end type
type dw_actserv from u_dw_abc within tabpage_serv
end type
type tabpage_serv from userobject within tab_actvcst
dw_actserv dw_actserv
end type
type tabpage_otr from userobject within tab_actvcst
end type
type dw_actotr from u_dw_abc within tabpage_otr
end type
type tabpage_otr from userobject within tab_actvcst
dw_actotr dw_actotr
end type
type tab_actvcst from tab within tabpage_actvdef
tabpage_rec tabpage_rec
tabpage_mat tabpage_mat
tabpage_serv tabpage_serv
tabpage_otr tabpage_otr
end type
type dw_actvdef from u_dw_abc within tabpage_actvdef
end type
type tabpage_actvdef from userobject within tab_actv
tab_actvcst tab_actvcst
dw_actvdef dw_actvdef
end type
type tab_actv from tab within tabpage_pactv
tabpage_actvsec tabpage_actvsec
tabpage_actvlst tabpage_actvlst
tabpage_actvdef tabpage_actvdef
end type
type tabpage_pactv from userobject within tab_main
tab_actv tab_actv
end type
type tabpage_pcst from userobject within tab_main
end type
type tab_cst from tab within tabpage_pcst
end type
type tabpage_cstrec from userobject within tab_cst
end type
type dw_cstrec from u_dw_abc within tabpage_cstrec
end type
type tabpage_cstrec from userobject within tab_cst
dw_cstrec dw_cstrec
end type
type tabpage_cstmat from userobject within tab_cst
end type
type dw_cstmat from u_dw_abc within tabpage_cstmat
end type
type tabpage_cstmat from userobject within tab_cst
dw_cstmat dw_cstmat
end type
type tabpage_cstserv from userobject within tab_cst
end type
type dw_cstserv from u_dw_abc within tabpage_cstserv
end type
type tabpage_cstserv from userobject within tab_cst
dw_cstserv dw_cstserv
end type
type tabpage_cstotr from userobject within tab_cst
end type
type dw_cstotr from u_dw_abc within tabpage_cstotr
end type
type tabpage_cstotr from userobject within tab_cst
dw_cstotr dw_cstotr
end type
type tab_cst from tab within tabpage_pcst
tabpage_cstrec tabpage_cstrec
tabpage_cstmat tabpage_cstmat
tabpage_cstserv tabpage_cstserv
tabpage_cstotr tabpage_cstotr
end type
type tabpage_pcst from userobject within tab_main
tab_cst tab_cst
end type
type tab_main from tab within w_pt315_pry_actividades
tabpage_pactv tabpage_pactv
tabpage_pcst tabpage_pcst
end type
type dw_pry from u_dw_abc within w_pt315_pry_actividades
end type
end forward

global type w_pt315_pry_actividades from w_abc
integer width = 2674
integer height = 2116
string title = "Proyectos - Programación Actividades  (PT315)"
string menuname = "m_mantenimiento_cl"
cb_2 cb_2
cb_1 cb_1
tab_main tab_main
dw_pry dw_pry
end type
global w_pt315_pry_actividades w_pt315_pry_actividades

type variables
String is_tipcst_mo, is_tip_cst_equipo, is_tipcst_material,&
		 is_tipcst_servicio, is_tipcst_otro
String is_tipfc_beneficio, is_tipfc_inversion, is_tipfc_amortizacion,&
		 is_tipfc_cfijo, is_tipfc_cvar, is_tipfc_lcred
		 
Datawindow idw_ActvLst, idw_ActvDef, idw_ActMat, idw_ActRec, idw_ActServ, idw_ActOtr, idw_ActvSec
DataWindow idw_CstRec, idw_CstMat, idw_CstServ, idw_CstOtr, idw_ESec
end variables

forward prototypes
public subroutine of_configura_observaciones (string as_columna)
end prototypes

public subroutine of_configura_observaciones (string as_columna);string	ls_matriz[]
string	ls_otro_texto
long	li_total
long	li_y
long	li_x
long	li_alto
string	ls_err

//is_columna_observaciones = as_columna

//li_total = f_dw_get_objects(this,ls_matriz, "text","header") 
ls_otro_texto = ls_matriz[1]
ls_otro_texto = "observaciones_t"

//li_x = long(Describe("bitmap_observaciones.X"))
//li_y = long(Describe(ls_otro_texto+".Y"))
//li_alto = long(Describe(ls_otro_texto+".Height"))

//ls_err = modify("create compute(band=detail expression='Bitmap(If(isnull(" + as_columna + "),~"f:\cr2000\bitmaps\comen2.bmp~",~"f:\cr2000\bitmaps\comen1.bmp~"))' border='0' color='0' x='3333' y='6' height='45' width='65' name=bitmap_observaciones background.mode='2' background.color='16777215')")
//ls_err = modify("create compute(band=detail expression='Bitmap(If(f_cadena_ingresada(" + as_columna + "),~"f:\cr2000\bitmaps\comen2.bmp~",~"f:\cr2000\bitmaps\comen1.bmp~"))' border='0' color='0' x='"+string(li_x)+"' y='"+string(li_y)+ "' height='"+string(li_alto)+ "' width='65' name=bitmap_observaciones background.mode='2' background.color='16777215')")
//
//if f_cadena_ingresada(ls_err) then
//	f_mensaje("",ls_err,"ERR")
//end if
//
//li_x = long(Describe("bitmap_observaciones.X"))
//li_y = long(Describe(ls_otro_texto+".Y"))
//li_alto = long(Describe(ls_otro_texto+".Height"))
//
//ls_err = modify("create text(band= Header text = '' border='6' color='0' x='"+string(li_x)+"' y='"+string(li_y)+ "' height='"+string(li_alto)+ "' width='65' background.mode='2' Background.Color='12632256')")
//
//if f_cadena_ingresada(ls_err) then
//	f_mensaje("",ls_err,"ERR")
//end if
end subroutine

on w_pt315_pry_actividades.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl" then this.MenuID = create m_mantenimiento_cl
this.cb_2=create cb_2
this.cb_1=create cb_1
this.tab_main=create tab_main
this.dw_pry=create dw_pry
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.tab_main
this.Control[iCurrent+4]=this.dw_pry
end on

on w_pt315_pry_actividades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.tab_main)
destroy(this.dw_pry)
end on

event ue_open_pre;call super::ue_open_pre;//Valores de los parametros
select tipo_gasto_mo      , tipo_gasto_equipo  , tipo_gasto_material,
		 tipo_gasto_servicio, tipo_gasto_otro    ,
		 tipo_fc_beneficio  , tipo_fc_inversion  , tipo_fc_amortizacion,
		 tipo_fc_costo_fijo , tipo_fc_costo_var  , tipo_fc_linea_cred
  into :is_tipcst_mo      , :is_tip_cst_equipo , :is_tipcst_material,
		 :is_tipcst_servicio, :is_tipcst_otro    ,
		 :is_tipfc_beneficio, :is_tipfc_inversion, :is_tipfc_amortizacion,
		 :is_tipfc_cfijo    , :is_tipfc_cvar     , :is_tipfc_lcred
  from pry_param
 where reckey = '1';

idw_1 = dw_pry
dw_pry.of_protect()
//TriggerEvent("ue_modify")

idw_ActvSec = tab_main.tabpage_pactv.tab_actv.tabpage_actvsec.dw_sec
idw_ActvLst = tab_main.tabpage_pactv.tab_actv.tabpage_actvlst.dw_actvlst
idw_ActvDef = tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef
idw_ActRec =  tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec
idw_ActMat =  tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat
idw_ActServ =  tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv
idw_ActOtr =  tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr

idw_CstRec = tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec
idw_CstMat = tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat
idw_CstServ = tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv
idw_CstOtr = tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr

idw_ESec = tab_main.tabpage_pactv.tab_actv.tabpage_actvlst.dw_seccion
end event

event ue_insert;call super::ue_insert;Long  ll_row

//Long  ll_row
//
//IF idw_1 = dw_detail AND dw_master.il_row = 0 THEN
//	MessageBox("Error", "No ha seleccionado registro Maestro")
//	RETURN
//END IF
//
ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_modify;call super::ue_modify;dw_pry.of_protect()

tab_main.tabpage_pactv.tab_actv.tabpage_actvsec.dw_sec.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvlst.dw_actvlst.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv.of_protect()
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr.of_protect()

tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec.of_protect()
tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat.of_protect()
tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv.of_protect()
tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr.of_protect()

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_ActvSec.AcceptText()
idw_ActvLst.AcceptText()
idw_ActvDef.AcceptText()
idw_ActRec.AcceptText()
idw_ActMat.AcceptText()
idw_ActServ.AcceptText()
idw_ActOtr.AcceptText()
idw_CstRec.AcceptText()
idw_CstMat.AcceptText()
idw_CstServ.AcceptText()
idw_CstOtr.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvsec.dw_sec.ii_update = 1 and lbo_ok = True THEN
	IF idw_ActvSec.Update() = -1 then
		lbo_ok = FALSE
    	Rollback using sqlca;
		messagebox("Error en Grabacion de Secuencia de Actividades...","Se ha procedido al rollback",exclamation!)
	END IF
END IF

//IF tab_main.tabpage_pactv.tab_actv.tabpage_actvlst.dw_actvlst.ii_update = 1 and lbo_ok = True THEN
	IF idw_ActvLst.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Lista de Actividades","Se ha procedido al rollback",exclamation!)
	END IF
//END IF

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef.ii_update = 1 and lbo_ok = True  THEN
	IF idw_ActvDef.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Definición de Actividad","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec.ii_update = 1 and lbo_ok = True  THEN
	IF idw_ActRec.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Recursos de Actividad","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat.ii_update = 1 and lbo_ok = True  THEN
	IF idw_ActMat.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Materiales de Actividad","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv.ii_update = 1 and lbo_ok = True  THEN
	IF idw_ActServ.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Servicios de Actividad","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr.ii_update = 1 and lbo_ok = True  THEN
	IF idw_ActOtr.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Otros Costos de Actividad","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec.ii_update = 1 and lbo_ok = True  THEN
	IF idw_CstRec.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Recursos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat.ii_update = 1 and lbo_ok = True  THEN
	IF idw_CstMat.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Materiales","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv.ii_update = 1 and lbo_ok = True  THEN
	IF idw_CstServ.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Costos de Servicios","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr.ii_update = 1 and lbo_ok = True  THEN
	IF idw_CstOtr.Update() = -1 then
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabacion de Otros Costos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	tab_main.tabpage_pactv.tab_actv.tabpage_actvsec.dw_sec.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvlst.dw_actvlst.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv.ii_update = 0
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr.ii_update = 0
	tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec.ii_update = 0
	tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat.ii_update = 0
	tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv.ii_update = 0
	tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr.ii_update = 0
END IF
end event

event ue_update_request;call super::ue_update_request;//Integer li_msg_result
//
//// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
//IF (tab_main.tabpage_pactv.tab_pactv.tabpage_sec.dw_sec.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvlst.dw_actvlst.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.dw_actvdef.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv.ii_update = 1 OR &
//	 tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr.ii_update = 1 OR &
//	 tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec.ii_update = 1 OR &
//	 tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat.ii_update = 1 OR &
//	 tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv.ii_update = 1 OR &
//	 tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr.ii_update = 1) THEN
//	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
//	IF li_msg_result = 1 THEN
// 		this.TriggerEvent("ue_update")
//	ELSE
//		tab_main.tabpage_pactv.tab_pactv.tabpage_sec.dw_sec.ii_update = 0
//		tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvlst.dw_actvlst.ii_update = 0
//	 	tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.dw_actvdef.ii_update = 0
//	 	tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_rec.dw_actrec.ii_update = 0
//	 	tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_mat.dw_actmat.ii_update = 0
//	 	tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_serv.dw_actserv.ii_update = 0
//	 	tab_main.tabpage_pactv.tab_pactv.tabpage_actv.tab_actv.tabpage_actvdef.tab_actvcst.tabpage_otr.dw_actotr.ii_update = 0
//	 	tab_main.tabpage_pcst.tab_cst.tabpage_cstrec.dw_cstrec.ii_update = 0
//	 	tab_main.tabpage_pcst.tab_cst.tabpage_cstmat.dw_cstmat.ii_update = 0
//	 	tab_main.tabpage_pcst.tab_cst.tabpage_cstserv.dw_cstserv.ii_update = 0
//	 	tab_main.tabpage_pcst.tab_cst.tabpage_cstotr.dw_cstotr.ii_update = 0
//	END IF
//END IF
end event

event ue_list_open;call super::ue_list_open;Long ll_row
str_parametros sl_param
String ls_tipo[2]

TriggerEvent ('ue_update_request')		
IF ib_update_check = FALSE THEN RETURN

sl_param.dw1     = 'd_abc_lista_proyecto_tbl'
sl_param.titulo  = 'Proyecto'

sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	idw_ActvLst.Reset()
	idw_ESec.Object.seccion[idw_ESec.GetRow()]=''
	idw_ESec.Object.desc_seccion[idw_ESec.GetRow()]=''	
	dw_pry.Retrieve(sl_param.field_ret[1])
	idw_ActvSec.Retrieve(sl_param.field_ret[1])
	//idw_ActvLst.Retrieve(sl_param.field_ret[1])
	//Costos de Recursos
	SetNull(ls_tipo[1]); SetNull(ls_tipo[2])
	ls_tipo[1]=is_tipcst_mo; ls_tipo[2]=is_tip_cst_equipo
	idw_CstRec.Retrieve(sl_param.field_ret[1],ls_tipo[])
	//Costos de Materiales
	SetNull(ls_tipo[1]); SetNull(ls_tipo[2])
	ls_tipo[1]=is_tipcst_material
	idw_CstMat.Retrieve(sl_param.field_ret[1],ls_tipo[])
	//Costos de Servicios
	SetNull(ls_tipo[1]); SetNull(ls_tipo[2])
	ls_tipo[1]=is_tipcst_servicio
	idw_CstServ.Retrieve(sl_param.field_ret[1],ls_tipo[])
	//Otros Costos
	SetNull(ls_tipo[1]); SetNull(ls_tipo[2])
	ls_tipo[1]=is_tipcst_otro
	idw_CstOtr.Retrieve(sl_param.field_ret[1],ls_tipo[])

	//Limpiar Algunos Dws
	idw_ActvDef.Reset()
	idw_ActvDef.InsertRow(0)
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef.il_row = 0
	idw_ActRec.Reset()
	idw_ActMat.Reset()
	idw_ActServ.Reset()
	idw_ActOtr.Reset()
	
	dw_pry.il_row = 1

END IF
end event

event ue_update_pre;call super::ue_update_pre;Long ll_max_nro_actv, ll_nro_actv, ll_i, ll_nro, ll_max_itm_cst, ll_itm_cst
String ls_nro_pry, ls_seccion, ls_desc, ls_tipo
Decimal ln_cant

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
//Validar Secciones
for ll_i = 1 to idw_ActvSec.RowCount()
	ls_seccion = idw_ActvSec.Object.seccion[ll_i]
	ls_desc = idw_ActvSec.Object.desc_seccion[ll_i]
	If IsNull(ls_seccion) or Len(Trim(ls_seccion))=0 then
		MessageBox("Aviso","Debe ingresar una seccion")
		ib_update_check = False
		Return
	end if
	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar una descripcion de seccion")
		ib_update_check = False
		Return
	end if
next
//Validar lista de Actividades
for ll_i = 1 to idw_ActvLst.RowCount()
	ls_desc = idw_ActvLst.Object.desc_actividad[ll_i]
	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar una descripcion de actividad")
		ib_update_check = False
		Return
	end if
next
//Validar Cantidad de Recursos por Actividad
for ll_i = 1 to idw_ActRec.RowCount()
	ln_cant = idw_ActRec.Object.cantidad_proy[ll_i]
	ls_desc = idw_ActRec.Object.desc_costo[ll_i]
	If IsNull(ln_cant) or ln_cant <=0 then
		MessageBox("Aviso","Debe ingresar una valor valido de cantidad en Recursos por Actividad")
		ib_update_check = False
		Return
	end if
	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar una descripcion del Recurso por Actividad")
		ib_update_check = False
		Return
	end if

next

//Validar Recurso, su costo y su tipo(Mano obra o Equipo)
for ll_i = 1 to idw_CstRec.RowCount()
	ln_cant = idw_CstRec.Object.costo_dol_proy[ll_i]
	ls_desc = idw_CstRec.Object.desc_costo[ll_i]
	ls_tipo = idw_CstRec.Object.tipo_costo[ll_i]

	If IsNull(ls_tipo) or Len(Trim(ls_tipo))=0 then
		MessageBox("Aviso","Debe ingresar un tipo de costo en Recursos")
		ib_update_check = False
		Return
	end if

	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar la descripcion del Recurso")
		ib_update_check = False
		Return
	end if

	If IsNull(ln_cant) or ln_cant <=0 then
		MessageBox("Aviso","Debe ingresar un costo valido en Recursos")
		ib_update_check = False
		Return
	end if
next
//Validar Materiales y su costo
for ll_i = 1 to idw_CstMat.RowCount()
	ln_cant = idw_CstMat.Object.costo_dol_proy[ll_i]
	ls_desc = idw_CstMat.Object.desc_costo[ll_i]

	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar la descripcion del Material")
		ib_update_check = False
		Return
	end if

	If IsNull(ln_cant) or ln_cant <=0 then
		MessageBox("Aviso","Debe ingresar un costo valido en Material")
		ib_update_check = False
		Return
	end if
next
//Validar Servicios y su costo
for ll_i = 1 to idw_CstServ.RowCount()
	ln_cant = idw_CstServ.Object.costo_dol_proy[ll_i]
	ls_desc = idw_CstServ.Object.desc_costo[ll_i]

	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar la descripcion del Servicio")
		ib_update_check = False
		Return
	end if

	If IsNull(ln_cant) or ln_cant <=0 then
		MessageBox("Aviso","Debe ingresar un costo valido en Servicio")
		ib_update_check = False
		Return
	end if
next
//Validar Otros y su costo
for ll_i = 1 to idw_CstOtr.RowCount()
	ln_cant = idw_CstOtr.Object.costo_dol_proy[ll_i]
	ls_desc = idw_CstOtr.Object.desc_costo[ll_i]

	If IsNull(ls_desc) or Len(Trim(ls_desc))=0 then
		MessageBox("Aviso","Debe ingresar la descripcion de Otros costos")
		ib_update_check = False
		Return
	end if

	If IsNull(ln_cant) or ln_cant <=0 then
		MessageBox("Aviso","Debe ingresar un costo valido en Otros Costos")
		ib_update_check = False
		Return
	end if
next

// NUMERACION DE CORRELATIVOS
//Establece el nro de actividad a registros k le falte
Select nvl(max(nro_actividad),0) into :ll_max_nro_actv
  from pry_actividad
 where nro_proyecto = :ls_nro_pry;
If f_valida_transaccion(sqlca) = False then GoTo error_bd

if idw_ActvLst.RowCount() > 0 then
	If idw_ActvLst.Object.max_nro_actv[1] > ll_max_nro_actv then
		ll_max_nro_actv = idw_ActvLst.Object.max_nro_actv[1]
	end if
end if
ll_nro_actv = ll_max_nro_actv
//Seccion 
ls_seccion = idw_ESec.Object.seccion[idw_ESec.GetRow()]
If IsNull(ls_seccion) or Len(Trim(ls_seccion))=0 then
	SetNull(ls_seccion)
end if
for ll_i = 1 to idw_ActvLst.RowCount()
	//ll_nro = idw_ActvLst.GetItemNumber(ll_i,"nro_actividad",Primary!,True)
	ll_nro = idw_ActvLst.GetItemNumber(ll_i,"nro_actividad")
	If IsNull(ll_nro) then
		ll_nro_actv = ll_nro_actv + 1
		idw_ActvLst.Object.nro_actividad[ll_i] = ll_nro_actv
		idw_ActvLst.Object.seccion[ll_i] = ls_seccion
	end if
next

//Establece el nro de costos para registros k le falte
//Definiendo el max item costo, para a partir de el 
//establecer los correlativos
Select nvl(max(nro_item_costo),0) into :ll_max_itm_cst
  from pry_activ_costo
 where nro_proyecto = :ls_nro_pry;
If f_valida_transaccion(sqlca) = False then GoTo error_bd

if idw_CstRec.RowCount() > 0 then
	If idw_CstRec.Object.max_itm_cst[1] > ll_max_itm_cst then
		ll_max_itm_cst = idw_CstRec.Object.max_itm_cst[1]
	end if
end if

if idw_CstMat.RowCount() > 0 then
	If idw_CstMat.Object.max_itm_cst[1] > ll_max_itm_cst then
		ll_max_itm_cst = idw_CstMat.Object.max_itm_cst[1]
	end if
end if

if idw_CstServ.RowCount() > 0 then
	If idw_CstServ.Object.max_itm_cst[1] > ll_max_itm_cst then
		ll_max_itm_cst = idw_CstServ.Object.max_itm_cst[1]
	end if
end if

if idw_CstOtr.RowCount() > 0 then
	If idw_CstOtr.Object.max_itm_cst[1] > ll_max_itm_cst then
		ll_max_itm_cst = idw_CstOtr.Object.max_itm_cst[1]
	end if
end if

ll_itm_cst = ll_max_itm_cst

for ll_i = 1 to idw_CstRec.RowCount()
	ll_nro = idw_CstRec.Object.nro_item_costo[ll_i]
	If IsNull(ll_nro) then
		ll_itm_cst = ll_itm_cst + 1
		idw_CstRec.Object.nro_item_costo[ll_i] = ll_itm_cst
	end if
next
for ll_i = 1 to idw_CstMat.RowCount()
	ll_nro = idw_CstMat.Object.nro_item_costo[ll_i]
	If IsNull(ll_nro) then
		ll_itm_cst = ll_itm_cst + 1
		idw_CstMat.Object.nro_item_costo[ll_i] = ll_itm_cst
	end if
next
for ll_i = 1 to idw_CstServ.RowCount()
	ll_nro = idw_CstServ.Object.nro_item_costo[ll_i]
	If IsNull(ll_nro) then
		ll_itm_cst = ll_itm_cst + 1
		idw_CstServ.Object.nro_item_costo[ll_i] = ll_itm_cst
	end if
next
for ll_i = 1 to idw_CstOtr.RowCount()
	ll_nro = idw_CstOtr.Object.nro_item_costo[ll_i]
	If IsNull(ll_nro) then
		ll_itm_cst = ll_itm_cst + 1
		idw_CstOtr.Object.nro_item_costo[ll_i] = ll_itm_cst
	end if
next
ib_update_check = True
Return
error_bd:
RollBack using sqlca;
ib_update_check = False
Return
end event

type cb_2 from commandbutton within w_pt315_pry_actividades
integer x = 2185
integer y = 172
integer width = 343
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Costos"
end type

event clicked;String ls_nro_pry
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

OpenSheetWithParm(w_pt768_rpt_cost_activ, ls_nro_pry, Parent,0,layered!)
end event

type cb_1 from commandbutton within w_pt315_pry_actividades
integer x = 2185
integer y = 268
integer width = 343
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Gantt"
end type

event clicked;String ls_nro_pry
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

OpenSheetWithParm(w_pt767_rpt_gantt, ls_nro_pry, Parent,0,layered!)
end event

type tab_main from tab within w_pt315_pry_actividades
integer x = 23
integer y = 380
integer width = 2624
integer height = 1536
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_pactv tabpage_pactv
tabpage_pcst tabpage_pcst
end type

on tab_main.create
this.tabpage_pactv=create tabpage_pactv
this.tabpage_pcst=create tabpage_pcst
this.Control[]={this.tabpage_pactv,&
this.tabpage_pcst}
end on

on tab_main.destroy
destroy(this.tabpage_pactv)
destroy(this.tabpage_pcst)
end on

type tabpage_pactv from userobject within tab_main
integer x = 18
integer y = 112
integer width = 2587
integer height = 1408
long backcolor = 79741120
string text = "Actividades"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "SelectObject!"
long picturemaskcolor = 536870912
tab_actv tab_actv
end type

on tabpage_pactv.create
this.tab_actv=create tab_actv
this.Control[]={this.tab_actv}
end on

on tabpage_pactv.destroy
destroy(this.tab_actv)
end on

type tab_actv from tab within tabpage_pactv
event create ( )
event destroy ( )
integer x = 18
integer y = 16
integer width = 2551
integer height = 1380
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_actvsec tabpage_actvsec
tabpage_actvlst tabpage_actvlst
tabpage_actvdef tabpage_actvdef
end type

on tab_actv.create
this.tabpage_actvsec=create tabpage_actvsec
this.tabpage_actvlst=create tabpage_actvlst
this.tabpage_actvdef=create tabpage_actvdef
this.Control[]={this.tabpage_actvsec,&
this.tabpage_actvlst,&
this.tabpage_actvdef}
end on

on tab_actv.destroy
destroy(this.tabpage_actvsec)
destroy(this.tabpage_actvlst)
destroy(this.tabpage_actvdef)
end on

type tabpage_actvsec from userobject within tab_actv
integer x = 18
integer y = 112
integer width = 2514
integer height = 1252
long backcolor = 79741120
string text = "Secciones"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Cascade!"
long picturemaskcolor = 536870912
dw_sec dw_sec
end type

on tabpage_actvsec.create
this.dw_sec=create dw_sec
this.Control[]={this.dw_sec}
end on

on tabpage_actvsec.destroy
destroy(this.dw_sec)
end on

type dw_sec from u_dw_abc within tabpage_actvsec
event ue_det_agregar ( )
event ue_det_insertar ( )
event ue_det_eliminar ( )
integer x = 14
integer y = 20
integer width = 2482
integer height = 1220
integer taborder = 40
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_abc_pry_activ_seccion"
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Verificar que existe registro maestro seleccionado
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Asignacion Automatica
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_i
For ll_i = 1 to Rowcount()
	SetItem(ll_i,"fila",ll_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Modify("seccion.Protect='1~tIf(IsRowNew(),0,1)'")
Modify("desc_seccion.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i
String ls_seccion_aux, ls_desc_seccion_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ls_seccion_aux = Object.seccion[ll_origen]
	ls_desc_seccion_aux = Object.desc_seccion[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.seccion[ll_i - 1] = Object.seccion[ll_i]
			Object.desc_seccion[ll_i - 1] = Object.desc_seccion[ll_i]
		NEXT
		Object.seccion[ll_destino] = ls_seccion_aux
		Object.desc_seccion[ll_destino] = ls_desc_seccion_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.seccion[ll_i + 1] = Object.seccion[ll_i]
			Object.desc_seccion[ll_i + 1] = Object.desc_seccion[ll_i]
		NEXT
		Object.seccion[ll_destino] = ls_seccion_aux
		Object.desc_seccion[ll_destino] = ls_desc_seccion_aux
	END IF	
	Drag(End!)
END IF
end event

event itemchanged;call super::itemchanged;Long ll_found
AcceptText()
Choose Case GetColumnName()
	Case "seccion"
		ll_found = Find( "seccion = '"+data+"' and getrow()<>"+String(row),1, RowCount())
		if ll_found > 0 then
			MessageBox("Aviso","Seccion Repetida en Fila "+String(ll_found))
			Object.seccion[row]=""
			Return 2
		end if
end choose
end event

event doubleclicked;call super::doubleclicked;String ls_nro_pry, ls_seccion, ls_desc_sec
Long ll_nro_actv
Integer li_count

If row <= 0 then Return
If IsNull(ll_nro_actv) then Return
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ls_seccion = Object.seccion[row]
ls_desc_sec = Object.desc_seccion[row]

//Validacion de que la seccion este Guardada en la BD
Select count(*) into :li_count
from pry_activ_seccion
where seccion = :ls_seccion;
If li_count > 0 then
	tab_main.tabpage_pactv.tab_actv.SelectedTab = 2
	idw_ESec.Object.seccion[idw_ESec.GetRow()] = ls_seccion
	idw_ESec.Object.desc_seccion[idw_ESec.GetRow()] = ls_desc_sec
	idw_ActvLst.Retrieve(ls_nro_pry, ls_seccion)
else
	MessageBox("Aviso","Esta sección aun no ha sido guardada")
	Return
end if
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count
String ls_seccion


ib_insert_mode = False

ls_seccion = idw_ActvSec.Object.seccion[idw_ActvSec.GetRow()]


Select count(*) into :ll_count
from pry_actividad
where seccion = :ls_seccion;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar la seccion pues existen actividades utilizandola")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

type tabpage_actvlst from userobject within tab_actv
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2514
integer height = 1252
long backcolor = 79741120
string text = "Lista"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Compute!"
long picturemaskcolor = 536870912
dw_actvlst dw_actvlst
dw_seccion dw_seccion
end type

on tabpage_actvlst.create
this.dw_actvlst=create dw_actvlst
this.dw_seccion=create dw_seccion
this.Control[]={this.dw_actvlst,&
this.dw_seccion}
end on

on tabpage_actvlst.destroy
destroy(this.dw_actvlst)
destroy(this.dw_seccion)
end on

type dw_actvlst from u_dw_abc within tabpage_actvlst
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
event ue_det_observaciones ( )
integer x = 14
integer y = 124
integer width = 2482
integer height = 1112
integer taborder = 50
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_lis_pry_actividad"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Validad Maestro
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Insertar claves de la llave
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		THIS.SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

ii_update = 1
end event

event ue_det_observaciones();string ls_obs
string 	ls_columna
long 		ll_row 

AcceptText()
//If Describe("observaciones.Protect") = '1' then RETURN

ls_obs = Object.observaciones[GetRow()]

openwithparm(w_rsp_descripcion,ls_obs)

if not isnull(Message.StringParm) then
	Object.observaciones[GetRow()] = Message.StringParm
	ii_update = 1
end if
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
//Observaciones
string	ls_matriz[]
string	ls_otro_texto
long	li_total
long	li_y
long	li_x
long	li_alto
string	ls_err
string ls_columna
ls_columna = "observaciones"

//li_total = f_dw_get_objects(this,ls_matriz, "text","header") 
//ls_otro_texto = ls_matriz[1]
ls_otro_texto = "observaciones_t"

li_x = long(Describe("bitmap_observaciones.X"))
li_y = long(Describe(ls_otro_texto+".Y"))
li_alto = long(Describe(ls_otro_texto+".Height"))

ls_err = modify("create compute(band=detail expression='Bitmap(If((IsNull(" + ls_columna + ")or len(trim(observaciones))=0),~"h:\source\bmp\coment.bmp~",~"h:\source\bmp\coment_lleno.bmp~"))' border='0' color='0' x='3333' y='6' height='45' width='65' name=bitmap_observaciones background.mode='2' background.color='16777215')")
//ls_err = modify("create compute(band=detail expression='Bitmap(If(f_cadena_ingresada(" + as_columna + "),~"f:\cr2000\bitmaps\comen2.bmp~",~"f:\cr2000\bitmaps\comen1.bmp~"))' border='0' color='0' x='"+string(li_x)+"' y='"+string(li_y)+ "' height='"+string(li_alto)+ "' width='65' name=bitmap_observaciones background.mode='2' background.color='16777215')")

//if ls_err = "" or IsNull(ls_err) then
//	MessageBox("ERR",ls_err)
//end if

li_x = long(Describe("bitmap_observaciones.X"))
li_y = long(Describe(ls_otro_texto+".Y"))
li_alto = long(Describe(ls_otro_texto+".Height"))

ls_err = modify("create text(band= Header text = '' border='6' color='0' x='"+string(li_x)+"' y='"+string(li_y)+ "' height='"+string(li_alto)+ "' width='65' background.mode='2' Background.Color='12632256')")

//if ls_err = "" or IsNull(ls_err) then
//	MessageBox("ERR",ls_err)
//end if
end event

event doubleclicked;call super::doubleclicked;String ls_nro_pry, ls_tipcost[2]
Long ll_nro_actv

If row <= 0 then Return
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.Enabled = True
ll_nro_actv = Object.nro_actividad[row]
If IsNull(ll_nro_actv) then Return
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
tab_main.tabpage_pactv.tab_actv.SelectedTab = 3
idw_ActvDef.Retrieve(ls_nro_pry, ll_nro_actv)
tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef.il_row = 1
//Recursos de las Actividades
ls_tipcost[1] = is_tipcst_mo
ls_tipcost[2] = is_tip_cst_equipo
idw_ActRec.Retrieve(ls_nro_pry, ll_nro_actv, ls_tipcost[])
//Materiales de las Actividades
ls_tipcost[1] = is_tipcst_material
SetNull(ls_tipcost[2])
idw_ActMat.Retrieve(ls_nro_pry, ll_nro_actv, ls_tipcost[])
//Servicios de las Actividades
ls_tipcost[1] = is_tipcst_servicio
SetNull(ls_tipcost[2])
idw_ActServ.Retrieve(ls_nro_pry, ll_nro_actv, ls_tipcost[])
//Otros costos de las Actividades
ls_tipcost[1] = is_tipcst_otro
SetNull(ls_tipcost[2])
idw_ActOtr.Retrieve(ls_nro_pry, ll_nro_actv, ls_tipcost[])

end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_nro_actv_aux
String ls_desc_actv_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_nro_actv_aux = Object.nro_actividad[ll_origen]
	ls_desc_actv_aux = Object.desc_actividad[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_actividad[ll_i - 1] = Object.nro_actividad[ll_i]
			Object.desc_actividad[ll_i - 1] = Object.desc_actividad[ll_i]
		NEXT
		Object.nro_actividad[ll_destino] = ll_nro_actv_aux
		Object.desc_actividad[ll_destino] = ls_desc_actv_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_actividad[ll_i + 1] = Object.nro_actividad[ll_i]
			Object.desc_actividad[ll_i + 1] = Object.desc_actividad[ll_i]
		NEXT
		Object.nro_actividad[ll_destino] = ll_nro_actv_aux
		Object.desc_actividad[ll_destino] = ls_desc_actv_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

event ue_delete_pos;call super::ue_delete_pos;Integer li_i
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
end event

event ue_insert_pre;call super::ue_insert_pre;Modify("desc_actividad.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event retrieveend;call super::retrieveend;If rowcount = 0 then
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.Enabled = False
else
	tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.Enabled = True
end if
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count, ll_nro_activ
String ls_nro_pry


ib_insert_mode = False
ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ll_nro_activ = idw_ActvLst.Object.nro_actividad[idw_ActvLst.GetRow()]


Select count(*) into :ll_count
  from pry_activ_prog_costo
 where nro_proyecto = :ls_nro_pry
   and nro_actividad = :ll_nro_activ;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar esta actividad pues existen costos asociados")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

type dw_seccion from datawindow within tabpage_actvlst
integer x = 14
integer y = 24
integer width = 2030
integer height = 100
integer taborder = 40
string title = "none"
string dataobject = "d_ext_pry_seccion"
boolean border = false
boolean livescroll = true
end type

event constructor;InsertRow(0)
end event

type tabpage_actvdef from userobject within tab_actv
event create ( )
event destroy ( )
integer x = 18
integer y = 112
integer width = 2514
integer height = 1252
long backcolor = 79741120
string text = "Definición"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom014!"
long picturemaskcolor = 536870912
tab_actvcst tab_actvcst
dw_actvdef dw_actvdef
end type

on tabpage_actvdef.create
this.tab_actvcst=create tab_actvcst
this.dw_actvdef=create dw_actvdef
this.Control[]={this.tab_actvcst,&
this.dw_actvdef}
end on

on tabpage_actvdef.destroy
destroy(this.tab_actvcst)
destroy(this.dw_actvdef)
end on

type tab_actvcst from tab within tabpage_actvdef
event create ( )
event destroy ( )
integer x = 9
integer y = 556
integer width = 2491
integer height = 688
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean fixedwidth = true
boolean multiline = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
tabposition tabposition = tabsonleft!
integer selectedtab = 1
tabpage_rec tabpage_rec
tabpage_mat tabpage_mat
tabpage_serv tabpage_serv
tabpage_otr tabpage_otr
end type

on tab_actvcst.create
this.tabpage_rec=create tabpage_rec
this.tabpage_mat=create tabpage_mat
this.tabpage_serv=create tabpage_serv
this.tabpage_otr=create tabpage_otr
this.Control[]={this.tabpage_rec,&
this.tabpage_mat,&
this.tabpage_serv,&
this.tabpage_otr}
end on

on tab_actvcst.destroy
destroy(this.tabpage_rec)
destroy(this.tabpage_mat)
destroy(this.tabpage_serv)
destroy(this.tabpage_otr)
end on

type tabpage_rec from userobject within tab_actvcst
event create ( )
event destroy ( )
integer x = 238
integer y = 16
integer width = 2235
integer height = 656
long backcolor = 79741120
string text = "Recursos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Count!"
long picturemaskcolor = 536870912
dw_actrec dw_actrec
end type

on tabpage_rec.create
this.dw_actrec=create dw_actrec
this.Control[]={this.dw_actrec}
end on

on tabpage_rec.destroy
destroy(this.dw_actrec)
end on

type dw_actrec from u_dw_abc within tabpage_rec
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
event ue_det_buscar ( )
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 12
integer width = 2199
integer height = 628
integer taborder = 30
string dragicon = "H:\source\Ico\row2.ico"
string dataobject = "d_abc_pry_activ_costo_rec"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
ll_count = RowCount()
If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Insertar claves de la llave
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		THIS.SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

ii_update = 1
end event

event ue_det_buscar();Long ll_i
str_pry_activ_costo istr_1
//Verifica que haya una actividad seleccionada
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
istr_1.dw_origen = this
istr_1.nro_proyecto = idw_ActvDef.Object.nro_proyecto[idw_ActvDef.GetRow()]
istr_1.nro_actividad = idw_ActvDef.Object.nro_actividad[idw_ActvDef.GetRow()]
istr_1.tipo_costo = is_tipcst_mo
OpenWithParm(w_rsp_pry_costos, istr_1)
for ll_i = 1 to RowCount()
	Object.fila[ll_i]= ll_i
next
ii_update = 1
end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_nro_pry
String ls_tipcost[2]

this.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

choose case lower(as_columna)
		
	case "desc_costo"
		ls_sql = "select nro_item_costo as nro_item_costo, "&
				  + "desc_costo as desc_costo, "&
				  + "tipo_costo as tipo_costo "&
				  + "FROM pry_activ_costo " &
				  + "where nro_proyecto ='"+ls_nro_pry+"' "&
				  + "and (tipo_costo = '"+is_tipcst_mo+"' "&
				  + "or tipo_costo = '"+is_tip_cst_equipo+"')"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_item_costo		[al_row] = Long(ls_codigo)
			this.object.desc_costo	[al_row] = ls_data
			this.ii_update = 1			
		end if
		
		return
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'

idw_mst = tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef

ii_ck[1]=1
ii_ck[2]=2

ii_rk[1]=1
ii_rk[2]=2
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_nro_itm_cst_aux
String ls_desc_costo_aux
Decimal ln_cant_proy_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_nro_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_costo_aux = Object.desc_costo[ll_origen]
	ln_cant_proy_aux = Object.cantidad_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i - 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i + 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event ue_delete_pos;call super::ue_delete_pos;Integer li_i
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
//NewMenu.m_detalle.m_agregar.enabled = False
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())



end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type tabpage_mat from userobject within tab_actvcst
event create ( )
event destroy ( )
integer x = 238
integer y = 16
integer width = 2235
integer height = 656
long backcolor = 79741120
string text = "Materiales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom045!"
long picturemaskcolor = 536870912
dw_actmat dw_actmat
end type

on tabpage_mat.create
this.dw_actmat=create dw_actmat
this.Control[]={this.dw_actmat}
end on

on tabpage_mat.destroy
destroy(this.dw_actmat)
end on

type dw_actmat from u_dw_abc within tabpage_mat
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_buscar ( )
event ue_det_insertar ( )
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 12
integer width = 2203
integer height = 636
integer taborder = 30
string dataobject = "d_abc_pry_activ_costo_mat"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_buscar();Long ll_i
str_pry_activ_costo istr_1
//Verifica que haya una actividad seleccionada
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
istr_1.dw_origen = this
istr_1.nro_proyecto = idw_ActvDef.Object.nro_proyecto[idw_ActvDef.GetRow()]
istr_1.nro_actividad = idw_ActvDef.Object.nro_actividad[idw_ActvDef.GetRow()]
istr_1.tipo_costo = is_tipcst_material
OpenWithParm(w_rsp_pry_costos, istr_1)
for ll_i = 1 to RowCount()
	Object.fila[ll_i]= ll_i
next
ii_update = 1
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
ll_count = RowCount()
If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Insertar claves de la llave
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		THIS.SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

ii_update = 1
end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_nro_pry
String ls_tipcost[2]

this.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

choose case lower(as_columna)
		
	case "desc_costo"
		ls_sql = "select nro_item_costo as nro_item_costo, "&
				  + "desc_costo as desc_costo, "&
				  + "tipo_costo as tipo_costo "&
				  + "FROM pry_activ_costo " &
				  + "where nro_proyecto ='"+ls_nro_pry+"' "&
				  + "and (tipo_costo = '"+is_tipcst_material+"')"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_item_costo		[al_row] = Long(ls_codigo)
			this.object.desc_costo	[al_row] = ls_data
			this.ii_update = 1			
		end if
		
		return
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'

idw_mst = tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef

ii_ck[1]=1
ii_ck[2]=2

ii_rk[1]=1
ii_rk[2]=2
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_nro_itm_cst_aux
String ls_desc_costo_aux
Decimal ln_cant_proy_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_nro_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_costo_aux = Object.desc_costo[ll_origen]
	ln_cant_proy_aux = Object.cantidad_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i - 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i + 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
//NewMenu.m_detalle.m_agregar.enabled = False
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete_pos;call super::ue_delete_pos;Integer li_i
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

type tabpage_serv from userobject within tab_actvcst
event create ( )
event destroy ( )
integer x = 238
integer y = 16
integer width = 2235
integer height = 656
long backcolor = 79741120
string text = "Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom082!"
long picturemaskcolor = 536870912
dw_actserv dw_actserv
end type

on tabpage_serv.create
this.dw_actserv=create dw_actserv
this.Control[]={this.dw_actserv}
end on

on tabpage_serv.destroy
destroy(this.dw_actserv)
end on

type dw_actserv from u_dw_abc within tabpage_serv
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_buscar ( )
event ue_det_insertar ( )
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 8
integer width = 2199
integer height = 636
integer taborder = 30
string dataobject = "d_abc_pry_activ_costo_serv"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_buscar();Long ll_i
str_pry_activ_costo istr_1
//Verifica que haya una actividad seleccionada
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
istr_1.dw_origen = this
istr_1.nro_proyecto = idw_ActvDef.Object.nro_proyecto[idw_ActvDef.GetRow()]
istr_1.nro_actividad = idw_ActvDef.Object.nro_actividad[idw_ActvDef.GetRow()]
istr_1.tipo_costo = is_tipcst_servicio
OpenWithParm(w_rsp_pry_costos, istr_1)
for ll_i = 1 to RowCount()
	Object.fila[ll_i]= ll_i
next
ii_update = 1
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
ll_count = RowCount()
If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Insertar claves de la llave
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		THIS.SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

ii_update = 1
end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_nro_pry
String ls_tipcost[2]

this.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

choose case lower(as_columna)
		
	case "desc_costo"
		ls_sql = "select nro_item_costo as nro_item_costo, "&
				  + "desc_costo as desc_costo, "&
				  + "tipo_costo as tipo_costo "&
				  + "FROM pry_activ_costo " &
				  + "where nro_proyecto ='"+ls_nro_pry+"' "&
				  + "and (tipo_costo = '"+is_tipcst_servicio+"')"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_item_costo		[al_row] = Long(ls_codigo)
			this.object.desc_costo	[al_row] = ls_data
			this.ii_update = 1			
		end if
		
		return
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'

idw_mst = tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef

ii_ck[1]=1
ii_ck[2]=2

ii_rk[1]=1
ii_rk[2]=2
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_nro_itm_cst_aux
String ls_desc_costo_aux
Decimal ln_cant_proy_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_nro_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_costo_aux = Object.desc_costo[ll_origen]
	ln_cant_proy_aux = Object.cantidad_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i - 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i + 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
//NewMenu.m_detalle.m_agregar.enabled = False
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete_pos;call super::ue_delete_pos;Integer li_i
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

type tabpage_otr from userobject within tab_actvcst
event create ( )
event destroy ( )
integer x = 238
integer y = 16
integer width = 2235
integer height = 656
long backcolor = 79741120
string text = "Otros"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 536870912
dw_actotr dw_actotr
end type

on tabpage_otr.create
this.dw_actotr=create dw_actotr
this.Control[]={this.dw_actotr}
end on

on tabpage_otr.destroy
destroy(this.dw_actotr)
end on

type dw_actotr from u_dw_abc within tabpage_otr
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_buscar ( )
event ue_det_insertar ( )
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 12
integer width = 2199
integer height = 632
integer taborder = 40
string dataobject = "d_abc_pry_activ_costo_otr"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_buscar();Long ll_i
str_pry_activ_costo istr_1
//Verifica que haya una actividad seleccionada
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
istr_1.dw_origen = this
istr_1.nro_proyecto = idw_ActvDef.Object.nro_proyecto[idw_ActvDef.GetRow()]
istr_1.nro_actividad = idw_ActvDef.Object.nro_actividad[idw_ActvDef.GetRow()]
istr_1.tipo_costo = is_tipcst_otro
OpenWithParm(w_rsp_pry_costos, istr_1)
for ll_i = 1 to RowCount()
	Object.fila[ll_i]= ll_i
next
ii_update = 1
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF
ll_count = RowCount()
If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Insertar claves de la llave
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		THIS.SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

ii_update = 1
end event

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_nro_pry
String ls_tipcost[2]

this.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

choose case lower(as_columna)
		
	case "desc_costo"
		ls_sql = "select nro_item_costo as nro_item_costo, "&
				  + "desc_costo as desc_costo, "&
				  + "tipo_costo as tipo_costo "&
				  + "FROM pry_activ_costo " &
				  + "where nro_proyecto ='"+ls_nro_pry+"' "&
				  + "and (tipo_costo = '"+is_tipcst_otro+"')"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_item_costo		[al_row] = Long(ls_codigo)
			this.object.desc_costo	[al_row] = ls_data
			this.ii_update = 1			
		end if
		
		return
end choose
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
Drag(Begin!)
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'

idw_mst = tab_main.tabpage_pactv.tab_actv.tabpage_actvdef.dw_actvdef

ii_ck[1]=1
ii_ck[2]=2

ii_rk[1]=1
ii_rk[2]=2
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_nro_itm_cst_aux
String ls_desc_costo_aux
Decimal ln_cant_proy_aux

IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_nro_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_costo_aux = Object.desc_costo[ll_origen]
	ln_cant_proy_aux = Object.cantidad_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i - 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cantidad_proy[ll_i + 1] = Object.cantidad_proy[ll_i]
		NEXT
		Object.nro_item_costo[ll_destino] = ll_nro_itm_cst_aux
		Object.desc_costo[ll_destino] = ls_desc_costo_aux
		Object.cantidad_proy[ll_destino] = ln_cant_proy_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
//NewMenu.m_detalle.m_agregar.enabled = False
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete_pos;call super::ue_delete_pos;Integer li_i
For li_i = 1 to Rowcount()
	SetItem(li_i,"fila",li_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

type dw_actvdef from u_dw_abc within tabpage_actvdef
event ue_display ( string as_columna,  long al_row )
integer y = 12
integer width = 2222
integer height = 528
integer taborder = 40
string dataobject = "d_abc_pry_actividad"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_cencos, ls_nro_pry
String ls_tipcost[2]

this.AcceptText()

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]

choose case lower(as_columna)
		
	case "nro_actividad"
		ls_sql = "select nro_actividad as nro_actividad, desc_actividad as desc_actividad " &
				  + "FROM pry_actividad " &
				  + "where nro_proyecto ='"+ls_nro_pry+"'" &
  				  + "order by fila " 

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			//this.object.nro_actividad		[al_row] = Long(ls_codigo)
			//this.object.desc_actividad	[al_row] = ls_data
			//this.ii_update = 1
			idw_ActvDef.Retrieve(ls_nro_pry, Long(ls_codigo))
			//Recursos de las Actividades
			ls_tipcost[1] = is_tipcst_mo
			ls_tipcost[2] = is_tip_cst_equipo
			idw_ActRec.Retrieve(ls_nro_pry, Long(ls_codigo), ls_tipcost[])
			//Materiales de las Actividades
			ls_tipcost[1] = is_tipcst_material
			SetNull(ls_tipcost[2])
			idw_ActMat.Retrieve(ls_nro_pry, Long(ls_codigo), ls_tipcost[])
			//Servicios de las Actividades
			ls_tipcost[1] = is_tipcst_servicio
			SetNull(ls_tipcost[2])
			idw_ActServ.Retrieve(ls_nro_pry, Long(ls_codigo), ls_tipcost[])
			//Otros costos de las Actividades
			ls_tipcost[1] = is_tipcst_otro
			SetNull(ls_tipcost[2])
			idw_ActOtr.Retrieve(ls_nro_pry, Long(ls_codigo), ls_tipcost[])
			
		end if
		
		return
		
//	case "nro_actividad"
//		ls_cencos = this.object.cencos[al_row]
//		
//		if IsNull(ls_Cencos) or ls_cencos = '' then
//			MessageBox('Aviso', 'Debe indicar primero el centro de costo ')
//			this.SetColumn('cencos')
//			return
//		end if
//		
//		ls_sql = "SELECT DISTINCT pc.cnta_prsp AS CODIGO_cnta_prsp, " &
//				  + "pc.descripcion AS descripcion_cnta_prsp " &
//				  + "FROM presupuesto_cuenta pc, " &
//				  + "presupuesto_partida pp " &
//				  + "where pp.cnta_prsp = pc.cnta_prsp " &
//				  + "and pp.cencos = '" + ls_Cencos + "' " &
//				  + "and pp.flag_estado <> '0' " &
//  				  + "order by pc.cnta_prsp " 
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.cnta_prsp		[al_row] = ls_codigo
//			this.object.desc_cnta_prsp	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//		return
//		
end choose
end event

event constructor;call super::constructor;SetTransObject(sqlca)
//is_dwform = "form"
is_mastdet = 'dd'
InsertRow(0)
ii_ck[1] = 1
ii_ck[2] = 2
ii_dk[1] = 1
ii_dk[2] = 2
ii_rk[1] = 1
ii_rk[2] = 2


il_row = 0
//SetTransObject(sqlca)
//is_mastdet ='d'
//is_dwform = 'tabular'
////idw_mst = idw_master
//
//ii_ck[1]=1
//ii_rk[1]=1
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type tabpage_pcst from userobject within tab_main
integer x = 18
integer y = 112
integer width = 2587
integer height = 1408
long backcolor = 79741120
string text = "Costos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "UserObject!"
long picturemaskcolor = 536870912
tab_cst tab_cst
end type

on tabpage_pcst.create
this.tab_cst=create tab_cst
this.Control[]={this.tab_cst}
end on

on tabpage_pcst.destroy
destroy(this.tab_cst)
end on

type tab_cst from tab within tabpage_pcst
integer x = 14
integer y = 20
integer width = 2560
integer height = 1376
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean fixedwidth = true
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_cstrec tabpage_cstrec
tabpage_cstmat tabpage_cstmat
tabpage_cstserv tabpage_cstserv
tabpage_cstotr tabpage_cstotr
end type

on tab_cst.create
this.tabpage_cstrec=create tabpage_cstrec
this.tabpage_cstmat=create tabpage_cstmat
this.tabpage_cstserv=create tabpage_cstserv
this.tabpage_cstotr=create tabpage_cstotr
this.Control[]={this.tabpage_cstrec,&
this.tabpage_cstmat,&
this.tabpage_cstserv,&
this.tabpage_cstotr}
end on

on tab_cst.destroy
destroy(this.tabpage_cstrec)
destroy(this.tabpage_cstmat)
destroy(this.tabpage_cstserv)
destroy(this.tabpage_cstotr)
end on

event selectionchanged;Choose Case NewIndex
	case 1
		idw_1.BorderStyle = StyleRaised!
		idw_1 = idw_CstRec
		idw_1.BorderStyle = StyleLowered!		
	case 2
		idw_1.BorderStyle = StyleRaised!
		idw_1 = idw_CstMat
		idw_1.BorderStyle = StyleLowered!
	case 3
		idw_1.BorderStyle = StyleRaised!
		idw_1 = idw_CstServ
		idw_1.BorderStyle = StyleLowered!
	case 4
		idw_1.BorderStyle = StyleRaised!
		idw_1 = idw_CstOtr
		idw_1.BorderStyle = StyleLowered!
end choose
end event

type tabpage_cstrec from userobject within tab_cst
integer x = 18
integer y = 112
integer width = 2523
integer height = 1248
long backcolor = 79741120
string text = "Recursos"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Count!"
long picturemaskcolor = 536870912
dw_cstrec dw_cstrec
end type

on tabpage_cstrec.create
this.dw_cstrec=create dw_cstrec
this.Control[]={this.dw_cstrec}
end on

on tabpage_cstrec.destroy
destroy(this.dw_cstrec)
end on

type dw_cstrec from u_dw_abc within tabpage_cstrec
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 20
integer width = 2491
integer height = 1212
integer taborder = 20
string dataobject = "d_abc_pry_costo_rec"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Verificar que existe registro maestro seleccionado
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
end if
//Asignacion Automatica
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF

end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;Modify("tipo_costo.Protect='1~tIf(IsRowNew(),0,1)'")
Modify("desc_costo.Protect='1~tIf(IsRowNew(),0,1)'")
Modify("costo_dol_proy.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_itm_cst_aux
String ls_desc_cst_aux, ls_tip_cst_aux, ls_cnta_prsp_aux
Decimal ln_costo_aux


IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_cst_aux = Object.desc_costo[ll_origen]
	ls_cnta_prsp_aux = Object.cnta_prsp[ll_origen]
	ln_costo_aux = Object.costo_dol_proy[ll_origen]
	ls_tip_cst_aux = Object.tipo_costo[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i - 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i - 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i - 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
			Object.tipo_costo[ll_destino] = ls_tip_cst_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i + 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i + 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i + 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
			Object.tipo_costo[ll_destino] = ls_tip_cst_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count, ll_itm_cst
String ls_nro_pry

ib_insert_mode = False

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ll_itm_cst = Object.nro_item_costo[GetRow()]

Select count(*) into :ll_count
  from pry_activ_prog_costo
 where nro_proyecto = :ls_nro_pry
   and nro_item_costo = :ll_itm_cst;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar el recurso pues existen actividades utilizandolo")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_i
For ll_i = 1 to Rowcount()
	SetItem(ll_i,"fila",ll_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

type tabpage_cstmat from userobject within tab_cst
integer x = 18
integer y = 112
integer width = 2523
integer height = 1248
long backcolor = 79741120
string text = "Materiales"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom045!"
long picturemaskcolor = 536870912
dw_cstmat dw_cstmat
end type

on tabpage_cstmat.create
this.dw_cstmat=create dw_cstmat
this.Control[]={this.dw_cstmat}
end on

on tabpage_cstmat.destroy
destroy(this.dw_cstmat)
end on

type dw_cstmat from u_dw_abc within tabpage_cstmat
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 16
integer width = 2491
integer height = 1220
integer taborder = 20
string dataobject = "d_abc_pry_costo_mat"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Verificar que existe registro maestro seleccionado
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	Object.tipo_costo[ll_row] = is_tipcst_material
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	Object.tipo_costo[ll_row] = is_tipcst_material
end if
//Asignacion Automatica
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;Object.tipo_costo[al_row] = is_tipcst_material
Modify("costo_dol_proy.Protect='1~If(IsRowNew(),0,1)'")
Modify("cnta_prsp.Protect='1~If(IsRowNew(),0,1)'")
Modify("desc_costo.Protect='1~If(IsRowNew(),0,1)'")
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_itm_cst_aux
String ls_desc_cst_aux, ls_cnta_prsp_aux
Decimal ln_costo_aux


IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_cst_aux = Object.desc_costo[ll_origen]
	ls_cnta_prsp_aux = Object.cnta_prsp[ll_origen]
	ln_costo_aux = Object.costo_dol_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i - 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i - 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i - 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i + 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i + 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i + 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count, ll_itm_cst
String ls_nro_pry

ib_insert_mode = False

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ll_itm_cst = Object.nro_item_costo[GetRow()]

Select count(*) into :ll_count
  from pry_activ_prog_costo
 where nro_proyecto = :ls_nro_pry
   and nro_item_costo = :ll_itm_cst;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar material pues existen actividades utilizandolo")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_i
For ll_i = 1 to Rowcount()
	SetItem(ll_i,"fila",ll_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

type tabpage_cstserv from userobject within tab_cst
integer x = 18
integer y = 112
integer width = 2523
integer height = 1248
long backcolor = 79741120
string text = "Servicios"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Custom082!"
long picturemaskcolor = 536870912
dw_cstserv dw_cstserv
end type

on tabpage_cstserv.create
this.dw_cstserv=create dw_cstserv
this.Control[]={this.dw_cstserv}
end on

on tabpage_cstserv.destroy
destroy(this.dw_cstserv)
end on

type dw_cstserv from u_dw_abc within tabpage_cstserv
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 20
integer width = 2487
integer height = 1212
integer taborder = 20
string dataobject = "d_abc_pry_costo_serv"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Verificar que existe registro maestro seleccionado
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	Object.tipo_costo[ll_row] = is_tipcst_servicio
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	Object.tipo_costo[ll_row] = is_tipcst_servicio
end if
//Asignacion Automatica
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_itm_cst_aux
String ls_desc_cst_aux, ls_cnta_prsp_aux
Decimal ln_costo_aux


IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_cst_aux = Object.desc_costo[ll_origen]
	ls_cnta_prsp_aux = Object.cnta_prsp[ll_origen]
	ln_costo_aux = Object.costo_dol_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i - 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i - 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i - 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i + 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i + 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i + 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count, ll_itm_cst
String ls_nro_pry

ib_insert_mode = False

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ll_itm_cst = Object.nro_item_costo[GetRow()]

Select count(*) into :ll_count
  from pry_activ_prog_costo
 where nro_proyecto = :ls_nro_pry
   and nro_item_costo = :ll_itm_cst;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar servicio pues existen actividades utilizandolo")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_i
For ll_i = 1 to Rowcount()
	SetItem(ll_i,"fila",ll_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Object.tipo_costo[al_row] = is_tipcst_servicio
Modify("costo_dol_proy.Protect='1~If(IsRowNew(),0,1)'")
Modify("cnta_prsp.Protect='1~If(IsRowNew(),0,1)'")
Modify("desc_costo.Protect='1~If(IsRowNew(),0,1)'")
end event

type tabpage_cstotr from userobject within tab_cst
integer x = 18
integer y = 112
integer width = 2523
integer height = 1248
long backcolor = 79741120
string text = "Otros"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Move!"
long picturemaskcolor = 536870912
dw_cstotr dw_cstotr
end type

on tabpage_cstotr.create
this.dw_cstotr=create dw_cstotr
this.Control[]={this.dw_cstotr}
end on

on tabpage_cstotr.destroy
destroy(this.dw_cstotr)
end on

type dw_cstotr from u_dw_abc within tabpage_cstotr
event ue_det_agregar ( )
event ue_det_eliminar ( )
event ue_det_insertar ( )
integer x = 14
integer y = 24
integer width = 2491
integer height = 1208
integer taborder = 20
string dataobject = "d_abc_pry_costo_otr"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_det_agregar();TriggerEvent("ue_insert")
end event

event ue_det_eliminar();TriggerEvent("ue_delete")
end event

event ue_det_insertar();Integer li_i
Long ll_count,ll_row

//Verificar que existe registro maestro seleccionado
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN
	END IF
END IF

ll_count = RowCount()

If ll_count > 0 then
	ll_row = getrow()
	InsertRow(ll_row)
	Object.tipo_costo[ll_row] = is_tipcst_otro
	for li_i = 1 To RowCount()
		SetItem(li_i,"fila", li_i)
	next
else
	ll_row = InsertRow(0)
	SetItem(ll_row,"fila",1)
	Object.tipo_costo[ll_row] = is_tipcst_otro
end if
//Asignacion Automatica
IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	long ll_size , ll_row_mst, ll_ii_dk, ll_ii_rk
	ll_size = UpperBound(idw_mst.ii_dk)
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		ll_row_mst = idw_mst.il_row
		ll_ii_dk = idw_mst.ii_dk[li_x]
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		ll_ii_rk = ii_rk[li_x]
		SetItem(ll_row, ii_rk[li_x], la_id)
	NEXT
END IF
end event

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet ='d'
is_dwform = 'tabular'
idw_mst = dw_pry

ii_ck[1]=1
ii_rk[1]=1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dragdrop;call super::dragdrop;Long ll_origen, ll_destino, ll_i, ll_itm_cst_aux
String ls_desc_cst_aux, ls_cnta_prsp_aux
Decimal ln_costo_aux


IF row > 0 THEN
	ll_origen = il_row
	ll_destino = row
	ll_itm_cst_aux = Object.nro_item_costo[ll_origen]
	ls_desc_cst_aux = Object.desc_costo[ll_origen]
	ls_cnta_prsp_aux = Object.cnta_prsp[ll_origen]
	ln_costo_aux = Object.costo_dol_proy[ll_origen]
	
	IF ll_origen < ll_destino THEN
		FOR ll_i = ll_origen + 1 TO ll_destino
			Object.nro_item_costo[ll_i - 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i - 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i - 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i - 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i - 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	ELSEIF ll_origen > ll_destino THEN
		FOR ll_i = ll_origen - 1 TO ll_destino STEP -1
			Object.nro_item_costo[ll_i + 1] = Object.nro_item_costo[ll_i]
			Object.desc_costo[ll_i + 1] = Object.desc_costo[ll_i]
			Object.cnta_prsp[ll_i + 1] = Object.cnta_prsp[ll_i]
			Object.costo_dol_proy[ll_i + 1] = Object.costo_dol_proy[ll_i]
			Object.tipo_costo[ll_i + 1] = Object.tipo_costo[ll_i]
		NEXT
			Object.nro_item_costo[ll_destino] = ll_itm_cst_aux
			Object.desc_costo[ll_destino] = ls_desc_cst_aux
			Object.cnta_prsp[ll_destino] = ls_cnta_prsp_aux
			Object.costo_dol_proy[ll_destino] = ln_costo_aux
	END IF	
	Drag(End!)
END IF
end event

event getfocus;call super::getfocus;gdw_activo = this
end event

event rbuttondown;//Override Ancestor Script
il_row     = row

m_popup_detalle NewMenu

NewMenu = CREATE m_popup_detalle
NewMenu.m_detalle.PopMenu(w_main.PointerX(), w_main.PointerY())
end event

event ue_delete;//Override
//Return :  1 Eliminacion satisfactoria, -1 Eliminacion con Error
long ll_row = 1, ll_count, ll_itm_cst
String ls_nro_pry

ib_insert_mode = False

ls_nro_pry = dw_pry.Object.nro_proyecto[dw_pry.GetRow()]
ll_itm_cst = Object.nro_item_costo[GetRow()]

Select count(*) into :ll_count
  from pry_activ_prog_costo
 where nro_proyecto = :ls_nro_pry
   and nro_item_costo = :ll_itm_cst;

If ll_count > 0 then
	MessageBox("Aviso","No se puede eliminar costo en otros pues existen actividades utilizandolo")
	Return -1
end if
IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row
end event

event ue_delete_pos;call super::ue_delete_pos;Long ll_i
For ll_i = 1 to Rowcount()
	SetItem(ll_i,"fila",ll_i)
next
end event

event ue_insert;call super::ue_insert;Long ll_i
for ll_i = 1 to RowCount()
	Object.fila[ll_i] = ll_i
next
Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Object.tipo_costo[al_row] = is_tipcst_otro
Modify("costo_dol_proy.Protect='1~If(IsRowNew(),0,1)'")
Modify("cnta_prsp.Protect='1~If(IsRowNew(),0,1)'")
Modify("desc_costo.Protect='1~If(IsRowNew(),0,1)'")
end event

type dw_pry from u_dw_abc within w_pt315_pry_actividades
integer x = 27
integer y = 16
integer width = 2107
integer height = 348
string dataobject = "d_abc_proyecto"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;SetTransObject(sqlca)
is_mastdet = 'md'
InsertRow(0)
il_row = 0
ii_ck[1] = 1
ii_dk[1] = 1
end event

