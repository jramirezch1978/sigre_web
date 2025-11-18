$PBExportHeader$w_pt767_rpt_gantt.srw
forward
global type w_pt767_rpt_gantt from w_report_smpl
end type
type cb_1 from commandbutton within w_pt767_rpt_gantt
end type
type dw_ames from datawindow within w_pt767_rpt_gantt
end type
type dw_semana from datawindow within w_pt767_rpt_gantt
end type
type dw_calend from datawindow within w_pt767_rpt_gantt
end type
type sle_1 from singlelineedit within w_pt767_rpt_gantt
end type
type rb_1 from radiobutton within w_pt767_rpt_gantt
end type
type rb_2 from radiobutton within w_pt767_rpt_gantt
end type
type rb_3 from radiobutton within w_pt767_rpt_gantt
end type
type gb_1 from groupbox within w_pt767_rpt_gantt
end type
end forward

global type w_pt767_rpt_gantt from w_report_smpl
integer width = 3410
integer height = 1532
string title = "Diagrama de Gantt"
string menuname = "m_impresion"
long backcolor = 67108864
cb_1 cb_1
dw_ames dw_ames
dw_semana dw_semana
dw_calend dw_calend
sle_1 sle_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_pt767_rpt_gantt w_pt767_rpt_gantt

forward prototypes
public subroutine wf_rpt_gantt (string as_nro_pry, string as_style_header)
end prototypes

public subroutine wf_rpt_gantt (string as_nro_pry, string as_style_header);//Construye Diagrama de Gantt
//Parametros:
//	as_nro_pry: Clave que identifica el proyecto
//	as_style_header: indica la cabecera del diagrama de Gantt
//						  D: Por Dias, S: Por Semanas
string  ls_select
string  ls_where
string  ls_dwsyntax
string  ls_err
String  ls_report_type, ls_type_font, ls_style
Integer li_mes, li_i
Date 	  ld_fecha_ini, ld_fecha_ini_new
String 	ls_ColName[], ls_ColName_t[], ls_x[]
Integer li_numcols, li_totfilas
String ls_col, ls_col_t, ls_desc_periodo, ls_rubro[2]
Long ll_tabseq
Integer li_ano, li_dia
Long li_pos
Long li_x, li_semana, li_width, li_dia_mes
String ls_mes, ls_etiqueta

Select min(fecha_inicio_proy) into :ld_fecha_ini
from pry_actividad where nro_proyecto = :as_nro_pry;

ld_fecha_ini_new = Date('01/'+String(ld_fecha_ini,'mm')+'/'+String(ld_fecha_ini,'yyyy'))

sqlca.AutoCommit = True;
DECLARE pb_activ_calendario &
PROCEDURE FOR usp_pry_activ_calendario(:as_nro_pry) ;
execute pb_activ_calendario ;

IF sqlca.sqlcode = -1 THEN
  rollback ;
  MessageBox( 'Error usp_pry_activ_calendario', sqlca.sqlerrtext, StopSign! )
  Return
END IF
dw_calend.Retrieve()
dw_ames.Retrieve()
dw_semana.Retrieve()
sqlca.AutoCommit = False;

//Construccion del SQLSelect
ls_select = "Select fila, desc_actividad, fecha_inicio_proy, dias_duracion_proy, "& 
			  +"(fecha_inicio_proy - to_date('"+String(ld_fecha_ini_new,"dd/mm/yyyy")+"','dd/mm/yyyy')) as dias_ini"&
			  +" from pry_actividad "&
			  +"where nro_proyecto = '"+as_nro_pry+"' order by fila"

//Creacion Dw Dinamico
ls_report_type  = "tabular"
ls_type_font    = "Arial"
ls_style = 'style(type=' + ls_report_type + ')' + &
	        'Text(background.mode=0 background.color=12632256 color=0  border=2 ' +&
	        'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch=2 ) ' + &
	        'Column(background.mode=0 background.color=1073741824 color=0 border=0 ' +&
           'font.face = "' + ls_type_font + '"  font.height = -8  font.weight = 400 font.family = 2 ' + &
	        'font.pitch = 2 ) ' 
			  
ls_dwsyntax = SQLCA.SyntaxFromSQL ( ls_select, ls_style, ls_err )
dw_report.Create ( ls_dwsyntax, ls_err )
IF ls_err <> '' THEN
	MessageBox ( "error - Syntax", ls_err )
ELSE
	dw_report.SetTransObject ( SQLCA )
	dw_report.Retrieve()
end if

//Formato General
dw_report.Object.DataWindow.Selected.Mouse='No'
dw_report.Object.DataWindow.Retrieve.AsNeeded='Yes'
dw_report.Object.DataWindow.Grid.ColumnMove = 'no'
dw_report.Object.DataWindow.Header.Height = 152
dw_report.Object.DataWindow.Detail.Height = 60

//Obteniendo nombres de Controles del dw Dinamico
li_NumCols = Integer(dw_report.Describe("Datawindow.Column.Count"))
ll_tabseq = 0
FOR li_i = 1 TO li_NumCols
	ls_ColName  [li_i] = dw_report.Describe("#"+String(li_i)+".Name")
	ls_ColName_t[li_i] = ls_ColName[li_i]+'_t'
	//ll_tabseq = ll_tabseq + 10
	//dw_report.Modify(ls_ColName[li_i]+".tabsequence="+String(ll_tabseq))
NEXT
//dw_report.Object.fila.tabsequence = 0


//Formato Detalle
//Datos
Integer li_size_fila, li_size_desc_activ, li_size_fec_ini, li_size_dias, li_wdia
//li_wdia establece el nro de unidades para representar un dia
li_size_fila = 100
li_size_desc_activ = 1000
li_size_fec_ini = 300
li_size_dias = 200
li_pos = li_size_fila + li_size_desc_activ + li_size_fec_ini + li_size_dias

//Etiquetas de la cabecera
dw_report.Modify(ls_ColName_t[1]+".text='N°' "+ls_ColName_t[1]+".x=0 "+ls_ColName_t[1]+".y=4 "+ls_ColName_t[1]+".width="+String(li_size_fila)+" "+ls_ColName_t[1]+".height=144")
dw_report.Modify(ls_ColName_t[2]+".text='Actividad' "+ls_ColName_t[2]+".x="+String(li_size_fila)+" "+ls_ColName_t[2]+".y=4 "+ls_ColName_t[2]+".width="+String(li_size_desc_activ)+" "+ls_ColName_t[2]+".height=144")
dw_report.Modify(ls_ColName_t[3]+".text='Fch Inicio' "+ls_ColName_t[3]+".x="+String(li_size_fila+li_size_desc_activ)+" "+ls_ColName_t[3]+".y=4 "+ls_ColName_t[3]+".width="+String(li_size_fec_ini)+" "+ls_ColName_t[3]+".height=144")
dw_report.Modify(ls_ColName_t[4]+".text='Dias' "+ls_ColName_t[4]+".x="+String(li_size_fila+li_size_desc_activ+li_size_fec_ini)+" "+ls_ColName_t[4]+".y=4 "+ls_ColName_t[4]+".width="+String(li_size_dias)+" "+ls_ColName_t[4]+".height=144")

//Columnas
dw_report.Modify(ls_ColName[1]+".x=0 "+ls_ColName[1]+".y=0 "+ls_ColName[1]+".width="+String(li_size_fila)+" "+ls_ColName[1]+".border='1'")// Nro Fila
dw_report.Modify(ls_ColName[2]+".x="+String(li_size_fila)+" "+ls_ColName[2]+".y=0 "+ls_ColName[2]+".width="+String(li_size_desc_activ)+" "+ls_ColName[2]+".border='1'")
dw_report.Modify(ls_ColName[3]+".x="+String(li_size_fila+li_size_desc_activ)+" "+ls_ColName[3]+".y=0 "+ls_ColName[3]+".width="+String(li_size_fec_ini)+" "+ls_ColName[3]+".format='dd/mm/yy' "+ls_ColName[3]+".alignment=2 "+ls_ColName[3]+".border='1'")
dw_report.Modify(ls_ColName[4]+".x="+String(li_size_fila+li_size_desc_activ+li_size_fec_ini)+" "+ls_ColName[4]+".y=0 "+ls_ColName[4]+".width="+String(li_size_dias)+" "+ls_ColName[4]+".border='2'")

//Ocultar columna dias_ini
dw_report.Modify(ls_ColName[5]+".visible=0" + ls_ColName[5]+".Width=0")

//rectangle(band=detail x="1115~t800 + dias_ini*7" y="4~tif(dias_ini<0, 40, 5)" height="56~tif(dias_ini<0, 6, 64)" width="137~t dias_duracion_proy*7"  name=r_1 visible="1" brush.hatch="6" brush.color="12632256~tIf( flag_estado=~"0~", rgb(255,0,0), 
//If( flag_estado=~"1~", rgb( 239,157,107), If( flag_estado=~"2~", rgb(0,192,0), rgb(192,192,192) ) ) )" pen.style="5" pen.width="5" pen.color="276856960"  background.mode="2" background.color="0" )
//compute(band=detail alignment="0" expression="daysafter(  2000-01-01, fec_inicio )"border="0" color="0" x="805" y="4" height="56" width="183" format="[general]" html.valueishtml="0"  name=dias_ini visible="1"  hidesnaked=1  font.face="Arial" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="1" background.color="553648127" )

choose case as_style_header
	case "D"
		li_wdia = 50
		//Crear Cabeceras
		//Año y Mes
		li_x = li_pos
		for li_i = 1 to dw_ames.RowCount()
			li_ano = dw_ames.Object.ano[li_i]
			li_mes = dw_ames.Object.mes[li_i]
			ls_mes = f_meses_texto(Right("0"+String(li_mes),2))
			li_dia = dw_ames.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			dw_report.modify('create text(band=header alignment="2" text="'+ls_mes+' '+String(li_ano)+'" border="2" color="0" x="'+String(li_x)+'" y="4" height="48" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			li_x = li_x + li_width
		next
		//Semanas
		li_x = li_pos
		for li_i = 1 to dw_semana.RowCount()
			li_dia = dw_semana.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			dw_report.modify('create text(band=header alignment="2" text="'+String(li_semana)+'" border="2" color="0" x="'+String(li_x)+'" y="52" height="48" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			//Linea x Semana
			if li_x <> li_pos then
				dw_report.modify('create line(band=detail x1="'+String(li_x)+'" x2="'+String(li_x)+'" y1="0" y2="60" pen.style="2" pen.width="9" pen.color="12632256"  background.mode="1")')
			end if
			li_x = li_x + li_width
		next
		//Dias
		for li_i = 1 to dw_calend.RowCount()
			li_dia = dw_calend.Object.dia[li_i]
			li_x = li_pos + (li_i - 1)*li_wdia
			dw_report.modify('create text(band=header alignment="2" text="'+String(li_dia)+'" border="2" color="0" x="'+String(li_x)+'" y="100" height="48" width="'+String(li_wdia)+'" font.face="Arial Narrow" font.height="-7" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
		next
		//Barra del Diagrama de Gantt
		dw_report.modify('create text(band=detail alignment="2" text="'+""+'" border="0" color="0" x="1115~t'+String(li_pos)+' + dias_ini*'+String(li_wdia)+'" y="6" height="48" width="0~tIf(IsNull(dias_duracion_proy),0,dias_duracion_proy*'+String(li_wdia)+')" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="0" background.color="134217741" )')
	case "S"
		li_wdia = 25
		//Crear Cabeceras
		//Año y Mes
		li_x = li_pos
		for li_i = 1 to dw_ames.RowCount()
			li_ano = dw_ames.Object.ano[li_i]
			li_mes = dw_ames.Object.mes[li_i]
			ls_mes = f_meses_texto(Right("0"+String(li_mes),2))
			li_dia = dw_ames.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			dw_report.modify('create text(band=header alignment="2" text="'+ls_mes+' '+String(li_ano)+'" border="2" color="0" x="'+String(li_x)+'" y="4" height="48" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			li_x = li_x + li_width
		next
		//Dia Mes(inicial de la semana)
		li_x = li_pos
		for li_i = 1 to dw_semana.RowCount()
			li_dia = dw_semana.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			li_dia_mes = dw_semana.Object.dia_mes[li_i]
			li_mes = dw_semana.Object.mes[li_i]
			ls_etiqueta = String(li_dia_mes)+" "+f_meses_texto(Right("0"+String(li_mes),2))
			dw_report.modify('create text(band=header alignment="3" text="'+ls_etiqueta+'" border="2" color="0" x="'+String(li_x)+'" y="52" height="48" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-7" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			li_x = li_x + li_width
		next
		//Semanas
		li_x = li_pos
		for li_i = 1 to dw_semana.RowCount()
			li_dia = dw_semana.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			dw_report.modify('create text(band=header alignment="2" text="'+String(li_semana)+'" border="2" color="0" x="'+String(li_x)+'" y="100" height="48" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			//Linea x Semana
			if li_x <> li_pos then
				dw_report.modify('create line(band=detail x1="'+String(li_x)+'" x2="'+String(li_x)+'" y1="0" y2="60" pen.style="2" pen.width="9" pen.color="12632256"  background.mode="1")')
			end if
			li_x = li_x + li_width
		next
		//Barra del Diagrama de Gantt
		dw_report.modify('create text(band=detail alignment="2" text="'+""+'" border="0" color="0" x="1115~t'+String(li_pos)+' + dias_ini*'+String(li_wdia)+'" y="6" height="48" width="0~tIf(IsNull(dias_duracion_proy),0,dias_duracion_proy*'+String(li_wdia)+')" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="0" background.color="134217747" )')

	case "M"
		li_wdia = 10
		//Crear Cabeceras
		//Año y Mes
		li_x = li_pos
		for li_i = 1 to dw_ames.RowCount()
			li_ano = dw_ames.Object.ano[li_i]
			li_mes = dw_ames.Object.mes[li_i]
			ls_mes = f_meses_texto(Right("0"+String(li_mes),2))
			li_dia = dw_ames.Object.dias[li_i]
			li_semana = dw_semana.Object.semana[li_i]
			li_width = li_wdia*li_dia
			dw_report.modify('create text(band=header alignment="2" text="'+ls_mes+' '+String(li_ano)+'" border="2" color="0" x="'+String(li_x)+'" y="4" height="144" width="'+String(li_width)+'" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="2" background.color="65280" )')
			//Linea x Mes
			if li_x <> li_pos then
				dw_report.modify('create line(band=detail x1="'+String(li_x)+'" x2="'+String(li_x)+'" y1="0" y2="60" pen.style="2" pen.width="9" pen.color="12632256"  background.mode="1")')
			end if
			li_x = li_x + li_width
		next
		//Barra del Diagrama de Gantt
		dw_report.modify('create text(band=detail alignment="2" text="'+""+'" border="0" color="0" x="1115~t'+String(li_pos)+' + dias_ini*'+String(li_wdia)+'" y="6" height="48" width="0~tIf(IsNull(dias_duracion_proy),0,dias_duracion_proy*'+String(li_wdia)+')" font.face="Arial Narrow" font.height="-8" font.weight="400"  font.family="2" font.pitch="2" font.charset="0" background.mode="0" background.color="65280" )')

end choose

dw_report.Settransobject(SQLCA)
dw_report.visible = true
setpointer(Arrow!)
end subroutine

on w_pt767_rpt_gantt.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.dw_ames=create dw_ames
this.dw_semana=create dw_semana
this.dw_calend=create dw_calend
this.sle_1=create sle_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.dw_ames
this.Control[iCurrent+3]=this.dw_semana
this.Control[iCurrent+4]=this.dw_calend
this.Control[iCurrent+5]=this.sle_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.rb_3
this.Control[iCurrent+9]=this.gb_1
end on

on w_pt767_rpt_gantt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.dw_ames)
destroy(this.dw_semana)
destroy(this.dw_calend)
destroy(this.sle_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;//integer li_ano, li_mes_desde, li_mes_hasta
//string  ls_mensaje
//
//li_ano       = integer(em_ano.text)
//li_mes_desde = integer(em_mes_desde.text)
//li_mes_hasta = integer(em_mes_hasta.text)
//
//DECLARE pb_usp_ptto_rpt_volquetes PROCEDURE FOR USP_PTTO_RPT_VOLQUETES
//        ( :li_ano, :li_mes_desde, :li_mes_hasta ) ;
//EXECUTE pb_usp_ptto_rpt_volquetes ;
//
//idw_1.retrieve()
//
//idw_1.object.p_logo.filename = gs_logo
//idw_1.object.t_nombre.text   = gs_empresa
//idw_1.object.t_user.text     = gs_user
//
//if SQLCA.SQLCode = -1 then
//  ls_mensaje = sqlca.sqlerrtext
//  rollback ;
//  MessageBox("SQL error", ls_mensaje, StopSign!)
//end if
//
end event

event ue_open_pre;call super::ue_open_pre;String ls_nro_pry
ls_nro_pry = Message.StringParm
sle_1.Text = ls_nro_pry
wf_rpt_gantt(ls_nro_pry,"D")
end event

type dw_report from w_report_smpl`dw_report within w_pt767_rpt_gantt
integer x = 9
integer y = 156
integer width = 3355
integer height = 1184
integer taborder = 50
boolean hsplitscroll = true
end type

type cb_1 from commandbutton within w_pt767_rpt_gantt
boolean visible = false
integer x = 2185
integer y = 24
integer width = 302
integer height = 76
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type dw_ames from datawindow within w_pt767_rpt_gantt
boolean visible = false
integer x = 1097
integer y = 172
integer width = 544
integer height = 400
integer taborder = 60
boolean bringtotop = true
string title = "none"
string dataobject = "d_lis_pry_anomes"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetTransObject(sqlca)
end event

type dw_semana from datawindow within w_pt767_rpt_gantt
boolean visible = false
integer x = 1678
integer y = 156
integer width = 997
integer height = 400
integer taborder = 70
boolean bringtotop = true
string title = "none"
string dataobject = "d_lis_pry_semanas"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetTransObject(sqlca)
end event

type dw_calend from datawindow within w_pt767_rpt_gantt
boolean visible = false
integer x = 2715
integer width = 544
integer height = 400
integer taborder = 80
boolean bringtotop = true
string title = "none"
string dataobject = "d_lis_pry_activ_calendario"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event constructor;SetTransObject(sqlca)
end event

type sle_1 from singlelineedit within w_pt767_rpt_gantt
integer x = 18
integer y = 28
integer width = 581
integer height = 100
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type rb_1 from radiobutton within w_pt767_rpt_gantt
integer x = 704
integer y = 52
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Dias"
boolean checked = true
end type

event clicked;String ls_nro_pry
If rb_1.Checked then
	ls_nro_pry = sle_1.Text
	wf_rpt_gantt(ls_nro_pry,"D")
end if
end event

type rb_2 from radiobutton within w_pt767_rpt_gantt
integer x = 1019
integer y = 52
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Semanas"
end type

event clicked;String ls_nro_pry
If rb_2.Checked then
	ls_nro_pry = sle_1.Text
	wf_rpt_gantt(ls_nro_pry,"S")
end if
end event

type rb_3 from radiobutton within w_pt767_rpt_gantt
integer x = 1417
integer y = 52
integer width = 343
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Meses"
end type

event clicked;String ls_nro_pry
If rb_3.Checked then
	ls_nro_pry = sle_1.Text
	wf_rpt_gantt(ls_nro_pry,"M")
end if
end event

type gb_1 from groupbox within w_pt767_rpt_gantt
integer x = 667
integer y = 12
integer width = 1157
integer height = 112
integer taborder = 80
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Diagrama"
end type

