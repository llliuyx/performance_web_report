class PerfSuite < ActiveRecord::Base
  belongs_to :perf_task, {foreign_key: :task_id }
  has_many :perf_cases, {foreign_key: :suite_id }
end