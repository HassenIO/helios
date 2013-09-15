//= require twitter/bootstrap
//= require argo/index

jQuery(function($){

	/*
	 *	Need to check the use conditions in order to signup.
	 */
	$("#signup-accept-cgu").click(function(){
		if(this.checked) {
			$("#signup-button").removeAttr("disabled");
			console.log("btn enabled");
		} else {
			$("#signup-button").attr("disabled", "disabled");
			console.log("btn disabled");
		}
	});

	// All DateTime Picker fields have the same settings.
	$(".form_datetime").datetimepicker({
	    format: "dd/mm/yyyy hh:ii",
	    minuteStep: 15,
	    autoclose: true,
	    pickerPosition: "bottom-left",
	    startDate: "2013-11-01"
	});
	
});

