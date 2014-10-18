class Wall < ActiveRecord::Base
  def to_param
    access_code
  end
end

