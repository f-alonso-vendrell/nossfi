
 function formParser(headers,csv) {

     raw_array = csv.csvToArray();

     var a = new Array(raw_array.length-1);

     for (var i=0;i<raw_array.length-1;i++)
     {
         a[i]=new Array(headers.length);

         for(var j=0;j<headers.length;j++)
         {
             a[i][j]="";
         }
     }

     for (var i = 0; i < raw_array[0].length; i++)
     {
        console.log("Trying "+raw_array[0][i]);
        for (var j = 0; j< headers.length; j++)
        {
           console.log("Checking "+headers[j]);
           if ( raw_array[0][i]==headers[j] )
           {
               for(var k=1;k<raw_array.length;k++)
               {
                   console.log("Setting: "+raw_array[k][i]+ " at "+(k-1)+","+j);
                   a[k-1][j]=raw_array[k][i];
               }
               j=headers.length;

           }
        }

     }

     console.log(a);
  
     return a;


 }

 function formParser(csv) {

  console.log("FormParser called");

  raw_array = csv.csvToArray();

  var retData = new Array(raw_array.length-1);

  //var retData = "\[\{\"a\": \"Action\", \"b\": \"checkbox\"\}\]";

  for (var i = 0; i < retData.length; i++) {
    var obj = {};
    for (var j = 0; j < raw_array[0].length; j++) {
      obj[raw_array[0][j]] = raw_array[i+1][j];
    }
    retData[i]=obj;
  }

  



   //return JSON.stringify(retData);
   //return JSON.parse(retData);

   return retData;

 }


 function templateParser(csv) {

   raw_array = csv.csvToArray();

   fields_array = raw_array[0];

   var a = [];

    for (i = 0; i < fields_array.length; i++) {

      field_data = [fields_array[i],"","","text",""];

        if ( raw_array.length > 1)
        {
            // try to setup tip, type and optional data

            console.log("storing field data");

            field_data[2]=raw_array[1][i];

        }
        a[i]=field_data;
    }
    return a;

}

 function templateParserTr(csv) {

   raw_array = csv.csvToArray();

   
   var a = [];

    for (i = 0; i < raw_array.length; i++) {

      field_data = [raw_array[i][0],raw_array[i][1],raw_array[i][2],raw_array[i][3],raw_array[i][4]];

        a[i]=field_data;
    }
    return a;

}