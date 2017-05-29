inspect = require('eyes').inspector({maxLength:20000});
var fs = require('fs');
var async = require("async");
var pdf_extract = require('pdf-extract');
var absolute_path = '/home/sabman/Projects/box-office/data/original_parkway_data/2016/'
//var absolute_path = '/home/sabman/Projects/box-office/data/other_box_office_reports/'
var absolute_write_path = '/home/sabman/Projects/box-office/data/tmp/'
//var absolute_write_path = '/home/sabman/Projects/box-office/data/corrected_box_office_reports/'
var files = fs.readdirSync(absolute_path);
var options = {
    type: 'text'  // extract the actual text in the pdf file
}

var errorCallback = function(err) {
  if(err) console.log('ERROR! : ', err);
}

var q = async.queue(function(file, cb) {

  console.log('Parsing', absolute_path+file);
  fullFilePath = absolute_path +  file;

  var parser = pdf_extract(fullFilePath, options, errorCallback);

  parser.on('complete',function(data){
    console.log('Finished parsing');
    fs.writeFile(absolute_write_path + file + '.txt', data.text_pages, function(err) {
      if(err) console.log('error writing to file', err);
    });
    cb();
  });

  parser.on('error',function(err){
    if(err) console.log('Error parsing', err);
    cb();
  });

}, 1);

q.push(files);








