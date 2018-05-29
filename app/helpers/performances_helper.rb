module PerformancesHelper
  require 'time'
  class HighChartsHandler
    def self.launch_charts(launch_case_result)

      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "冷启动测试-竞品对比(单位:ms)"})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )

        launch_case_result.each {|launch_case|
          f.series(:name => launch_case.app_name, :data => eval(eval(launch_case.result)))
        }
      end
      return line_chart
    end

    def self.launch_charts_recent_app(launch_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "冷启动测试-历史版本对比(单位:ms)"})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )

        launch_case_result.each {|launch_case|
          p launch_case
          if launch_case.result
            f.series(:name => launch_case.app_version, :data => eval(eval(launch_case.result)))
          end
        }
      end
      return line_chart
    end

    def self.cpu_charts(cpu_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "CPU测试-竞品对比(单位:jiffies)"})
        f.subtitle({:text => '负数表示CPU System Time'})
        f.chart({:defaultSeriesType => "line"})

        f.plotOptions(
          {
            column: {
              # minPointWidth:20
              maxPointWidth:20
            }
          }
        )
        cpu_case_result.each {|cpu_case|
          result_array = eval(eval(cpu_case.result))
          utime_array = []
          stime_array = []
          result_array.each {|cpu_result|
            utime_array << cpu_result[:utime]
            stime_array << -cpu_result[:stime]
          }

          f.series(:name => "#{cpu_case.app_name} User Time", :data => utime_array)
          f.series(:name => "#{cpu_case.app_name} System Time", :data => stime_array)
        }
      end
      return line_chart
    end

    def self.cpu_charts_recent_app(cpu_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "CPU测试-历史版本对比(单位:jiffies)"})
        f.subtitle({:text => '负数表示CPU System Time'})
        f.chart({:defaultSeriesType => "line"})

        f.plotOptions(
          {
            column: {
              # minPointWidth:20
              maxPointWidth:20
            }
          }
        )
        cpu_case_result.each {|cpu_case|
          unless cpu_case.result.nil?
            result_array = eval(eval(cpu_case.result))
            utime_array = []
            stime_array = []
            result_array.each {|cpu_result|
              utime_array << cpu_result[:utime]
              stime_array << -cpu_result[:stime]
            }

            f.series(:name => "#{cpu_case.app_version} User Time", :data => utime_array)
            f.series(:name => "#{cpu_case.app_version} System Time", :data => stime_array)
          end

        }
      end
      return line_chart
    end

    def self.memory_charts(memory_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "内存测试-竞品对比(KB)"})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )

        memory_case_result.each {|memory_case|

          result_array = eval(eval(memory_case.result))
          timestamp_array = []
          memory_array = []
          result_array.each {|memory_result|
            timestamp_array << Time.at(memory_result[:timestamp]).to_s.gsub("+0800", "")
            memory_array << memory_result[:memory]
          }
          f.series(:name => memory_case.app_name, :data => memory_array)

        }
      end
      return line_chart
    end

    def self.memory_charts_recent_app(memory_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "内存测试-历史版本对比(KB)"})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )

        memory_case_result.each {|memory_case|

          result_array = eval(eval(memory_case.result))
          timestamp_array = []
          memory_array = []
          result_array.each {|memory_result|
            timestamp_array << Time.at(memory_result[:timestamp]).to_s.gsub("+0800", "")
            memory_array << memory_result[:memory]
          }
          f.series(:name => memory_case.app_version, :data => memory_array)

        }
      end
      return line_chart
    end

    def self.traffic_charts(traffic_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "流量测试-竞品对比(bytes)"})
        f.subtitle({:text => '负数表示发送流量'})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )
        traffic_case_result.each {|traffic_case|
          result_array = eval(eval(traffic_case.result))
          tcp_scv_array = []
          tcp_snd_array = []
          result_array.each {|cpu_result|
            tcp_scv_array << cpu_result[:tcp_rcv]
            tcp_snd_array << -cpu_result[:tcp_snd]
          }

          f.series(:name => "#{traffic_case.app_name} TCP Receiver", :data => tcp_scv_array)
          f.series(:name => "#{traffic_case.app_name} TCP Sender", :data => tcp_snd_array)
        }
      end
      return line_chart
    end

    def self.traffic_charts_recent_app(traffic_case_result)
      line_chart = LazyHighCharts::HighChart.new('graph') do |f|
        f.title({:text => "流量测试-历史版本对比(bytes)"})
        f.subtitle({:text => '负数表示发送流量'})
        f.chart({:defaultSeriesType => "line"})
        f.plotOptions(
          {
            column: {
              maxPointWidth:20
            }
          }
        )
        traffic_case_result.each {|traffic_case|
          result_array = eval(eval(traffic_case.result))
          tcp_scv_array = []
          tcp_snd_array = []
          result_array.each {|cpu_result|
            tcp_scv_array << cpu_result[:tcp_rcv]
            tcp_snd_array << -cpu_result[:tcp_snd]
          }

          f.series(:name => "#{traffic_case.app_version} TCP Receiver", :data => tcp_scv_array)
          f.series(:name => "#{traffic_case.app_version} TCP Sender", :data => tcp_snd_array)
        }
      end
      return line_chart
    end
  end
end
