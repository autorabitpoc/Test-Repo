({
	onRender : function(component, event, helper) {
		console.log('Rendering...');
        var x = document.getElementById('borderdiv');
        x.innerHTML = "I just modified this!";
        $A.util.removeClass(x,'border');
	}
})