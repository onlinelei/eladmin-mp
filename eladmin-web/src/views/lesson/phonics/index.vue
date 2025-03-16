<template>
  <div class="new-category">
    <h1 class="page-title">自然拼读
      <span class="title-decoration" />
    </h1>
    <div class="content-container">
      <!-- 视频播放区域 -->
      <div class="video-wrapper">
        <div class="video-container">
          <div v-if="isLoading" class="loading-overlay">
            <div class="loading-spinner" />
            <div class="loading-text">加载中...</div>
          </div>
          <video
            ref="videoPlayer"
            controls
            class="video-player"
            @waiting="onVideoWaiting"
            @playing="onVideoPlaying"
          >
            <source :src="currentVideoUrl" type="video/mp4">
            您的浏览器不支持 video 标签。
          </video>
        </div>
      </div>

      <!-- 分级播放列表 -->
      <div class="playlist-container">
        <h2 class="playlist-title">
          <i class="el-icon-menu" />
          课程目录
        </h2>
        <div class="playlist-scroll">
          <ul class="playlist">
            <li
              v-for="(category, index) in categorizedPlaylist"
              :key="'cat-'+index"
              class="category-item"
              :class="{ expanded: category.expanded }"
            >
              <div class="category-header" @click="toggleCategory(category)">
                <i v-if="category.expanded" class="el-icon-folder-opened" />
                <i v-else class="el-icon-folder" />
                {{ category.name }}
                <i class="el-icon-arrow-right arrow-icon" />
              </div>
              <transition name="slide">
                <ul v-show="category.expanded" class="sub-list">
                  <li
                    v-for="(video, vIndex) in category.videos"
                    :key="'vid-'+vIndex"
                    :class="{ 'active': currentVideoUrl === video.url }"
                    @click.stop="playVideo(video.url)"
                  >
                    <i class="el-icon-video-play" />
                    <span class="video-title">{{ video.title }}</span>
                  </li>
                </ul>
              </transition>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewCategoryIndex',
  data() {
    return {
      currentVideoUrl: '',
      isLoading: false,
      categorizedPlaylist: [
        {
          name: 'L1 基础课程,想好叫什么告诉我',
          expanded: true,
          videos: [
            { title: 'ABC', url: 'https://okeng.top/file/phonics/L1/ABC.mp4' },
            { title: 'DEF', url: 'https://okeng.top/file/phonics/L1/DEF.mp4' },
            { title: 'GHI', url: 'https://okeng.top/file/phonics/L1/GHI.mp4' },
            { title: 'JKL', url: 'https://okeng.top/file/phonics/L1/JKL.mp4' },
            { title: 'MNO', url: 'https://okeng.top/file/phonics/L1/MNO.mp4' },
            { title: 'PQR', url: 'https://okeng.top/file/phonics/L1/PQR.mp4' },
            { title: 'STUV', url: 'https://okeng.top/file/phonics/L1/STUV.mp4' },
            { title: 'WXYZ', url: 'https://okeng.top/file/phonics/L1/WXYZ.mp4' }
          ]
        },
        {
          name: 'L2 进阶课程,想好叫什么告诉我',
          expanded: false,
          videos: [
            { title: 'MNO', url: 'http://file.okeng.top/phonics/L1/MNO.mp4' },
            { title: 'PQR', url: 'http://file.okeng.top/phonics/L1/PQR.mp4' },
            { title: 'STUV', url: 'http://file.okeng.top/phonics/L1/STUV.mp4' },
            { title: 'WXYZ', url: 'http://file.okeng.top/phonics/L1/WXYZ.mp4' }
          ]
        },
        {
          name: 'L3 高级课程,想好叫什么告诉我',
          expanded: false,
          videos: [
            { title: '组合发音1', url: 'http://file.okeng.top/demo/1.mp4' },
            { title: '组合发音2', url: 'http://file.okeng.top/demo/2.mp4' }
          ]
        },
        {
          name: 'L4 实战训练, 想好叫什么告诉我',
          expanded: false,
          videos: [
            { title: '场景练习1', url: 'http://file.okeng.top/demo/3.mp4' },
            { title: '场景练习2', url: 'http://file.okeng.top/demo/4.mp4' }
          ]
        }
      ]
    }
  },
  mounted() {
    this.initFirstVideo()
  },
  methods: {
    initFirstVideo() {
      if (this.categorizedPlaylist[0].videos.length > 0) {
        this.currentVideoUrl = this.categorizedPlaylist[0].videos[0].url
      }
    },
    toggleCategory(category) {
      category.expanded = !category.expanded
    },
    playVideo(url) {
      this.currentVideoUrl = url
      const video = this.$refs.videoPlayer
      this.isLoading = true
      video.load()
      video.play().catch(error => {
        console.log('视频自动播放被阻止:', error)
        this.isLoading = false
      })
    },
    onVideoWaiting() {
      this.isLoading = true
    },
    onVideoPlaying() {
      this.isLoading = false
    }
  }
}
</script>

<style scoped>
/* 页面容器样式 */
.new-category {
  padding: 30px 40px;
  background: #f5f7fa;
  min-height: 100vh;
}

/* 页面标题样式 */
.page-title {
  font-size: 28px;
  color: #2c3e50;
  margin-bottom: 30px;
  position: relative;
  text-align: center;
  padding-bottom: 15px;
}

/* 标题装饰线样式 */
.title-decoration {
  display: block;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #409EFF, transparent);
  margin: 10px auto 0;
}

/* 内容容器样式 */
.content-container {
  display: flex;
  gap: 30px;
  max-width: 1400px;
  margin: 0 auto;
  flex-wrap: nowrap; /* 防止换行 */
}

/* 视频区域容器样式 */
.video-wrapper {
  flex: 3;
  min-width: 0;
  overflow: hidden;
}

/* 视频容器样式 */
.video-container {
  background: #000;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  position: relative;
  padding-top: 56.25%; /* 16:9 比例 */
}

/* 视频播放器样式 */
.video-player {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

/* 播放列表容器样式 */
.playlist-container {
  flex: 1;
  min-width: 300px;
  max-width: 350px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.08);
  padding: 20px;
  display: flex;
  flex-direction: column;
}

/* 播放列表滚动区域样式 */
.playlist-scroll {
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
}

/* 播放列表标题样式 */
.playlist-title {
  font-size: 18px;
  color: #303133;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f2f5;
  display: flex;
  align-items: center;
  gap: 8px;
}

/* 播放列表样式 */
.playlist {
  list-style: none;
  padding: 0;
  margin: 0;
}

/* 分类项样式 */
.category-item {
  margin: 8px 0;
  border-radius: 8px;
  background: #fff;
}

/* 分类标题样式 */
.category-header {
  padding: 14px 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
  background: #f8f9fa;
  border-radius: 8px;
}

/* 分类标题hover效果 */
.category-header:hover {
  background: #f0f7ff;
}

/* 分类箭头图标样式 */
.arrow-icon {
  margin-left: auto;
  transform: rotate(0deg);
  transition: transform 0.3s;
}

/* 展开状态的分类箭头图标样式 */
.expanded .arrow-icon {
  transform: rotate(90deg);
}

/* 子列表样式 */
.sub-list {
  list-style: none;
  padding: 8px 0 8px 30px;
  margin: 0;
}

/* 子列表项样式 */
.sub-list li {
  padding: 12px 16px;
  margin: 4px 0;
  border-radius: 6px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 10px;
  transition: all 0.3s;
  background: #f8f9fa;
}

/* 子列表项hover效果 */
.sub-list li:hover {
  background: #f0f7ff;
}

/* 选中状态的子列表项样式 */
.sub-list li.active {
  background: #ecf5ff;
  font-weight: 500;
  color: #409EFF;
}

/* 视频标题样式 */
.video-title {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 加载遮罩样式 */
.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 2;
}

/* 加载动画样式 */
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #409EFF;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

/* 加载文字样式 */
.loading-text {
  color: white;
  margin-top: 10px;
  font-size: 16px;
}

/* 旋转动画定义 */
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 展开收起动画 */
.slide-enter-active, .slide-leave-active {
  transition: all 0.3s ease;
}
.slide-enter, .slide-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .content-container {
    flex-direction: row; /* 保持水平排列 */
  }

  .video-container {
    padding-top: 56.25%; /* 保持16:9比例 */
  }

  .playlist-container {
    width: auto;
    max-width: 350px;
  }
}

@media (max-width: 768px) {
  .new-category {
    padding: 20px 15px;
  }

  .page-title {
    font-size: 24px;
  }

  .playlist li {
    padding: 12px;
  }
}
</style>
