
function setRefFormEditor()
{

  var RefFormEditor = Handsontable.editors.HandsontableEditor.prototype.extend();

  
  RefFormEditor.prototype.myData = [];
  RefFormEditor.prototype.hot = null;
  RefFormEditor.prototype.colheaders = [];
  RefFormEditor.prototype.fieldtoshow = "name";
  RefFormEditor.prototype.url = "https://www.elmundo.es/forms/";

  RefFormEditor.prototype.finishEditing = function(isCancelled, ctrlDown) {
    if (this.htEditor && this.htEditor.isListening()) { //if focus is still in the HOT editor

      //if (Handsontable.tmpHandsontable(this.htContainer,'isListening')) { //if focus is still in the HOT editor
      //if (this.$htContainer.handsontable('isListening')) { //if focus is still in the HOT editor
      this.instance.listen(); //return the focus to the parent HOT instance
    }

    if (this.htEditor && this.htEditor.getSelected()) {
      //if (Handsontable.tmpHandsontable(this.htContainer,'getSelected')) {
      //if (this.$htContainer.handsontable('getSelected')) {
      //  var value = this.$htContainer.handsontable('getInstance').getValue();
      //var value = this.htEditor.getInstance().getValue();

      var value = {};

      if ( this.myData[this.htEditor.getSelected()[0]][this.fieldtoshow].indexOf("|") == -1 )
      {
         value=  this.myData[this.htEditor.getSelected()[0]][this.fieldtoshow]+"|"+
                  this.url+"/forms/"+this.myData[this.htEditor.getSelected()[0]].id;

      }
      else
      {
        value=  this.myData[this.htEditor.getSelected()[0]][this.fieldtoshow];
      }
      

      //var value = Handsontable.tmpHandsontable(this.htContainer,'getInstance').getValue();
      if (value !== void 0) { //if the value is undefined then it means we don't want to set the value
        this.setValue(value);
      }
    }

    return Handsontable.editors.TextEditor.prototype.finishEditing.apply(this, arguments);
  };

  RefFormEditor.prototype.prepare = function(row, col, prop, td, originalValue, cellProperties){
    
    cellProperties.handsontable.data=this.myData;

    // Invoke the original method...
    Handsontable.editors.HandsontableEditor.prototype.prepare.apply(this, arguments);
    // ...and then do some stuff specific to your CustomEditor
    this.customEditorSpecificProperty = 'foo';
  };

  

  

  //RefFormEditor.prototype.getData = function(hot) {

  //  this.hot=hot;

  //  return this.myData;

  //};

  return RefFormEditor;
};




function getRefFormEditor(url_base,id_template,fieldtoshow,colheaders)
{
   var RefFormEditor = setRefFormEditor();

   var RefFormEditor2 = RefFormEditor.prototype.extend();

   RefFormEditor2.prototype.url = url_base;
   RefFormEditor2.prototype.fieldtoshow = fieldtoshow;
   RefFormEditor2.prototype.colheaders = colheaders;
   RefFormEditor2.prototype.myData = [];


   xdr(url_base+"/forms.json?template_id="+id_template,"GET",null,
       function(response)
       {
            console.log("Received response setting data");

             var myjson = $.parseJSON(response);
            if (myjson == null || typeof (myjson) == 'undefined')
            {
                console.log("Not received JSON"+response);
              }

            var forms = myjson.forms;  
            var template_data = myjson.template;

            RefFormEditor2.prototype.myData = [];

            for (var i = 0; i < forms.length; i++) {
                
                //console.log("FORM: "+JSON.stringify(forms[i].data));

                var myform = {};
                myform.id = forms[i].id

                for (var j = 0; j < template_data.length; j++) {

                  //console.log("Template " + template_data[j][0]);

                  
                  myform[template_data[j][0]]=forms[i].data[template_data[j][0]];
                }

                //console.log("Data built: "+JSON.stringify(myform));

                RefFormEditor2.prototype.myData.push(myform);
            }

            
            //console.log("Data List"+forms);

            //RefFormEditor2.prototype.myData = [
            //  {id: 1, name: 'BMW', country: 'Germany', owner: 'Bayerische Motoren Werke AG'},
            //  {id: 2,name: 'Chrysler', country: 'USA', owner: 'Chrysler Group LLC'},
            //  {id: 3,name: 'Nissan', country: 'Japan', owner: 'Nissan Motor Company Ltd'},
            //  {id: 4,name: 'Suzuki', country: 'Japan', owner: 'Suzuki Motor Corporation'},
            //  {id: 5,name: 'Toyota', country: 'Japan', owner: 'Toyota Motor Corporation'},
            //  {id: 6,name: 'Volvo', country: 'Sweden', owner: 'Zhejiang Geely Holding Group'}
            //];

            
           
       },function(){});

   // RefFormEditor2.prototype.myData = [
   //            {id: 1, name: 'BMW', country: 'Germany', owner: 'Bayerische Motoren Werke AG'},
   //            {id: 2,name: 'Chrysler', country: 'USA', owner: 'Chrysler Group LLC'},
   //            {id: 3,name: 'Nissan', country: 'Japan', owner: 'Nissan Motor Company Ltd'},
   //            {id: 4,name: 'Suzuki', country: 'Japan', owner: 'Suzuki Motor Corporation'},
   //            {id: 5,name: 'Toyota', country: 'Japan', owner: 'Toyota Motor Corporation'},
   //            {id: 6,name: 'Volvo', country: 'Sweden', owner: 'Zhejiang Geely Holding Group'}
   //          ];
   
   return RefFormEditor2;

};