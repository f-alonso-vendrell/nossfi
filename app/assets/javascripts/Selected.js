    function getSelected()
        {
          var ret_data = new Array();

          console.log("SUBMITTING FORMS");

             for(var i=0;i<data.length;i++)
             {
                var item = data[i];
                console.log(item);
                console.log(item.Action);

                if (data[i].Action)
                {
                  console.log("MANAGE");
                  ret_data.push(item.id);

                }
                
                
             }

             if ( ret_data.length == 0 )
             {
                 alert("No Forms selected");
             }

             return ret_data;

        }

        function getSelectedWithData()
        {
          var ret_data = new Array();

          console.log("Get Selected with data");

             for(var i=0;i<data.length;i++)
             {
                var item = data[i];
                console.log(item.Action);

                if (item.Action)
                {
                  console.log("Selected: "+item);
                  var datatmp = item;
                  datatmp.shift;
                  ret_data.push(datatmp);

                }
                
                
             }

             if ( ret_data.length == 0 )
             {
                 alert("No Forms selected");
             }

             console.log("Get Selected with data Done");

             return ret_data;

        }

        function exportSelected()
        {
            var items = getSelectedWithData();

            var headers = colFields;
            headers.shift();

            exportAsCSV(colFields,items);


        }

        function deleteSelected()
        {
            var items = getSelected();

            
            console.log(result);

            if (items.length > 0 )
            {
              var result = confirm("You Are going to delete " + items.length +
                  " forms, is that OK?");

              if (result)
              {
                var fields = "{"
                for(var i=0;i<items.length;i++)
                {
                   fields = fields + items[i].toString() + ",";
                }
                fields = fields.slice(0,-1);
                fields = fields + "}";

                document.getElementById('delete_form_data').value=fields;
                document.getElementById('delete_form').submit();


              }
            }

        }

        function createForms(template_id,user_id)
        {

          var items = getSelectedWithData();

          if (items.length > 0 )
          {
            console.log(items);

            var fields = new Array();; // = jsonify(colFields,items);

            for (var i=0;i<items.length;i++)
             {
                fields.push(JSON.stringify(items[i]));

             }

             console.log(fields.toString());

             
             
            var result = confirm("You Are going to create " + items.length +
                " forms, is that OK?");

            
            if (result)
            {
              document.getElementById('create_form_template_id').value=template_id;
              document.getElementById('create_form_creator').value=user_id;
              document.getElementById('create_form_private').value="false";
              document.getElementById('create_form_data').value="["+fields.toString()+"]";
              document.forms[0].submit();
            }
            
          

          }

        }

        
        function updateSelected()
        {

          var items = getSelectedWithData();

          if (items.length > 0 )
          {
            console.log(items);

            var fields = new Array();; // = jsonify(colFields,items);

            for (var i=0;i<items.length;i++)
             {
                fields.push(JSON.stringify(items[i]));

             }

             console.log(fields.toString());

             
             
            var result = confirm("You Are going to update " + items.length +
                " forms, is that OK?");

            
            if (result)
            {
              document.getElementById('update_form_data').value="["+fields.toString()+"]";
              document.getElementById('update_forms').submit();
            }
            
          

          }

        }




        function opSelected(form_type)
        {

          var items = getSelected();

            
            console.log(result);

            if (items.length > 0 )
            {
              var result = confirm("You Are going to " + form_type + " " + items.length +
                  " forms, is that OK?");

              if (result)
              {
                var fields = "{"
                for(var i=0;i<items.length;i++)
                {
                   fields = fields + items[i].toString() + ",";
                }
                fields = fields.slice(0,-1);
                fields = fields + "}";

                document.getElementById('op_type').value=form_type;
                document.getElementById('op_form_data').value=fields;
                document.getElementById('op_forms').submit();


              }
            }


        }
