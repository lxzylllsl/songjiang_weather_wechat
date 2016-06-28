# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

drawAqi = (ec)->
  dataConfigs = for data in aqi_datas
    {
      value: [
        new Date(data[0])
        data[1]
      ]
      itemStyle:
        normal:
          color: data[2]
    }

  aqiChart = ec.init(document.getElementById('aqi_m'))
  option = 
    grid:
      height: 340
      x: 30
      x2: 20
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      # splitNumber: 4
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#ffffff"
      axisLine:
        lineStyle:
          color: '#ffffff'
          width: 0
      axisTick:
        show: false
      splitLine:
        lineStyle:
          width: 0
    ]
    yAxis: [
      type: 'value'
      min: 0
      max: 500
      splitNumber: 10
      axisLabel:
        textStyle:
          color: "#ffffff"
      axisLine:
        show: false
        lineStyle:
          color: '#657398'
      splitLine:
        onGap: true
        lineStyle:
          color: '#657398'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ffffff'
            width: 1
      data: dataConfigs
    ]
  aqiChart.setOption(option)

drawPm25 = (ec)->
  dataConfigs = for data in pm25_datas
    {
      value: [
        new Date(data[0])
        data[1]
      ]
      itemStyle:
        normal:
          color: data[2]
    }

  pm10Chart = ec.init(document.getElementById('pm25_m'))
  option = 
    grid:
      height: 340
      x: 30
      x2: 20
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#ffffff"
      axisLine:
        lineStyle:
          color: '#ffffff'
          width: 0
      axisTick:
        show: false
      splitLine:
        lineStyle:
          width: 0
    ]
    yAxis: [
      type: 'value'
      min: 0
      max: 500
      splitNumber: 10
      axisLabel:
        textStyle:
          color: "#ffffff"
      axisLine:
        show: false
        lineStyle:
          color: '#657398'
      splitLine:
        onGap: true
        lineStyle:
          color: '#657398'
    ]
    series: [
      name: 'PM10'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ffffff'
            width: 1
      data: dataConfigs
    ]
  pm10Chart.setOption(option)

drawO3 = (ec)->
  dataConfigs = for data in o3_datas
    {
      value: [
        new Date(data[0])
        data[1]
      ]
      itemStyle:
        normal:
          color: data[2]
    }

  aqiChart = ec.init(document.getElementById('o3_m'))
  option = 
    grid:
      height: 340
      x: 30
      x2: 20
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#ffffff"
      axisLine:
        lineStyle:
          color: '#ffffff'
          width: 0
      axisTick:
        show: false
      splitLine:
        lineStyle:
          width: 0
    ]
    yAxis: [
      type: 'value'
      min: 0
      max: 500
      splitNumber: 10
      axisLabel:
        textStyle:
          color: "#ffffff"
      axisLine:
        show: false
        lineStyle:
          color: '#657398'
      splitLine:
        onGap: true
        lineStyle:
          color: '#657398'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ffffff'
            width: 1
      data: dataConfigs
    ]
  aqiChart.setOption(option)

drawPm10 = (ec)->
  dataConfigs = for data in pm10_datas
    {
      value: [
        new Date(data[0])
        data[1]
      ]
      itemStyle:
        normal:
          color: data[2]
    }

  aqiChart = ec.init(document.getElementById('pm10_m'))
  option = 
    grid:
      height: 340
      x: 30
      x2: 20
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#ffffff"
      axisLine:
        lineStyle:
          color: '#ffffff'
          width: 0
      axisTick:
        show: false
      splitLine:
        lineStyle:
          width: 0
    ]
    yAxis: [
      type: 'value'
      min: 0
      max: 500
      splitNumber: 10
      axisLabel:
        textStyle:
          color: "#ffffff"
      axisLine:
        show: false
        lineStyle:
          color: '#657398'
      splitLine:
        onGap: true
        lineStyle:
          color: '#657398'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ffffff'
            width: 1
      data: dataConfigs
    ]
  aqiChart.setOption(option)

drawNo2 = (ec)->
  dataConfigs = for data in no2_datas
    {
      value: [
        new Date(data[0])
        data[1]
      ]
      itemStyle:
        normal:
          color: data[2]
    }

  no2Chart = ec.init(document.getElementById('no2_m'))
  option = 
    grid:
      height: 340
      x: 30
      x2: 20
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      # splitNumber: 4
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#ffffff"
      axisLine:
        lineStyle:
          color: '#ffffff'
          width: 0
      axisTick:
        show: false
      splitLine:
        lineStyle:
          width: 0
    ]
    yAxis: [
      type: 'value'
      min: 0
      max: 500
      splitNumber: 10
      axisLabel:
        textStyle:
          color: "#ffffff"
      axisLine:
        show: false
        lineStyle:
          color: '#657398'
      splitLine:
        onGap: true
        lineStyle:
          color: '#657398'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ffffff'
            width: 1
      data: dataConfigs
    ]
  no2Chart.setOption(option)

drawCharts = (ec)->
  drawAqi(ec)
  drawPm10(ec)
  drawO3(ec)
  drawPm25(ec)
  drawNo2(ec)

$ ->
  require.config
    paths:
      echarts: 'http://echarts.baidu.com/build/dist'
  require(
    [
      'echarts'
      'echarts/chart/line'
    ],
    drawCharts
  )
  $('a[data-toggle="tab"]').on('shown.bs.tab', (e)->
    require.config
      paths:
        echarts: 'http://echarts.baidu.com/build/dist'
    require(
      [
        'echarts'
        'echarts/chart/line'
      ],
      drawCharts
    )
  )
