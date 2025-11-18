$PBExportHeader$w_pop_grf.srw
forward
global type w_pop_grf from window
end type
type dw_1 from u_dw_abc within w_pop_grf
end type
type st_1 from statictext within w_pop_grf
end type
type gr_1 from graph within w_pop_grf
end type
end forward

global type w_pop_grf from window
integer width = 2071
integer height = 1884
boolean titlebar = true
string title = "Detalle (w_pop_grf)"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_gr01 ( string as_title,  string as_nave,  date ad_fecha1,  date ad_fecha2 )
dw_1 dw_1
st_1 st_1
gr_1 gr_1
end type
global w_pop_grf w_pop_grf

type variables
m_rb_graph	im_graph
u_ds_base 	ids_data
end variables

forward prototypes
public subroutine of_copiar ()
end prototypes

event ue_gr01(string as_title, string as_nave, date ad_fecha1, date ad_fecha2);// Detalle de la eficiencia de Pesca
string 	ls_CodNave, ls_mensaje
Integer 	li_Serie1, li_Serie2, li_x, li_ok
decimal	ln_captura, ln_CapBod
Date		ld_fecha


//create or replace procedure USP_FL_DET_NAVE_PESCA(
//		adi_fecha1 		in date, 
//    adi_fecha2 		in date,
//    asi_nomb_nave in varchar2, 
//    aso_mensaje 	out varchar2, 
//    aio_ok 				out number) is

DECLARE USP_FL_DET_NAVE_PESCA PROCEDURE FOR
	USP_FL_DET_NAVE_PESCA( :ad_fecha1, :ad_fecha2, :as_nave );

EXECUTE USP_FL_DET_NAVE_PESCA;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_DET_NAVE_PESCA: " &
		+ SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

FETCH USP_FL_DET_NAVE_PESCA INTO :ls_mensaje, :li_ok;
CLOSE USP_FL_DET_NAVE_PESCA;

if li_ok <> 1 then
	MessageBox('Error USP_FL_DET_NAVE_PESCA', ls_mensaje, StopSign!)	
	return 
end if

gr_1.SetRedraw(false)
gr_1.Reset( All! )

gr_1.Title = as_title

dw_1.DataObject = 'ds_ventas_fecha_nave'
dw_1.SetTransObject(SQLCA)
dw_1.Retrieve()

ids_data.DataObject = 'ds_ventas_fecha_nave'
ids_data.SetTransObject(SQLCA)
ids_data.Retrieve()

li_Serie1 	= gr_1.AddSeries("1.- Pesca Capturada")
li_Serie2 	= gr_1.AddSeries("2.- Capacidad Bodega")


for li_x = 1 to ids_data.RowCount()
	ln_captura 	= dec(ids_data.object.pesca[li_x])
	ld_fecha		= Date(ids_data.object.fecha[li_x])
	ln_CapBod	= Dec(ids_data.object.capac_bodega[li_x])
	
	gr_1.AddData( li_Serie1, ln_captura, ld_fecha )
	gr_1.AddData( li_Serie2, ln_CapBod, ld_fecha )
next

gr_1.SetRedraw(true)
end event

public subroutine of_copiar ();gr_1.ClipBoard( )
end subroutine

on w_pop_grf.create
this.dw_1=create dw_1
this.st_1=create st_1
this.gr_1=create gr_1
this.Control[]={this.dw_1,&
this.st_1,&
this.gr_1}
end on

on w_pop_grf.destroy
destroy(this.dw_1)
destroy(this.st_1)
destroy(this.gr_1)
end on

event open;im_graph = create m_rb_graph
ids_data = create u_ds_base
end event

event close;destroy im_graph
destroy ids_data
end event

event resize;this.SetRedraw(false)
gr_1.width  = newwidth  - gr_1.x - 10
gr_1.height = newheight - gr_1.y - 10
st_1.y = gr_1.height - st_1.height - 5
st_1.width  = newwidth  - st_1.x - 10
this.SetRedraw(true)
end event

type dw_1 from u_dw_abc within w_pop_grf
boolean visible = false
integer y = 1280
integer width = 2002
integer height = 468
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type st_1 from statictext within w_pop_grf
integer x = 18
integer y = 1176
integer width = 1874
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
boolean focusrectangle = false
end type

type gr_1 from graph within w_pop_grf
event create ( )
event destroy ( )
integer y = 4
integer width = 1979
integer height = 1260
boolean border = true
grgraphtype graphtype = linegraph!
long textcolor = 33554432
long backcolor = 16777215
integer spacing = 100
integer elevation = 6
integer rotation = -33
integer perspective = 7
integer depth = 100
grlegendtype legend = atbottom!
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
grsorttype seriessort = ascending!
grsorttype categorysort = ascending!
end type

on gr_1.create
TitleDispAttr = create grDispAttr
LegendDispAttr = create grDispAttr
PieDispAttr = create grDispAttr
Series = create grAxis
Series.DispAttr = create grDispAttr
Series.LabelDispAttr = create grDispAttr
Category = create grAxis
Category.DispAttr = create grDispAttr
Category.LabelDispAttr = create grDispAttr
Values = create grAxis
Values.DispAttr = create grDispAttr
Values.LabelDispAttr = create grDispAttr
TitleDispAttr.Weight=700
TitleDispAttr.FaceName="Arial"
TitleDispAttr.FontCharSet=DefaultCharSet!
TitleDispAttr.FontFamily=Swiss!
TitleDispAttr.FontPitch=Variable!
TitleDispAttr.Alignment=Center!
TitleDispAttr.BackColor=536870912
TitleDispAttr.Format="[General]"
TitleDispAttr.DisplayExpression="title"
TitleDispAttr.AutoSize=true
Category.Label="Fechas"
Category.AutoScale=true
Category.ShadeBackEdge=true
Category.SecondaryLine=transparent!
Category.MajorGridLine=transparent!
Category.MinorGridLine=transparent!
Category.DropLines=transparent!
Category.OriginLine=transparent!
Category.MajorTic=Outside!
Category.DataType=adtDate!
Category.DispAttr.TextSize=11
Category.DispAttr.Weight=400
Category.DispAttr.FaceName="Times New Roman"
Category.DispAttr.FontCharSet=DefaultCharSet!
Category.DispAttr.FontFamily=Roman!
Category.DispAttr.FontPitch=Variable!
Category.DispAttr.Alignment=Center!
Category.DispAttr.BackColor=536870912
Category.DispAttr.Format="[General]"
Category.DispAttr.DisplayExpression="category"
Category.DispAttr.Escapement=900
Category.LabelDispAttr.Weight=400
Category.LabelDispAttr.FaceName="Arial"
Category.LabelDispAttr.FontCharSet=DefaultCharSet!
Category.LabelDispAttr.FontFamily=Swiss!
Category.LabelDispAttr.FontPitch=Variable!
Category.LabelDispAttr.Alignment=Center!
Category.LabelDispAttr.BackColor=536870912
Category.LabelDispAttr.Format="[General]"
Category.LabelDispAttr.DisplayExpression="categoryaxislabel"
Category.LabelDispAttr.AutoSize=true
Values.Label="Toneladas"
Values.AutoScale=true
Values.SecondaryLine=transparent!
Values.MajorGridLine=transparent!
Values.MinorGridLine=transparent!
Values.DropLines=transparent!
Values.MajorTic=Outside!
Values.DataType=adtDouble!
Values.DispAttr.Weight=400
Values.DispAttr.FaceName="Arial"
Values.DispAttr.FontCharSet=DefaultCharSet!
Values.DispAttr.FontFamily=Swiss!
Values.DispAttr.FontPitch=Variable!
Values.DispAttr.Alignment=Right!
Values.DispAttr.BackColor=536870912
Values.DispAttr.Format="[General]"
Values.DispAttr.DisplayExpression="value"
Values.DispAttr.AutoSize=true
Values.LabelDispAttr.Weight=400
Values.LabelDispAttr.FaceName="Arial"
Values.LabelDispAttr.FontCharSet=DefaultCharSet!
Values.LabelDispAttr.FontFamily=Swiss!
Values.LabelDispAttr.FontPitch=Variable!
Values.LabelDispAttr.Alignment=Center!
Values.LabelDispAttr.BackColor=536870912
Values.LabelDispAttr.Format="[General]"
Values.LabelDispAttr.DisplayExpression="valuesaxislabel"
Values.LabelDispAttr.AutoSize=true
Values.LabelDispAttr.Escapement=900
Series.Label="(None)"
Series.AutoScale=true
Series.SecondaryLine=transparent!
Series.MajorGridLine=transparent!
Series.MinorGridLine=transparent!
Series.DropLines=transparent!
Series.OriginLine=transparent!
Series.MajorTic=Outside!
Series.DataType=adtText!
Series.DispAttr.Weight=400
Series.DispAttr.FaceName="Arial"
Series.DispAttr.FontCharSet=DefaultCharSet!
Series.DispAttr.FontFamily=Swiss!
Series.DispAttr.FontPitch=Variable!
Series.DispAttr.BackColor=536870912
Series.DispAttr.Format="[General]"
Series.DispAttr.DisplayExpression="series"
Series.DispAttr.AutoSize=true
Series.LabelDispAttr.Weight=400
Series.LabelDispAttr.FaceName="Arial"
Series.LabelDispAttr.FontCharSet=DefaultCharSet!
Series.LabelDispAttr.FontFamily=Swiss!
Series.LabelDispAttr.FontPitch=Variable!
Series.LabelDispAttr.Alignment=Center!
Series.LabelDispAttr.BackColor=536870912
Series.LabelDispAttr.Format="[General]"
Series.LabelDispAttr.DisplayExpression="seriesaxislabel"
Series.LabelDispAttr.AutoSize=true
LegendDispAttr.Weight=400
LegendDispAttr.FaceName="Arial"
LegendDispAttr.FontCharSet=DefaultCharSet!
LegendDispAttr.FontFamily=Swiss!
LegendDispAttr.FontPitch=Variable!
LegendDispAttr.BackColor=536870912
LegendDispAttr.Format="[General]"
LegendDispAttr.DisplayExpression="series"
LegendDispAttr.AutoSize=true
PieDispAttr.Weight=400
PieDispAttr.FaceName="Arial"
PieDispAttr.FontCharSet=DefaultCharSet!
PieDispAttr.FontFamily=Swiss!
PieDispAttr.FontPitch=Variable!
PieDispAttr.BackColor=536870912
PieDispAttr.Format="[General]"
PieDispAttr.DisplayExpression="if(seriescount > 1, series,string(percentofseries,~"0.00%~"))"
PieDispAttr.AutoSize=true
end on

on gr_1.destroy
destroy TitleDispAttr
destroy LegendDispAttr
destroy PieDispAttr
destroy Series.DispAttr
destroy Series.LabelDispAttr
destroy Series
destroy Category.DispAttr
destroy Category.LabelDispAttr
destroy Category
destroy Values.DispAttr
destroy Values.LabelDispAttr
destroy Values
end on

event rbuttondown;im_graph.PopMenu(w_main.PointerX(), w_main.PointerY())

end event

event clicked;grObjectType	ClickedObject
int		li_Rtn, li_Series, li_Category
string 	ls_serie, ls_categ, ls_cantidad
long ll_row


ClickedObject = this.ObjectAtPointer(li_Series, li_category)

if ClickedObject = TypeData! &
	or ClickedObject = TypeCategory! then
	
	ls_categ = this.CategoryName(li_Category)
	ls_serie = this.SeriesName(li_Series)
	
	ls_cantidad = string(this.GetData(li_series, li_category), '###,##0.00')
	
	
	st_1.text = ls_serie + ' - ' + ls_categ &
			+ ' Cantidad: ' + ls_cantidad + ' TONELADAS'
	
else
	MessageBox(Parent.Title, "Haga Click en alguna " &
		+"barra que desee consultar", &
		Information!)
end if

end event

