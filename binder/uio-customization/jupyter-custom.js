// Requires Jupyter > 5.10, see https://github.com/jupyter/notebook/pull/2710

define([
        'base/js/namespace',
        'base/js/promises'
     ], function(Jupyter, promises) {
         console.log('custom.js');
         promises.app_initialized.then(function(appname) {
		 if (appname === 'NotebookApp') {
			 var my_elem = document.getElementById('kernel_logo_widget');
			 var span = document.createElement('span');
             span.innerHTML = '<a href="https://www.uio.no/english/services/it/research/hpc/jupyter-notebook/index.html"><img src="/user/home/custom/UiO_A_ENG.png" style="height: 15px;" alt="UiO" /></a>';
			 span.style = 'padding: 5px 15px;';
			 span.className = 'nav navbar-brand pull-right';

			 my_elem.parentNode.insertBefore(span, my_elem);
		 }
		 else if (appname === 'DashboardApp') {
			 var my_elem = document.getElementById('login_widget');
			 var span = document.createElement('span');
             span.innerHTML = '<a href="https://www.uio.no/english/services/it/research/hpc/jupyter-notebook/index.html"><img src="/user/home/custom/UiO_A_ENG.png" style="height: 15px;" alt="UiO" /></a>';
			 span.style = 'padding: 5px 15px;';
			 span.className = 'nav navbar-brand pull-right';

			 my_elem.parentNode.insertBefore(span, my_elem);
		 }
		 else {
			 console.log('appname: ' + appname);
		 }
         });
     });

$(document).ready(function() {

    function functionToLoadFile(){
      // jQuery.get('/user/home/custom/test.txt', function(data) {
      jQuery.get('/user/home/custom/maintenance.txt', function(data) {
       var myvar = data;
       var parts = myvar.split(/\n/);
       var cur_date = new Date();
       var maint_date = new Date(parts[1]);
       var minutes_left = Math.floor((maint_date - cur_date) / 60000);
       var hub = window.location.hostname.split('.')[0]
       
       // console.log("parts " + parts)
       // console.log("hub   " + hub)
       if ((parts[0] == 'maintenance') && (parts[2].match(hub))) {
           alert('Going down for maintenance in ' + minutes_left + ' minutes. Please save your work.');
       }

       if (minutes_left > 10) {
 	      setTimeout(functionToLoadFile, (minutes_left - 10) * 60000);
       }
       else {
 	      setTimeout(functionToLoadFile, 60000);
       }
    });
    }

    setTimeout(functionToLoadFile, 10);
      
});


