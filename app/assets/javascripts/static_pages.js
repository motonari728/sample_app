# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


function install(){
var url = location.href;
var manifestUrl = url.substring(0, url.lastIndexOf('/')) + '/manifest.webapp';
var install = navigator.mozApps.install(manifestUrl);
install.addEventListener('success', function() {
    alert('Installed successfully.');
}, false);
install.addEventListener('error', function() {
    alert('Install failed. ' + install.error.name);
}, false);

};


