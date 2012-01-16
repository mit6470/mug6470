# Used in the scaffolded ConfigVarsController.
ConfigVars.string 'config_vars.http_user', 'config'
ConfigVars.string 'config_vars.http_password', 'vars'
ConfigVars.string 'config_vars.http_realm', 'Configuration Variables'

# Define your own configuration variables here.
weka = Rails.root.join 'lib/weka/weka.jar'
libsvm = Rails.root.join 'lib/weka/libsvm.jar'
ConfigVars.string :weka_classpath, "#{weka}:#{libsvm}"
ConfigVars.string(:data_dir) { Rails.root.join 'lib/weka/data' }
