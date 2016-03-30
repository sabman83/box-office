inspect = require('eyes').inspector({maxLength:20000});
var fs = require('fs');
var pdf_extract = require('pdf-extract');
var absolute_path_to_pdf = '/home/sabman/Downloads/branch_area_20151127_SF.pdf'
var options = {
    type: 'text'  // extract the actual text in the pdf file
}
var processor = pdf_extract(absolute_path_to_pdf, options, function(err) {
    if (err) {
          return errorCallback(err);
            }
});

var showText = function(arg1, arg2) {

  console.log('Completed scanning file');
  fs.writeFile('./report-20151127.txt', arg2, function(err){
    console.log(err);
  });
};

var errorCallback = function(err) {
  console.log(err);
};

processor.on('complete', function(data) {
    inspect(data.text_pages, 'extracted text pages');
      showText(null, data.text_pages);
});
processor.on('error', function(err) {
    inspect(err, 'error while extracting pages');
      return errorCallback(err);
});
