require 'yaml'
require 'mail'

CONFIG = YAML.load_file('config.yml')

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'gmail.com',
            :user_name            => CONFIG['gmail']['username'],
            :password             => CONFIG['gmail']['password'],
            :authentication       => 'plain',
            :return_response => true,
            :enable_starttls_auto => true  }
            
Mail.defaults do
  delivery_method :smtp, options
end