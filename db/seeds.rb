# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#

Diymenu.delete_all
Diymenu.create(id: 1, name: '天气实况', is_show: true, sort: 0)
Diymenu.create(id: 2, name: '预报预警', is_show: true, sort: 1)
Diymenu.create(id: 3, name: '问问', key: '问问', is_show: true, sort:2)
Diymenu.create(id: 4, parent_id: 1, name: '空气质量', url: 'http://cs.tallty.com/air_quality', is_show: true, sort:0)
Diymenu.create(id: 5, parent_id: 1, name: '台风动态', key: '台风动态', is_show: true, sort:1)
Diymenu.create(id: 6, parent_id: 1, name: '雷达卫星', key: '雷达卫星', is_show: true, sort:2)
Diymenu.create(id: 7, parent_id: 1, name: '气象要素', url: 'http://cs.tallty.com/weather_essential/locate', is_show: true, sort:3)
Diymenu.create(id: 8, parent_id: 2, name: '客户端下载', key: '社区预警', is_show: true, sort:0)
Diymenu.create(id: 10, parent_id: 2, name: '专题信息', key: '灾情互动', is_show: true, sort:1)
Diymenu.create(id: 11, parent_id: 2, name: '气象预警', key: '实况监测', is_show: true, sort:2)
Diymenu.create(id: 12, parent_id: 2, name: '天气预报', url: 'http://cs.tallty.com/weather_forecast/locate', is_show: true, sort:3)
