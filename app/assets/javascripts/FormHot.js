var container;
var hot;

function setupHot(mycontainer,mydata)
{


  //container = document.getElementById('example');
  var myhot = new Handsontable(mycontainer, {
    data: mydata,
    colHeaders: colFields,
    columns: globalColumns,
    rowHeaders: false,
    columnSorting: true,
    search: true,
    stretchH: "all",
    minSpareRows: 1,
    //afterChange: function(changes, source) {
    //  console.log("Change on"+changes+"\n"+source);
    //  setDataAtCell(0, 0, true);
    //},
    contextMenu: true
    });

  //local hook (has same effect as a callback)
  myhot.addHook('afterChange', function(changes, source) {
    console.log("Change on"+changes+"\n"+source);
    if (source=="external")
    {
      return;
    }

    for (i=0;i<changes.length;i++)
    {
      if (!( (changes[i][1]=="Action")&&(changes[i][3])))
      {
        var row=changes[i][0];
        console.log("Change: " + i+ "Row is "+row+ " and length " + originalLenght + " with " + viewState);

        if (( row == originalLenght ) && (viewState == "idle"))
        {
          viewState = "canCreate";
          console.log("Restricting read to hot");
          myhot.updateSettings({
            cells: function (row, col, prop) {
              var cellProperties = {};

              if (row < originalLenght) {
                cellProperties.readOnly = true;
              }

              return cellProperties;
            }
          });

        }
        else if ( viewState != "canCreate")
        {
          //updatesPresent=true;
          console.log("Updating HOT state to canUpdate");
         
          viewState = "canUpdate"; // idle, canDelete, canUpdate, canCreate
          myhot.updateSettings({minSpareRows: 0});
          //var curdata = hot.getData();

          //for (j=originalLenght;j<data.length;j++)
          //{
          //  data.pop();
          //}
          if ( mydata.length > originalLenght )
          {
             console.log("reducing size");
             mydata.pop();
             myhot.render();
          }
        }

        myhot.setDataAtCell(row, 0, true);
        
        
        //hot.loadData(curdata);
        //hot.render();
        //showUpdate();
      }
      else
      {
          if ( viewState == "idle" )
          {
               viewState = "canDelete";
          }
      }
    }


    buttonMngr.updateButtons();
    
  });

  myhot.addHook('afterCreateRow',function(index,ammount) {

    // show some info
    console.log("after create row");
    // console.log(index);
    // console.log(ammount);

    var data2 = myhot.getData();
    //  var count=0;
    //  <% @fields.each do |field| %>
    //     <% if field[3] == "checkbox" %>
    //          data2[index-1][count]= "false";
    //     <%end%>
    //     count++;
    //  <%end%>

    //  console.log(data2[index-1][field_lenght]);
    //  console.log("<%= @form.template.defaultemail%>");

    // hot2.loadData(data2);
    // hot2.render();
                     
                        
  });

  return myhot;

};
