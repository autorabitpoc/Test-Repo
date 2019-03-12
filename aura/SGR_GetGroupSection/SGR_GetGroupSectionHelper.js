({

    sortData: function (component, fieldName, sortDirection) {

        var data = component.get("v.gsRec");

        var isDesc = (sortDirection !== 'asc');
        console.log('Inside helper.sortData1::fieldName=' + fieldName + ' sortDirection=' + sortDirection);
        console.log('isDesc::' + isDesc);

        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);

        //sorts the rows based on the column header that's clicked
        //    data.sort(this.toCompare(fieldName, isDesc))
        data.sort(this.toCompare(fieldName, isDesc))
        component.set("v.gsRec", data);


    },

    toCompare: function (field, isDesc, primer) {
        //var key = primer ?
        //function(x) {return primer(x[field])} :
        //function(x) {return x[field]};
        var key = primer ?
            function (x) {
                return primer(x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : '000')
            } :
            function (x) {
                return x.hasOwnProperty(field) ? (typeof x[field] === 'string' ? x[field].toLowerCase() : x[field]) : '000'
            };
        //reverse = !reverse ? 1 : -1;
        var multiplier = isDesc ? -1 : 1;
        console.log('multiplier:' + multiplier);

        return function (a, b) {
            return a = key(a), b = key(b), multiplier * ((a > b) - (b > a));
        }
    }


})