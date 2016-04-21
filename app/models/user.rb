class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :forms
  has_many :templates

  def initPrefs

  	logger.debug "Initializing User Preferences"

  	# if ! preferences.nil? || preferences == ""

  	# 	return

  	# end

  	logger.debug "Not initialized before"

  	pref = Hash.new

  	pref["alias"]=""
  	pref["template_prefs"]=Hash.new
  	pref["report_prefs"]=Hash.new

  	self.preferences=pref.to_json

  end


  def getPreferencesFor(templateId)

  	if preferences.nil? || preferences == ""

  		initPrefs
  		self.save

  	end

  	pref=JSON.parse(preferences)

  	return pref["template_prefs"][templateId]
  	
  end

  def addHideFor(templateId,prefs)

    pref = JSON.parse(preferences)

    if pref["template_prefs"][templateId].nil?

      pref["template_prefs"][templateId]=Hash.new

    end

    if pref["template_prefs"][templateId]["hide"].nil?

     pref["template_prefs"][templateId]["hide"] = Array.new

     end

     if ! pref["template_prefs"][templateId]["hide"].kind_of?(Array)

       pref["template_prefs"][templateId]["hide"] = nil

       pref["template_prefs"][templateId]["hide"] = Array.new


     end


      pref["template_prefs"][templateId]["hide"].push(prefs)

    self.preferences=pref.to_json

    self.save

  end

def addShowFor(templateId,prefs)

    pref = JSON.parse(preferences)

    if pref["template_prefs"][templateId].nil?

      pref["template_prefs"][templateId]=Hash.new

    end

    if pref["template_prefs"][templateId]["hide"].nil?

     return

    end

     if ! pref["template_prefs"][templateId]["hide"].kind_of?(Array)

       pref["template_prefs"][templateId]["hide"] = nil

       pref["template_prefs"][templateId]["hide"] = Array.new


     end

     pref["template_prefs"][templateId]["hide"].delete(prefs)

    self.preferences=pref.to_json

    self.save

  end


  def setPreferencesFor(templateId,prefs)

    pref = JSON.parse(preferences)

    if pref["template_prefs"][templateId].nil?

      pref["template_prefs"][templateId]=Hash.new

    end

    pref["template_prefs"][templateId]=prefs

    self.preferences=pref.to_json

    self.save

  end

  def setFilterId(templateId,id)

    if preferences.nil? || preferences == ""

      initPrefs
      
    end

    pref = JSON.parse(preferences)

    if pref["template_prefs"][templateId].nil?

      pref["template_prefs"][templateId]=Hash.new

    end

    pref["template_prefs"][templateId]["filterId"]=id

    self.preferences=pref.to_json

    self.save

  end

end
