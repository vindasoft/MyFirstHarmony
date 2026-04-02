@Component
  // 开放给别的组件调用
export struct Mine {
  build() {
    Text('我的')
      .fontColor('#fff')

  }
}