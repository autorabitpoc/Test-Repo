({
    startTimer: function (component) {
        component.set("v.timerRef", window.setTimeout(
            $A.getCallback(function() {
                component.set("v.showToast", false);
            }), 3000
        ));
    },

    stopTimer: function (component) {
        var timerRef = component.get("v.timerRef");
        if(timerRef > 0){
            window.clearTimeout(timerRef);
            component.set("v.timerRef", -1);
        }
    }
})