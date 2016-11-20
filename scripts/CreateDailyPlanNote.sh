#!/usr/bin/env osascript -l JavaScript

ObjC.import("Foundation");


var monthNames = ["January", "February", "March", "April", "May", "June",
  "July", "August", "September", "October", "November", "December"
];

//Note template from HTML
var htmlContents = `
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/><meta name="exporter-version" content="Evernote Mac 6.7.1 (453575)"/><meta name="keywords" content="templates"/><meta name="author" content="Alberto Sadde"/><meta name="created" content="2016-06-14 21:00:20 +0000"/><meta name="source" content="desktop.mac"/><meta name="updated" content="2016-06-14 21:04:48 +0000"/><title>DailyPlanTemplate</title></head><body>
<div><br/></div>
<table width="100%" bgcolor="#D4DDE5" border="0">
<tr>
<td>
<div><span style="font-size: 18px;"><b>Outline of the day</b></span></div>
<div><br/></div>
</td>
</tr>
<tr>
<td/>
</tr>
</table>
<div style="text-align: center"><br/></div>
<table style="-evernote-table:true;border-collapse:collapse;margin-left:0px;table-layout:fixed;width:100%;">
<tr>
<td style="border: 1px solid rgb(219, 219, 219); padding: 10px; margin: 0px;width:14.285714285714285%;">
<div style="text-align: center"><b>Block</b></div>
</td>
<td style="border: 1px solid rgb(219, 219, 219); padding: 10px; margin: 0px;width:34.20707732634338%;">
<div style="text-align: center"><b>Schedule</b></div>
</td>
<td style="border: 1px solid rgb(219, 219, 219); padding: 10px; margin: 0px;width:51.37614678899083%;">
<div style="text-align: center"><b>Details</b></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">0700 - 0800</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">0800 - 0900</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">0900 - 1000</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1000 - 1100</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1100 - 1200</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1200 - 1300</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1300 - 1400</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1400 - 1500</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1500 - 1600</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1600 - 1700</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1700 - 1800</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1800 - 1900</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">1900 - 2000</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">2000 - 2100</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">2100 - 2200</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
<tr>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">2200 - 2300</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center">Turn of Lights -&gt; Go to bed</div>
</td>
<td style="border-style:solid;border-width:1px;border-color:rgb(219,219,219);padding:10px;margin:0px;width:33.33%;">
<div style="text-align: center"><br/></div>
</td>
</tr>
</table>
<div style="text-align: center"><br/></div>
<div style="text-align: center;"><br/></div>
<table width="100%" bgcolor="#D4DDE5" border="0">
<tr>
<td>
<div><span style="font-size: 18px;"><b>Review of the day</b></span></div>
<div><br/></div>
</td>
</tr>
<tr>
<td/>
</tr>
</table>
<div style="text-align: center"><br/></div>
</body></html>
`;


//Get Date to build Titles
var daysToAdd = 1;
var now = new Date();
var nextDay = now.getDate() + daysToAdd;
var month = monthNames[now.getUTCMonth()];
var year = now.getFullYear();

var fullDate = month + " " + nextDay + ", " + year; // the title of the note


//Talk to Evernote
var Ev = Application('Evernote');
Ev.activate();


var nb = ".Schedule";
var tags = ["!Daily", "schedule"];
if (findNotebook(nb)) {

Ev.createNote({withHtml: htmlContents, title: fullDate, notebook: nb, tags: tags});
}

else {
Ev.createNote({withText: "Error No notebook for automated Script", title: "ERROR CHECK SCRIPT", tags: "ERROR"});
}


//Automation.getDisplayString(x);

//Check that the notebook exists
function findNotebook(notebook) {
	var notebooks = Ev.notebooks();
	var nbNames = [];
	const nbsCount = notebooks.length;

	//Get notebooks names
	for (i = 0; i < nbsCount; i++) {
		nbNames.push(notebooks[i].name());
	}
	if (nbNames.find(function(nbName){return nbName == notebook;}) != notebook) {
	return false;
	}
	return true;
}
