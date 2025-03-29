<template>
  <div class="login" :style="backgroundStyle">
    <el-form ref="loginForm" :model="loginForm" :rules="loginRules" label-position="left" label-width="0px" class="login-form">
      <h3 class="title">
        OK English 登录
      </h3>
      <el-form-item prop="username">
        <el-input v-model="loginForm.username" type="text" auto-complete="off" placeholder="账号">
          <svg-icon slot="prefix" icon-class="user" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input v-model="loginForm.password" type="password" auto-complete="off" placeholder="密码" @keyup.enter.native="handleLogin">
          <svg-icon slot="prefix" icon-class="password" class="el-input__icon input-icon" />
        </el-input>
      </el-form-item>
      <el-form-item prop="code">
        <el-input v-model="loginForm.code" auto-complete="off" placeholder="验证码" style="width: 63%" @keyup.enter.native="handleLogin">
          <svg-icon slot="prefix" icon-class="validCode" class="el-input__icon input-icon" />
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode">
        </div>
      </el-form-item>
      <el-checkbox v-model="loginForm.rememberMe" style="margin:0 0 25px 0;">
        记住我
      </el-checkbox>
      <el-form-item style="width:100%;">
        <el-button :loading="loading" size="medium" type="primary" style="width:100%;" @click.native.prevent="handleLogin">
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
      </el-form-item>
    </el-form>
    <!-- 名言锦句 -->
    <!-- <div class="quote">
      {{ quote }}
    </div> -->
    <!--  底部  -->
    <div v-if="$store.state.settings.showFooter" id="el-login-footer">
      <span v-html="$store.state.settings.footerTxt" />
      <span v-if="$store.state.settings.caseNumber"> ⋅ </span>
      <a href="https://beian.miit.gov.cn/#/Integrated/index" target="_blank">{{ $store.state.settings.caseNumber }}</a>
    </div>
  </div>
</template>

<script>
import { encrypt } from '@/utils/rsaEncrypt'
import Config from '@/settings'
import { getCodeImg } from '@/api/login'
import Cookies from 'js-cookie'
import qs from 'qs'

export default {
  name: 'Login',
  data() {
    return {
      codeUrl: '',
      cookiePass: '',
      loginForm: {
        username: '',
        password: '',
        rememberMe: false,
        code: '',
        uuid: ''
      },
      loginRules: {
        username: [{ required: true, trigger: 'blur', message: '用户名不能为空' }],
        password: [{ required: true, trigger: 'blur', message: '密码不能为空' }],
        code: [{ required: true, trigger: 'change', message: '验证码不能为空' }]
      },
      loading: false,
      redirect: undefined,
      quote: '', // 名言锦句
      backgroundStyle: {
        background: 'linear-gradient(135deg, #6a11cb, #2575fc)',
        backgroundSize: '300% 300%',
        animation: 'gradientAnimation 15s ease infinite'
      }
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        const data = route.query
        if (data && data.redirect) {
          this.redirect = data.redirect
          delete data.redirect
          if (JSON.stringify(data) !== '{}') {
            this.redirect = this.redirect + '&' + qs.stringify(data, { indices: false })
          }
        }
      },
      immediate: true
    }
  },
  created() {
    // 获取验证码
    this.getCode()
    // 获取用户名密码等Cookie
    this.getCookie()
    // token 过期提示
    this.point()
    // 获取名言锦句
    this.getQuote()
  },
  methods: {
    getCode() {
      getCodeImg().then(res => {
        this.codeUrl = res.img
        this.loginForm.uuid = res.uuid
      })
    },
    getCookie() {
      const username = Cookies.get('username')
      let password = Cookies.get('password')
      const rememberMe = Cookies.get('rememberMe')
      // 保存cookie里面的加密后的密码
      this.cookiePass = password === undefined ? '' : password
      password = password === undefined ? this.loginForm.password : password
      this.loginForm = {
        username: username === undefined ? this.loginForm.username : username,
        password: password,
        rememberMe: rememberMe === undefined ? false : Boolean(rememberMe),
        code: ''
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        const user = {
          username: this.loginForm.username,
          password: this.loginForm.password,
          rememberMe: this.loginForm.rememberMe,
          code: this.loginForm.code,
          uuid: this.loginForm.uuid
        }
        if (user.password !== this.cookiePass) {
          user.password = encrypt(user.password)
        }
        if (valid) {
          this.loading = true
          if (user.rememberMe) {
            Cookies.set('username', user.username, { expires: Config.passCookieExpires })
            Cookies.set('password', user.password, { expires: Config.passCookieExpires })
            Cookies.set('rememberMe', user.rememberMe, { expires: Config.passCookieExpires })
          } else {
            Cookies.remove('username')
            Cookies.remove('password')
            Cookies.remove('rememberMe')
          }
          this.$store.dispatch('Login', user).then(() => {
            this.loading = false
            this.$router.push({ path: this.redirect || '/' })
          }).catch(() => {
            this.loading = false
            this.getCode()
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    point() {
      const point = Cookies.get('point') !== undefined
      if (point) {
        this.$notify({
          title: '提示',
          message: '当前登录状态已过期，请重新登录！',
          type: 'warning',
          duration: 5000
        })
        Cookies.remove('point')
      }
    },
    getQuote() {
      const quotes = [
        // 英文名言（80条）
        { text: 'The only limit to our realization of tomorrow is our doubts of today.', author: 'Franklin D. Roosevelt' },
        { text: 'Success is not final, failure is not fatal: It is the courage to continue that counts.', author: 'Winston Churchill' },
        { text: 'The best way to predict the future is to create it.', author: 'Peter Drucker' },
        { text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt' },
        { text: 'Do what you can, with what you have, where you are.', author: 'Theodore Roosevelt' },
        { text: 'The future belongs to those who believe in the beauty of their dreams.', author: 'Eleanor Roosevelt' },
        { text: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela' },
        { text: 'Strive not to be a success, but rather to be of value.', author: 'Albert Einstein' },
        { text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs' },
        { text: 'Your time is limited, don\'t waste it living someone else\'s life.', author: 'Steve Jobs' },
        { text: 'The mind is everything. What you think you become.', author: 'Buddha' },
        { text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb' },
        { text: 'Life is 10% what happens to us and 90% how we react to it.', author: 'Charles R. Swindoll' },
        { text: 'The only person you are destined to become is the person you decide to be.', author: 'Ralph Waldo Emerson' },
        { text: 'Whether you think you can or you think you can\'t, you\'re right.', author: 'Henry Ford' },
        { text: 'I have not failed. I\'ve just found 10,000 ways that won\'t work.', author: 'Thomas Edison' },
        { text: 'The way to get started is to quit talking and begin doing.', author: 'Walt Disney' },
        { text: 'Don\'t watch the clock; do what it does. Keep going.', author: 'Sam Levenson' },
        { text: 'You miss 100% of the shots you don\'t take.', author: 'Wayne Gretzky' },
        { text: 'The best revenge is massive success.', author: 'Frank Sinatra' },
        { text: 'The harder I work, the luckier I get.', author: 'Gary Player' },
        { text: 'You must be the change you wish to see in the world.', author: 'Mahatma Gandhi' },
        { text: 'What you get by achieving your goals is not as important as what you become by achieving your goals.', author: 'Zig Ziglar' },
        { text: 'The only place where success comes before work is in the dictionary.', author: 'Vidal Sassoon' },
        { text: 'Success usually comes to those who are too busy to be looking for it.', author: 'Henry David Thoreau' },
        { text: 'The road to success and the road to failure are almost exactly the same.', author: 'Colin R. Davis' },
        { text: 'Success is walking from failure to failure with no loss of enthusiasm.', author: 'Winston Churchill' },
        { text: 'Don\'t be afraid to give up the good to go for the great.', author: 'John D. Rockefeller' },
        { text: 'I find that the harder I work, the more luck I seem to have.', author: 'Thomas Jefferson' },
        { text: 'The secret of success is to do the common thing uncommonly well.', author: 'John D. Rockefeller Jr.' },
        { text: 'You can\'t connect the dots looking forward; you can only connect them looking backward.', author: 'Steve Jobs' },
        { text: 'The only limit to our impact is our imagination and commitment.', author: 'Tony Robbins' },
        { text: 'The best and most beautiful things in the world cannot be seen or even touched - they must be felt with the heart.', author: 'Helen Keller' },
        { text: 'It is during our darkest moments that we must focus to see the light.', author: 'Aristotle' },
        { text: 'The only true wisdom is in knowing you know nothing.', author: 'Socrates' },
        { text: 'The journey of a thousand miles begins with one step.', author: 'Lao Tzu' },
        { text: 'Happiness is not something ready made. It comes from your own actions.', author: 'Dalai Lama' },
        { text: 'The power of imagination makes us infinite.', author: 'John Muir' },
        { text: 'The best preparation for tomorrow is doing your best today.', author: 'H. Jackson Brown Jr.' },
        { text: 'The only way to achieve the impossible is to believe it is possible.', author: 'Charles Kingsleigh' },
        { text: 'The greatest glory in living lies not in never falling, but in rising every time we fall.', author: 'Nelson Mandela' },
        { text: 'The only thing standing between you and your goal is the story you keep telling yourself as to why you can\'t achieve it.', author: 'Jordan Belfort' },
        { text: 'The best time to plant a tree was 20 years ago. The second best time is now.', author: 'Chinese Proverb' },
        { text: 'The only limit to our realization of tomorrow is our doubts of today.', author: 'Franklin D. Roosevelt' },
        { text: 'The only person you are destined to become is the person you decide to be.', author: 'Ralph Waldo Emerson' },
        { text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs' },
        { text: 'The only thing that interferes with my learning is my education.', author: 'Albert Einstein' },
        { text: 'The only thing we have to fear is fear itself.', author: 'Franklin D. Roosevelt' },
        { text: 'The only true wisdom is in knowing you know nothing.', author: 'Socrates' },
        { text: 'The only limit to our impact is our imagination and commitment.', author: 'Tony Robbins' },
        { text: 'The only way to achieve the impossible is to believe it is possible.', author: 'Charles Kingsleigh' },
        { text: 'The only thing standing between you and your goal is the story you keep telling yourself as to why you can\'t achieve it.', author: 'Jordan Belfort' },
        { text: 'The only limit to our realization of tomorrow is our doubts of today.', author: 'Franklin D. Roosevelt' },
        { text: 'The only person you are destined to become is the person you decide to be.', author: 'Ralph Waldo Emerson' },
        { text: 'The only way to do great work is to love what you do.', author: 'Steve Jobs' },
        { text: 'The only thing that interferes with my learning is my education.', author: 'Albert Einstein' },
        { text: 'The only thing we have to fear is fear itself.', author: 'Franklin D. Roosevelt' },
        { text: 'The only true wisdom is in knowing you know nothing.', author: 'Socrates' },
        { text: 'The only limit to our impact is our imagination and commitment.', author: 'Tony Robbins' },
        { text: 'The only way to achieve the impossible is to believe it is possible.', author: 'Charles Kingsleigh' },
        { text: 'The only thing standing between you and your goal is the story you keep telling yourself as to why you can\'t achieve it.', author: 'Jordan Belfort' },

        // 中文名言（20条）
        { text: '学如逆水行舟，不进则退。', author: '中国谚语' },
        { text: '知识就是力量。', author: '培根' },
        { text: '行动是成功的阶梯。', author: '佚名' },
        { text: '今天的努力，明天的实力。', author: '佚名' },
        { text: '不积跬步，无以至千里。', author: '荀子' },
        { text: '天行健，君子以自强不息。', author: '《周易》' },
        { text: '千里之行，始于足下。', author: '老子' },
        { text: '少壮不努力，老大徒伤悲。', author: '《长歌行》' },
        { text: '书山有路勤为径，学海无涯苦作舟。', author: '韩愈' },
        { text: '业精于勤，荒于嬉；行成于思，毁于随。', author: '韩愈' },
        { text: '读万卷书，行万里路。', author: '刘彝' },
        { text: '黑发不知勤学早，白首方悔读书迟。', author: '颜真卿' },
        { text: '宝剑锋从磨砺出，梅花香自苦寒来。', author: '《警世贤文》' },
        { text: '有志者，事竟成。', author: '《后汉书》' },
        { text: '天生我材必有用，千金散尽还复来。', author: '李白' },
        { text: '路漫漫其修远兮，吾将上下而求索。', author: '屈原' },
        { text: '海纳百川，有容乃大；壁立千仞，无欲则刚。', author: '林则徐' },
        { text: '勿以恶小而为之，勿以善小而不为。', author: '刘备' },
        { text: '天下兴亡，匹夫有责。', author: '顾炎武' },
        { text: '人生在勤，不索何获。', author: '张衡' }
      ]
      const randomQuote = quotes[Math.floor(Math.random() * quotes.length)]
      this.quote = `${randomQuote.text} —— ${randomQuote.author}`
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss">
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background: linear-gradient(135deg, #6a11cb, #2575fc);
  background-size: 300% 300%;
  animation: gradientAnimation 15s ease infinite;
}

@keyframes gradientAnimation {
  0% {
    background-position: 0% 50%;
  }
  50% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0% 50%;
  }
}

.title {
  margin: 0 auto 30px auto;
  text-align: center;
  color: #000000; /* 标题保持黑色 */
}

.login-form {
  border-radius: 6px;
  background: rgba(255, 255, 255, 0.9);
  width: 385px;
  padding: 25px 25px 5px 25px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  .el-input {
    height: 38px;
    input {
      height: 38px;
    }
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 2px;
  }
}

.quote {
  position: absolute;
  bottom: 80px; /* 调整位置，避免被登录框遮挡 */
  left: 50%;
  transform: translateX(-50%);
  text-align: center;
  font-size: 24px; /* 加大字体 */
  font-weight: bold; /* 加粗 */
  color: #ffffff; /* 白色字体 */
  font-style: italic; /* 斜体 */
  width: 80%;
  max-width: 600px;
}

.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}

.login-code {
  width: 33%;
  display: inline-block;
  height: 38px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}

#el-login-footer {
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  padding: 10px 0;
  background: rgba(255, 255, 255, 0.8);
  color: #606266;
  a {
    color: #606266;
    text-decoration: none;
    &:hover {
      color: #409eff;
    }
  }
}
</style>
