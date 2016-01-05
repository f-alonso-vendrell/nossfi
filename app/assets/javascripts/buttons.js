buttonMngr = {

   setupButtons: function()
   {
      this.updateButtons();
      document.getElementById('creation').style.display = 'none';
      document.getElementById('updateButton').style.display = 'none';
   },

   showUpdate: function()
   {
       if ( updatesPresent )
       {
          document.getElementById('updateButton').style.display = 'inline';
          document.getElementById('deleteButton').style.display = 'none';

       }
       else
       {
          document.getElementById('updateButton').style.display = 'none';

       }

   },

   updateButtons: function()
   {
       console.log("Updating Buttons: "+viewState);

       if ( viewState == "idle") // idle, canDelete, canUpdate, canCreate)
       {
          document.getElementById('creation').style.display = 'none';
          document.getElementById('updateButton').style.display = 'none';
          document.getElementById('deleteButton').style.display = 'none';
       }
       else if ( viewState == "canDelete") 
       {
          document.getElementById('creation').style.display = 'none';
          document.getElementById('updateButton').style.display = 'none';
          document.getElementById('deleteButton').style.display = 'inline';

       }
       else if ( viewState == "canUpdate") 
       {
          document.getElementById('creation').style.display = 'none';
          document.getElementById('updateButton').style.display = 'inline';
          document.getElementById('deleteButton').style.display = 'none';
       }
       else if ( viewState == "canCreate") 
       {
          document.getElementById('creation').style.display = 'inline';
          document.getElementById('updateButton').style.display = 'none';
          document.getElementById('deleteButton').style.display = 'none';

       }
   }

};