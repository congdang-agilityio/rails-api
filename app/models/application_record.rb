class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = "auth_"
end
