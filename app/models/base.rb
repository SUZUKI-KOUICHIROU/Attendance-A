class Base < ApplicationRecord
  validates :base_number, :base_name, presence: true
  validates :attendance_type, inclusion: { in: [1,2] }
end