class PerformancesController < ApplicationController
  include PerformancesHelper

  def index
    @perf_tasks = PerfTask.all.order("id desc")
  end

  def report
    major_app_name = "美团"
    launch_case = "launch"
    cpu_case = "cpu"
    memory_case = "memory"
    traffic_case = "traffic"
    task_id = params[:task_id]

    case_array = PerfSuite.select('*').joins(:perf_cases).where(:task_id => task_id)
    # puts case_array[0].app_name, case_array[0].case_chinese_name

    launch_case_result = case_array.where(perf_cases: {case_type: launch_case})
    cpu_case_result = case_array.where(perf_cases: {case_type: cpu_case})
    memory_case_result = case_array.where(perf_cases: {case_type: memory_case})
    traffic_case_result = case_array.where(perf_cases: {case_type: traffic_case})

    @launch_chart = HighChartsHandler.launch_charts(launch_case_result)
    @cpu_chart = HighChartsHandler.cpu_charts(cpu_case_result)
    @memory_chart = HighChartsHandler.memory_charts(memory_case_result)
    @traffic_chart = HighChartsHandler.traffic_charts(traffic_case_result)

    perf_suite = PerfSuite.select("*").joins(:perf_task).where(:task_id => task_id, :app_name => major_app_name).first
    device_model = perf_suite.device_model
    device_serial = perf_suite.device_serial
    app_version = perf_suite.app_version

    puts device_model, device_serial, app_version
    app_version_recent_array = []
    app_version_suite = PerfSuite.distinct.select(:app_version).joins(:perf_task).where("app_name = ?", major_app_name).where("perf_tasks.status = 0 AND perf_tasks.id <= ?", task_id).order("app_version DESC")
    count = 0
    app_version_suite.each {|app_version_suite_item|
      unless app_version_recent_array.include?(app_version_suite_item.app_version)
        app_version_recent_array << app_version_suite_item.app_version
        count += 1
        if count >= 3
          break
        end
      end
    }

    perf_task_recent_task = PerfTask.where("status = 0 AND perf_tasks.id <= ?", task_id).order("id DESC")

    launch_case_recent_app_result = []
    cpu_case_recent_app_result = []
    memory_case_recent_app_result = []
    traffic_case_recent_app_result = []

    perf_task_recent_task.each {|each_task|
      perf_recent_app_suite_item = each_task.perf_suites.where("app_name = ? AND app_version in (?)", major_app_name, app_version_recent_array)
      case_app_result = perf_recent_app_suite_item.select("*").joins(:perf_cases)
      case_app_result.each {|case_app_result_item|
        if case_app_result_item.case_type.eql?(launch_case)
          launch_case_recent_app_result << case_app_result_item
        end
        if case_app_result_item.case_type.eql?(cpu_case)
          cpu_case_recent_app_result << case_app_result_item
        end
        if case_app_result_item.case_type.eql?(memory_case)
          memory_case_recent_app_result << case_app_result_item
        end
        if case_app_result_item.case_type.eql?(traffic_case)
          traffic_case_recent_app_result << case_app_result_item
        end
      }

      @launch_chart_app_verison = HighChartsHandler.launch_charts_recent_app(launch_case_recent_app_result)
      @cpu_chart_app_verison = HighChartsHandler.cpu_charts_recent_app(cpu_case_recent_app_result)
      @memory_chart_app_verison = HighChartsHandler.memory_charts_recent_app(memory_case_recent_app_result)
      @traffic_chart_app_verison = HighChartsHandler.traffic_charts_recent_app(traffic_case_recent_app_result)
    }

  end

  def home
    @chart = LazyHighCharts::HighChart.new('graph') do |f|

      categories = ['美团', '点评', '京东', '淘宝', '携程', '头条']
      f.title({:text => "耗电量"})
      f.chart({:defaultSeriesType => "line"})
      f.xAxis(:categories => categories)
      # f.colors(['#058DC7', '#50B432', '#ED561B', '#DDDF00', '#24CBE5', '#64E572', '#FF9655', '#FFF263', '#6AF9C4'])
      f.plotOptions(
        {
          column: {
            # minPointWidth:20
            maxPointWidth:20
          }
        }
      )

      f.series(:name => "8.6", :data => [2.500, 0.176, 0.203, 1.040, 1.690, 0.264])
      f.series(:name => "8.7", :data => [2.690, 1.030, 0.033, 0.100, 0.000, 1.000])
      f.series(:name => "8.8", :data => [0.526, 0.295, 0.0810, 1.08, 0.00522, 0.00862])
    end
    #
    @chart2 = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => "Population vs GDP For 5 Big Countries [2009]")
      f.xAxis(:categories => ["United States", "Japan", "China", "Germany", "France"])
      f.series(:name => "GDP in Billions", :yAxis => 0, :data => [14119, 5068, 4985, 3339, 2656])
      f.series(:name => "Population in Millions", :yAxis => 1, :data => [310, 127, 1340, 81, 65])

      f.yAxis [
                {:title => {:text => "GDP in Billions", :margin => 70}},
                {:title => {:text => "Population in Millions"}, :opposite => true},
              ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType => "column"})
    end

    @chart3 = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType => "pie", :margin => [50, 200, 60, 170]})
      series = {
        :case_type => 'pie',
        :name => 'Browser share',
        :data => [
          ['Firefox', 45.0],
          ['IE', 26.8],
          {
            :name => 'Chrome',
            :y => 12.8,
            :sliced => true,
            :selected => true
          },
          ['Safari', 8.5],
          ['Opera', 6.2],
          ['Others', 0.7]
        ]
      }
      f.series(series)
      f.options[:title][:text] = "THA PIE"
      f.legend(:layout => 'vertical', :style => {:left => 'auto', :bottom => 'auto', :right => '50px', :top => '100px'})
      f.plot_options(:pie => {
        :allowPointSelect => true,
        :cursor => "pointer",
        :dataLabels => {
          :enabled => true,
          :color => "black",
          :style => {
            :font => "13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end

    @chart4 = LazyHighCharts::HighChart.new('column') do |f|
      f.series(:name => 'John', :data => [3, 20, 3, 5, 4, 10, 12])
      f.series(:name => 'Jane', :data => [1, 3, 4, 3, 3, 5, 4, -46])
      f.title({:text => "example test title from controller"})
      f.options[:chart][:defaultSeriesType] = "column"
      f.plot_options({:column => {:stacking => "percent"}})
    end

  end
end
