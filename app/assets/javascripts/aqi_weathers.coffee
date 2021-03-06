# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
console.log(aqi_datas)
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

  aqiChart = ec.init(document.getElementById('aqi'))
  gheight = $("#aqi").height()-50
  option = 
    grid:
      height: gheight
      x: 30
      x2: 16
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      # splitNumber: 4
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#4a4a4a"
      axisLine:
        lineStyle:
          color: '#fff'
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
      max: 350
      splitNumber: 7
      axisLabel:
        textStyle:
          color: 'rgba(74,74,74,0.47)'
      axisLine:
        show: false
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
      splitLine:
        onGap: true
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 3
      itemStyle:
        normal:
          lineStyle:
            color: '#ccc'
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

  pm10Chart = ec.init(document.getElementById('pm25'))
  gheight = $("#pm25").height()-50
  option = 
    grid:
      height: gheight
      x: 30
      x2: 16
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#4a4a4a"
      axisLine:
        lineStyle:
          color: '#fff'
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
      max: 350
      splitNumber: 7
      axisLabel:
        textStyle:
          color: 'rgba(74,74,74,0.47)'
      axisLine:
        show: false
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
      splitLine:
        onGap: true
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
    ]
    series: [
      name: 'PM10'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ccc'
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

  aqiChart = ec.init(document.getElementById('o3'))
  gheight = $("#o3").height()-50
  option = 
    grid:
      height: gheight
      x: 30
      x2: 16
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#4a4a4a"
      axisLine:
        lineStyle:
          color: '#fff'
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
      max: 350
      splitNumber: 7
      axisLabel:
        textStyle:
          color: 'rgba(74,74,74,0.47)'
      axisLine:
        show: false
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
      splitLine:
        onGap: true
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ccc'
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

  aqiChart = ec.init(document.getElementById('pm10'))
  gheight = $("#pm10").height()-50
  option = 
    grid:
      height: gheight
      x: 30
      x2: 16
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#4a4a4a"
      axisLine:
        lineStyle:
          color: '#fff'
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
      max: 350
      splitNumber: 7
      axisLabel:
        textStyle:
          color: 'rgba(74,74,74,0.47)'
      axisLine:
        show: false
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
      splitLine:
        onGap: true
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ccc'
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

  no2Chart = ec.init(document.getElementById('no2'))
  gheight = $("#no2").height()-50
  option = 
    grid:
      height: gheight
      x: 30
      x2: 16
      y: 10
      borderWidth: 0
    xAxis: [
      type: 'time'
      # splitNumber: 4
      axisLabel:
        formatter: (value)->
          "#{value.getHours()}时\n#{value.getMonth()+1}-#{value.getDate()}"
        textStyle:
          color: "#4a4a4a"
      axisLine:
        lineStyle:
          color: '#fff'
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
      max: 350
      splitNumber: 7
      axisLabel:
        textStyle:
          color: 'rgba(74,74,74,0.47)'
      axisLine:
        show: false
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
      splitLine:
        onGap: true
        lineStyle:
          color: 'rgba(155,155,155,0.54)'
    ]
    series: [
      name: '空气质量'
      type: 'line'
      showAllSymbol: true
      symbolSize: 4
      itemStyle:
        normal:
          lineStyle:
            color: '#ccc'
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
