$PBExportHeader$w_googlemaps_demo.srw
forward
global type w_googlemaps_demo from window
end type
type st_error from statictext within w_googlemaps_demo
end type
type cb_find from commandbutton within w_googlemaps_demo
end type
type sle_address from singlelineedit within w_googlemaps_demo
end type
type cb_2 from commandbutton within w_googlemaps_demo
end type
type rb_hybrid from radiobutton within w_googlemaps_demo
end type
type rb_satellite from radiobutton within w_googlemaps_demo
end type
type rb_normal from radiobutton within w_googlemaps_demo
end type
type cbx_continuouszoom from checkbox within w_googlemaps_demo
end type
type cbx_doubleclickzoom from checkbox within w_googlemaps_demo
end type
type cbx_infowindow from checkbox within w_googlemaps_demo
end type
type cbx_dragging from checkbox within w_googlemaps_demo
end type
type cb_setascenter from commandbutton within w_googlemaps_demo
end type
type cb_removemarkers from commandbutton within w_googlemaps_demo
end type
type st_6 from statictext within w_googlemaps_demo
end type
type st_5 from statictext within w_googlemaps_demo
end type
type st_4 from statictext within w_googlemaps_demo
end type
type ddlb_zoom from dropdownlistbox within w_googlemaps_demo
end type
type cb_setcenterzoom from commandbutton within w_googlemaps_demo
end type
type st_3 from statictext within w_googlemaps_demo
end type
type em_ct_lng from editmask within w_googlemaps_demo
end type
type st_2 from statictext within w_googlemaps_demo
end type
type st_1 from statictext within w_googlemaps_demo
end type
type em_ct_lat from editmask within w_googlemaps_demo
end type
type em_mk_lng from editmask within w_googlemaps_demo
end type
type em_mk_lat from editmask within w_googlemaps_demo
end type
type cb_addmarker from commandbutton within w_googlemaps_demo
end type
type mle_mk_info from multilineedit within w_googlemaps_demo
end type
type cbx_overviewmapcontrol from checkbox within w_googlemaps_demo
end type
type cbx_maptypecontrol from checkbox within w_googlemaps_demo
end type
type cbx_scalecontrol from checkbox within w_googlemaps_demo
end type
type cbx_smallzoomcontrol from checkbox within w_googlemaps_demo
end type
type cbx_smallmapcontrol from checkbox within w_googlemaps_demo
end type
type cbx_largemapcontrol from checkbox within w_googlemaps_demo
end type
type gb_1 from groupbox within w_googlemaps_demo
end type
type gb_2 from groupbox within w_googlemaps_demo
end type
type gb_3 from groupbox within w_googlemaps_demo
end type
type gb_4 from groupbox within w_googlemaps_demo
end type
type gb_5 from groupbox within w_googlemaps_demo
end type
type gb_address from groupbox within w_googlemaps_demo
end type
end forward

global type w_googlemaps_demo from window
integer width = 4608
integer height = 2672
boolean titlebar = true
string title = "Google Maps Control Demo"
boolean controlmenu = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_error st_error
cb_find cb_find
sle_address sle_address
cb_2 cb_2
rb_hybrid rb_hybrid
rb_satellite rb_satellite
rb_normal rb_normal
cbx_continuouszoom cbx_continuouszoom
cbx_doubleclickzoom cbx_doubleclickzoom
cbx_infowindow cbx_infowindow
cbx_dragging cbx_dragging
cb_setascenter cb_setascenter
cb_removemarkers cb_removemarkers
st_6 st_6
st_5 st_5
st_4 st_4
ddlb_zoom ddlb_zoom
cb_setcenterzoom cb_setcenterzoom
st_3 st_3
em_ct_lng em_ct_lng
st_2 st_2
st_1 st_1
em_ct_lat em_ct_lat
em_mk_lng em_mk_lng
em_mk_lat em_mk_lat
cb_addmarker cb_addmarker
mle_mk_info mle_mk_info
cbx_overviewmapcontrol cbx_overviewmapcontrol
cbx_maptypecontrol cbx_maptypecontrol
cbx_scalecontrol cbx_scalecontrol
cbx_smallzoomcontrol cbx_smallzoomcontrol
cbx_smallmapcontrol cbx_smallmapcontrol
cbx_largemapcontrol cbx_largemapcontrol
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
gb_4 gb_4
gb_5 gb_5
gb_address gb_address
end type
global w_googlemaps_demo w_googlemaps_demo

type variables
uo_googlemap_api GoogleMapAPI
vo_googlemap_pb GoogleMapControl_HL
vo_googlemap_activex GoogleMapControl_AX
integer _width
integer _height
string is_mapfile

end variables

forward prototypes
public subroutine init_ui ()
public subroutine init_map ()
public function integer init_db ()
public subroutine rendermap ()
public subroutine setheightwidth (dragobject ad_object)
end prototypes

public subroutine init_ui ();//control
cbx_largemapcontrol.checked = GoogleMapAPI.has_largemapcontrol()
cbx_smallmapcontrol.checked = GoogleMapAPI.has_smallmapcontrol()
cbx_smallzoomcontrol.checked = GoogleMapAPI.has_smallzoomcontrol()
cbx_scalecontrol.checked = GoogleMapAPI.has_scalecontrol()
cbx_maptypecontrol.checked = GoogleMapAPI.has_maptypecontrol()
cbx_overviewmapcontrol.checked = GoogleMapAPI.has_overviewmapcontrol()

//map center and zoom
em_ct_lat.Text = string(GoogleMapAPI.get_mapcenter().lat)
em_ct_lng.Text = string(GoogleMapAPI.get_mapcenter().lng)
ddlb_zoom.Text = string(GoogleMapAPI.get_zoomlevel())

//configuration
cbx_dragging.checked = GoogleMapAPI.dragging_enabled()
cbx_infowindow.checked = GoogleMapAPI.infowindow_enabled()
cbx_doubleclickzoom.checked = GoogleMapAPI.doubleclickzoom_enabled()
cbx_continuouszoom.checked = GoogleMapAPI.continuouszoom_enabled()

//map type
rb_normal.checked = GoogleMapAPI.is_normalmap()
rb_satellite.checked = GoogleMapAPI.is_satellitemap()
rb_hybrid.checked = GoogleMapAPI.is_hybridmap()

#IF DEFINED PBWEBFORM THEN
	this.controlmenu = FALSE
#END IF


end subroutine

public subroutine init_map ();//get Google Maps API Key from web.config
#IF DEFINED PBWEBFORM THEN
	GoogleMapAPI.is_apikey = GetConfigSetting("GoogleMapsAPIKey")
	OpenUserObject(GoogleMapControl_HL,35,25)
	this.SetHeightWidth(GoogleMapControl_HL)
#ELSE
	GoogleMapAPI.is_APIKEY = "AIzaSyD-_EAVP9aSkoAHUtn_7O9DdhKo6leuMGM"
	OpenUserObject(GoogleMapControl_AX,35,25)
	this.SetHeightWidth(GoogleMapControl_AX)
#END IF

GoogleMapAPI.set_largemapcontrol(true)
GoogleMApAPI.set_maptypecontrol(true)

//render map
this.RenderMap()

end subroutine

public function integer init_db ();//Connect to the database 
SQLCA.DBMS = "ODBC"
SQLCA.AutoCommit = False
SQLCA.DBParm = "ConnectString='DSN=EAS Demo DB V110;UID=dba;PWD=sql'"

Connect using SQLCA;

return SQLCA.SQLCode
end function

public subroutine rendermap ();//render map
is_mapfile = GoogleMapAPI.render_map(_width,_height)

#if defined PBWEBFORM then
	GoogleMapControl_HL.URL = GetDownloadFileUrl(is_mapfile, true)
#ELSE
	GoogleMapControl_AX.object.resizable = FALSE
	GoogleMapControl_AX.object.Navigate(is_mapfile)
	GoogleMapControl_AX.SetFocus()
#end if

end subroutine

public subroutine setheightwidth (dragobject ad_object);_width = UnitsToPixels(ad_object.Width, XUnitsToPixels!)
_height = UnitsToPixels(ad_object.Height, YUnitsToPixels!) 

end subroutine

on w_googlemaps_demo.create
this.st_error=create st_error
this.cb_find=create cb_find
this.sle_address=create sle_address
this.cb_2=create cb_2
this.rb_hybrid=create rb_hybrid
this.rb_satellite=create rb_satellite
this.rb_normal=create rb_normal
this.cbx_continuouszoom=create cbx_continuouszoom
this.cbx_doubleclickzoom=create cbx_doubleclickzoom
this.cbx_infowindow=create cbx_infowindow
this.cbx_dragging=create cbx_dragging
this.cb_setascenter=create cb_setascenter
this.cb_removemarkers=create cb_removemarkers
this.st_6=create st_6
this.st_5=create st_5
this.st_4=create st_4
this.ddlb_zoom=create ddlb_zoom
this.cb_setcenterzoom=create cb_setcenterzoom
this.st_3=create st_3
this.em_ct_lng=create em_ct_lng
this.st_2=create st_2
this.st_1=create st_1
this.em_ct_lat=create em_ct_lat
this.em_mk_lng=create em_mk_lng
this.em_mk_lat=create em_mk_lat
this.cb_addmarker=create cb_addmarker
this.mle_mk_info=create mle_mk_info
this.cbx_overviewmapcontrol=create cbx_overviewmapcontrol
this.cbx_maptypecontrol=create cbx_maptypecontrol
this.cbx_scalecontrol=create cbx_scalecontrol
this.cbx_smallzoomcontrol=create cbx_smallzoomcontrol
this.cbx_smallmapcontrol=create cbx_smallmapcontrol
this.cbx_largemapcontrol=create cbx_largemapcontrol
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
this.gb_4=create gb_4
this.gb_5=create gb_5
this.gb_address=create gb_address
this.Control[]={this.st_error,&
this.cb_find,&
this.sle_address,&
this.cb_2,&
this.rb_hybrid,&
this.rb_satellite,&
this.rb_normal,&
this.cbx_continuouszoom,&
this.cbx_doubleclickzoom,&
this.cbx_infowindow,&
this.cbx_dragging,&
this.cb_setascenter,&
this.cb_removemarkers,&
this.st_6,&
this.st_5,&
this.st_4,&
this.ddlb_zoom,&
this.cb_setcenterzoom,&
this.st_3,&
this.em_ct_lng,&
this.st_2,&
this.st_1,&
this.em_ct_lat,&
this.em_mk_lng,&
this.em_mk_lat,&
this.cb_addmarker,&
this.mle_mk_info,&
this.cbx_overviewmapcontrol,&
this.cbx_maptypecontrol,&
this.cbx_scalecontrol,&
this.cbx_smallzoomcontrol,&
this.cbx_smallmapcontrol,&
this.cbx_largemapcontrol,&
this.gb_1,&
this.gb_2,&
this.gb_3,&
this.gb_4,&
this.gb_5,&
this.gb_address}
end on

on w_googlemaps_demo.destroy
destroy(this.st_error)
destroy(this.cb_find)
destroy(this.sle_address)
destroy(this.cb_2)
destroy(this.rb_hybrid)
destroy(this.rb_satellite)
destroy(this.rb_normal)
destroy(this.cbx_continuouszoom)
destroy(this.cbx_doubleclickzoom)
destroy(this.cbx_infowindow)
destroy(this.cbx_dragging)
destroy(this.cb_setascenter)
destroy(this.cb_removemarkers)
destroy(this.st_6)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.ddlb_zoom)
destroy(this.cb_setcenterzoom)
destroy(this.st_3)
destroy(this.em_ct_lng)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_ct_lat)
destroy(this.em_mk_lng)
destroy(this.em_mk_lat)
destroy(this.cb_addmarker)
destroy(this.mle_mk_info)
destroy(this.cbx_overviewmapcontrol)
destroy(this.cbx_maptypecontrol)
destroy(this.cbx_scalecontrol)
destroy(this.cbx_smallzoomcontrol)
destroy(this.cbx_smallmapcontrol)
destroy(this.cbx_largemapcontrol)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
destroy(this.gb_4)
destroy(this.gb_5)
destroy(this.gb_address)
end on

event open;//Instantiate the Google API interface User Object
GOOGLEMAPAPI = CREATE UO_GOOGLEMAP_API

//init map
init_map()

//init UI
init_ui()

//Connect to the Database
init_db()


end event

event close;Disconnect using SQLCA;
end event

type st_error from statictext within w_googlemaps_demo
integer x = 2354
integer y = 2372
integer width = 1998
integer height = 160
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 255
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_find from commandbutton within w_googlemaps_demo
integer x = 1938
integer y = 2416
integer width = 338
integer height = 92
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "Find"
end type

event clicked;//Find an addresses latitude and longitude
n_ds lds_location
integer li_rc
real lr_lat, lr_lng

lds_location = CREATE n_ds
lds_location.dataobject = 'd_address_lookup'

li_rc = lds_location.Retrieve(sle_address.text)
if li_rc > 0 then
	//A match was found, populate the structure marker
	lr_lat = lds_location.object.lat[1]
	lr_lng = lds_location.object.lng[1]
	GoogleMapAPI.add_markerwithinfowindow( lr_lat, lr_lng, sle_address.text)

	//render map
	parent.RenderMap()

	sle_address.text = ""
else
	Messagebox("Google Map","Location could not be found")
end if


end event

type sle_address from singlelineedit within w_googlemaps_demo
integer x = 174
integer y = 2420
integer width = 1751
integer height = 88
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_googlemaps_demo
integer x = 3168
integer y = 2204
integer width = 498
integer height = 92
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "PowerBuilder 11!"
end type

event clicked;datastore lds_cities
long ll_rows
long ll_cnt
decimal ld_lat
decimal ld_long
string ls_info

lds_cities = create datastore
lds_cities.DataObject = 'd_pb11_cities'
lds_cities.SetTransObject( SQLCA)
ll_rows = lds_cities.Retrieve()

if ll_rows > 0 then
	for ll_cnt = 1 to ll_rows
		//Get the latitude, longitude, city and presenter information
		ld_lat = lds_cities.object.city_latitude[ll_cnt]
		ld_long = lds_cities.object.city_longitude[ll_cnt]
		ls_info = lds_cities.object.city_name[ll_cnt] + " (" + lds_cities.object.presenter[ll_cnt] + ")"
		//Call the add_marker method to add the city to the map
		GoogleMapAPI.add_markerwithinfowindow(ld_lat,ld_long, ls_info)
	next
end if

//render map
parent.RenderMap()
end event

type rb_hybrid from radiobutton within w_googlemaps_demo
integer x = 2501
integer y = 2140
integer width = 297
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Hybrid"
end type

event clicked;GoogleMapAPI.set_hybridmaptype()

//render map
parent.RenderMap()
end event

type rb_satellite from radiobutton within w_googlemaps_demo
integer x = 2501
integer y = 2032
integer width = 334
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Satellite"
end type

event clicked;GoogleMapAPI.set_satellitemaptype()

//render map
parent.RenderMap()
end event

type rb_normal from radiobutton within w_googlemaps_demo
integer x = 2501
integer y = 1924
integer width = 325
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Normal"
end type

event clicked;GoogleMapAPI.set_normalmaptype()

//render map
parent.RenderMap()
end event

type cbx_continuouszoom from checkbox within w_googlemaps_demo
integer x = 1755
integer y = 2232
integer width = 544
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Continuous Zoom"
end type

event clicked;GoogleMapAPI.set_continuouszoom(checked)

//render map
parent.RenderMap()

end event

type cbx_doubleclickzoom from checkbox within w_googlemaps_demo
integer x = 1755
integer y = 2120
integer width = 581
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Double Click Zoom"
end type

event clicked;GoogleMapAPI.set_doubleclickzoom(checked)

//render map
parent.RenderMap()

end event

type cbx_infowindow from checkbox within w_googlemaps_demo
integer x = 1755
integer y = 2008
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Info Window"
end type

event clicked;GoogleMapAPI.set_infowindow(checked)

//render map
parent.RenderMap()

end event

type cbx_dragging from checkbox within w_googlemaps_demo
integer x = 1755
integer y = 1896
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dragging"
end type

event clicked;GoogleMapAPI.set_dragging(checked)

//render map
parent.RenderMap()
end event

type cb_setascenter from commandbutton within w_googlemaps_demo
integer x = 3941
integer y = 2104
integer width = 416
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "Set as Center"
end type

event clicked;em_ct_lat.Text = em_mk_lat.Text
em_ct_lng.Text = em_mk_lng.Text
GoogleMapAPI.set_mapcenter(real(em_mk_lat.Text), real(em_mk_lng.Text))

//render map
parent.RenderMap()
end event

type cb_removemarkers from commandbutton within w_googlemaps_demo
integer x = 3717
integer y = 2204
integer width = 645
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "Remove All Markers"
end type

event clicked;GoogleMapAPI.remove_all_markers()

//render map
parent.RenderMap()
end event

type st_6 from statictext within w_googlemaps_demo
integer x = 2994
integer y = 2012
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Info."
boolean focusrectangle = false
end type

type st_5 from statictext within w_googlemaps_demo
integer x = 3762
integer y = 1884
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lng."
boolean focusrectangle = false
end type

type st_4 from statictext within w_googlemaps_demo
integer x = 2994
integer y = 1896
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lat."
boolean focusrectangle = false
end type

type ddlb_zoom from dropdownlistbox within w_googlemaps_demo
integer x = 1179
integer y = 2212
integer width = 421
integer height = 400
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
boolean sorted = false
string item[] = {"0","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;GoogleMapAPI.set_zoomlevel(integer(ddlb_zoom.Text))

//render map
parent.RenderMap()
end event

type cb_setcenterzoom from commandbutton within w_googlemaps_demo
integer x = 1358
integer y = 2084
integer width = 242
integer height = 92
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "Set"
end type

event clicked;GoogleMapAPI.set_mapcenter(real(em_ct_lat.Text), real(em_ct_lng.Text));

//render map
parent.RenderMap()
end event

type st_3 from statictext within w_googlemaps_demo
integer x = 969
integer y = 2212
integer width = 178
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Zoom"
boolean focusrectangle = false
end type

type em_ct_lng from editmask within w_googlemaps_demo
integer x = 1179
integer y = 1984
integer width = 421
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##0.000000"
end type

type st_2 from statictext within w_googlemaps_demo
integer x = 969
integer y = 1984
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lng."
boolean focusrectangle = false
end type

type st_1 from statictext within w_googlemaps_demo
integer x = 969
integer y = 1896
integer width = 169
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Lat."
boolean focusrectangle = false
end type

type em_ct_lat from editmask within w_googlemaps_demo
integer x = 1179
integer y = 1888
integer width = 421
integer height = 88
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
string mask = "##0.000000"
end type

type em_mk_lng from editmask within w_googlemaps_demo
integer x = 3936
integer y = 1884
integer width = 421
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
string text = "34.47983"
borderstyle borderstyle = stylelowered!
string mask = "##0.000000"
end type

type em_mk_lat from editmask within w_googlemaps_demo
integer x = 3168
integer y = 1884
integer width = 421
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
string text = "32.05078"
borderstyle borderstyle = stylelowered!
string mask = "##0.000000"
end type

type cb_addmarker from commandbutton within w_googlemaps_demo
integer x = 3941
integer y = 1992
integer width = 416
integer height = 92
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
string text = "Add Marker"
end type

event clicked;GoogleMapAPI.add_markerwithinfowindow(real(em_mk_lat.Text), real(em_mk_lng.Text), mle_mk_info.Text)

//render map
parent.RenderMap()
end event

type mle_mk_info from multilineedit within w_googlemaps_demo
integer x = 3168
integer y = 1992
integer width = 745
integer height = 200
integer taborder = 50
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
string text = "Sheraton City Tower (Tel Aviv)"
borderstyle borderstyle = stylelowered!
end type

type cbx_overviewmapcontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 2264
integer width = 663
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Overview Map Control"
end type

event clicked;GoogleMapAPI.set_overviewmapcontrol(checked)

//render map
parent.RenderMap()

end event

type cbx_maptypecontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 2188
integer width = 544
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Type Control"
end type

event clicked;GoogleMapAPI.set_maptypecontrol(checked)

//render map
parent.RenderMap()

end event

type cbx_scalecontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 2112
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Scale Control"
end type

event clicked;GoogleMapAPI.set_scalecontrol(checked)

//render map
parent.RenderMap()

end event

type cbx_smallzoomcontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 2036
integer width = 608
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Small Zoom Control"
end type

event clicked;GoogleMapAPI.set_smallzoomcontrol(checked)

//render map
parent.RenderMap()

end event

type cbx_smallmapcontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 1960
integer width = 562
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Small Map Control"
end type

event clicked;GoogleMapAPI.set_smallmapcontrol(checked)

//render map
parent.RenderMap()

end event

type cbx_largemapcontrol from checkbox within w_googlemaps_demo
integer x = 169
integer y = 1884
integer width = 562
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Large Map Control"
end type

event clicked;GoogleMapAPI.set_largemapcontrol(checked)

//render map
parent.RenderMap()
end event

type gb_1 from groupbox within w_googlemaps_demo
integer x = 114
integer y = 1832
integer width = 754
integer height = 508
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Controls"
end type

type gb_2 from groupbox within w_googlemaps_demo
integer x = 910
integer y = 1832
integer width = 745
integer height = 508
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Center and Zoom"
end type

type gb_3 from groupbox within w_googlemaps_demo
integer x = 1701
integer y = 1832
integer width = 699
integer height = 508
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Configuration"
end type

type gb_4 from groupbox within w_googlemaps_demo
integer x = 2944
integer y = 1832
integer width = 1477
integer height = 508
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Markers"
end type

type gb_5 from groupbox within w_googlemaps_demo
integer x = 2446
integer y = 1832
integer width = 453
integer height = 508
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Map Type"
end type

type gb_address from groupbox within w_googlemaps_demo
integer x = 128
integer y = 2356
integer width = 2176
integer height = 184
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Verdana"
long textcolor = 33554432
long backcolor = 67108864
string text = "Find Address"
end type

