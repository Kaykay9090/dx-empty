({
    populateData: function (component, response) {

        var year1 = [];
        var year2 = [];
        var year3 = [];
        var year4 = [];
        var year5 = [];
        var year6 = [];


        var fullData = new Array(72).fill(" ");

        let jsonData = JSON.parse(response.Payment_status__c);
        let startDate = new Date(response.Start_date__c);

        const startYear = startDate.getFullYear();
        const startMonth = startDate.getMonth();

        const currentYear = new Date().getFullYear();
        const lastYear = currentYear - 5;
        
        var yearsAgo = startYear - lastYear; // Calculate how many years ago the data starts
         // For March (0-indexed, so January is 0, February is 1, March is 2)
        var startIndex = yearsAgo * 12 + startMonth + jsonData.length - 1;
        

        // Place the actual data into the full data array starting at the right index

        for (var i = 0; i < jsonData.length; i++) {

            
            if (jsonData[i].paymentStatus == 'ZERO') {
                fullData[startIndex-i] = 'OK';
            } else if (jsonData[i].paymentStatus == 'DOT') {
                fullData[startIndex-i] = '-';
            } else if (jsonData[i].paymentStatus == 'ONE') {
                fullData[startIndex-i] = '1';
            } else if (jsonData[i].paymentStatus == 'TWO') {
                fullData[startIndex-i] = '2';
            } else if (jsonData[i].paymentStatus == 'THREE') {
                fullData[startIndex-i] = '3';
            } else if (jsonData[i].paymentStatus == 'FOUR') {
                fullData[startIndex-i] = '4';
            } else if (jsonData[i].paymentStatus == 'FIVE') {
                fullData[startIndex-i] = '5';
            } else if (jsonData[i].paymentStatus == 'SIX') {
                fullData[startIndex-i] = '6';
            } else if (jsonData[i].paymentStatus == 'I') {
                fullData[startIndex-i] = 'AR';
            } else if (jsonData[i].paymentStatus == 'Z') {
                fullData[startIndex-i] = 'U';
            } else {
                fullData[startIndex-i] = jsonData[i].paymentStatus;
            }
            
        }

        // Split full data into a 6x12 array for display
        //var displayData = [];
        for (var row = 0; row < 6; row++) {
            for (var col = 0; col < 12; col++) {
                var val = fullData[row * 12 + col];

                if (row == 0) {
                    year6[col] = { "value" : val, 'color': this.getColor(val) };
                }
                else if (row == 1) {
                    year5[col] = { "value" : val, 'color': this.getColor(val) };
                }
                else if (row == 2) {
                    year4[col] = { "value" : val, 'color': this.getColor(val) };
                }
                else if (row == 3) {
                    year3[col] = { "value" : val, 'color': this.getColor(val) }
                }
                else if (row == 4) {
                    year2[col] = { "value" : val, 'color': this.getColor(val) }
                } 
                else if (row == 5) {
                    year1[col] = { "value" : val, 'color': this.getColor(val) }
                }
            }
        }

        component.set("v.year1", year1);
        component.set("v.year2", year2);
        component.set("v.year3", year3);
        component.set("v.year4", year4);
        component.set("v.year5", year5);
        component.set("v.year6", year6);
    },

    getColor: function (value) {

        if (value == 'OK' || value == 'S') {
            return 'green-box'
        } else if (value == '-' || value == 'U' || value == 'G' || value == 'N' || value == 'W') {
            return 'blue-box'
        } else if (value == '1') {
            return 'amber-box'
        } else if (value == '2' || value == 'A' || value == 'AR' ) {
            return 'orange-box'
        } else if (value == '3' || value == '4' || value == '5' || value == '6' ) {
            return 'red-box'
        } else if (value == 'D' || value == 'Q' || value == 'V' || value == 'X' ) {
            return 'black-box'
        }

        return 'gray-box';
    }
})