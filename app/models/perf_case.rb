class PerfCase  < ActiveRecord::Base
  belongs_to :perf_suite, {foreign_key: :case_id }
end