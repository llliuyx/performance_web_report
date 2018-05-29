class PerfTask  < ActiveRecord::Base
  has_many :perf_suites, {foreign_key: :task_id }
end