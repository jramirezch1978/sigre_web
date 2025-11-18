$PBExportHeader$uo_googlemap_api.sru
forward
global type uo_googlemap_api from nonvisualobject
end type
end forward

global type uo_googlemap_api from nonvisualobject
end type
global uo_googlemap_api uo_googlemap_api

type variables
string is_MapName //Name of file created by this object
string is_ApiKey //Google Maps API Key
string is_address //Address to search for
struct_marker is_marker[] //Marker array of structure
integer ii_upperbound = 0 //Array element counter
integer ii_mapfile //File ID for FileOpen and FileWriteEX
integer _width //Map Width
integer _height //Map Height
double _center_latitude //Map center latitude
double _center_longitude //Map center longitude
string _maptype //map type (Map, Satellite, Hybrid)
integer _zoomLevel //Zoom level
boolean _largeMapControl //Large Map Control (On or Off)
boolean _smallMapControl //Small Map Control (On or Off)
boolean _smallZoomControl //Small Zoom Control (On or Off)
boolean _scaleControl //Map Scale Marker (On or Off)
boolean _mapTypeControl //Map Type Control (Map/Satellite/Hybrid) (On or Off)
boolean _overviewMapControl //Overview Control (Map Inset) (On or Off)
boolean _dragging //Map Dragging (On or Off)
boolean _infoWindow //Info Window opens when marker is clicked on (On or Off)
boolean _doubleClickZoom //Double clicking causes map to zoom in (On or Off)
boolean _continuousZoom //Continuous smooth zooming (On or Off)

end variables

forward prototypes
public function boolean dragging_enabled ()
public subroutine set_dragging (boolean value)
public subroutine remove_all_markers ()
public subroutine set_mapcenter (real lat, real lng)
public function boolean infowindow_enabled ()
public function boolean doubleclickzoom_enabled ()
public function boolean continuouszoom_enabled ()
public subroutine set_infowindow (boolean value)
public subroutine set_doubleclickzoom (boolean value)
public subroutine set_continuouszoom (boolean value)
public subroutine set_normalmaptype ()
public subroutine set_satellitemaptype ()
public subroutine set_hybridmaptype ()
public function boolean is_normalmap ()
public function boolean is_satellitemap ()
public function boolean is_hybridmap ()
public subroutine add_markerwithinfowindow (real lat, real lng, string info)
public subroutine add_marker (real lat, real lng)
public subroutine set_largemapcontrol (boolean value)
public subroutine set_smallmapcontrol (boolean value)
public subroutine set_smallzoomcontrol (boolean value)
public subroutine set_scalecontrol (boolean value)
public subroutine set_maptypecontrol (boolean value)
public subroutine set_overviewmapcontrol (boolean value)
public function boolean has_largemapcontrol ()
public function boolean has_smallmapcontrol ()
public function boolean has_smallzoomcontrol ()
public function boolean has_scalecontrol ()
public function boolean has_maptypecontrol ()
public function boolean has_overviewmapcontrol ()
public function struct_latlng get_mapcenter ()
public subroutine set_zoomlevel (integer value)
public function integer get_zoomlevel ()
public subroutine rendermapcontrols ()
public subroutine rendermapcenter ()
public subroutine rendermaptype ()
public subroutine rendermapconfiguration ()
public subroutine renderheader ()
public subroutine renderbody ()
public subroutine rendermarkers ()
public subroutine geocode (string address)
public subroutine rendergeocode ()
public function string render_map (integer ai_width, integer ai_height)
end prototypes

public function boolean dragging_enabled ();//Determine if Dragging is enabled or not
if _dragging then
	return true
else
	return false
end if
end function

public subroutine set_dragging (boolean value);//Set dragging on or off

_dragging = value

end subroutine

public subroutine remove_all_markers ();//Remove all the marker information by resetting the structure array
struct_marker ls_empty_marker[] 

is_marker[] = ls_empty_marker[]
ii_upperbound = 0

end subroutine

public subroutine set_mapcenter (real lat, real lng);//Set Map center latitude and longitude

_center_latitude = lat
_center_longitude = lng

end subroutine

public function boolean infowindow_enabled ();//Determine if the Info Window is enabled or not
if _infowindow then
	return true
else
	return false
end if
end function

public function boolean doubleclickzoom_enabled ();//Determine if the Double Click Zooming is enabled or not
if _doubleclickzoom then
	return true
else
	return false
end if
end function

public function boolean continuouszoom_enabled ();//Determine if the Continuous zooming is enabled or not
if _continuouszoom then
	return true
else
	return false
end if

end function

public subroutine set_infowindow (boolean value);//Set Info Window on or off
_infowindow = value

end subroutine

public subroutine set_doubleclickzoom (boolean value);//Set doubleclick zoom on or off

_doubleclickzoom = value
end subroutine

public subroutine set_continuouszoom (boolean value);//Set continuous zoom on or off

_continuouszoom = value
end subroutine

public subroutine set_normalmaptype ();//Set map type to Normal

_maptype = "Map"
end subroutine

public subroutine set_satellitemaptype ();//Set map type to Satellite

_maptype = "Satellite"
end subroutine

public subroutine set_hybridmaptype ();//Set map type to Hybrid

_maptype = "Hybrid"
end subroutine

public function boolean is_normalmap ();//Determine if the Normal map is turned on or not
boolean lb_map

if _maptype = "Map" then
	lb_map = true
else
	lb_map = false
end if

return lb_map
end function

public function boolean is_satellitemap ();//Determine if the Satellite map is turned on or not
boolean lb_satellite

if _maptype = "Satellite" then
	lb_satellite = true
else
	lb_satellite = false
end if

return lb_satellite
end function

public function boolean is_hybridmap ();//Determine if the Hybrid map is turned on or not
boolean lb_hybrid

if _maptype = "Hybrid" then
	lb_hybrid = true
else
	lb_hybrid = false
end if

return lb_hybrid

end function

public subroutine add_markerwithinfowindow (real lat, real lng, string info);//Add the latitude and longitude to the marker structure array

ii_upperbound++

is_marker[ii_upperbound].latitude = lat
is_marker[ii_upperbound].longitude = lng
is_marker[ii_upperbound].information = info


end subroutine

public subroutine add_marker (real lat, real lng);//Add the latitude and longitude to the marker structure array

ii_upperbound++

is_marker[ii_upperbound].latitude = lat
is_marker[ii_upperbound].longitude = lng





end subroutine

public subroutine set_largemapcontrol (boolean value);//Set Large map control on or off
_largemapcontrol = value

end subroutine

public subroutine set_smallmapcontrol (boolean value);//Set small map control on or off
_smallmapcontrol = value

end subroutine

public subroutine set_smallzoomcontrol (boolean value);//set SmallZoomControl on or off
_smallzoomcontrol = value

end subroutine

public subroutine set_scalecontrol (boolean value);//Set Scale control on or off
_scalecontrol = value

end subroutine

public subroutine set_maptypecontrol (boolean value);//Set Map Type control on or off
_maptypecontrol = value

end subroutine

public subroutine set_overviewmapcontrol (boolean value);//Set Overview map control on or off
_overviewmapcontrol = value
end subroutine

public function boolean has_largemapcontrol ();//Determine if the Large Map Control is enabled or not
if _largemapcontrol then
	return true
else
	return false
end if
end function

public function boolean has_smallmapcontrol ();//Determine if the Small Map control is enabled or not
if _smallmapcontrol then
	return true
else
	return false
end if
end function

public function boolean has_smallzoomcontrol ();//Determine if the Small Zoom control is enabled or not
if _smallzoomcontrol then
	return true
else
	return false
end if
end function

public function boolean has_scalecontrol ();//Determine if the Scale Control is enabled or not
if _scalecontrol then
	return true
else
	return false
end if
end function

public function boolean has_maptypecontrol ();//Determine if the Map Type Control is enabled or not
if _maptypecontrol then
	return true
else
	return false
end if
end function

public function boolean has_overviewmapcontrol ();//Determine if the Overview Map control is enabled or not
if _overviewmapcontrol then
	return true
else
	return false
end if
end function

public function struct_latlng get_mapcenter ();//Set Map center latitude and longitude

struct_latlng latlng

latlng.lat = _center_latitude
latlng.lng = _center_longitude

return latlng
end function

public subroutine set_zoomlevel (integer value);//Set ZoomLevel
_zoomlevel = value
end subroutine

public function integer get_zoomlevel ();//Return Zoom Level

return _zoomlevel

end function

public subroutine rendermapcontrols ();//Determine which map controls should be displayed based on user selection

string ls_map_control

if _largeMapControl then 
	ls_map_control = "map.addControl(new GLargeMapControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if

if _smallMapControl then 
	ls_map_control = "map.addControl(new GSmallMapControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if

if _smallZoomControl then 
	ls_map_control = "map.addControl(new GSmallZoomControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if

if _scaleControl then 
	ls_map_control = "map.addControl(new GScaleControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if
	
if _mapTypeControl then 
	ls_map_control = "map.addControl(new GMapTypeControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if

if _overviewMapControl then 
	ls_map_control = "map.addControl(new GOverviewMapControl());"
	FileWriteEx(ii_mapfile, ls_map_control)
end if

end subroutine

public subroutine rendermapcenter ();//Set the map center based on the latitude and longitude and zoom level
string ls_map_center

ls_map_center = "map.setCenter(new GLatLng(" + string(_center_latitude) + ", " + string(_center_longitude) + "), " + string(_zoomlevel) + ");"

//ls_map_center = "map.setCenter(new GLatLng(19.64259, 168.75), 2);"

FileWriteEx(ii_mapfile, ls_map_center)



end subroutine

public subroutine rendermaptype ();//Render the map based on the selected type (Normal, Satellite, or Hybrid)

string ls_map_type

choose case _maptype	
	case "Satellite"
		ls_map_type = "map.setMapType(G_SATELLITE_MAP);"
		FileWriteEx(ii_mapfile, ls_map_type)
	case "Hybrid"
		ls_map_type = "map.setMapType(G_HYBRID_MAP);"
		FileWriteEx(ii_mapfile, ls_map_type)		
end choose

end subroutine

public subroutine rendermapconfiguration ();//Render the user selected configuration options

string ls_configuration

if not _dragging then 
	ls_configuration =" map.disableDragging();"
	FileWriteEx(ii_mapfile, ls_configuration)
end if

if not _infoWindow then	
	ls_configuration =" map.disableInfoWindow();"
	FileWriteEx(ii_mapfile, ls_configuration)
end if

if _doubleClickZoom then 
	ls_configuration =" map.enableDoubleClickZoom();"
	FileWriteEx(ii_mapfile, ls_configuration)
end if

if _continuousZoom then 
	ls_configuration =" map.enableContinuousZoom();"
	FileWriteEx(ii_mapfile, ls_configuration)
end if
end subroutine

public subroutine renderheader ();//Populate the HTML Header information
string ls_header_info

ls_header_info ='<head>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='<meta http-equiv="content-type" content="text/html; charset=utf-8"/>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='<title>Map</title>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='<script src="http://maps.google.com/maps?file=api&v=2&key='
ls_header_info+= is_apiKey
ls_header_info+='" type="text/javascript"></script>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='<script type="text/javascript">'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='//<![CDATA['
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='function load() {'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='if (GBrowserIsCompatible()) {'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='var map = new GMap2(document.getElementById("map"));'
FileWriteEx(ii_mapfile, ls_header_info)

//if not IsNull(is_address) then
//	ls_header_info = 'var geocoder = new GClientGeocoder();'
//	FileWriteEx(ii_mapfile, ls_header_info)
//
//	RenderGeocode( ) //Render a marker at the address
//end if

RenderMapControls() //Render the map controls

RenderMapCenter() //Render the map center

RenderMapType() //Render the map type

RenderMapConfiguration() //Render the configuration options

RenderMarkers() //Render the map markers

ls_header_info ='}}'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='//]]>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='</script>'
FileWriteEx(ii_mapfile, ls_header_info)

ls_header_info ='</head>'
FileWriteEx(ii_mapfile, ls_header_info)

end subroutine

public subroutine renderbody ();//Render the HTML Body

string ls_body_info

ls_body_info='<body onload="load()" onunload="GUnload()" style="margin:0; padding:0; border:none;">'
FileWriteEx(ii_mapfile, ls_body_info)

ls_body_info ='<div id="map" style="width: '
ls_body_info+= string(_width)
ls_body_info+='px; height: '
ls_body_info+= string(_height)
ls_body_info +='px"></div>'
FileWriteEx(ii_mapfile, ls_body_info)

ls_body_info ='</body>'
FileWriteEx(ii_mapfile, ls_body_info)

end subroutine

public subroutine rendermarkers ();//Render the map markers based on the information in the marker list

string ls_markers
integer li_counter

if ii_upperbound < 1 then return

ls_markers ="function createMarkerWithInfoWindow(point, info) {"
FileWriteEx(ii_mapfile, ls_markers)

ls_markers ="var marker = new GMarker(point);"
FileWriteEx(ii_mapfile, ls_markers)

ls_markers ='GEvent.addListener(marker, "click", function() {'
FileWriteEx(ii_mapfile, ls_markers)

ls_markers ="marker.openInfoWindowHtml(info);});"
FileWriteEx(ii_mapfile, ls_markers)

ls_markers ="return marker;}"
FileWriteEx(ii_mapfile, ls_markers)

for li_counter =1 to ii_upperbound
	if len(is_marker[li_counter].information) > 0 then
		ls_markers ='map.addOverlay(createMarkerWithInfoWindow(new GLatLng(' + string(is_marker[li_counter].latitude) + ', ' + string(is_marker[li_counter].longitude) + '), "' + is_marker[li_counter].information + '"));'
		FileWriteEx(ii_mapfile, ls_markers)
	else
		ls_markers ='map.addOverlay(createMarkerWithInfoWindow(new GLatLng(' + string(is_marker[li_counter].latitude) + ', ' + string(is_marker[li_counter].longitude) + '));'
		FileWriteEx(ii_mapfile, ls_markers)
	end if
next

end subroutine

public subroutine geocode (string address);//Take an address and get the latitude and longitude
is_address = address


end subroutine

public subroutine rendergeocode ();//Get address coordinates and render marker on map
//Note this function has not been implemented and is not currently used

string ls_address_location

//if IsNull(is_address) then return

ls_address_location = "function showAddress(address) {  "
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location= '	geocoder.getLatLng(    "' + is_address + '",'
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location= "	function(point) {      "
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = "		if (!point) {        "
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '			alert("' + is_address + ' not found"); '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '		} else {        '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '			map.setCenter(point, 13);        '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '			var marker = new GMarker(point);        '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '			map.addOverlay(marker);        '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '			marker.openInfoWindowHtml("' + is_address + '");      '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '		}    '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '	}    '
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '	);'
FileWriteEx(ii_mapfile, ls_address_location)

ls_address_location = '}    '
FileWriteEx(ii_mapfile, ls_address_location)

SetNull(is_address)
end subroutine

public function string render_map (integer ai_width, integer ai_height);//Render the Map Page by concatenating the HTML and selected
//Properties into a string

string ls_mappage_content
string ls_mapfile

#IF DEFINED PBWEBFORM THEN
	_width = ai_width - 5
	_height = ai_height - 5
#ELSE
	_width = ai_width - 25
	_height = ai_height - 25
#END IF



//write to a file
ii_mapfile = FileOpen("c:\"+is_mapname, LineMode!, Write!, LockReadWrite!, Replace!, EncodingUTF8!)

ls_mappage_content = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'
FileWriteEx(ii_mapfile, ls_mappage_content)

ls_mappage_content ='<html xmlns="http://www.w3.org/1999/xhtml">'
FileWriteEx(ii_mapfile, ls_mappage_content)

RenderHeader()//Create the page header
RenderBody()//Create the page body

ls_mappage_content ="</html>"
FileWriteEx(ii_mapfile, ls_mappage_content)

FileClose(ii_mapfile)

//get the url for that file
ls_mapfile = "c:\"+is_mapname

return ls_mapfile

//#if defined PBWEBFORM then
//	this.URL = GetDownloadFileUrl("c:\"+is_mapname, true)
//#end if


end function

on uo_googlemap_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_googlemap_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;is_mapname = "defaultmap.htm"

_width = 200
_height = 200
_center_latitude = 19.64259
_center_longitude = 168.75
_zoomLevel = 2
_maptype = "Normal"
_largeMapControl = false
_smallMapControl = false
_smallZoomControl = false
_scaleControl = false
_mapTypeControl = false
_overviewMapControl = false
_dragging = true
_infoWindow = true
_doubleClickZoom = false
_continuousZoom = false
_maptype = "Map"

end event

