# Used in the scaffolded ConfigVarsController.
ConfigVars.string 'config_vars.http_user', 'config'
ConfigVars.string 'config_vars.http_password', 'vars'
ConfigVars.string 'config_vars.http_realm', 'Configuration Variables'

# Define your own configuration variables here.
ConfigVars.string(:weka_classpath) { Rails.root.join 'lib/weka/weka.jar' }
