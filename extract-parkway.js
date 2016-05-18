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

//converts the MM.DD.YYYY/ MM.DD.YY to YYYY-MM-DD

var formattedDateString = function(str) {
  var nums = str.split('\.');
  //append 20 if year only has last 2 numbers
  if(nums[2].length == 2) nums[2] = '20'+ nums[2];
  //using Number to standardize number format, e.g 01 -> 1
  var value = '';
  var year = nums.pop();
  nums.splice(0,0,year); // move year to the first element
  nums.forEach(function(num){
    num = Number(num);
    if(num < 10) {
      num = '0'+ num;
    } else {
      num = num.toString();
    }
    value += num + '-'
  });

  //remove last -
  return value.substr(0,value.length-1);

}
files.forEach(function(name, index, array) {
  console.log('processing ', name);
  var workbook = XLSX.readFile(path + name);
  //console.log(workbook.SheetNames[0]);
  var sheets = workbook.SheetNames;
  sheets.forEach(function(sheetName) {
    var sheet = workbook.Sheets[sheetName];
    var data = XLSX.utils.sheet_to_csv(sheet);
    if(data.length == 0) return;
    data = data.replace(/\$(\d+)/g, '$1'); //remove $ signs
    data = data.replace(/\"(\d+)\,(\d+)[\s\"]{1,2}/g, '$1$2'); // replace "1,020" with 1020
    data = data.replace(/CLOSED/g,'');
    data = data.replace(/No Shows/g,'');
    var date = name.match(/\d{1,2}[\.\:]\d{1,2}[\.\:]\d{2,4}/g)[0];
    date = formattedDateString(date);
    fs.writeFile(path + 'parkway-'+ date +'.txt', data, function(err){
      if(!err) return;
      console.log('Error processing', name);
    });
  });
});
