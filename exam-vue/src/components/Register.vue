<template>
  <el-container>
    <el-main>
      <el-card class="box-card" shadow="always">
        <div slot="header" class="card-header">
          <p>在线考试系统</p>
        </div>

        <div>
          <el-form :model="registerForm" :rules="registerFormRules" ref="registerForm" :status-icon="true"
                   label-width="100px">
            <el-form-item prop="username">
              <el-input prefix-icon="el-icon-user" v-model="registerForm.username" placeholder="账号"></el-input>
            </el-form-item>

            <el-form-item prop="trueName">
              <el-input prefix-icon="el-icon-s-check" v-model="registerForm.trueName" placeholder="姓名"></el-input>
            </el-form-item>

            <el-form-item prop="password">
              <el-input prefix-icon="el-icon-lock" v-model="registerForm.password" placeholder="密码"
                        show-password></el-input>
            </el-form-item>

            <el-form-item prop="code">
              <el-input class="code" prefix-icon="el-icon-chat-line-round" v-model="registerForm.code"
                        placeholder="验证码"></el-input>
              <img src="http://127.0.0.1:9991/util/getCodeImg" @click="changeCode" id="code"
                   style="float: right;margin-top: 4px;cursor: pointer" title="看不清,点击刷新"
                   alt="验证码"/>
            </el-form-item>

            <el-form-item>
              <el-button type="warning" @click="submitForm('registerForm')" icon="el-icon el-icon-circle-plus">注册
              </el-button>
              <el-button @click="toLoginPage" icon="el-icon el-icon-s-promotion">去登陆</el-button>
            </el-form-item>
          </el-form>
        </div>
      </el-card>
    </el-main>

    <el-footer>
      <span>版权所有</span>
      <br>
      <i class="el-icon-thumb"></i>
    </el-footer>
  </el-container>
</template>

<script>

  export default {
    name: 'Register',
    data () {
      //自定义验证码校验规则
      var validateCode = (rule, value, callback) => {
        if (value !== this.code) {
          callback(new Error('验证码输入错误'))
        } else {
          callback()
        }
      }
      //自定义用户名校验规则
      var validateUsername = (rule, value, callback) => {
        this.$http.get(this.API.checkUsername + '/' + this.registerForm.username).then((resp) => {
          if (resp.data.code === 200){
            callback()
          }else {
            callback(new Error('用户名已存在'))
          }
        })
      }
      return {
        //登录表单数据信息
        registerForm: {
          username: '',
          trueName: '',
          password: '',
          code: ''
        },
        //登录表单的校验规则
        registerFormRules: {
          username: [
            {
              required: true,
              message: '请输入账号',
              trigger: 'blur'
            },
            {
              validator: validateUsername,
              trigger: 'blur'
            }
          ],
          trueName: [
            {
              required: true,
              message: '请输入您的姓名',
              trigger: 'blur'
            },
          ],
          password: [
            {
              required: true,
              message: '请输入密码',
              trigger: 'blur'
            },
            {
              min: 5,
              message: '密码不能小于5个字符',
              trigger: 'blur'
            }
          ],
          code: [
            {
              required: true,
              message: '请输入验证码',
              trigger: 'blur'
            },
            {
              validator: validateCode,
              trigger: 'blur'
            }
          ],
        },
        //后台的验证码
        code: window.onload = () => this.getCode(),
      }
    },
    mounted () {
      this.changeCode()
    },
    methods: {
      //表单信息提交
      submitForm () {
        this.$refs['registerForm'].validate((valid) => {
          if (valid) {//验证通过
            this.$http.post(this.API.register, this.registerForm).then((resp) => {
              if (resp.data.code === 200) {
                localStorage.setItem('authorization', resp.data.data)
                this.$router.push('/index')
              } else {//请求出错
                this.$notify({
                  title: 'Tips',
                  message: '用户注册失败,请稍后重试',
                  type: 'error',
                  duration: 2000
                });
              }
            })
          } else {//验证失败
            this.$notify({
              title: 'Tips',
              message: '请检查所填写信息是否正确',
              type: 'error',
              duration: 2000
            });
            return false
          }
        })
      },
      //注册页面跳转
      toLoginPage () {
        this.$router.push('/')
      },
      //点击图片刷新验证码
      changeCode () {
        const code = document.querySelector('#code')
        code.src = 'http://127.0.0.1:9991/util/getCodeImg?id=' + Math.random()
        code.onload = () => this.getCode()
      },
      //获取后台验证码
      getCode () {
        this.$http.get(this.API.getCode).then((resp) => {
          this.code = resp.data.message
        })
      },
    }
  }
</script>

<style scoped lang="scss">
  .el-container {
    height: 100%;
    background: url("../assets/imgs/bg.png");
    -moz-background-size: 100% 100%;
    background-size: 100% 100%;
  }

  a {
    text-decoration: none;
    color: blueviolet;
  }

  /*  card样式  */
  .box-card {
    width: 450px;
  }

  .el-card {
    position: absolute;
    top: 45%;
    left: 50%;
    transform: translateX(-50%) translateY(-50%);
    border-radius: 15px;
  }

  .card-header {
    text-align: center;

    p {
      font-size: 20px;
    }
  }

  /*  表单的左侧margin清楚 */
  /deep/ .el-form-item__content {
    margin: 0 !important;
  }

  /*  按钮样式 */
  .el-button:first-child {
    width: 60%;
  }

  .el-button:nth-child(2) {
    width: 37%;
  }

  /*  按钮前的小图标样式更改*/
  /deep/ .el-icon {
    margin-right: 3px;
  }

  /*  验证码的输入框*/
  .code {
    width: 72%;
  }
</style>
