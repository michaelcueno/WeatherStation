
function tr(textToTranslate, fromLanguage, toLanguage) {
    var p = {};
    p.appid = 'DvqR/Yg/3Re8SnBwzCEXe7+JH61EzhkcVA+nwrjXBHo=';
    p.to = toLanguage;
    p.from = fromLanguage;
    p.text = textToTranslate;
    $.ajax({
        url: 'http://api.microsofttranslator.com/V2/Ajax.svc/Translate',
        data: p,
        dataType: 'jsonp',
        jsonp: 'oncomplete',
        jsonpCallback: 'ajaxTranslateCallback',
        complete: function(request, status) {
            alert('complete: '+status);
        },
        success: function(data, status) {
            alert('success: data-'+data+',status-'+status);
        },
        error: function(request, status, error) {
            alert('error: status-'+status+',desc-'+error);
        }
    });
}
function ajaxTranslateCallback(response) {
    console.log(response);
}
