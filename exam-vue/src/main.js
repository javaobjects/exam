import Vue from 'vue'
import App from './App.vue'
import router from './router'
import './plugins/element.js'
import axios from 'axios'
import api from './api/api'
// 引入echarts
import echarts from 'echarts'
Vue.prototype.$echarts = echarts

//配置请求根路径
axios.defaults.baseURL = 'http://127.0.0.1:9991/'
//axios拦截器拦截每一个请求,有token就配置头信息的token
axios.interceptors.request.use(config => {
  let token = window.localStorage.getItem('authorization')
  if (token) {  // 判断是否存在token，如果存在的话，则每个http header都加上token
    config.headers.authorization = token
  }
  return config
}, error => {
  return Promise.reject(error)
})

//接口地址统一管理
Vue.prototype.API = api.API.api
/**
 * 原型链挂载
 * @type {AxiosStatic}
 */
Vue.prototype.$http = axios
Vue.config.productionTip = false

//全局过滤器(秒数转化为分钟)
Vue.filter('timeFormat',function (time) {
  //分钟
  var minute = time / 60;
  var minutes = parseInt(minute);

  if (minutes < 10) {
    minutes = "0" + minutes;
  }

  //秒
  var second = time % 60;
  var seconds = Math.round(second);
  if (seconds < 10) {
    seconds = "0" + seconds;
  }
  return `${minutes}:${seconds}`;
})

//解决路径跳转的报错
import Router from 'vue-router'

const originalPush = Router.prototype.push
Router.prototype.push = function push (location) {
  return originalPush.call(this, location).catch(err => err)
}

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')

var s = [{
  'topMenuName': '控制台',
  'topIcon': 'el-icon-odometer'
}, {
  'topMenuName': '在线考试',
  'topIcon': 'el-icon-menu',
  'submenu': [{
    'name': '在线考试',
    'icon': 'el-icon-s-promotion',
    'url': ''
  }, {
    'name': '我的成绩',
    'icon': 'el-icon-trophy',
    'url': ''
  }, {
    'name': '我的题库',
    'icon': 'el-icon-notebook-2',
    'url': ''
  }]
}, {
  'topMenuName': '考试管理',
  'topIcon': 'el-icon-bangzhu',
  'submenu': [{
    'name': '题库管理',
    'icon': 'el-icon-aim',
    'url': ''
  }, {
    'name': '试题管理',
    'icon': 'el-icon-news',
    'url': ''
  }, {
    'name': '考试管理',
    'icon': 'el-icon-tickets',
    'url': ''
  }, {
    'name': '阅卷管理',
    'icon': 'el-icon-view',
    'url': ''
  }]
}, {
  'topMenuName': '考试统计',
  'topIcon': 'el-icon-pie-chart',
  'submenu': [{
    'name': '统计总览',
    'icon': 'el-icon-data-line',
    'url': ''
  }, {
    'name': '部门统计',
    'icon': 'el-icon-data-analysis',
    'url': ''
  }]
}, {
  'topMenuName': '系统设置',
  'topIcon': 'el-icon-setting',
  'submenu': [{
    'name': '角色管理',
    'icon': 'el-icon-s-custom',
    'url': ''
  }, {
    'name': '用户管理',
    'icon': 'el-icon-user-solid',
    'url': ''
  }]
}]
