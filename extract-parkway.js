var XLSX = require('xlsx');
var fs = require('fs');
var workbook = XLSX.readFile('nightly\ box\ office\ report\ 2.12.16.xlsx');
console.log(workbook.SheetNames[0]);
var sheet1 = workbook.Sheets['Sheet1'];
console.log(XLSX.utils.sheet_to_csv(sheet1));
fs.writeFile('./parkway-report.txt', XLSX.utils.sheet_to_csv(sheet1), function(err){
  console.log(err);
});
