//= require twitter/bootstrap
//= require argo/index

$(function(){

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
	
});

