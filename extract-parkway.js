/**
 * Gets a list of xlsx files in the data directory and parses the content to a text file.
 *
 * Stores the files as parkway-(date).txt
 * */
var XLSX = require('xlsx');
var fs = require('fs');
var path = './data/';
var files =  fs.readdirSync(path);
files = files.filter(function(name) {
  return !!name.match('xlsx');
} );
files.forEach(function(name, index, array) {

  console.log('processing ', name);
  var workbook = XLSX.readFile(path + name);
  //console.log(workbook.SheetNames[0]);
  var sheet1 = workbook.Sheets['Sheet1'];
  var data = XLSX.utils.sheet_to_csv(sheet1);
  var date = name.match(/\d{1,2}[\.\:]\d{1,2}[\.\:]\d{2,4}/g)[0];
  fs.writeFile(path + 'parkway-'+ date +'.txt', data, function(err){
    if(!err) return;
    console.log('Error processing', name);
  });
});
