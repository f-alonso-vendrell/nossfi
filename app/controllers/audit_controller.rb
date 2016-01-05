class AuditController < ApplicationController
  
   def index
    @audits = Audit.all.reverse
  end

 
end